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
import android.net.Uri
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import org.json.JSONArray

import sa.vrtx.public.Vrtx
import sa.vrtx.public.configuration.DesignOption
import sa.vrtx.public.configuration.Environment
import sa.vrtx.public.configuration.Language
import sa.vrtx.public.configuration.Mode
import sa.vrtx.public.configuration.theme.ThemeOptions
import sa.vrtx.public.configuration.theme.VrtxColors
import sa.vrtx.public.configuration.theme.VrtxRadius
import sa.vrtx.public.configuration.theme.VrtxSpacing

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
        val externalReference = call.argument<String?>("externalReference")
        val fontFamily   = call.argument<String?>("fontFamily")
        val designOption = parseDesignOption(call.argument<String?>("designOption"))
        val theme = parseThemeOptions(call.argument<Map<String, Any?>>("theme"))

        // Reject unknown values rather than defaulting: a silent fallback can
        // point an integrator at the wrong backend without any signal, the
        // worst possible failure mode for an environment switch.
        val environmentName = call.argument<String>("environment")
        val environment: Environment = when (environmentName) {
            "sandbox"    -> Environment.Sandbox
            "production" -> Environment.Production
            else -> {
                result.error(
                    "INVALID_ENVIRONMENT",
                    "Unsupported environment '$environmentName'. Expected 'sandbox' or 'production'.",
                    null,
                )
                return
            }
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
                    designOption = designOption,
                    theme        = theme,
                    externalReference = externalReference,
                    fontFamily   = composeFontFamily,
                    onSuccess    = {
                        result.success(null)
                    },
                    onExit       = {
                        channel.invokeMethod("onExit", null)
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

    private fun parseDesignOption(name: String?): DesignOption = when (name) {
        "optionA" -> DesignOption.OptionA
        "optionB" -> DesignOption.OptionB
        else -> DesignOption.OptionC
    }

    private fun parseThemeColor(value: String): Color? {
        val rgba = Regex(
            """rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([0-9.]+)\s*\)""",
        ).matchEntire(value.trim())
        if (rgba != null) {
            val red = rgba.groupValues[1].toIntOrNull() ?: return null
            val green = rgba.groupValues[2].toIntOrNull() ?: return null
            val blue = rgba.groupValues[3].toIntOrNull() ?: return null
            val alpha = ((rgba.groupValues[4].toFloatOrNull() ?: return null) * 255).toInt()
            return Color(android.graphics.Color.argb(alpha, red, green, blue))
        }
        return runCatching { Color(android.graphics.Color.parseColor(value)) }.getOrNull()
    }

    private fun parseThemeOptions(value: Map<String, Any?>?): ThemeOptions? {
        val root = value ?: return null
        fun child(parent: Map<*, *>?, key: String): Map<*, *>? =
            parent?.get(key) as? Map<*, *>
        fun text(parent: Map<*, *>?, key: String): String? =
            (parent?.get(key) as? String)?.takeIf { it.isNotBlank() }
        fun color(parent: Map<*, *>?, key: String): Color? =
            text(parent, key)?.let(::parseThemeColor)
        fun dp(parent: Map<*, *>?, key: String) =
            (parent?.get(key) as? Number)?.toDouble()?.toFloat()?.dp

        val colors = child(root, "colors")
        val themeColors = colors?.let {
            VrtxColors(
                allBrands = child(it, "allBrands")?.let { value ->
                    VrtxColors.AllBrands(color(value, "primary"), color(value, "buttonLabel"))
                },
                labels = child(it, "labels")?.let { value ->
                    VrtxColors.Labels(
                        color(value, "primary"), color(value, "secondary"),
                        color(value, "tertiary"), color(value, "quaternary"),
                    )
                },
                fills = child(it, "fills")?.let { value ->
                    VrtxColors.Fills(
                        primary = color(value, "primary"),
                        secondary = color(value, "secondary"),
                        tertiary = color(value, "tertiary"),
                        quaternary = color(value, "quaternary"),
                        vibrant = child(value, "vibrant")?.let { vibrant ->
                            VrtxColors.Fills.Vibrant(color(vibrant, "secondary"))
                        },
                    )
                },
                backgrounds = child(it, "backgrounds")?.let { value ->
                    VrtxColors.Backgrounds(
                        primary = color(value, "primary"),
                        secondary = color(value, "secondary"),
                    )
                },
                backgroundsGradient = child(it, "backgroundsGradient")?.let { value ->
                    VrtxColors.BackgroundsGradients(
                        color(value, "wb01"), color(value, "wb02"),
                    )
                },
                accents = child(it, "accents")?.let { value ->
                    VrtxColors.Accents(
                        red = color(value, "red"),
                        green = color(value, "green"),
                        greenBg = color(value, "greenBg"),
                    )
                },
            )
        }

        return ThemeOptions(
            cardImage = text(root, "cardImage")?.let(Uri::parse),
            brandLogo = text(root, "brandLogo")?.let(Uri::parse),
            brandName = text(root, "brandName"),
            colors = themeColors,
            spacing = child(root, "spacing")?.let { value ->
                VrtxSpacing(
                    x0 = dp(value, "x0"), xxs = dp(value, "xxs"),
                    xs = dp(value, "xs"), sm = dp(value, "sm"),
                    md = dp(value, "md"), ml = dp(value, "ml"),
                    lg = dp(value, "lg"),
                )
            },
            radius = child(root, "radius")?.let { value ->
                VrtxRadius(
                    s = dp(value, "s"), sm = dp(value, "sm"),
                    md = dp(value, "md"), lg = dp(value, "lg"),
                    full = dp(value, "full"), huge = dp(value, "huge"),
                )
            },
        )
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
