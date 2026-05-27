import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../router/app_router.dart';

class NotificationService {
  static const _appId = 'cfc58648-689b-432f-9afa-c4f49e69199f';

  static Future<void> initialize() async {
    OneSignal.initialize(_appId);

    await OneSignal.Notifications.requestPermission(true);

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
  }

  static Future<void> _saveSubscriptionId(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'oneSignalId': id});
  }

  static void _handleRoute(String? route) {
    if (route == null || route.isEmpty) return;
    AppRouter.router.push(route);
  }
}
