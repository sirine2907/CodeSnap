import '../entities/snippet.dart';
import '../repositories/snippet_repository.dart';

class SaveSnippet {
  final SnippetRepository repository;

  SaveSnippet(this.repository);

  // Gives new snippets an id and updates the date, then saves.
  // Returns the snippet that was saved so the editor can keep the id.
  Future<Snippet> call(Snippet snippet) async {
    final now = DateTime.now();
    var toSave = snippet.copyWith(updatedAt: now);

    if (snippet.isNew) {
      toSave = toSave.copyWith(id: now.millisecondsSinceEpoch.toString());
    }

    if (toSave.title.trim().isEmpty) {
      toSave = toSave.copyWith(title: 'Untitled');
    }

    await repository.saveSnippet(toSave);
    return toSave;
  }
}
