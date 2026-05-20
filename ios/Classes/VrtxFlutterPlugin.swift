import Flutter
import UIKit
import VRTX

public class VrtxFlutterPlugin: NSObject, FlutterPlugin {

    // ── Registration ──────────────────────────────────────────────────────────

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "vrtx_flutter",
            binaryMessenger: registrar.messenger()
        )
        let instance = VrtxFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // ── Method dispatch ───────────────────────────────────────────────────────

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setup":
            handleSetup(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // ── setup ─────────────────────────────────────────────────────────────────

    private func handleSetup(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGS", message: "Expected a dictionary of arguments.", details: nil))
            return
        }

        // ── Parse arguments ──────────────────────────────────────────────────

        guard
            let clientId     = args["clientId"]     as? String,
            let clientSecret = args["clientSecret"] as? String
        else {
            result(FlutterError(code: "MISSING_ARGS", message: "clientId and clientSecret are required.", details: nil))
            return
        }

        let fontFamily = args["fontFamily"] as? String  // nullable → nil uses SDK default

        let environment: VrtxEnvironment = {
            switch args["environment"] as? String {
            case "staging": return .staging
            default:        return .sandbox
            }
        }()

        let language: VrtxLanguage = {
            switch args["language"] as? String {
            case "arabic": return .arabic
            default:       return .english
            }
        }()

        let mode: VrtxThemeMode = {
            switch args["mode"] as? String {
            case "dark": return .dark
            default:     return .light
            }
        }()

        // ── Call SDK ─────────────────────────────────────────────────────────
        // The SDK presents its own UI. Wrap callbacks in DispatchQueue.main for safety.

        Vrtx.setup(
            environment:  environment,
            clientID:     clientId,
            clientSecret: clientSecret,
            mode:         mode,
            language:     language,
            fontFamily:   fontFamily,           // nil → SDK default font
            onSuccess: {
                DispatchQueue.main.async {
                    result(nil)                 // Future completes normally
                }
            },
            onError: { error in
                DispatchQueue.main.async {
                    result(FlutterError(
                        code:    error.status,  // → PlatformException.code  in Dart
                        message: error.message, // → PlatformException.message in Dart
                        details: nil
                    ))
                }
            }
        )
    }
}
