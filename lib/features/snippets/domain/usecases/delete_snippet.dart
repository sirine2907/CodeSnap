import '../repositories/snippet_repository.dart';

class DeleteSnippet {
  final SnippetRepository repository;

  DeleteSnippet(this.repository);

  Future<void> call(String id) {
    return repository.deleteSnippet(id);
  }
}
