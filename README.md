# vrtx-flutter

The official Flutter SDK for Vrtx — onboarding, wallet, and card flows for your app.

## Install

Add `vrtx_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  vrtx_flutter:
    path: ./vrtx-flutter
```

Then install dependencies:

```bash
flutter pub get
```

## Quick start

```dart
import 'package:vrtx_flutter/vrtx_flutter.dart';

try {
  await Vrtx.setup(
    clientId: 'your-client-id',
    clientSecret: 'your-client-secret',
    environment: Environment.sandbox,
    language: Language.english,
    mode: Mode.light,
  );

  print('Vrtx screen opened');
} on VrtxError catch (error) {
  print('Vrtx error: ${error.status} ${error.message}');
}
```

## Requirements

### Flutter

| Requirement | Version |
| ----------- | ------- |
| Flutter     | 3.10.0+ |
| Dart        | 3.0.0+  |

### iOS

| Requirement | Version |
| ----------- | ------- |
| iOS         | 15.6+   |
| Xcode       | 16+     |
| Swift       | 5.9+    |

Set the minimum iOS version in your app's `ios/Podfile`:

```ruby
platform :ios, '15.6'
```

Then run `pod install` from your `ios/` directory.

### Android

| Requirement           | Version |
| --------------------- | ------- |
| `minSdk`              | 29      |
| `compileSdk`          | 36      |
| Android Gradle Plugin | 8.13    |
| Kotlin                | 2.1     |
| JVM target            | 17      |

Make sure your Android project can resolve Google and Maven Central artifacts:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}
```

## Contract

The Flutter API mirrors the native SDK public enums:

| Parameter     | Enum              | Values                                                 |
| ------------- | ----------------- | ------------------------------------------------------ |
| `environment` | `Environment` | `Environment.sandbox`, `Environment.staging` |
| `language`    | `Language`    | `Language.english`, `Language.arabic`        |
| `mode`        | `Mode`        | `Mode.light`, `Mode.dark`                    |

`fontFamily` may be passed with the name of a font already bundled in the host app.

## Result

| Result    | Dart behavior                                      |
| --------- | -------------------------------------------------- |
| Success   | `Vrtx.setup(...)` completes normally              |
| Error     | `Vrtx.setup(...)` throws a `VrtxError`            |

`VrtxError` contains a native `status` code and a human-readable `message`.

## Support

For credentials, license keys, and integration help, contact your Vrtx account manager or [support@vrtx.sa](mailto:support@vrtx.sa).

## License

Licensed under the Apache License, Version 2.0. Copyright (C) 2026 vrtx fintech.
