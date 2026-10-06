// Theme value objects are documented together in the README contract.
// ignore_for_file: public_member_api_docs
/// Flutter SDK for Vrtx — onboarding, wallet, and card flows.
///
/// Public surface mirrors the native iOS and Android SDKs. Call
/// [Vrtx.setup] to authenticate and launch the SDK UI.
library;

import 'package:flutter/services.dart';

// ─── Enums (mirror both native SDKs) ─────────────────────────────────────────

/// Target Vrtx environment.
enum Environment {
  /// Sandbox environment for local development and integration testing.
  sandbox,

  /// Production environment serving live customers.
  production,
}

/// SDK display language.
enum Language {
  /// English locale.
  english,

  /// Arabic locale.
  arabic,
}

/// SDK display theme.
enum Mode {
  /// Light theme.
  light,

  /// Dark theme.
  dark,
}

/// Selects the SDK's product design variant.
enum DesignOption {
  /// Design variant A.
  optionA,

  /// Design variant B.
  optionB,

  /// Design variant C.
  optionC,
}

/// Optional colors for [VrtxThemeOptions]. Values are CSS-style color strings
/// such as `#377DFF` or `rgba(55, 125, 255, 1)`.
class VrtxColors {
  const VrtxColors({
    this.allBrands,
    this.labels,
    this.fills,
    this.backgrounds,
    this.backgroundsGradient,
    this.accents,
  });

  final VrtxAllBrandColors? allBrands;
  final VrtxLabelColors? labels;
  final VrtxFillColors? fills;
  final VrtxBackgroundColors? backgrounds;
  final VrtxBackgroundGradientColors? backgroundsGradient;
  final VrtxAccentColors? accents;

  Map<String, Object?> toMap() => _nonNullMap({
    'allBrands': allBrands?.toMap(),
    'labels': labels?.toMap(),
    'fills': fills?.toMap(),
    'backgrounds': backgrounds?.toMap(),
    'backgroundsGradient': backgroundsGradient?.toMap(),
    'accents': accents?.toMap(),
  });
}

/// Brand colors used by the SDK.
class VrtxAllBrandColors {
  const VrtxAllBrandColors({this.primary, this.buttonLabel});

  final String? primary;
  final String? buttonLabel;

  Map<String, Object?> toMap() => _nonNullMap({
    'primary': primary,
    'buttonLabel': buttonLabel,
  });
}

/// Label colors used by the SDK.
class VrtxLabelColors {
  const VrtxLabelColors({
    this.primary,
    this.secondary,
    this.tertiary,
    this.quaternary,
  });

  final String? primary;
  final String? secondary;
  final String? tertiary;
  final String? quaternary;

  Map<String, Object?> toMap() => _nonNullMap({
    'primary': primary,
    'secondary': secondary,
    'tertiary': tertiary,
    'quaternary': quaternary,
  });
}

/// Fill colors used by the SDK.
class VrtxFillColors {
  const VrtxFillColors({
    this.primary,
    this.secondary,
    this.tertiary,
    this.quaternary,
    this.vibrant,
  });

  final String? primary;
  final String? secondary;
  final String? tertiary;
  final String? quaternary;
  final VrtxVibrantFillColors? vibrant;

  Map<String, Object?> toMap() => _nonNullMap({
    'primary': primary,
    'secondary': secondary,
    'tertiary': tertiary,
    'quaternary': quaternary,
    'vibrant': vibrant?.toMap(),
  });
}

/// Vibrant fill colors used by the SDK.
class VrtxVibrantFillColors {
  const VrtxVibrantFillColors({this.secondary});

  final String? secondary;

  Map<String, Object?> toMap() => _nonNullMap({'secondary': secondary});
}

/// Background colors used by the SDK.
class VrtxBackgroundColors {
  const VrtxBackgroundColors({
    this.primary,
    this.secondary,
  });

  final String? primary;
  final String? secondary;

  Map<String, Object?> toMap() => _nonNullMap({
    'primary': primary,
    'secondary': secondary,
  });
}

/// Gradient background colors used by the SDK.
class VrtxBackgroundGradientColors {
  const VrtxBackgroundGradientColors({this.wb01, this.wb02});

  final String? wb01;
  final String? wb02;

  Map<String, Object?> toMap() => _nonNullMap({'wb01': wb01, 'wb02': wb02});
}

/// Accent colors used by the SDK.
class VrtxAccentColors {
  const VrtxAccentColors({
    this.red,
    this.green,
    this.greenBg,
  });

  final String? red;
  final String? green;
  final String? greenBg;

  Map<String, Object?> toMap() => _nonNullMap({
    'red': red,
    'green': green,
    'greenBg': greenBg,
  });
}

/// Spacing overrides, expressed in logical pixels.
class VrtxSpacing {
  const VrtxSpacing({
    this.x0,
    this.xxs,
    this.xs,
    this.sm,
    this.md,
    this.ml,
    this.lg,
  });

  final double? x0;
  final double? xxs;
  final double? xs;
  final double? sm;
  final double? md;
  final double? ml;
  final double? lg;

  Map<String, Object?> toMap() => _nonNullMap({
    'x0': x0,
    'xxs': xxs,
    'xs': xs,
    'sm': sm,
    'md': md,
    'ml': ml,
    'lg': lg,
  });
}

/// Corner-radius overrides, expressed in logical pixels.
class VrtxRadius {
  const VrtxRadius({
    this.s,
    this.sm,
    this.md,
    this.lg,
    this.full,
    this.huge,
  });

  final double? s;
  final double? sm;
  final double? md;
  final double? lg;
  final double? full;
  final double? huge;

  Map<String, Object?> toMap() => _nonNullMap({
    's': s,
    'sm': sm,
    'md': md,
    'lg': lg,
    'full': full,
    'huge': huge,
  });
}

/// Optional brand and design-token overrides for the native SDK UI.
class VrtxThemeOptions {
  /// Creates optional theme overrides. Image values must be remote URLs.
  const VrtxThemeOptions({
    this.cardImage,
    this.brandLogo,
    this.brandName,
    this.colors,
    this.spacing,
    this.radius,
  });

  final String? cardImage;
  final String? brandLogo;
  final String? brandName;
  final VrtxColors? colors;
  final VrtxSpacing? spacing;
  final VrtxRadius? radius;

  Map<String, Object?> toMap() => _nonNullMap({
    'cardImage': cardImage,
    'brandLogo': brandLogo,
    'brandName': brandName,
    'colors': colors?.toMap(),
    'spacing': spacing?.toMap(),
    'radius': radius?.toMap(),
  });
}

Map<String, Object?> _nonNullMap(Map<String, Object?> values) =>
    Map<String, Object?>.fromEntries(
      values.entries.where((entry) => entry.value != null),
    );

// ─── Error model ─────────────────────────────────────────────────────────────

/// Error thrown by [Vrtx.setup] when the native SDK reports a failure.
///
/// Mirrors the native error object:
/// - [status]  → iOS `error.status`  / Android `error.status`
/// - [message] → iOS `error.message` / Android `error.message`
class VrtxError implements Exception {
  /// Creates a [VrtxError] with the native [status] code and [message].
  const VrtxError({required this.status, required this.message});

  /// Native status code, e.g. `auth_failed`, `network_error`.
  final String status;

  /// Human-readable message from the native SDK.
  final String message;

  @override
  String toString() => 'VrtxError($status): $message';
}

// ─── Plugin ──────────────────────────────────────────────────────────────────

/// Entry point for the Vrtx Flutter SDK.
class Vrtx {
  const Vrtx._();

  static const MethodChannel _channel = MethodChannel('vrtx_flutter');
  static VoidCallback? _onExit;
  static bool _handlerInstalled = false;

  static void _ensureHandler() {
    if (_handlerInstalled) return;
    _handlerInstalled = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onExit') _onExit?.call();
    });
  }

  /// Authenticates with Vrtx and launches the SDK's own UI flow.
  ///
  /// Completes normally when the SDK UI has been successfully launched
  /// (mirrors `onSuccess`), or throws a [VrtxError] if the SDK reports
  /// a failure (mirrors `onError`).
  ///
  /// Parameters:
  /// - [clientId]     Your Vrtx client ID.
  /// - [clientSecret] Your Vrtx client secret.
  /// - [environment]  [Environment.sandbox] or [Environment.production].
  /// - [language]     [Language.english] or [Language.arabic].
  /// - [mode]         [Mode.light] or [Mode.dark].
  /// - [externalReference] Optional app-provided SDK session reference.
  /// - [fontFamily]   Optional font-family name already registered in the
  ///                  host app. Pass `null` to use the SDK default.
  /// - [designOption] Optional native design variant.
  /// - [theme]        Optional native theme and design-token overrides.
  /// - [onExit]       Called when the user closes the native SDK flow.
  static Future<void> setup({
    required String clientId,
    required String clientSecret,
    required Environment environment,
    required Language language,
    required Mode mode,
    String? externalReference,
    String? fontFamily,
    DesignOption? designOption,
    VrtxThemeOptions? theme,
    VoidCallback? onExit,
  }) async {
    _ensureHandler();
    _onExit = onExit;
    try {
      await _channel.invokeMethod<void>('setup', <String, Object?>{
        'clientId': clientId,
        'clientSecret': clientSecret,
        'environment': environment.name,
        'language': language.name,
        'mode': mode.name,
        'externalReference': externalReference,
        'fontFamily': fontFamily,
        'designOption': designOption?.name,
        'theme': theme?.toMap(),
      });
    } on PlatformException catch (e) {
      throw VrtxError(
        status: e.code,
        message: e.message ?? 'Unknown error',
      );
    }
  }
}
