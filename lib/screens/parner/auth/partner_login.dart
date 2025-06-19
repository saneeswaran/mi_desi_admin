import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/providers/statemanagement_provider.dart';
import 'package:desi_shopping_seller/screens/parner/auth/partner_signup.dart';
import 'package:desi_shopping_seller/screens/parner/bottom_nav/partner_bottom_nav.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerLogin extends StatefulWidget {
  const PartnerLogin({super.key});

  @override
  State<PartnerLogin> createState() => _PartnerLoginState();
}

class _PartnerLoginState extends State<PartnerLogin> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final isSuccess = await Provider.of<PartnerProvider>(context, listen: false)
        .partnerLogin(
          context: context,
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    if (isSuccess && context.mounted) {
      replaceCurrentPageWithFadeAnimations(
        context: context,
        route: const PartnerBottomNav(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.backgroundImages, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          AppImages.ayurvedicThayoli,
                          height: size.height * 0.3,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.28),
                        child: Center(
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 4,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: AppColors.textFormFieldColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _customText(text: "Email"),
                                    CustomTextFormField(
                                      hintText: "Email",
                                      controller: emailController,
                                      color: AppColors.textFormFieldColor,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 12),
                                    _customText(text: "Password"),
                                    Consumer<StatemanagementProvider>(
                                      builder: (context, value, _) {
                                        return CustomTextFormField(
                                          hintText: "Password",
                                          controller: passwordController,
                                          color: AppColors.textFormFieldColor,
                                          isObscure: value.isObscure,
                                          suffixIcon: IconButton(
                                            onPressed: () =>
                                                value.toggleObscure(),
                                            icon: Icon(
                                              value.isObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Consumer<PartnerProvider>(
                                      builder: (context, provider, child) {
                                        final value = provider.isLoading;
                                        return SizedBox(
                                          height: size.height * 0.05,
                                          width: double.infinity,
                                          child: CustomElevatedButton(
                                            color: Colors.pink,
                                            text: value
                                                ? "Loading..."
                                                : "Login",
                                            onPressed: () => login(context),
                                          ),
                                        );
                                      },
                                    ),
                                    _signUpAccount(context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customText({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _signUpAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: () => moveToNextPageWithFadeAnimations(
            context: context,
            route: const PartnerSignup(),
          ),
          child: const Text("Register", style: TextStyle(color: Colors.pink)),
        ),
      ],
    );
  }
}
