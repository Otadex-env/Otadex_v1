import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android plugin.
    // Kotlin is applied automatically by the Flutter Gradle Plugin (built-in Kotlin).
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

android {
    namespace = "com.otadex.otadex"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.otadex.otadex"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            // x86_64 est une ABI d'émulateur/Chromebook — aucun testeur sur
            // téléphone réel n'en a besoin. Scopé au release pour ne pas
            // gêner un émulateur x86_64 en debug/profile.
            // ATTENTION : le plugin Gradle de Flutter pose lui-même abiFilters
            // (toutes les ABI par défaut) dans defaultConfig et ce filtre s'y
            // AJOUTE. Le retrait de x86_64 n'est fiable qu'avec le drapeau CLI :
            //   flutter build appbundle --release --target-platform android-arm,android-arm64
            ndk {
                abiFilters += setOf("armeabi-v7a", "arm64-v8a")
            }
        }
    }
}

// Exclusion x86/x86_64 du packaging RELEASE uniquement. abiFilters ne retire pas
// les .so x86_64 des dépendances (libdartjni, libdatastore_shared_counter) : sans
// libflutter/libapp x86_64, Play déclarerait l'app compatible x86_64 alors qu'elle
// ne peut pas y démarrer. Debug/profile gardent x86_64 (émulateurs).
androidComponents {
    onVariants(selector().withBuildType("release")) { variant ->
        variant.packaging.jniLibs.excludes.addAll("**/x86_64/**", "**/x86/**")
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
