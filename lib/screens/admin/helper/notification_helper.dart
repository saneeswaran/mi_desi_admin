import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    debugPrint("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  static Future<void> sendNotification({
    required String title,
    required String message,
    required String screen,
    required String userId,
  }) async {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("customers");
    final DocumentSnapshot documentSnapshot = await collectionReference
        .doc(userId)
        .get();
    final token = documentSnapshot.get('fcmToken');
    log(token.toString());
    if (token != null) {
      await http.post(
        Uri.parse(
          "https://mi-desi-notification-service.vercel.app/api/sendNotification",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "body": message,
          "fcmToken": token,
          "screen": screen,
        }),
      );
    }
  }
}
