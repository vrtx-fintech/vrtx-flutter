import com.android.build.api.dsl.LibraryExtension
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

extensions.configure<LibraryExtension>("android") {
    namespace = "sa.vrtx.flutter"
    compileSdk = 37

    defaultConfig {
        minSdk = 29
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

extensions.configure<KotlinAndroidProjectExtension>("kotlin") {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_17
    }
}

// vrtx-android ships Kotlin stdlib/reflect built against an older Kotlin than
// the example app's Kotlin Gradle Plugin (2.4.10, pinned in
// example/android/settings.gradle.kts). Force both onto the host KGP's version
// so Android Lint does not load mixed Kotlin compiler/runtime internals.
// Keep this in step with that plugin version when it moves.
configurations.configureEach {
    resolutionStrategy {
        force("org.jetbrains.kotlin:kotlin-stdlib:2.4.10")
        force("org.jetbrains.kotlin:kotlin-reflect:2.4.10")
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2026.05.01"))
    implementation("androidx.compose.ui:ui")
    implementation("sa.vrtx.sa:vrtx-android:0.1.1")
}
