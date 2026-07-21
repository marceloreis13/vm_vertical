// DOMAIN layer — pure Dart. No Flutter. No imports from data/ or presentation/.
// Template: split into <feature>_entity.dart, failures.dart, <feature>_repository.dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain.freezed.dart'; // run build_runner

// --- failures.dart ---------------------------------------------------------

/// Result returned across boundaries. Never throw across layers.
sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

/// Domain failures for this module. The data layer maps IO errors to these.
sealed class Failure {
  const Failure();
}

class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(this.cause);
  final Object cause;
}

// --- <feature>_entity.dart -------------------------------------------------

/// Value object: equality by value, validated on creation.
@freezed
class ArticleId with _$ArticleId {
  const ArticleId._();
  const factory ArticleId(String value) = _ArticleId;

  factory ArticleId.parse(String raw) {
    if (raw.trim().isEmpty) {
      throw ArgumentError('ArticleId cannot be empty');
    }
    return ArticleId(raw);
  }
}

/// Entity: identity-based, immutable.
@freezed
class Article with _$Article {
  const factory Article({
    required ArticleId id,
    required String title,
    required String body,
  }) = _Article;
}

// --- <feature>_repository.dart ---------------------------------------------

/// Repository interface, expressed in domain terms, returns Result.
/// Implemented in the data layer, wired by DI.
abstract interface class ArticleRepository {
  Future<Result<Article>> getById(ArticleId id);
  Future<Result<List<Article>>> list();
}
