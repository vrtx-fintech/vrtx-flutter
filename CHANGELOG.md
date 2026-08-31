# Changelog

## 0.1.4

- iOS: bump `VRTX` to 0.1.11, the latest published pod.
- iOS: drop the explicit `DeviceKit` pin — the `VRTX` pod already declares
  `DeviceKit (= 5.7.0)` itself, so CocoaPods resolves it transitively and a
  second exact pin could only conflict later.
- Android: the `INVALID_ENVIRONMENT` error message now interpolates the
  rejected value instead of printing a literal `$environmentName`.
- Example: build against the plugin source in this repository instead of the
  published package, so the platform CI jobs exercise the code under review.

## 0.1.3

- Add the iOS Free-RASP runtime protection bundled with `VRTX` 0.1.10.

## 0.1.2

- **Breaking:** `Environment.staging` is replaced by `Environment.production`.
  0.1.0 and 0.1.1 kept the old Dart value but neither native bridge accepted
  it, so it silently ran against sandbox and production was unreachable from
  Dart. Callers must move to `Environment.production` or
  `Environment.sandbox` deliberately.
- Both native bridges now reject an unrecognised environment with
  `INVALID_ENVIRONMENT` instead of silently falling back to sandbox.
- Pin the `DeviceKit` pod to `5.7.0`, matching the version the VRTX
  xcframework is compiled against.

## 0.1.1

- Fix Android release-build compatibility with the FreeRASP SDK dependency.

## 0.1.0

- Android: upgrade to `vrtx-android` 0.1.1 with FreeRASP app-integrity support.
- iOS: upgrade to `VRTX` 0.1.2 and link its `DeviceKit` dependency.
- Replace the `staging` environment with `production`.

## 0.0.2

- iOS: pull the VRTX SDK from CocoaPods trunk via `s.dependency 'VRTX'`
  instead of vendoring a downloaded `VRTX.xcframework`.

## 0.0.1

- Initial release of the Vrtx Flutter SDK.
