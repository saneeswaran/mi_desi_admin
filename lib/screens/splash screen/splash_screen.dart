import 'package:desi_shopping_seller/screens/auth/login_page.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(microseconds: 400), () {
      if (context.mounted) {
        replaceCurrentPageWithFadeAnimations(
          context: context,
          route: const LoginPage(),
        );
      }
    });
    return const Scaffold(
      body: Center(child: Text('Welcome to my desi seller')),
    );
  }
}
