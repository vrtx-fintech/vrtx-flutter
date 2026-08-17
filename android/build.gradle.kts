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

// Keep the native SDK's newer Kotlin dependencies compatible with host apps
// that still use the Kotlin 2.1 / AGP 8.x toolchain. These are local
// resolution rules and do not expose strict constraints to consumers.
configurations.configureEach {
    resolutionStrategy {
        force("org.jetbrains.kotlin:kotlin-stdlib:2.1.20")
        force("org.jetbrains.kotlin:kotlin-reflect:2.1.20")
        force("androidx.lifecycle:lifecycle-runtime-compose-android:2.10.0")
        force("androidx.lifecycle:lifecycle-viewmodel-compose-android:2.10.0")
        eachDependency {
            if (requested.group == "org.jetbrains.kotlinx" &&
                requested.name.startsWith("kotlinx-serialization-")
            ) {
                useVersion("1.8.1")
            }
            if (requested.group == "org.jetbrains.kotlinx" &&
                requested.name.startsWith("kotlinx-datetime")
            ) {
                useVersion("0.7.1")
            }
        }
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2026.05.01"))
    implementation("androidx.compose.ui:ui")
    implementation("sa.vrtx.sa:vrtx-android:0.1.1")
}
