import '../entities/snippet.dart';

abstract class SnippetRepository {
  Future<List<Snippet>> getSnippets();

  Future<void> saveSnippet(Snippet snippet);

  Future<void> deleteSnippet(String id);
}
