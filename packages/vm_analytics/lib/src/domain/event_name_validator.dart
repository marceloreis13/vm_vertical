/// The provider-agnostic naming convention shared by `AnalyticsEvent.name`
/// and manual `screenView(name)` calls: snake_case, starting with a lowercase
/// letter, only lowercase letters/digits/underscores, bounded length. This is
/// a superset reasonable across vendors (e.g. Firebase's own 40-char
/// snake_case limit); a provider may further sanitize/truncate when mapping
/// to its own SDK.
const int kAnalyticsNameMaxLength = 40;

final RegExp _analyticsNamePattern = RegExp(r'^[a-z][a-z0-9_]*$');

/// Validates [name] against the naming convention and returns it unchanged
/// on success. Throws [ArgumentError] on any violation (empty, camelCase,
/// spaces, leading digit/underscore, disallowed character, or over
/// [kAnalyticsNameMaxLength]) — construction fails rather than silently
/// forwarding an invalid name to a provider.
String validateAnalyticsName(String name, {required String label}) {
  if (name.isEmpty) {
    throw ArgumentError.value(name, label, 'must not be empty');
  }
  if (name.length > kAnalyticsNameMaxLength) {
    throw ArgumentError.value(
      name,
      label,
      'must be at most $kAnalyticsNameMaxLength characters',
    );
  }
  if (!_analyticsNamePattern.hasMatch(name)) {
    throw ArgumentError.value(
      name,
      label,
      'must be snake_case: start with a lowercase letter and contain only '
      'lowercase letters, digits and underscores',
    );
  }
  return name;
}

/// Best-effort conversion of an arbitrary identifier (e.g. a go_router route
/// name/path) into a name that satisfies [validateAnalyticsName]: lowercased,
/// non-alphanumeric runs collapsed to a single underscore, leading digits/
/// underscores trimmed, and truncated to [kAnalyticsNameMaxLength]. Used by
/// `AnalyticsRouteObserver` so automatic screen tracking never throws on an
/// oddly-shaped route name. Returns `null` if nothing usable remains.
String? sanitizeAnalyticsName(String raw) {
  final lowered = raw.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '_');
  final trimmed = lowered.replaceFirst(RegExp(r'^[0-9_]+'), '');
  final collapsed = trimmed
      .replaceAll(RegExp('_+'), '_')
      .replaceFirst(RegExp(r'_$'), '');
  if (collapsed.isEmpty) return null;
  final bounded = collapsed.length > kAnalyticsNameMaxLength
      ? collapsed.substring(0, kAnalyticsNameMaxLength)
      : collapsed;
  final name = bounded.replaceFirst(RegExp(r'_$'), '');
  return name.isEmpty ? null : name;
}
