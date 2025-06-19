import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/screens/admin/splash%20screen/components/auth_support.dart';
import 'package:desi_shopping_seller/screens/parner/auth/partner_login.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundPallet),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: size.height * 0.01,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: size.height * 0.2,
                width: size.width * 0.4,
                child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
              ),
              const SplashScreenPageView(),
              _loginButton(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomElevatedButton(
          text: "Admin",
          onPressed: () {},
          color: Colors.pink,
          radius: 20,
        ),
        CustomElevatedOutlinedButton(
          text: "Partner",
          onPressed: () => moveToNextPageWithFadeAnimations(
            context: context,
            route: const PartnerLogin(),
          ),
        ),
      ],
    );
  }
}
