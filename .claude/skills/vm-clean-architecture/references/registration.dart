// DI — the module's single registration entry point.
// Receives config INJECTED by the app. No hard-coded keys/endpoints/env.
import 'package:get_it/get_it.dart';

import 'data.dart';
import 'domain.dart';
import 'presentation.dart';

/// Config the consuming app injects. Nothing here is hard-coded in the module.
class ArticleConfig {
  const ArticleConfig({required this.baseUrl});
  final String baseUrl;
}

/// Called from the app's bootstrap. With Injectable you would express this as a
/// generated `@module`; this is the shape of what ends up registered.
///
/// Depend on abstractions: register the interface, not the concrete type, so
/// consumers resolve `ArticleRepository`, never `ArticleRepositoryImpl`.
void registerArticleModule(GetIt gh, ArticleConfig config) {
  gh
    ..registerLazySingleton<ArticleRemoteDataSource>(
      // Build the datasource over injected infrastructure (e.g. vm_network)
      // using config.baseUrl. Throws here only because this is a template.
      () => throw UnimplementedError('provide an ArticleRemoteDataSource impl'),
    )
    ..registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(gh<ArticleRemoteDataSource>()),
    )
    ..registerFactory<ArticleCubit>(
      () => ArticleCubit(gh<ArticleRepository>()),
    );
}
