import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../../../domain/document_store.dart';
import '../../../domain/key_value_store.dart';
import '../../../domain/secure_store.dart';
import '../../../domain/vm_storage_config.dart';
import '../demo_note.dart';
import '../document_demo_cubit.dart';
import '../key_value_demo_cubit.dart';
import '../secure_demo_cubit.dart';
import '../sections/document_section.dart';
import '../sections/key_value_section.dart';
import '../sections/secure_section.dart';

/// Entry point of the `vm_storage` visual example. Resolves the
/// app-registered `KeyValueStore`, `SecureStore` and `DocumentStoreFactory`
/// (via `registerVmStorageModule`, all opted-in) and opens a demo document
/// collection. Lives in `lib/`, not `example/`, so any app can embed it
/// directly (see `docs/module-scaffold.md`).
class StorageDemoScreen extends StatefulWidget {
  const StorageDemoScreen({this.getIt, super.key});

  /// Defaults to [GetIt.instance]; overridable for tests/embedding apps
  /// with a scoped container.
  final GetIt? getIt;

  static const collection = 'demo_notes';

  @override
  State<StorageDemoScreen> createState() => _StorageDemoScreenState();
}

class _StorageDemoScreenState extends State<StorageDemoScreen> {
  static const _tabs = ['Preferences', 'Secure', 'Documents'];

  late final GetIt _container;
  DocumentStore<DemoNote>? _documentStore;
  bool _softDeleteEnabled = false;

  @override
  void initState() {
    super.initState();
    _container = widget.getIt ?? GetIt.instance;
    unawaited(_openDocumentStore());
  }

  Future<void> _openDocumentStore() async {
    final config = _container<VmStorageConfig>();
    final options = config.collectionOptions(StorageDemoScreen.collection);
    final store = await _container<DocumentStoreFactory>().open<DemoNote>(
      collection: StorageDemoScreen.collection,
      toJson: (note) => note.toJson(),
      fromJson: DemoNote.fromJson,
      keyOf: (note) => note.id,
    );
    if (!mounted) return;
    setState(() {
      _documentStore = store;
      _softDeleteEnabled = options.softDeleteEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final documentStore = _documentStore;
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: VmAppBar(
          title: 'vm_storage example',
          bottom: TabBar(tabs: [for (final tab in _tabs) Tab(text: tab)]),
        ),
        body: documentStore == null
            ? const VmLoadingView()
            : TabBarView(
                children: [
                  BlocProvider(
                    create: (_) =>
                        KeyValueDemoCubit(store: _container<KeyValueStore>()),
                    child: const KeyValueSection(),
                  ),
                  BlocProvider(
                    create: (_) =>
                        SecureDemoCubit(store: _container<SecureStore>()),
                    child: const SecureSection(),
                  ),
                  BlocProvider(
                    create: (_) => DocumentDemoCubit(
                      store: documentStore,
                      softDeleteEnabled: _softDeleteEnabled,
                    ),
                    child: const DocumentSection(),
                  ),
                ],
              ),
      ),
    );
  }
}
