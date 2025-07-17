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
import 'package:desi_shopping_seller/providers/referral_provider.dart';
import 'package:desi_shopping_seller/providers/statemanagement_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/screens/admin/orders/orders_page.dart';
import 'package:desi_shopping_seller/screens/admin/recharge%20request/recharge_request_page.dart';
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

// Background message handler - runs when app is in background or terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
  // You can do background processing here if needed
}

// Local notification click handler
@pragma('vm:entry-point')
void onNotificationClick(NotificationResponse response) {
  final payload = response.payload;
  if (payload != null && navigatorKey.currentContext != null) {
    Navigator.pushNamed(navigatorKey.currentContext!, payload);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request notification permissions (iOS/Android 13+)
  await FirebaseMessaging.instance.requestPermission();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications (Android + iOS)
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
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
        ChangeNotifierProvider(create: (_) => ReferralProvider()),
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Handle messages when app is in foreground
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
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data['screen'], // Navigate to this screen on click
        );
      }
    });

    // When user taps a notification (app is in background but not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final screen = message.data['screen'];
      if (screen != null && navigatorKey.currentContext != null) {
        Navigator.pushNamed(navigatorKey.currentContext!, screen);
      }
    });

    // When app is launched from terminated state by tapping a notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data['screen'] != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentContext != null) {
            Navigator.pushNamed(
              navigatorKey.currentContext!,
              message.data['screen'],
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'My Desi Seller',

      // Define your named routes here to support notification navigation
      routes: {
        '/dashboard': (context) => const DashBoardPage(),
        '/partnerBottomNav': (context) => const PartnerBottomNav(),
        '/auth': (context) => const AuthPage(),
        '/splash': (context) => const SplashPage(),
        '/order': (context) => const OrdersPage(),
        '/recharge': (context) => const RechargeRequestPage(),
        // Add your other routes/screens here
      },

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
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
