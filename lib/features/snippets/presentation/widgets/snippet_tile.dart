import 'package:flutter/material.dart';

import '../../../../core/constants/backgrounds.dart';
import '../../../../core/constants/code_themes.dart';
import '../../../../core/constants/languages.dart';
import '../../../editor/presentation/widgets/code_highlighter.dart';
import '../../domain/entities/snippet.dart';

class SnippetTile extends StatelessWidget {
  final Snippet snippet;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SnippetTile({
    super.key,
    required this.snippet,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final codeTheme = findCodeTheme(snippet.style.themeName);
    final background = findBackground(snippet.style.backgroundName);
    final language = findLanguage(snippet.language);

    // only the first lines fit in the small preview
    final previewCode = snippet.code.split('\n').take(8).join('\n');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(gradient: background.gradient),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: codeTheme.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: ClipRect(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 10,
                          height: 1.4,
                          color: codeTheme.textColor,
                        ),
                        children: highlightCode(
                          previewCode,
                          snippet.language,
                          codeTheme.styles,
                        ),
                      ),
                      softWrap: false,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snippet.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${language.label} · ${snippet.lineCount} lines · '
                          '${_formatDate(snippet.updatedAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
