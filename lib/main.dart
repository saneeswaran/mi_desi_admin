import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/enum/app_enum.dart';
import 'package:desi_shopping_seller/firebase_options.dart';
import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/providers/statemanagement_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/screens/admin/splash%20screen/auth_page.dart';
import 'package:desi_shopping_seller/screens/admin/splash%20screen/splash_page.dart';
import 'package:desi_shopping_seller/screens/parner/bottom_nav/partner_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// Foreground/local click handler
@pragma('vm:entry-point')
void onNotificationClick(NotificationResponse response) {
  final payload = response.payload;
  if (payload != null && navigatorKey.currentContext != null) {
    Navigator.pushNamed(navigatorKey.currentContext!, payload);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request permissions
  await FirebaseMessaging.instance.requestPermission();

  // Background notification handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Local Notification settings
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onNotificationClick,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BannersProvider()),
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        ChangeNotifierProvider(create: (_) => StatemanagementProvider()),
        ChangeNotifierProvider(create: (_) => PartnerProvider()),
        ChangeNotifierProvider(create: (_) => RechargeSimProvider()),
        ChangeNotifierProvider(create: (_) => ReachargesProvider()),
        ChangeNotifierProvider(create: (_) => YoutubeVideoPlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Foreground Notification Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'Seller Notifications',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          payload: message.data['screen'], // Example: "/recharge"
        );
      }
    });

    // Background Notification Tap Handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final screen = message.data['screen'];
      if (screen != null && navigatorKey.currentContext != null) {
        Navigator.pushNamed(navigatorKey.currentContext!, screen);
      }
    });

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'My Desi Seller',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('partners')
                  .doc(asyncSnapshot.data!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashPage();
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  if (data['activeStatus'] == PartnerStatus.inactive) {
                    return const SplashPage();
                  } else {
                    return const PartnerBottomNav();
                  }
                } else {
                  return const AdvanceDrawerPage(
                    body: DashBoardPage(),
                    title: 'DashBoard',
                  );
                }
              },
            );
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
