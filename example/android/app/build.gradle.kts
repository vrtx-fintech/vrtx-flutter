plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

fun localVrtxCertificateHash(): String {
    val configFile = rootProject.file("../lib/local_config.dart")
    if (!configFile.isFile) return ""

    val hashPattern = Regex("""const\s+vrtxCertHash\s*=\s*['\"]([^'\"]+)['\"]""")
    return hashPattern.find(configFile.readText())?.groupValues?.get(1).orEmpty()
}

android {
    namespace = "com.example.vrtx_flutter_example"
    compileSdk = 37
    // Pinned to match what vrtx_flutter's transitive Android dependencies need
    // (AGP picks the highest requested NDK across plugins; Flutter's default
    // 27.x lags behind, which warns at assemble-time).
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.vrtx_flutter_example"
        minSdk = 29
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["vrtxPackageName"] = requireNotNull(applicationId) {
            "applicationId is required for VRTX FreeRASP configuration"
        }
        // A Gradle property takes precedence; local_config.dart provides the
        // default for local debug builds.
        manifestPlaceholders["vrtxCertHash"] = providers
            .gradleProperty("VRTX_CERT_HASH")
            .orElse(localVrtxCertificateHash())
            .get()
    }

    signingConfigs {
        create("release") {
            storeFile = file("release.keystore")
            storePassword = providers.environmentVariable("ANDROID_KEYSTORE_PASSWORD").orNull
            keyAlias = providers.environmentVariable("ANDROID_KEY_ALIAS").orNull
            keyPassword = providers.environmentVariable("ANDROID_KEY_PASSWORD").orNull
        }
    }

    buildTypes {
        release {
            // CI installs app/release.keystore before its signed release build.
            // The debug fallback keeps local release builds usable without
            // committing signing material.
            signingConfig = if (file("release.keystore").isFile) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
