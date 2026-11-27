plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.tomzagroup.app_supervisores_gt"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.tomzagroup.app_supervisores_gt"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            manifestPlaceholders["appName"] = "Supervisores GT Dev"
            resValue("string", "app_name", readEnvAppName(".env.dev"))
            ndk {
                abiFilters.addAll(listOf("arm64-v8a", "x86_64"))
            }
        }
        create("prod") {
            dimension = "env"
            manifestPlaceholders["appName"] = "Supervisores GT"
            resValue("string", "app_name", readEnvAppName(".env.prod"))
        }
    }

    buildFeatures {
        resValues = true
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    lint {
        checkReleaseBuilds = false
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

fun readEnvAppName(envFileName: String): String {
    val envFile = rootProject.file("../$envFileName")
    if (!envFile.exists()) {
        return "Supervisores GT"
    }
    val line = envFile.readLines().firstOrNull { it.trim().startsWith("APP_NAME=") }
    return line?.substringAfter("=")?.trim()?.takeIf { it.isNotEmpty() } ?: "Supervisores GT"
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // Hilt
    // implementation("androidx.hilt:hilt-work:1.1.0")
    // ksp("androidx.hilt:hilt-compiler:1.1.0")
}
