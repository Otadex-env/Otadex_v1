# Signature APK Play Store — Instructions

> **Note** : Le projet utilise Kotlin DSL (`build.gradle.kts`).
> Les étapes 4 et 5 sont **déjà configurées** dans `android/app/build.gradle.kts` (Task 21).
> Si tu recrées le projet, suis les étapes ci-dessous.

## Étape 1 — Créer la clé de signature (une seule fois)

```bash
keytool -genkey -v \
  -keystore ~/otadex-key.jks \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias otadex
```

Répondre aux questions :
- Prénom/Nom : TilStack
- Organisation : TilStack
- Ville : Douala
- Pays : CM

⚠️ Retenir le mot de passe — impossible à récupérer

## Étape 2 — Créer android/key.properties

```properties
storePassword=TON_MOT_DE_PASSE
keyPassword=TON_MOT_DE_PASSE
keyAlias=otadex
storeFile=/home/tilstack/otadex-key.jks
```

## Étape 3 — Vérifier .gitignore

Ces lignes sont déjà présentes dans `.gitignore` :

```
android/key.properties
*.jks
```

## Étape 4 — Configuration build.gradle.kts (déjà fait)

Le fichier `android/app/build.gradle.kts` charge déjà `key.properties` et configure
`signingConfigs.release`. Si le fichier `key.properties` est absent, le build utilise
le signing debug en fallback.

Extrait de référence (Kotlin DSL) :

```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}
val hasReleaseKeystore = keystorePropertiesFile.exists()

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
    }
}
```

## Étape 5 — Build App Bundle

```bash
cd /home/tilstack/Bureau/Otadex_v1
flutter build appbundle --release
```

## Fichier généré (à uploader sur Play Store)

```
build/app/outputs/bundle/release/app-release.aab
```
