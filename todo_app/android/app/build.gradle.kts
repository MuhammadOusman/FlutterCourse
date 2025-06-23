// Ye poora code android/app/build.gradle.kts me paste karein

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.todo_app_hive" // Aap isay apne project ke naam se change kar sakte hain
    compileSdk = flutter.compileSdkVersion

    // --- FIX #1: NDK VERSION UPDATE ---
    // Flutter ne humein ye line add karne ko kaha tha
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.todo_app_hive"
        
        // --- FIX #2: MIN SDK VERSION UPDATE ---
        // flutter_sound ko kam se kam version 24 chahiye
        minSdkVersion(24) 
        
        targetSdkVersion(flutter.targetSdkVersion)
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Multidex ki line
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Multidex ki line
    implementation("androidx.multidex:multidex:2.0.1")
}