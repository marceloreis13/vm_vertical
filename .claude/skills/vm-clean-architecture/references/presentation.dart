// PRESENTATION layer — Flutter. Renders state, dispatches intents.
// No IO, no mapping, no data access. Depends on domain/ only.
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'domain.dart';

part 'presentation.freezed.dart'; // run build_runner

// --- <feature>_cubit.dart --------------------------------------------------

/// State is a sealed/Freezed union. No mutable fields.
@freezed
sealed class ArticleState with _$ArticleState {
  const factory ArticleState.initial() = ArticleInitial;
  const factory ArticleState.loading() = ArticleLoading;
  const factory ArticleState.loaded(List<Article> articles) = ArticleLoaded;
  const factory ArticleState.error(Failure failure) = ArticleError;
}

/// Cubit orchestrates the domain. It holds no business rules and no IO.
class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit(this._repository) : super(const ArticleState.initial());

  final ArticleRepository _repository;

  Future<void> load() async {
    emit(const ArticleState.loading());
    final result = await _repository.list();
    emit(switch (result) {
      Ok(:final value) => ArticleState.loaded(value),
      Err(:final failure) => ArticleState.error(failure),
    });
  }
}

// --- screen/<feature>_screen.dart -------------------------------------------
//
// Screen: entry point. Binds the Cubit, composes Sections. See
// vm-ui-composition for the Screen/Sections/Views split this mirrors.

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArticleSection();
  }
}

// --- sections/article_section.dart ------------------------------------------
//
// Section: reads this feature's State, decides what to render. Never
// promoted or reused by another feature.

class ArticleSection extends StatelessWidget {
  const ArticleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) => switch (state) {
        ArticleInitial() || ArticleLoading() => const _Loading(),
        ArticleLoaded(:final articles) => ArticleListView(articles: articles),
        ArticleError(:final failure) => _Error(failure: failure),
      },
    );
  }
}

// Placeholders — in a real feature these use vm_storyboard components
// (VmLoadingView / VmErrorView), so they typically aren't hand-written here.
class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _Error extends StatelessWidget {
  const _Error({required this.failure});
  final Failure failure;
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// --- views/article_list_view.dart -------------------------------------------
//
// View: plain parameters only, no Cubit/State/repository. Reusable elsewhere
// unchanged — promote to vm_storyboard or a shared package if it repeats in
// a second feature.

class ArticleListView extends StatelessWidget {
  const ArticleListView({required this.articles, super.key});
  final List<Article> articles;
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
