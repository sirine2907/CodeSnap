import 'package:codesnap/core/errors/failures.dart';
import 'package:codesnap/features/snippets/data/datasources/snippet_local_data_source.dart';
import 'package:codesnap/features/snippets/data/models/snippet_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/sample_snippets.dart';

void main() {
  late SnippetLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dataSource = SnippetLocalDataSourceImpl(await SharedPreferences.getInstance());
  });

  test('returns empty list when nothing is saved', () async {
    expect(await dataSource.getSnippets(), isEmpty);
  });

  test('saves a new snippet and reads it back', () async {
    await dataSource.saveSnippet(SnippetModel.fromEntity(pythonSnippet));

    final result = await dataSource.getSnippets();

    expect(result, [SnippetModel.fromEntity(pythonSnippet)]);
  });

  test('saving with the same id replaces the old one', () async {
    await dataSource.saveSnippet(SnippetModel.fromEntity(pythonSnippet));
    final edited = pythonSnippet.copyWith(title: 'renamed.py');

    await dataSource.saveSnippet(SnippetModel.fromEntity(edited));

    final result = await dataSource.getSnippets();
    expect(result.length, 1);
    expect(result.first.title, 'renamed.py');
  });

  test('deletes a snippet by id', () async {
    await dataSource.saveSnippet(SnippetModel.fromEntity(pythonSnippet));
    await dataSource.saveSnippet(SnippetModel.fromEntity(goSnippet));

    await dataSource.deleteSnippet(pythonSnippet.id);

    final result = await dataSource.getSnippets();
    expect(result, [SnippetModel.fromEntity(goSnippet)]);
  });

  test('throws CacheException when saved data is broken', () async {
    SharedPreferences.setMockInitialValues({
      SnippetLocalDataSourceImpl.snippetsKey: 'not json',
    });
    dataSource = SnippetLocalDataSourceImpl(await SharedPreferences.getInstance());

    expect(dataSource.getSnippets(), throwsA(isA<CacheException>()));
  });
}
