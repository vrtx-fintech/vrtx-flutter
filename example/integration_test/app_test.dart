// On-device integration test for the Vrtx plugin.
//
// This is the credential-free e2e contract: it drives a real `Vrtx.setup`
// call on an emulator/simulator and asserts the call ROUND-TRIPS through the
// native SDK. Deliberately invalid credentials are used, so the native SDK
// rejects authentication and the plugin surfaces a typed [VrtxError]. We don't
// assert a successful login (that would need real secrets and a live backend);
// we assert the bridge is wired.
//
// The regression this guards against: a `MissingPluginException` (plugin not
// registered, or method-channel name mismatch) or a hang — either of which
// means a consumer's `Vrtx.setup` would never reach the native SDK.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vrtx_flutter/vrtx_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Vrtx.setup round-trips through the native SDK', (tester) async {
    try {
      await Vrtx.setup(
        clientId: 'ci-invalid-client-id',
        clientSecret: 'ci-invalid-client-secret',
        environment: Environment.sandbox,
        language: Language.english,
        mode: Mode.light,
      );
      // Resolved with no error — also a valid round-trip.
    } on VrtxError {
      // Expected: the invalid credentials make the native SDK reject auth,
      // surfaced as the plugin's own typed error. The bridge worked.
    } on MissingPluginException catch (e) {
      fail('Plugin not registered or method channel misnamed: $e');
    }
    // Any other exception type propagates and fails the test, which is correct:
    // only success or VrtxError is an acceptable round-trip result.
  });
}
