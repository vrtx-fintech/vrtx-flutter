# Changelog

## 0.0.2

- iOS: pull the VRTX SDK from CocoaPods trunk via `s.dependency 'VRTX'`
  instead of vendoring a downloaded `VRTX.xcframework`. `pod install` now
  fetches the binary automatically — no out-of-band download step is needed.
- No changes to the public Dart API.

## 0.0.1

- Initial release of the Vrtx Flutter SDK.
- Public `Vrtx.setup(...)` entry point bridging the iOS and Android native SDKs.
- `Environment`, `Language`, and `Mode` enums mirror the native SDK contracts.
- `VrtxError` exception surfaces native `status` and `message` to Dart callers.
