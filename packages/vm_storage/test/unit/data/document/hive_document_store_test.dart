import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:vm_storage/src/data/document/hive_document_store.dart';
import 'package:vm_storage/vm_storage.dart';

import '../../../fakes/in_memory_document_store.dart';

class _Note {
  const _Note({required this.id, required this.text});

  final String id;
  final String text;

  Map<String, dynamic> toJson() => {'id': id, 'text': text};

  static _Note fromJson(Map<String, dynamic> json) =>
      _Note(id: json['id'] as String, text: json['text'] as String);
}

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  var boxCount = 0;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vm_storage_hive_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>('notes_${boxCount++}');
  });

  tearDown(() async {
    await box.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  HiveDocumentStore<_Note> buildStore({
    Duration? defaultTtl,
    bool softDeleteEnabled = false,
  }) {
    return HiveDocumentStore<_Note>(
      box: box,
      toJson: (note) => note.toJson(),
      fromJson: _Note.fromJson,
      keyOf: (note) => note.id,
      defaultTtl: defaultTtl,
      softDeleteEnabled: softDeleteEnabled,
    );
  }

  Future<T> unwrap<T>(Future<Result<T, StorageFailure>> future) async {
    final result = await future;
    return result.when(
      success: (value) => value,
      failure: (failure) => throw StateError('unexpected failure: $failure'),
    );
  }

  group('HiveDocumentStore', () {
    test('put then get roundtrips via the injected codec', () async {
      final store = buildStore();
      const note = _Note(id: '1', text: 'hello');

      await unwrap(store.put(note));
      final read = await unwrap(store.get('1'));

      expect(read.id, note.id);
      expect(read.text, note.text);
    });

    test('getAll returns every live record', () async {
      final store = buildStore();
      await unwrap(store.put(const _Note(id: '1', text: 'a')));
      await unwrap(store.put(const _Note(id: '2', text: 'b')));

      final all = await unwrap(store.getAll());

      expect(all.map((note) => note.id).toSet(), {'1', '2'});
    });

    test('a codec decode error surfaces as a serialization failure', () async {
      await box.put('broken', {
        'data': {'id': '1'},
        'expiresAt': null,
        'deletedAt': null,
      });
      final store = buildStore();

      final result = await store.get('broken');

      expect(
        result.when(success: (_) => null, failure: (failure) => failure),
        isA<StorageSerializationFailure>(),
      );
    });

    test('an expired entry reads as not-found and is evicted', () async {
      final store = buildStore(defaultTtl: const Duration(milliseconds: 1));
      await unwrap(store.put(const _Note(id: '1', text: 'a')));
      await Future<void>.delayed(const Duration(milliseconds: 5));

      final result = await store.get('1');

      expect(
        result.when(success: (_) => null, failure: (failure) => failure),
        isA<StorageNotFoundFailure>(),
      );
      expect(box.get('1'), isNull);
    });

    group('soft-delete', () {
      test(
        'hides the record from get/getAll but keeps the tombstone',
        () async {
          final store = buildStore(softDeleteEnabled: true);
          await unwrap(store.put(const _Note(id: '1', text: 'a')));

          await unwrap(store.delete('1'));

          final result = await store.get('1');
          expect(
            result.when(success: (_) => null, failure: (failure) => failure),
            isA<StorageNotFoundFailure>(),
          );
          expect(await unwrap(store.getAll()), isEmpty);
          expect(box.get('1'), isNotNull);
        },
      );

      test('purge physically removes tombstoned records', () async {
        final store = buildStore(softDeleteEnabled: true);
        await unwrap(store.put(const _Note(id: '1', text: 'a')));
        await unwrap(store.delete('1'));

        await unwrap(store.purge());

        expect(box.get('1'), isNull);
      });
    });

    test(
      'delete physically removes the record when soft-delete is disabled',
      () async {
        final store = buildStore();
        await unwrap(store.put(const _Note(id: '1', text: 'a')));

        await unwrap(store.delete('1'));

        expect(box.get('1'), isNull);
      },
    );
  });

  group('DocumentStore backend-swap contract', () {
    Future<void> exercisesTtlAndSoftDelete(DocumentStore<_Note> store) async {
      await unwrap(store.put(const _Note(id: '1', text: 'a')));
      expect((await unwrap(store.get('1'))).text, 'a');
      await unwrap(store.delete('1'));
      final result = await store.get('1');
      expect(result.isFailure, isTrue);
    }

    test('Hive backend and in-memory fake behave the same', () async {
      await exercisesTtlAndSoftDelete(buildStore());
      await exercisesTtlAndSoftDelete(
        InMemoryDocumentStore<_Note>(keyOf: (_Note note) => note.id),
      );
    });
  });
}
