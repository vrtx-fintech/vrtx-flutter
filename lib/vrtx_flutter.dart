import 'package:flutter/services.dart';

// ─── Enums (mirror both native SDKs) ─────────────────────────────────────────

enum Environment { sandbox, staging }

enum Language { english, arabic }

enum Mode { light, dark }

// ─── Error model ──────────────────────────────────────────────────────────────

/// Mirrors the native error object.
/// [status]  → iOS `error.status`  / Android `error.status`
/// [message] → iOS `error.message` / Android `error.message`
class VrtxError implements Exception {
  final String status;
  final String message;

  const VrtxError({required this.status, required this.message});

  @override
  String toString() => 'VrtxError($status): $message';
}

// ─── Plugin ───────────────────────────────────────────────────────────────────

class Vrtx {
  static const MethodChannel _channel = MethodChannel('vrtx_flutter');

  /// Authenticates with Vrtx and launches the SDK's own UI flow.
  ///
  /// Completes normally when the SDK UI has been successfully launched
  /// (mirrors `onSuccess`), or throws a [VrtxError] if the SDK reports
  /// a failure (mirrors `onError`).
  ///
  /// Parameters:
  /// - [clientId]     Your Vrtx client ID.
  /// - [clientSecret] Your Vrtx client secret.
  /// - [environment]  [Environment.sandbox] or [Environment.staging].
  /// - [language]     [Language.english] or [Language.arabic].
  /// - [mode]         [Mode.light] or [Mode.dark].
  /// - [fontFamily]   Optional font-family name already registered in the app.
  ///                  Pass `null` to use the SDK default.
  static Future<void> setup({
    required String clientId,
    required String clientSecret,
    required Environment environment,
    required Language language,
    required Mode mode,
    String? fontFamily,
  }) async {
    try {
      await _channel.invokeMethod<void>('setup', {
        'clientId': clientId,
        'clientSecret': clientSecret,
        'environment': environment.name,   // "sandbox" | "staging"
        'language': language.name,         // "english" | "arabic"
        'mode': mode.name,                 // "light"   | "dark"
        'fontFamily': fontFamily,          // nullable
      });
    } on PlatformException catch (e) {
      // e.code    → error.status  from native
      // e.message → error.message from native
      throw VrtxError(
        status: e.code,
        message: e.message ?? 'Unknown error',
      );
    }
  }
}
