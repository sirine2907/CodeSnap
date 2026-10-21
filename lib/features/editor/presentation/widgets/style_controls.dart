import 'package:flutter/material.dart';

import '../../../../core/constants/backgrounds.dart';
import '../../../../core/constants/code_themes.dart';
import '../../../snippets/domain/entities/snippet_style.dart';

// All the controls that change how the card looks.
class StyleControls extends StatelessWidget {
  final SnippetStyle style;
  final ValueChanged<SnippetStyle> onChanged;

  const StyleControls({
    super.key,
    required this.style,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label('Theme'),
        InputDecorator(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: style.themeName,
              isExpanded: true,
              items: codeThemes.map((theme) {
                return DropdownMenuItem(
                  value: theme.name,
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.background,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(theme.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(style.copyWith(themeName: value));
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _Label('Background'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: backgroundPresets.map((background) {
            final selected = background.name == style.backgroundName;
            return Tooltip(
              message: background.name,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  onChanged(style.copyWith(backgroundName: background.name));
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: background.gradient,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _Label('Padding  ${style.padding.round()}px'),
        Slider(
          value: style.padding,
          min: 16,
          max: 96,
          divisions: 10,
          onChanged: (value) => onChanged(style.copyWith(padding: value)),
        ),
        _Label('Font size  ${style.fontSize.round()}'),
        Slider(
          value: style.fontSize,
          min: 10,
          max: 22,
          divisions: 12,
          onChanged: (value) => onChanged(style.copyWith(fontSize: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Line numbers'),
          value: style.showLineNumbers,
          onChanged: (value) {
            onChanged(style.copyWith(showLineNumbers: value));
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Window buttons'),
          value: style.showWindowControls,
          onChanged: (value) {
            onChanged(style.copyWith(showWindowControls: value));
          },
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
