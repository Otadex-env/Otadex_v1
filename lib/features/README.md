# lib/features/

Modules fonctionnels de l'application, organisés par domaine métier.

## Structure

Chaque feature suit le pattern **Clean Architecture** :

```
features/
  <nom_feature>/
    data/           # Sources de données (repositories impl, datasources)  ← à créer en Task 02+
    domain/         # Entités, use cases, interfaces repository             ← à créer en Task 02+
    presentation/   # Screens, widgets, providers Riverpod
```

## Features actuelles

| Feature | État | Description |
|---|---|---|
| `splash/` | ✅ Task 01 | Écran de démarrage animé avec progression, particules et badges de rang |
| `onboarding/` | ✅ Task 01 | 3 slides (welcome, explore, rangs) avec swipe et indicateur de progression |
| `auth/` | ⏳ Task 02 | Connexion / inscription — UI done, logique Firebase à implémenter |
| `home/` | 🔜 Task 03 | Page d'accueil avec catalogue de personnages |
| `character_detail/` | 🔜 Task 03 | Fiche détaillée d'un personnage |
| `profile/` | 🔜 Task 03 | Profil utilisateur et gestion du rang |

## Règle d'isolation

Une feature ne doit **jamais** importer directement depuis une autre feature.
Les échanges entre features passent exclusivement par `core/router/` (navigation) et `core/` (données partagées).
