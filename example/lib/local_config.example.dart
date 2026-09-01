/// Template for local Vrtx credentials. Copy this file to `local_config.dart`
/// and fill in real values for local development. `local_config.dart` is
/// gitignored.
library;

/// Vrtx client ID issued by your Vrtx account manager.
const vrtxClientId = 'YOUR_CLIENT_ID';

/// Vrtx client secret issued by your Vrtx account manager.
const vrtxClientSecret = 'YOUR_CLIENT_SECRET';

/// Target Vrtx environment: `sandbox` or `production`.
const vrtxEnvironment = 'sandbox';

/// Base64-encoded SHA-256 hash of the Android signing certificate.
/// Generate this for your local debug keystore before running Android.
const vrtxCertHash = 'YOUR_BASE64_SHA256_CERTIFICATE_HASH';
