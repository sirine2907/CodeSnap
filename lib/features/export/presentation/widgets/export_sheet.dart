import 'package:flutter/material.dart';

enum ExportOption { savePng, sharePng, copyCode, copyMarkdown }

// Bottom sheet with the export choices. Returns the option the user tapped.
class ExportSheet extends StatelessWidget {
  // Saving with a file dialog only works on desktop.
  final bool canSave;

  const ExportSheet({super.key, required this.canSave});

  static Future<ExportOption?> show(BuildContext context, {required bool canSave}) {
    return showModalBottomSheet<ExportOption>(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 520),
      builder: (context) => ExportSheet(canSave: canSave),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Export',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (canSave)
              _option(
                context,
                icon: Icons.download_rounded,
                title: 'Save as PNG',
                subtitle: 'High quality image (2x)',
                option: ExportOption.savePng,
              ),
            _option(
              context,
              icon: Icons.ios_share_rounded,
              title: 'Share image',
              subtitle: 'Send it to another app',
              option: ExportOption.sharePng,
            ),
            _option(
              context,
              icon: Icons.content_copy_rounded,
              title: 'Copy code',
              subtitle: 'Plain text to the clipboard',
              option: ExportOption.copyCode,
            ),
            _option(
              context,
              icon: Icons.tag_rounded,
              title: 'Copy as Markdown',
              subtitle: 'Code block ready for a README or chat',
              option: ExportOption.copyMarkdown,
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required ExportOption option,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () => Navigator.of(context).pop(option),
    );
  }
}
