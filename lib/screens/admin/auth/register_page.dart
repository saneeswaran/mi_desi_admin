import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/screens/admin/dash%20board/dash_board_page.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/advance_drawer_page.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:desi_shopping_seller/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void register() async {
    setState(() => isLoading = true);

    if (!formKey.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }

    final authProvider = Provider.of<AuthProviders>(context, listen: false);
    final bool isSuccess = await authProvider.registerAdmin(
      context: context,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
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

    setState(() => isLoading = false);
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
    final Size size = MediaQuery.of(context).size;

    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
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
                    height: size.height * 0.9,
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
                              padding: const EdgeInsets.all(20),
                              height: size.height * 0.6,
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
                                        "Register",
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _customText("Name"),
                                    CustomTextFormField(
                                      hintText: "Full Name",
                                      controller: nameController,
                                      color: AppColors.textFormFieldColor,
                                    ),
                                    const SizedBox(height: 12),
                                    _customText("Email"),
                                    CustomTextFormField(
                                      hintText: "Email",
                                      controller: emailController,
                                      color: AppColors.textFormFieldColor,
                                    ),
                                    const SizedBox(height: 12),
                                    _customText("Password"),
                                    CustomTextFormField(
                                      hintText: "Password",
                                      controller: passwordController,
                                      isObscure: true,
                                      color: AppColors.textFormFieldColor,
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: size.height * 0.05,
                                      width: size.width * 0.8,
                                      child: CustomElevatedButton(
                                        color: Colors.pink,
                                        onPressed: register,
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
            if (isLoading)
              Container(
                height: size.height,
                width: size.width,
                color: Colors.black38,
                child: const Center(child: Loader()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _customText(String text) {
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
