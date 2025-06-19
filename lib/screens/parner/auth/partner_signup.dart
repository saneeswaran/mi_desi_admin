import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/providers/statemanagement_provider.dart';
import 'package:desi_shopping_seller/screens/admin/auth/components/terms_and_conditions.dart';
import 'package:desi_shopping_seller/screens/parner/auth/partner_login.dart';
import 'package:desi_shopping_seller/screens/parner/bottom_nav/partner_bottom_nav.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerSignup extends StatefulWidget {
  const PartnerSignup({super.key});

  @override
  State<PartnerSignup> createState() => _PartnerSignupState();
}

class _PartnerSignupState extends State<PartnerSignup> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() async {
    final provider = Provider.of<PartnerProvider>(context, listen: false);
    final bool isSuccess = await provider.registerPartner(
      context: context,
      username: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    if (isSuccess && mounted) {
      replaceCurrentPageWithFadeAnimations(
        context: context,
        route: const PartnerBottomNav(),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.backgroundImages, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70),
                SizedBox(
                  height: size.height * 0.85,
                  child: Stack(
                    children: [
                      Positioned(
                        top: size.height * -0.06,
                        left: size.width * 0.12,
                        child: Image.asset(
                          AppImages.ayurvedicThayoli,
                          height: size.height * 0.3,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: size.height * 0.7,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      height: size.height * 0.005,
                                      width: size.width * 0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.textFormFieldColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _customText(text: "Name"),
                                  CustomTextFormField(
                                    hintText: "Name",
                                    controller: nameController,
                                    color: AppColors.textFormFieldColor,
                                  ),
                                  const SizedBox(height: 12),
                                  _customText(text: "Email"),
                                  CustomTextFormField(
                                    hintText: "Email",
                                    controller: emailController,
                                    color: AppColors.textFormFieldColor,
                                  ),
                                  const SizedBox(height: 12),
                                  _customText(text: "Password"),
                                  CustomTextFormField(
                                    hintText: "Password",
                                    controller: passwordController,
                                    color: AppColors.textFormFieldColor,
                                    isObscure: true,
                                  ),
                                  const SizedBox(height: 10),
                                  Consumer<StatemanagementProvider>(
                                    builder: (context, provider, _) {
                                      return _customCheckBox(
                                        context: context,
                                        value: provider.loading,
                                        onChanged: (val) {
                                          provider.setLoading(val ?? false);
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: size.height * 0.05,
                                    width: size.width * 0.8,
                                    child: CustomElevatedButton(
                                      color: Colors.pink,
                                      text: "Register",
                                      onPressed: register,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _rowButtons(context: context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _customCheckBox({
    required BuildContext context,
    required bool value,
    required Function(bool?)? onChanged,
  }) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: Colors.pink),
        const Text("I accept", style: TextStyle(fontSize: 16)),
        TextButton(
          onPressed: () => moveToNextPageWithFadeAnimations(
            context: context,
            route: const TermsAndConditions(),
          ),
          child: const Text(
            "Terms & Conditions",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Row _rowButtons({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () => moveToNextPageWithFadeAnimations(
            context: context,
            route: const PartnerLogin(),
          ),
          child: const Text("Login", style: TextStyle(color: Colors.pink)),
        ),
      ],
    );
  }
}
