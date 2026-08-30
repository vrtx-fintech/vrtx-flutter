import 'package:flutter_test/flutter_test.dart';
import 'package:vrtx_flutter/vrtx_flutter.dart';

/// The Dart enum name is sent verbatim over the method channel and matched
/// as a string by both native bridges (`VrtxFlutterPlugin.kt` and
/// `VrtxFlutterPlugin.swift`). Nothing in the type system ties the two
/// together, so a rename on either side compiles cleanly and fails only at
/// runtime — which is exactly how 0.1.0 and 0.1.1 shipped with `staging` on
/// the Dart side and `production` on both native sides, silently routing
/// every caller to sandbox. This test is that missing link.
void main() {
  group('Environment channel contract', () {
    test('exposes exactly the values both native bridges accept', () {
      expect(
        Environment.values.map((e) => e.name).toSet(),
        {'sandbox', 'production'},
      );
    });

    test('does not expose staging, which no native SDK accepts', () {
      expect(
        Environment.values.map((e) => e.name),
        isNot(contains('staging')),
      );
    });
  });

  group('Language and Mode channel contracts', () {
    test('Language names match the native bridges', () {
      expect(
        Language.values.map((e) => e.name).toSet(),
        {'english', 'arabic'},
      );
    });

    test('Mode names match the native bridges', () {
      expect(Mode.values.map((e) => e.name).toSet(), {'light', 'dark'});
    });
  });
}
