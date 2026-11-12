import java.io.FileInputStream
import java.util.Properties
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

fun loadProperties(fileName: String): Properties = Properties().apply {
    val propertiesFile = rootProject.file(fileName)
    if (propertiesFile.exists()) {
        FileInputStream(propertiesFile).use { load(it) }
    }
}

val localProperties = loadProperties("local.properties")
val keystoreProperties = loadProperties("key.properties")

android {
    namespace = "com.georgemc2610.benzinapp.xplatform.benzinapp"
    compileSdk = 36
    ndkVersion = "29.0.13113456"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.georgemc2610.benzinapp.xplatform.benzinapp"
        minSdk = 24
        targetSdk = 36
        versionCode = 9
        versionName = flutter.versionName
        manifestPlaceholders["mapsApiKey"] = localProperties.getProperty("MAPS_API_KEY", "")
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.13.0"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
