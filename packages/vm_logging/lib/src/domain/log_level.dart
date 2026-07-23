/// The five ordered severity levels a [Logger] entry can carry, from least
/// to most severe: `trace < debug < info < warn < error`.
///
/// Declaration order backs [Comparable]/`<`/`>=` via [index], so ordering is
/// total and directly usable to compare an entry's level against a sink's
/// `minLevel` threshold.
enum LogLevel implements Comparable<LogLevel> {
  trace,
  debug,
  info,
  warn,
  error;

  @override
  int compareTo(LogLevel other) => index.compareTo(other.index);

  bool operator <(LogLevel other) => index < other.index;

  bool operator <=(LogLevel other) => index <= other.index;

  bool operator >(LogLevel other) => index > other.index;

  bool operator >=(LogLevel other) => index >= other.index;
}
