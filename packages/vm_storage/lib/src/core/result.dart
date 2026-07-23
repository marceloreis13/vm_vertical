/// Either a success value [S] or a typed failure [F].
///
/// Defined locally in `vm_storage` (`lib/src/core/`) and isolated so it can
/// later migrate to `vm_foundation` without changing consumers' call sites.
sealed class Result<S, F> {
  const Result();

  /// Exhaustively folds both branches into a single value of type [R].
  R when<R>({
    required R Function(S value) success,
    required R Function(F failure) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<S, F>() => success(self.value),
      Err<S, F>() => failure(self.value),
    };
  }

  /// Maps the success value, leaving a failure untouched.
  Result<R, F> map<R>(R Function(S value) transform) {
    final self = this;
    return switch (self) {
      Success<S, F>() => Success<R, F>(transform(self.value)),
      Err<S, F>() => Err<R, F>(self.value),
    };
  }

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Err<S, F>;
}

final class Success<S, F> extends Result<S, F> {
  const Success(this.value);

  final S value;
}

/// The failure branch of a [Result], carrying the typed error value [F].
final class Err<S, F> extends Result<S, F> {
  const Err(this.value);

  final F value;
}
