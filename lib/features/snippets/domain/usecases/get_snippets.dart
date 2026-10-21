import '../entities/snippet.dart';
import '../repositories/snippet_repository.dart';

class GetSnippets {
  final SnippetRepository repository;

  GetSnippets(this.repository);

  Future<List<Snippet>> call() {
    return repository.getSnippets();
  }
}
