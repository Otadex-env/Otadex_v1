import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../router/app_router.dart';

class NotificationService {
  static const _appId = 'cfc58648-689b-432f-9afa-c4f49e69199f';

  /// Tâche de fond best-effort : jamais sur le chemin critique de démarrage
  /// (appelée via `unawaited` depuis main.dart). Un SDK OneSignal en échec
  /// réseau (DNS, ANR côté plugin) ne doit jamais faire planter ni geler
  /// l'app — toute erreur est avalée ici.
  static Future<void> initialize() async {
    try {
      OneSignal.initialize(_appId);

      // Aucune demande de permission ici : POST_NOTIFICATIONS n'est demandée
      // que par l'interrupteur « Notifications » du profil (action explicite).

      // Sauvegarde de l'ID OneSignal dès qu'il est disponible
      final subId = OneSignal.User.pushSubscription.id;
      if (subId != null) await _saveSubscriptionId(subId);

      OneSignal.User.pushSubscription.addObserver((state) {
        final id = state.current.id;
        if (id != null) _saveSubscriptionId(id);
      });

      // Notification reçue en foreground → on l'affiche et on écoute le tap
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        event.notification.display();
      });

      // Tap sur notification (app ouverte depuis background/killed)
      OneSignal.Notifications.addClickListener((event) {
        final route =
            event.notification.additionalData?['route']?.toString();
        _handleRoute(route);
      });
    } catch (_) {
      // Best-effort : les notifications push ne sont pas critiques au
      // fonctionnement de l'app.
    }
  }

  static Future<void> _saveSubscriptionId(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'oneSignalId': id});
  }

  // Appelé après un login tardif (après le démarrage de l'app)
  static Future<void> saveCurrentSubscriptionId() async {
    final id = OneSignal.User.pushSubscription.id;
    if (id != null) await _saveSubscriptionId(id);
  }

  static void _handleRoute(String? route) {
    if (route == null || route.isEmpty) return;
    AppRouter.router.push(route);
  }
}
