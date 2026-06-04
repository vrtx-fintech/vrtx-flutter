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

  /// Staging environment for pre-production validation.
  staging,
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
  /// - [externalReference] Optional app-provided SDK session reference.
  /// - [fontFamily]   Optional font-family name already registered in the
  ///                  host app. Pass `null` to use the SDK default.
  static Future<void> setup({
    required String clientId,
    required String clientSecret,
    required Environment environment,
    required Language language,
    required Mode mode,
    String? externalReference,
    String? fontFamily,
  }) async {
    try {
      await _channel.invokeMethod<void>('setup', <String, Object?>{
        'clientId': clientId,
        'clientSecret': clientSecret,
        'environment': environment.name,
        'language': language.name,
        'mode': mode.name,
        'externalReference': externalReference,
        'fontFamily': fontFamily,
      });
    } on PlatformException catch (e) {
      throw VrtxError(
        status: e.code,
        message: e.message ?? 'Unknown error',
      );
    }
  }
}
