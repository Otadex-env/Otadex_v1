import 'package:flutter/material.dart';

/// Habille un écran conçu comme *onglet* (sans Scaffold ni SafeArea, car
/// `HomeScreen` fournit déjà le SafeArea) pour qu'il puisse aussi être monté
/// en route racine sans passer sous la barre d'état / l'encoche / la barre de
/// gestes.
///
/// À utiliser uniquement dans le routeur : dans `HomeScreen` le SafeArea existe
/// déjà, l'ajouter ici doublerait les marges.
class SafeRootScreen extends StatelessWidget {
  final Widget child;

  const SafeRootScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
    );
  }
}
