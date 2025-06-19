import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.contain,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
                width: size.width * 0.4,
                child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
              ),
              const CircularProgressIndicator(color: Colors.pink),
            ],
          ),
        ),
      ),
    );
  }
}
