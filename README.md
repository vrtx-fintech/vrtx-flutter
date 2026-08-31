# vrtx-flutter

The official Flutter SDK for Vrtx — onboarding, wallet, and card flows for your app.

## Install

Add the package from [pub.dev](https://pub.dev/packages/vrtx_flutter):

```bash
flutter pub add vrtx_flutter
```

This adds the latest version to your `pubspec.yaml` and runs `flutter pub get`.

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
    externalReference: 'YOUR_EXTERNAL_REFERENCE', // omit when no external reference is needed
    fontFamily: 'Inter', // omit to use the SDK default per language
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
| Flutter     | 3.44.0+ |
| Dart        | 3.12.0+ |

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
| `compileSdk`          | 37      |
| Android Gradle Plugin | 8.13    |
| Kotlin                | 2.4     |
| JVM target            | 17      |

`vrtx-android` uses Talsec freeRASP to verify the host app's package name and
signing certificate. Configure the required repositories in
`android/settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        maven(url = "https://europe-west3-maven.pkg.dev/talsec-artifact-repository/freerasp")
        maven(url = "https://jitpack.io")
        mavenCentral()
    }
}
```

Then configure the placeholders in `android/app/build.gradle.kts`:

```kotlin
android {
    defaultConfig {
        manifestPlaceholders["vrtxPackageName"] = applicationId
        manifestPlaceholders["vrtxCertHash"] = "YOUR_BASE64_SHA256_CERTIFICATE_HASH"
    }
}
```

Generate the certificate hash from the certificate that signs the installed
app. Debug and release hashes may be comma-separated:

```bash
keytool -list -v -keystore path/to/your/keystore.jks -alias your_alias
echo -n "SHA256_HEX_WITHOUT_COLONS" | xxd -r -p | base64
```

FreeRASP disables Android backups; set `android:allowBackup="false"` on the
host app's `<application>` element to avoid a manifest-merger conflict. Run a
full native rebuild after changing the hash.

## Contract

The Flutter API mirrors the native SDK public enums:

| Parameter     | Enum          | Values                                       |
| ------------- | ------------- | -------------------------------------------- |
| `environment` | `Environment` | `Environment.sandbox`, `Environment.production` |
| `language`    | `Language`    | `Language.english`, `Language.arabic`        |
| `mode`        | `Mode`        | `Mode.light`, `Mode.dark`                    |

`externalReference` may be passed with an app-provided SDK session reference.
`fontFamily` may be passed with the name of a font already bundled in the host app.

## Result

| Result  | Dart behavior                          |
| ------- | -------------------------------------- |
| Success | `Vrtx.setup(...)` completes normally   |
| Error   | `Vrtx.setup(...)` throws a `VrtxError` |

`VrtxError` contains a native `status` code and a human-readable `message`.

## Support

For credentials, license keys, and integration help, contact your Vrtx account manager or [support@vrtx.sa](mailto:support@vrtx.sa).

## License

Licensed under the Apache License, Version 2.0. Copyright (C) 2026 vrtx fintech.
