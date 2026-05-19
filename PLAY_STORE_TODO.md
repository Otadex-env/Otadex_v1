# OTADEX — Checklist Play Store

## ✅ Déjà fait

- [x] Firebase Auth (email + Google)
- [x] Firestore profil utilisateur
- [x] Pages légales (otadex.tilstack.me)
- [x] URL politique de confidentialité publique
- [x] firebase_options.dart + google-services.json
- [x] android:label = "OTADEX"
- [x] applicationId = "com.otadex.otadex"
- [x] Import JJK Firestore (scripts/import_jjk.js)
- [x] Fix Quiz Firestore (firestoreQuizProvider branché dans character_quiz_screen.dart)
- [x] Signing config release (build.gradle.kts + .gitignore)
- [x] minifyEnabled + shrinkResources activés

## 🔲 À faire manuellement (dans l'ordre)

### 1. Importer les données JJK dans Firestore

```bash
cd /home/tilstack/Bureau/Otadex_v1
env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
  /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_jjk.js
```

Attendre "🎉 Import JJK terminé !" avant de continuer.

### 2. Vérifier l'app sur device Android

- [ ] Home → personnages JJK visibles (Gojo, Yuji, Sukuna)
- [ ] Tap Gojo → fiche complète (bio + pouvoirs + citations)
- [ ] Onglet Quiz → questions JJK depuis Firestore (pas les 5 génériques)
- [ ] Inscription → compte visible Firebase Console → Auth + Firestore users/
- [ ] Connexion → redirige Home
- [ ] Déconnexion → redirige Login

### 3. Signature + Build

- [ ] Créer clé : `keytool -genkey ...` (voir PLAY_STORE_SIGNING.md Étape 1)
- [ ] Créer `android/key.properties` (voir PLAY_STORE_SIGNING.md Étape 2)
- [ ] `flutter build appbundle --release`
- [ ] Vérifier taille AAB < 150 MB

### 4. Assets Play Store à préparer

- [ ] Icône app 512×512px PNG (fond #FF6500 + "OTADEX" blanc centré)
- [ ] Feature graphic 1024×500px PNG (bannière avec logo + screenshots)
- [ ] 8 screenshots Android (390×844px minimum) :
      Home | Fiche Gojo | Galerie | Recherche |
      Profil | Collection | Plans | Exclusif Kage

### 5. Soumission Play Console

- [ ] Compte développeur activé (25 USD)
- [ ] Créer application "OTADEX"
- [ ] Description courte (80 chars max) :
      "Explore et collecte tes personnages d'animés 🔥"
- [ ] Description longue :
      OTADEX est l'encyclopédie ultime des personnages
      d'animés pour les fans francophones.
      🔥 Fiches complètes : pouvoirs, histoire, citations
      📸 Galeries d'images immersives
      🎴 Collecte tes personnages favoris
      🏆 Vote Fan du Mois avec récompenses
      🧠 Quiz par personnage (Jonin+)
      🤖 Chatbot IA personnage (Kage)
      Gojo, Luffy, Tanjiro, Sung Jin-Woo...
      Genin gratuit · Jonin · Kage Pass
- [ ] Catégorie : Divertissement
- [ ] Classification : 12+
- [ ] URL politique : https://otadex.tilstack.me/privacy-policy.html
- [ ] Pays : Cameroun → Monde entier
- [ ] Uploader app-release.aab
- [ ] Soumettre → révision 3-7 jours

## 📅 Après lancement

- [ ] GitHub repo otadex-images (images persos)
- [ ] Import Solo Leveling
- [ ] Import Demon Slayer
- [ ] Google AdMob intégration
- [ ] Notifications push Firebase
