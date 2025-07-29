import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localPropertiesFile = rootProject.file("local.properties")
val localProperties = Properties().apply {
    load(FileInputStream(localPropertiesFile))
}
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "flutterfly.nl.flutterfly"
    try {
        compileSdk = Integer.parseInt(localProperties.getProperty("flutter.compileSdkVersion"))
    } catch (e: NumberFormatException) {
        compileSdk = 36
    }
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "flutterfly.nl.flutterfly"
        try {
            minSdk = Integer.parseInt(localProperties.getProperty("flutter.minSdkVersion"))
        } catch (e: NumberFormatException) {
            minSdk = 24
        }
        try {
            targetSdk = Integer.parseInt(localProperties.getProperty("flutter.targetSdkVersion"))
        } catch (e: NumberFormatException) {
            targetSdk = 36
        }
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
