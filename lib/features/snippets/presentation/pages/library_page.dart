import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/snippet.dart';
import '../bloc/library_bloc.dart';
import '../widgets/snippet_tile.dart';

// Shows the saved snippets. Tapping one closes the page and returns it.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My snippets')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name, language or code',
              ),
              onChanged: (value) {
                context.read<LibraryBloc>().add(LibrarySearchChanged(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state.status == LibraryStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == LibraryStatus.error) {
                  return Center(child: Text(state.errorMessage));
                }
                if (state.snippets.isEmpty) {
                  return const _EmptyMessage(
                    icon: Icons.bookmark_border,
                    text: 'No snippets yet.\nSave one from the editor and it will show up here.',
                  );
                }

                final snippets = state.visibleSnippets;
                if (snippets.isEmpty) {
                  return _EmptyMessage(
                    icon: Icons.search_off,
                    text: 'Nothing matches "${state.query}"',
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisExtent: 220,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: snippets.length,
                  itemBuilder: (context, index) {
                    final snippet = snippets[index];
                    return SnippetTile(
                      snippet: snippet,
                      onTap: () => Navigator.of(context).pop(snippet),
                      onDelete: () => _confirmDelete(context, snippet),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Snippet snippet) async {
    final bloc = context.read<LibraryBloc>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete snippet?'),
        content: Text('"${snippet.title}" will be removed from your library.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bloc.add(LibrarySnippetDeleted(snippet.id));
    }
  }
}

class _EmptyMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
