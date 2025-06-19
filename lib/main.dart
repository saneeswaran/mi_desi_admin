import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/enum/app_enum.dart';
import 'package:desi_shopping_seller/firebase_options.dart';
import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/statemanagement_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/screens/admin/splash%20screen/splash_screen.dart';
import 'package:desi_shopping_seller/screens/parner/bottom_nav/partner_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Desi Seller',
      debugShowCheckedModeBanner: false,
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  if (data['activeStatus'] == PartnerStatus.inactive) {
                    return const SplashScreen();
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
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
