package sa.vrtx.flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.app.Activity
import android.graphics.Typeface
import androidx.compose.ui.text.font.FontFamily
import org.json.JSONArray

import sa.vrtx.public.Vrtx
import sa.vrtx.public.configuration.Environment
import sa.vrtx.public.configuration.Language
import sa.vrtx.public.configuration.Mode

class VrtxFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var flutterAssets: FlutterPlugin.FlutterAssets? = null

    // Vrtx.setup() launches its own Activity, so we need the current Activity context.
    private var activity: Activity? = null

    // ── FlutterPlugin ─────────────────────────────────────────────────────────

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterAssets = binding.flutterAssets
        channel = MethodChannel(binding.binaryMessenger, "vrtx_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        flutterAssets = null
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

        val composeFontFamily: FontFamily = resolveFontFamily(currentActivity, fontFamily)

        // ── Call SDK ─────────────────────────────────────────────────────────

        currentActivity.runOnUiThread {
            try {
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
                            error::class.simpleName ?: "VRTX_ERROR",
                            error.message ?: "Unknown error",
                            null
                        )
                    }
                )
            } catch (e: Exception) {
                result.error(
                    "VRTX_ERROR",
                    e.message ?: "Failed to initialize Vrtx SDK",
                    null
                )
            }
        }
    }

    private fun resolveFontFamily(activity: Activity, fontFamily: String?): FontFamily {
        val assetPath = resolveFlutterFontAssetPath(activity, fontFamily) ?: return FontFamily.Default

        return try {
            FontFamily(Typeface.createFromAsset(activity.assets, assetPath))
        } catch (_: RuntimeException) {
            FontFamily.Default
        }
    }

    private fun resolveFlutterFontAssetPath(activity: Activity, fontFamily: String?): String? {
        val requestedFamily = fontFamily?.trim().orEmpty()
        if (requestedFamily.isEmpty()) return null

        val assets = flutterAssets ?: return null
        val manifestPath = assets.getAssetFilePathByName("FontManifest.json")

        val manifest = try {
            activity.assets.open(manifestPath).bufferedReader().use { it.readText() }
        } catch (_: Exception) {
            return null
        }

        val families = try {
            JSONArray(manifest)
        } catch (_: Exception) {
            return null
        }

        for (index in 0 until families.length()) {
            val family = families.optJSONObject(index) ?: continue
            val manifestFamily = family.optString("family")
            if (!matchesFontFamily(manifestFamily, requestedFamily)) continue

            val fonts = family.optJSONArray("fonts") ?: continue
            val asset = selectRegularFontAsset(fonts) ?: continue
            return assets.getAssetFilePathByName(asset)
        }

        return null
    }

    private fun matchesFontFamily(manifestFamily: String, requestedFamily: String): Boolean {
        return manifestFamily == requestedFamily ||
            manifestFamily.substringAfterLast('/') == requestedFamily
    }

    private fun selectRegularFontAsset(fonts: JSONArray): String? {
        var fallbackAsset: String? = null

        for (index in 0 until fonts.length()) {
            val font = fonts.optJSONObject(index) ?: continue
            val asset = font.optString("asset").takeIf { it.isNotEmpty() } ?: continue
            fallbackAsset = fallbackAsset ?: asset

            val weight = font.optInt("weight", 400)
            val style = font.optString("style", "normal")
            if (weight == 400 && style == "normal") return asset
        }

        return fallbackAsset
    }
}
