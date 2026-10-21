import 'package:codesnap/core/errors/failures.dart';
import 'package:codesnap/features/snippets/data/datasources/snippet_local_data_source.dart';
import 'package:codesnap/features/snippets/data/models/snippet_model.dart';
import 'package:codesnap/features/snippets/data/repositories/snippet_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/sample_snippets.dart';

class MockSnippetLocalDataSource extends Mock implements SnippetLocalDataSource {}

void main() {
  late MockSnippetLocalDataSource dataSource;
  late SnippetRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(SnippetModel.fromEntity(pythonSnippet));
  });

  setUp(() {
    dataSource = MockSnippetLocalDataSource();
    repository = SnippetRepositoryImpl(dataSource);
  });

  test('getSnippets sorts newest first', () async {
    when(() => dataSource.getSnippets()).thenAnswer((_) async => [
          SnippetModel.fromEntity(rustSnippet),
          SnippetModel.fromEntity(pythonSnippet),
          SnippetModel.fromEntity(goSnippet),
        ]);

    final result = await repository.getSnippets();

    expect(result.map((s) => s.id).toList(), ['1', '3', '6']);
  });

  test('getSnippets turns CacheException into Failure', () async {
    when(() => dataSource.getSnippets()).thenThrow(CacheException('broken'));

    expect(repository.getSnippets(), throwsA(isA<Failure>()));
  });

  test('saveSnippet passes a model to the data source', () async {
    when(() => dataSource.saveSnippet(any())).thenAnswer((_) async {});

    await repository.saveSnippet(pythonSnippet);

    verify(() => dataSource.saveSnippet(SnippetModel.fromEntity(pythonSnippet)))
        .called(1);
  });
}
