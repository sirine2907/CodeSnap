import '../../../../core/errors/failures.dart';
import '../../domain/entities/snippet.dart';
import '../../domain/repositories/snippet_repository.dart';
import '../datasources/snippet_local_data_source.dart';
import '../models/snippet_model.dart';

class SnippetRepositoryImpl implements SnippetRepository {
  final SnippetLocalDataSource localDataSource;

  SnippetRepositoryImpl(this.localDataSource);

  @override
  Future<List<Snippet>> getSnippets() async {
    try {
      final snippets = await localDataSource.getSnippets();
      // newest first
      snippets.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return snippets;
    } on CacheException catch (e) {
      throw Failure(e.message);
    }
  }

  @override
  Future<void> saveSnippet(Snippet snippet) async {
    try {
      await localDataSource.saveSnippet(SnippetModel.fromEntity(snippet));
    } on CacheException catch (e) {
      throw Failure(e.message);
    }
  }

  @override
  Future<void> deleteSnippet(String id) async {
    try {
      await localDataSource.deleteSnippet(id);
    } on CacheException catch (e) {
      throw Failure(e.message);
    }
  }
}
