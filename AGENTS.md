# Local Testing

Use the `example` app for local validation through the same flow used by real
consumers. The example depends on the plugin via `path: ..` in
`example/pubspec.yaml`, so changes in `lib/`, `android/`, or `ios/` are picked
up automatically — no symlinking or local registry override needed.

## First-time setup

After cloning, copy the credential template:

```bash
cp example/lib/local_config.example.dart example/lib/local_config.dart
```

`example/lib/local_config.dart` is gitignored. The VRTX iOS SDK is pulled
automatically by CocoaPods (`pod install`, run transparently by
`flutter build`) — it is a binary pod published to CocoaPods trunk, declared
as `s.dependency 'VRTX', '<version>'` in `ios/vrtx_flutter.podspec`. No fetch
step is needed.

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

Update the pinned version in `ios/vrtx_flutter.podspec`
(`s.dependency 'VRTX', '<version>'`), then refresh the example's pods:

```bash
cd example/ios && pod update VRTX
```

The version must match a release published to CocoaPods trunk
(<https://github.com/vrtx-fintech/vrtx-ios/releases>).

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
