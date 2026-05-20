# Local Testing

Use the `example` app for local validation through the same flow used by real
consumers. The example depends on the plugin via `path: ..` in
`example/pubspec.yaml`, so changes in `lib/`, `android/`, or `ios/` are picked
up automatically — no symlinking or local registry override needed.

## First-time setup

After cloning, copy the credential template and (on macOS) fetch the iOS
binary framework:

```bash
cp example/lib/local_config.example.dart example/lib/local_config.dart
# macOS only — pulls VRTX.xcframework into ios/Frameworks/
./scripts/fetch_vrtx_ios.sh
```

`example/lib/local_config.dart` and `ios/Frameworks/` are both gitignored.

## After SDK changes

When changing files in `lib/`, `android/`, or `ios/`:

1. Get dependencies in the example app:

   ```bash
   cd example
   flutter pub get
   ```

2. Run the example app on the platform you touched:

   ```bash
   flutter run -d android
   # or
   flutter run -d ios
   ```

   Hot reload is enough for Dart-only changes in `lib/`. Native changes in
   `android/` or `ios/` require a full rebuild — stop the app and re-run
   `flutter run`.

## Bumping the VRTX iOS SDK

Override the pinned version with an env var, then rerun the fetch script and
`pod install`:

```bash
VRTX_IOS_VERSION=0.0.15 ./scripts/fetch_vrtx_ios.sh
cd example/ios && pod install
```

Update the default in `scripts/fetch_vrtx_ios.sh` once the bump is confirmed.

## Testing the published package

Before cutting a release, validate that the package can be published:

```bash
flutter pub publish --dry-run
```

To exercise the published artifact end-to-end, temporarily swap
`example/pubspec.yaml` from `path: ..` to the version constraint
(`vrtx_flutter: ^x.y.z`) and rerun `flutter pub get` in `example/`. Don't
commit that swap — the in-tree `path:` dependency is what the CI builds
against.

## Testing notes

- `flutter pub get` in `example/` is required after any change to the plugin's
  `pubspec.yaml` or after switching between `path:` and version dependencies.
- Rebuild the example app after native changes; hot reload alone is not enough
  for Android or iOS code changes.
- Run `flutter analyze` and `dart format --set-exit-if-changed .` from the
  repo root before pushing — CI runs the same checks.
