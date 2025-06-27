plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Plugin do Google Services
}

android {
    namespace = "com.andresilveiras.chatsimulator"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.andresilveiras.chatsimulator"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM (Bill of Materials) para gerenciar versões
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    
    // Firebase Analytics (obrigatório)
    implementation("com.google.firebase:firebase-analytics")
    
    // Firebase Auth (para autenticação)
    implementation("com.google.firebase:firebase-auth")
    
    // Firebase Firestore (para banco de dados)
    implementation("com.google.firebase:firebase-firestore")
    
    // Google Play Services Auth (para login Google)
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
