import 'package:flutter/material.dart';

// Gradient that goes behind the code window.
class BackgroundPreset {
  final String name;
  final List<Color> colors;

  const BackgroundPreset(this.name, this.colors);

  LinearGradient get gradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
}

const List<BackgroundPreset> backgroundPresets = [
  BackgroundPreset('Candy', [Color(0xFFFF7EB3), Color(0xFF7C5CFF)]),
  BackgroundPreset('Sunset', [Color(0xFFFFB86C), Color(0xFFFF5F6D)]),
  BackgroundPreset('Ocean', [Color(0xFF4FACFE), Color(0xFF00F2FE)]),
  BackgroundPreset('Forest', [Color(0xFF43E97B), Color(0xFF1E9E8F)]),
  BackgroundPreset('Peach', [Color(0xFFFFECD2), Color(0xFFFCB69F)]),
  BackgroundPreset('Midnight', [Color(0xFF232526), Color(0xFF414345)]),
  BackgroundPreset('Snow', [Color(0xFFE9EEF5), Color(0xFFDDE3EC)]),
];

BackgroundPreset findBackground(String name) {
  for (final background in backgroundPresets) {
    if (background.name == name) {
      return background;
    }
  }
  return backgroundPresets.first;
}
