// Sample tests for a feature (see vm-clean-architecture's Article example).
// Illustrative only. Split into files under test/<feature>/{domain,data,presentation}/.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:vm_<module>/vm_<module>.dart'; // public API (barrel)

// --- test/fakes/fake_article_remote_data_source.dart -----------------------

class FakeArticleRemoteDataSource implements ArticleRemoteDataSource {
  FakeArticleRemoteDataSource({this.onFetchAll});
  final Future<List<ArticleModel>> Function()? onFetchAll;

  @override
  Future<ArticleModel> fetchById(String id) async =>
      const ArticleModel(id: '1', title: 't', body: 'b');

  @override
  Future<List<ArticleModel>> fetchAll() =>
      (onFetchAll ?? () async => const <ArticleModel>[])();
}

void main() {
  // --- domain: value object validation ------------------------------------
  group('ArticleId', () {
    test('parse throws on empty', () {
      expect(() => ArticleId.parse('  '), throwsArgumentError);
    });
  });

  // --- data: repository maps IO error to a domain Failure -----------------
  group('ArticleRepositoryImpl', () {
    test('returns Err(NetworkFailure) when the datasource throws timeout', () async {
      final repo = ArticleRepositoryImpl(
        FakeArticleRemoteDataSource(
          onFetchAll: () async => throw TimeoutException('x'),
        ),
      );

      final result = await repo.list();

      expect(result, isA<Err<List<Article>>>());
      // expect((result as Err).failure, isA<NetworkFailure>()); // once mapping is wired
    });
  });

  // --- presentation: cubit emits the expected state sequence ---------------
  blocTest<ArticleCubit, ArticleState>(
    'emits [loading, loaded] on successful load',
    build: () => ArticleCubit(_FakeRepo.ok(const [])),
    act: (cubit) => cubit.load(),
    expect: () => [isA<ArticleLoading>(), isA<ArticleLoaded>()],
  );

  // --- presentation: golden for a component in both themes ------------------
  testWidgets('ArticleView golden (light)', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ArticleView()));
    await expectLater(
      find.byType(ArticleView),
      matchesGoldenFile('goldens/article_view_light.png'),
    );
  });
}

// Minimal fake repository for the bloc test.
class _FakeRepo implements ArticleRepository {
  _FakeRepo(this._articles);
  factory _FakeRepo.ok(List<Article> a) => _FakeRepo(a);
  final List<Article> _articles;

  @override
  Future<Result<Article>> getById(ArticleId id) async => Err(const NotFoundFailure());

  @override
  Future<Result<List<Article>>> list() async => Ok(_articles);
}
