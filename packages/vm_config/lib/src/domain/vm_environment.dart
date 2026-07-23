/// The active deployment environment, resolved from the injected
/// `VmConfigConfig` and exposed by `ConfigReader.environment` so consumers
/// can branch on it instead of a raw string or `--dart-define`.
enum VmEnvironment { dev, staging, prod }
