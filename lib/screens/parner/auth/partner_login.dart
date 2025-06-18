import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/providers/statemanagement_provider.dart';
import 'package:desi_shopping_seller/screens/parner/bottom_nav/partner_bottom_nav.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerLogin extends StatelessWidget {
  const PartnerLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final Size size = MediaQuery.of(context).size;

    void login() async {
      if (formKey.currentState!.validate()) return;
      final isSuccess =
          await Provider.of<PartnerProvider>(
            context,
            listen: false,
          ).partnerLogin(
            context: context,
            email: emailController.text,
            password: passwordController.text,
          );

      if (isSuccess && context.mounted) {
        replaceCurrentPageWithFadeAnimations(
          context: context,
          route: const PartnerBottomNav(),
        );
      }
    }

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
                        top: size.height * 0.05,
                        left: size.width * 0.12,
                        child: Image.asset(
                          AppImages.ayurvedicThayoli,
                          height: size.height * 0.3,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.28,
                        left: size.width * 0.05,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            height: size.height * 0.4,
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
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                  Consumer<StatemanagementProvider>(
                                    builder: (context, value, child) {
                                      final obScure = value.isObscure;
                                      return CustomTextFormField(
                                        hintText: "Password",
                                        controller: passwordController,
                                        color: AppColors.textFormFieldColor,
                                        suffixIcon: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            obScure
                                                ? Icons.remove_red_eye_outlined
                                                : Icons.remove_red_eye,
                                            color: obScure
                                                ? Colors.pink
                                                : Colors.grey,
                                          ),
                                        ),
                                        isObscure: obScure,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: size.height * 0.05,
                                    width: size.width * 0.8,
                                    child: CustomElevatedButton(
                                      color: Colors.pink,
                                      text: "Login",
                                      onPressed: login,
                                    ),
                                  ),
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
}
