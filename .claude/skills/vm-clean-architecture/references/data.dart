// DATA layer — models mirror the wire/storage shape; mappers convert to domain.
// Depends on domain/ only. Nothing from domain leaks a model outward.
import 'package:json_annotation/json_annotation.dart';

import 'domain.dart';

part 'data.g.dart'; // run build_runner

// --- <feature>_model.dart --------------------------------------------------

@JsonSerializable()
class ArticleModel {
  const ArticleModel({required this.id, required this.title, required this.body});

  final String id;
  final String title;
  final String body;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}

/// Mapper: model -> entity. The domain never sees a model.
extension ArticleModelMapper on ArticleModel {
  Article toEntity() => Article(
        id: ArticleId.parse(id),
        title: title,
        body: body,
      );
}

// --- <feature>_remote_data_source.dart -------------------------------------

/// Raw IO abstraction. Implemented over vm_network/vm_storage, injected via DI.
abstract interface class ArticleRemoteDataSource {
  Future<ArticleModel> fetchById(String id);
  Future<List<ArticleModel>> fetchAll();
}

// --- <feature>_repository_impl.dart ----------------------------------------

/// Implements the domain interface. Catches IO errors, maps to domain Failure,
/// returns Result. Never lets an exception cross the boundary.
class ArticleRepositoryImpl implements ArticleRepository {
  const ArticleRepositoryImpl(this._remote);

  final ArticleRemoteDataSource _remote;

  @override
  Future<Result<Article>> getById(ArticleId id) async {
    try {
      final model = await _remote.fetchById(id.value);
      return Ok(model.toEntity());
    } on Exception catch (e) {
      return Err(_toFailure(e));
    }
  }

  @override
  Future<Result<List<Article>>> list() async {
    try {
      final models = await _remote.fetchAll();
      return Ok(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Err(_toFailure(e));
    }
  }

  Failure _toFailure(Object e) => switch (e) {
        // Map concrete IO exceptions (e.g. from vm_network) to domain failures.
        // TimeoutException() => const NetworkFailure(),
        _ => UnexpectedFailure(e),
      };
}
