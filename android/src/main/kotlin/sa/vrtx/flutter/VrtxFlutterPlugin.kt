package sa.vrtx.flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.app.Activity
import androidx.compose.ui.text.font.FontFamily

import sa.vrtx.public.Vrtx
import sa.vrtx.public.configuration.Environment
import sa.vrtx.public.configuration.Language
import sa.vrtx.public.configuration.Mode

class VrtxFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel

    // Vrtx.setup() launches its own Activity, so we need the current Activity context.
    private var activity: Activity? = null

    // ── FlutterPlugin ─────────────────────────────────────────────────────────

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "vrtx_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ── ActivityAware ─────────────────────────────────────────────────────────

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    // ── MethodCallHandler ─────────────────────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setup" -> handleSetup(call, result)
            else    -> result.notImplemented()
        }
    }

    private fun handleSetup(call: MethodCall, result: Result) {
        val currentActivity = activity
        if (currentActivity == null) {
            result.error("NO_ACTIVITY", "No active Activity found. Make sure the plugin is attached.", null)
            return
        }

        // ── Parse arguments ──────────────────────────────────────────────────

        val clientId     = call.argument<String>("clientId")!!
        val clientSecret = call.argument<String>("clientSecret")!!
        val fontFamily   = call.argument<String?>("fontFamily")

        val environment: Environment = when (call.argument<String>("environment")) {
            "staging" -> Environment.Staging
            else      -> Environment.Sandbox   // default to sandbox
        }

        val language: Language = when (call.argument<String>("language")) {
            "arabic" -> Language.Arabic
            else     -> Language.English
        }

        val mode: Mode = when (call.argument<String>("mode")) {
            "dark" -> Mode.DARK
            else   -> Mode.LIGHT
        }

        // FontFamily: Flutter fonts aren't auto-available as Compose fonts.
        // We use FontFamily.Default and let the app customize at native level if needed.
        // Future: accept a pre-built FontFamily via a companion helper.
        val composeFontFamily: FontFamily = FontFamily.Default

        // ── Call SDK ─────────────────────────────────────────────────────────
        // Callbacks are delivered on the main thread per SDK docs — no Handler needed.

        Vrtx.setup(
            clientId     = clientId,
            clientSecret = clientSecret,
            environment  = environment,
            language     = language,
            mode         = mode,
            fontFamily   = composeFontFamily,
            onSuccess    = {
                result.success(null)
            },
            onError      = { error ->
                result.error(
                    error.status,   // → PlatformException.code  in Dart
                    error.message,  // → PlatformException.message in Dart
                    null
                )
            }
        )
    }
}
