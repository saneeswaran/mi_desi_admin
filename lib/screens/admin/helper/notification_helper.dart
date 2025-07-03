import 'dart:developer' show log;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static void setupFirebaseForegroundNotifications(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final title = message.notification!.title ?? 'Notification';
        final body = message.notification!.body ?? 'You have a new message';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title\n$body'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }

  static void setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await messaging.requestPermission();
    }
    final Permission status = Permission.notification;
    if (await status.isDenied) {
      await status.request();
    }

    // Get FCM token (use this to test sending from backend)
    String? token = await messaging.getToken();
    log("📲 FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("🔔 Foreground message: ${message.notification?.title}");
      // Optionally show snackbar or local notification
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("📲 Notification clicked!");
      // Navigate to order page or perform actions
    });
  }
}
