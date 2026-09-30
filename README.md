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

final theme = VrtxThemeOptions(
  cardImage: 'https://example.com/card.png',
  brandLogo: 'https://example.com/logo.png',
  brandName: 'Atlas Pay',
  colors: VrtxColors(
    allBrands: VrtxAllBrandColors(
      primary: '#377DFF',
      buttonLabel: '#FFFFFF',
    ),
    labels: VrtxLabelColors(
      primary: '#12233D',
      secondary: '#60708A',
      tertiary: '#8B9AB2',
      quaternary: '#B8C4D6',
    ),
    fills: VrtxFillColors(
      primary: '#EAF3FF',
      secondary: '#DCEAFF',
      tertiary: '#C5D9F5',
      quaternary: '#ADC8EC',
      vibrant: VrtxVibrantFillColors(secondary: '#4DE3D1'),
    ),
    backgrounds: VrtxBackgroundColors(
      primary: '#F4F8FF',
      secondary: '#F7FAFF',
      tertiary: '#E7F5F6',
      primaryElevated: '#FFFFFF',
      secondaryElevated: '#F1F6FC',
      tertiaryElevated: '#E6EEF8',
    ),
    backgroundsGradient: VrtxBackgroundGradientColors(
      wb01: '#EAF3FF',
      wb02: '#E7F5F6',
    ),
    accents: VrtxAccentColors(
      red: '#E05252',
      redBg: '#FFE7E7',
      green: '#2E9B67',
      greenBg: '#E1F5EA',
      orange: '#E58A2B',
      indigo: '#5B5BD6',
      teal: '#4DE3D1',
      pink: '#D65B9B',
      cyan: '#2DAAC7',
      purple: '#8A5BD6',
    ),
  ),
  spacing: VrtxSpacing(
    x0: 0, xxs: 2, xs: 4, sm: 8, md: 12, ml: 16,
    lg: 20, xl: 24, xxl: 32, xxxl: 40,
  ),
  radius: VrtxRadius(
    x0: 0, xxs: 2, xs: 4, s: 6, sm: 8, md: 12, ml: 16,
    lg: 20, xl: 24, xxl: 28, xxxl: 32, big: 40, full: 999, huge: 64,
  ),
  sizing: VrtxSizing(
    xxs: 2, xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48, xxxl: 64,
  ),
);

try {
  await Vrtx.setup(
    clientId: 'your-client-id',
    clientSecret: 'your-client-secret',
    environment: Environment.sandbox,
    language: Language.english,
    mode: Mode.light,
    designOption: DesignOption.optionC,
    theme: theme,
    externalReference: 'YOUR_EXTERNAL_REFERENCE', // omit when no external reference is needed
    fontFamily: 'Inter', // omit to use the SDK default per language
    onExit: () => print('Vrtx screen closed'),
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
| Android Gradle Plugin | 9.1     |
| Kotlin                | 2.4.10  |
| JVM target            | 17      |

The Flutter plugin uses `sa.vrtx.sa:vrtx-android:0.1.13` on Android and the
`VRTX` CocoaPod `0.1.15` on iOS. `vrtx-android` uses Talsec freeRASP to verify
the host app's package name and signing certificate. Configure the required repositories in
`android/settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
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

The Flutter API mirrors the native SDK public configuration contract:

| Parameter      | Type               | Values                                                                 |
| -------------- | ------------------ | ---------------------------------------------------------------------- |
| `environment`  | `Environment`      | `Environment.sandbox`, `Environment.production`                        |
| `language`     | `Language`         | `Language.english`, `Language.arabic`                                  |
| `mode`         | `Mode`             | `Mode.light`, `Mode.dark`                                              |
| `designOption` | `DesignOption`     | `DesignOption.optionA`, `DesignOption.optionB`, `DesignOption.optionC` |
| `theme`        | `VrtxThemeOptions` | Optional brand and design-token overrides                              |

`externalReference` may be passed with an app-provided SDK session reference.
`fontFamily` may be passed with the name of a font already bundled in the host app.
`onExit` is called when the user closes the native SDK flow.

### Theme options

Theme images are remote URLs. Color values use `#RRGGBB` or
`rgba(r,g,b,a)` strings; spacing, radius, and sizing values use logical pixels.
Every theme field is optional and omitted fields retain the native SDK defaults.

`VrtxThemeOptions` accepts these top-level keys:

| Key         | Type                       |
| ----------- | -------------------------- |
| `cardImage` | `String?` remote image URL |
| `brandLogo` | `String?` remote image URL |
| `brandName` | `String?`                  |
| `colors`    | `VrtxColors?`              |
| `spacing`   | `VrtxSpacing?`             |
| `radius`    | `VrtxRadius?`              |
| `sizing`    | `VrtxSizing?`              |

`VrtxColors` contains these groups and keys:

| Group                 | Keys                                                                                           |
| --------------------- | ---------------------------------------------------------------------------------------------- |
| `allBrands`           | `primary`, `buttonLabel`                                                                       |
| `labels`              | `primary`, `secondary`, `tertiary`, `quaternary`                                               |
| `fills`               | `primary`, `secondary`, `tertiary`, `quaternary`, `vibrant.secondary`                          |
| `backgrounds`         | `primary`, `secondary`, `tertiary`, `primaryElevated`, `secondaryElevated`, `tertiaryElevated` |
| `backgroundsGradient` | `wb01`, `wb02`                                                                                 |
| `accents`             | `red`, `redBg`, `green`, `greenBg`, `orange`, `indigo`, `teal`, `pink`, `cyan`, `purple`       |

The numeric token groups accept these keys:

| Group     | Keys                                                                                       |
| --------- | ------------------------------------------------------------------------------------------ |
| `spacing` | `x0`, `xxs`, `xs`, `sm`, `md`, `ml`, `lg`, `xl`, `xxl`, `xxxl`                             |
| `radius`  | `x0`, `xxs`, `xs`, `s`, `sm`, `md`, `ml`, `lg`, `xl`, `xxl`, `xxxl`, `big`, `full`, `huge` |
| `sizing`  | `xxs`, `xs`, `sm`, `md`, `lg`, `xl`, `xxl`, `xxxl`                                         |

## Result

| Result  | Dart behavior                             |
| ------- | ----------------------------------------- |
| Success | `Vrtx.setup(...)` completes normally      |
| Error   | `Vrtx.setup(...)` throws a `VrtxError`    |
| Exit    | `onExit` runs when the native flow closes |

`VrtxError` contains a native `status` code and a human-readable `message`.

## Support

For credentials, license keys, and integration help, contact your Vrtx account manager or [contact@vrtx.sa](mailto:contact@vrtx.sa).

## License

Licensed under the Apache License, Version 2.0. Copyright (C) 2026 vrtx fintech.
