import Flutter
import UIKit
import VRTX

public class VrtxFlutterPlugin: NSObject, FlutterPlugin {

    private var channel: FlutterMethodChannel!

    // ── Registration ──────────────────────────────────────────────────────────

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "vrtx_flutter",
            binaryMessenger: registrar.messenger()
        )
        let instance = VrtxFlutterPlugin()
        instance.channel = channel
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

        let externalReference = args["externalReference"] as? String
        let fontFamily = args["fontFamily"] as? String  // nullable → nil uses SDK default
        let designOption: DesignOption = {
            switch args["designOption"] as? String {
            case "optionA": return .optionA
            case "optionB": return .optionB
            default: return .optionC
            }
        }()
        let theme = themeOptions(from: args["theme"] as? [String: Any])

        // Reject unknown values rather than defaulting: a silent fallback can
        // point an integrator at the wrong backend without any signal, the
        // worst possible failure mode for an environment switch.
        let environmentName = args["environment"] as? String
        let environment: Environment
        switch environmentName {
        case "sandbox":    environment = .sandbox
        case "production": environment = .production
        default:
            result(FlutterError(
                code: "INVALID_ENVIRONMENT",
                message: "Unsupported environment '\(environmentName ?? "nil")'. Expected 'sandbox' or 'production'.",
                details: nil
            ))
            return
        }

        let language: Language = {
            switch args["language"] as? String {
            case "arabic": return .arabic
            default:       return .english
            }
        }()

        let mode: Mode = {
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
            externalReference: externalReference,
            fontFamily:   fontFamily ?? "",           // nil → SDK default font
            designOption: designOption,
            theme:        theme,
            onSuccess: {
                DispatchQueue.main.async {
                    result(nil)                 // Future completes normally
                }
            },
            onError: { error in
                DispatchQueue.main.async {
                    result(FlutterError(
                        // VrtxSetupError.status is Int; surfaced as a string via PlatformException.code in Dart.
                        code:    String(error.status),
                        message: error.message,
                        details: nil
                    ))
                }
            },
            onExit: {
                DispatchQueue.main.async {
                    self.channel.invokeMethod("onExit", arguments: nil)
                }
            }
        )
    }

    private func themeOptions(from object: [String: Any]?) -> ThemeOptions? {
        guard let object else { return nil }

        func text(_ object: [String: Any]?, _ key: String) -> String? {
            object?[key] as? String
        }
        func number(_ object: [String: Any]?, _ key: String) -> CGFloat? {
            guard let value = object?[key] as? NSNumber else { return nil }
            return CGFloat(value.doubleValue)
        }
        func child(_ object: [String: Any]?, _ key: String) -> [String: Any]? {
            object?[key] as? [String: Any]
        }

        let options = ThemeOptions()
        options.brandName = text(object, "brandName")
        if let value = text(object, "cardImage"), let url = URL(string: value) {
            options.cardImage = .remote(url)
        }
        if let value = text(object, "brandLogo"), let url = URL(string: value) {
            options.brandLogo = .remote(url)
        }

        if let colors = child(object, "colors") {
            let allBrands = child(colors, "allBrands").map {
                VrtxColors.AllBrands(
                    primary: text($0, "primary"),
                    buttonLabel: text($0, "buttonLabel"),
                )
            }
            let labels = child(colors, "labels").map {
                VrtxColors.Labels(
                    primary: text($0, "primary"),
                    secondary: text($0, "secondary"),
                    tertiary: text($0, "tertiary"),
                    quaternary: text($0, "quaternary"),
                )
            }
            let fills = child(colors, "fills").map { value in
                VrtxColors.Fills(
                    primary: text(value, "primary"),
                    secondary: text(value, "secondary"),
                    tertiary: text(value, "tertiary"),
                    quaternary: text(value, "quaternary"),
                    vibrant: child(value, "vibrant").map {
                        VrtxColors.Fills.Vibrant(secondary: text($0, "secondary"))
                    },
                )
            }
            let backgrounds = child(colors, "backgrounds").map {
                VrtxColors.Backgrounds(
                    primary: text($0, "primary"),
                    secondary: text($0, "secondary"),
                )
            }
            let gradients = child(colors, "backgroundsGradient").map {
                VrtxColors.BackgroundsGradient(
                    wb01: text($0, "wb01"), wb02: text($0, "wb02"),
                )
            }
            let accents = child(colors, "accents").map {
                VrtxColors.Accents(
                    red: text($0, "red"),
                    green: text($0, "green"), greenBg: text($0, "greenBg"),
                )
            }
            options.colors = VrtxColors(
                allBrands: allBrands,
                labels: labels,
                fills: fills,
                backgrounds: backgrounds,
                backgroundsGradient: gradients,
                accents: accents,
            )
        }

        if let spacing = child(object, "spacing") {
            options.spacing = VrtxSpacing(
                x0: number(spacing, "x0"), xxs: number(spacing, "xxs"),
                xs: number(spacing, "xs"), sm: number(spacing, "sm"),
                md: number(spacing, "md"), ml: number(spacing, "ml"),
                lg: number(spacing, "lg"),
            )
        }
        if let radius = child(object, "radius") {
            options.radius = VrtxRadius(
                s: number(radius, "s"), sm: number(radius, "sm"),
                md: number(radius, "md"),
                lg: number(radius, "lg"),
                full: number(radius, "full"), huge: number(radius, "huge"),
            )
        }
        return options
    }

}
