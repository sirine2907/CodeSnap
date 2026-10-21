part of 'library_bloc.dart';

enum LibraryStatus { loading, loaded, error }

class LibraryState extends Equatable {
  final LibraryStatus status;
  final List<Snippet> snippets;
  final String query;
  final String errorMessage;

  const LibraryState({
    this.status = LibraryStatus.loading,
    this.snippets = const [],
    this.query = '',
    this.errorMessage = '',
  });

  // Snippets that match the search box (title, language or code).
  List<Snippet> get visibleSnippets {
    final search = query.trim().toLowerCase();
    if (search.isEmpty) {
      return snippets;
    }
    return snippets.where((snippet) {
      return snippet.title.toLowerCase().contains(search) ||
          snippet.language.toLowerCase().contains(search) ||
          snippet.code.toLowerCase().contains(search);
    }).toList();
  }

  LibraryState copyWith({
    LibraryStatus? status,
    List<Snippet>? snippets,
    String? query,
    String? errorMessage,
  }) {
    return LibraryState(
      status: status ?? this.status,
      snippets: snippets ?? this.snippets,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, snippets, query, errorMessage];
}
