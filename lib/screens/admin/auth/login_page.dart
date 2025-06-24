import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (!formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProviders>(context, listen: false);
    final bool isSuccess = await authProvider.loginAdmin(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );

    if (isSuccess && mounted) {
      replaceCurrentPageWithFadeAnimations(
        context: context,
        route: const AdvanceDrawerPage(
          body: DashBoardPage(),
          title: "DashBoard",
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(20),
                            height: size.height * 0.5,
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
                                  const SizedBox(height: 20),
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
                                  SizedBox(
                                    height: size.height * 0.05,
                                    width: size.width * 0.8,
                                    child: CustomElevatedButton(
                                      color: Colors.pink,
                                      text: "Login",
                                      onPressed: login,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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
