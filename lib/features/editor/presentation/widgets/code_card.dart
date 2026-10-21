import 'package:flutter/material.dart';

import '../../../../core/constants/backgrounds.dart';
import '../../../../core/constants/code_themes.dart';
import '../../../snippets/domain/entities/snippet.dart';
import 'code_highlighter.dart';

// The card that gets exported as an image:
// gradient background -> window with dots and title -> highlighted code.
class CodeCard extends StatelessWidget {
  final Snippet snippet;

  const CodeCard({super.key, required this.snippet});

  @override
  Widget build(BuildContext context) {
    final style = snippet.style;
    final codeTheme = findCodeTheme(style.themeName);
    final background = findBackground(style.backgroundName);

    // tabs look huge in Text, so swap them for 2 spaces
    final code = snippet.code.replaceAll('\t', '  ');
    final lineCount = code.split('\n').length;

    final codeTextStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: style.fontSize,
      height: 1.5,
      color: codeTheme.textColor,
    );

    return Container(
      decoration: BoxDecoration(gradient: background.gradient),
      padding: EdgeInsets.all(style.padding),
      child: Container(
        constraints: const BoxConstraints(minWidth: 380),
        padding: const EdgeInsets.fromLTRB(20, 16, 28, 22),
        decoration: BoxDecoration(
          color: codeTheme.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WindowBar(
              title: snippet.title,
              showDots: style.showWindowControls,
              color: codeTheme.textColor,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (style.showLineNumbers)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      List.generate(lineCount, (i) => '${i + 1}').join('\n'),
                      textAlign: TextAlign.right,
                      style: codeTextStyle.copyWith(
                        color: codeTheme.textColor.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                Text.rich(
                  TextSpan(
                    style: codeTextStyle,
                    children: highlightCode(
                      code,
                      snippet.language,
                      codeTheme.styles,
                    ),
                  ),
                  softWrap: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowBar extends StatelessWidget {
  final String title;
  final bool showDots;
  final Color color;

  const _WindowBar({
    required this.title,
    required this.showDots,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDots) ...[
          _dot(const Color(0xFFFF5F57)),
          _dot(const Color(0xFFFEBC2E)),
          _dot(const Color(0xFF28C840)),
          const SizedBox(width: 10),
        ],
        Text(
          title,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            color: color.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
