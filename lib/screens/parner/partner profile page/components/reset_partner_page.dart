import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:desi_shopping_seller/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPartnerPage extends StatefulWidget {
  final String email;
  const ResetPartnerPage({super.key, required this.email});

  @override
  State<ResetPartnerPage> createState() => _ResetPartnerPageState();
}

class _ResetPartnerPageState extends State<ResetPartnerPage> {
  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: size.height * 0.02,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            SizedBox(
              height: size.height * 0.2,
              width: size.width * 0.8,
              child: Image.asset(AppImages.appLogo, fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please enter your email",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CustomTextFormField(hintText: "Email", controller: emailController),
            const Spacer(),
            SizedBox(
              height: size.height * 0.07,
              width: size.width * 1,
              child: Consumer<AuthProviders>(
                builder: (context, provider, child) {
                  final loader = provider.isLoading;
                  return CustomElevatedButton(
                    onPressed: () async {
                      final isSuccess = await provider.resetPartnerPassword(
                        context: context,
                        email: emailController.text,
                      );

                      if (isSuccess && context.mounted) {
                        showSnackBar(
                          context: context,
                          e: "Password reset email sent successfully",
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: loader
                        ? const Loader()
                        : const Text(
                            "Send Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
