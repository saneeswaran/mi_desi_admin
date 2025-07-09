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

  static Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission once
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log('Notification permission denied');

      return;
    }

    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        log('Permission.notification was denied');
        return;
      }
    }

    // Get and log FCM token
    String? token = await messaging.getToken();
    if (token != null) {
      log("FCM Token: $token");
    } else {
      log("FCM Token is null");
    }

    // Add listeners if needed
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.messageId}');
      // You can add more logic here if desired
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification caused app to open: ${message.messageId}');
      // Navigate to appropriate screen if needed
    });
  }

  static Future<void> sendNotification({
    required String title,
    required String message,
    required String screen,
    required String userId,
  }) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("customers")
          .doc(userId)
          .get();

      if (!documentSnapshot.exists) {
        log('User document does not exist');
        return;
      }

      final token = documentSnapshot.data() is Map<String, dynamic>
          ? (documentSnapshot.data() as Map<String, dynamic>)['fcmToken']
          : null;

      if (token == null) {
        log('FCM token not found for user $userId');
        return;
      }

      final response = await http.post(
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

      if (response.statusCode == 200) {
        log('Notification sent successfully');
      } else {
        log('Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error sending notification: $e', stackTrace: stackTrace);
    }
  }
}
