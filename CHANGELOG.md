# Changelog

## 0.0.2

- Maintenance release; no functional changes to the SDK.

## 0.0.1

- Initial release of the Vrtx Flutter SDK.
- Public `Vrtx.setup(...)` entry point bridging the iOS and Android native SDKs.
- `Environment`, `Language`, and `Mode` enums mirror the native SDK contracts.
- `VrtxError` exception surfaces native `status` and `message` to Dart callers.
