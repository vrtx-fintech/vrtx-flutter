import 'package:flutter_test/flutter_test.dart';
import 'package:vrtx_flutter/vrtx_flutter.dart';

void main() {
  test('serializes the shared native theme contract', () {
    const theme = VrtxThemeOptions(
      colors: VrtxColors(
        backgrounds: VrtxBackgroundColors(
          primary: '#F4FBF7',
          secondary: '#F8FCF9',
        ),
        accents: VrtxAccentColors(
          red: '#D9534F',
          green: '#16804F',
          greenBg: '#DDF3E7',
        ),
      ),
      spacing: VrtxSpacing(x0: 0, ml: 16),
      radius: VrtxRadius(s: 6, huge: 64),
    );

    expect(theme.toMap(), {
      'colors': {
        'backgrounds': {
          'primary': '#F4FBF7',
          'secondary': '#F8FCF9',
        },
        'accents': {
          'red': '#D9534F',
          'green': '#16804F',
          'greenBg': '#DDF3E7',
        },
      },
      'spacing': {'x0': 0.0, 'ml': 16.0},
      'radius': {'s': 6.0, 'huge': 64.0},
    });
  });
}
