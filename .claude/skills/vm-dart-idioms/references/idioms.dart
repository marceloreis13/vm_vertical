// Compact, copyable Dart 3.x idioms used across vm_core.
// Illustrative only (not part of the build).
import 'dart:async';

// --- Sealed union + exhaustive switch expression ---------------------------

sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Err<T> extends Result<T> {
  const Err(this.error);
  final Object error;
}

String describe(Result<int> r) => switch (r) {
      Ok(:final value) => 'ok: $value',
      Err(:final error) => 'err: $error',
      // No default: adding a new subtype forces this switch to be updated.
    };

// --- Null-safety without bang ----------------------------------------------

int lengthOrZero(String? s) => switch (s) {
      final v? => v.length, // binds only when non-null
      null => 0,
    };

// --- Records for local grouping / multiple returns -------------------------

(int total, int errors) tally(List<Result<int>> results) {
  var total = 0;
  var errors = 0;
  for (final r in results) {
    switch (r) {
      case Ok():
        total++;
      case Err():
        errors++;
    }
  }
  return (total, errors);
}

// --- Immutability + extension helper ---------------------------------------

class Money {
  const Money(this.cents);
  final int cents;

  Money operator +(Money other) => Money(cents + other.cents);
}

extension MoneyFormat on Money {
  String get formatted => '\$${(cents / 100).toStringAsFixed(2)}';
}

// --- Async: parallel awaits, Result instead of throwing --------------------

Future<Result<(int, int)>> loadBoth(
  Future<int> Function() a,
  Future<int> Function() b,
) async {
  try {
    final results = await Future.wait([a(), b()]);
    return Ok((results[0], results[1]));
  } on Exception catch (e) {
    return Err(e);
  }
}

// --- Collections: declarative building -------------------------------------

List<String> labels(List<int> ids, {bool includeZero = false}) => [
      if (includeZero) 'zero',
      for (final id in ids.where((i) => i > 0)) 'item-$id',
    ];
