/// A type with exactly one value, used as the success payload of a
/// [Result]-like return that carries no meaningful data (e.g. `refresh()`
/// only needs to signal "it worked", not produce a value).
final class Unit {
  const Unit._();

  /// The single instance of [Unit].
  static const Unit value = Unit._();

  @override
  String toString() => 'Unit';
}
