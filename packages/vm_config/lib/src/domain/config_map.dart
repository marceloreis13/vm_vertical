/// Shorthand for a raw key/value config snapshot (remote payload, cache
/// snapshot, or defaults map). Values are whatever a provider/cache
/// resolves to — typing to a specific Dart type happens at the
/// `ConfigReader` getter boundary.
typedef ConfigMap = Map<String, Object?>;

/// Shorthand for a decoded JSON object value, as returned by
/// `ConfigReader.getJson`.
typedef JsonMap = Map<String, dynamic>;
