import '../../snippets/domain/entities/snippet.dart';
import '../../snippets/domain/entities/snippet_style.dart';

// Code shown when the app opens so the preview isn't empty.
const String sampleCode = '''// Count the words in a sentence
Map<String, int> countWords(String text) {
  final counts = <String, int>{};

  for (final word in text.toLowerCase().split(' ')) {
    if (word.isEmpty) continue;
    counts[word] = (counts[word] ?? 0) + 1;
  }

  return counts;
}

void main() {
  print(countWords('the cat and the hat'));
}''';

Snippet newSnippet() {
  return Snippet(
    id: '',
    title: 'word_count.dart',
    code: sampleCode,
    language: 'dart',
    style: const SnippetStyle(),
    updatedAt: DateTime.now(),
  );
}
