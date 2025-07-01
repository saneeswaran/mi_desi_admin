import 'dart:io';

import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRechargeProvider extends StatefulWidget {
  const CreateRechargeProvider({super.key});

  @override
  State<CreateRechargeProvider> createState() => _CreateRechargeProviderState();
}

class _CreateRechargeProviderState extends State<CreateRechargeProvider> {
  File? image;
  final TextEditingController providerNameController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    providerNameController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final pickedFile = await pickBrandImage(context: context);
    setState(() {
      image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create Recharge Provider",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    image == null
                        ? GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: size.height * 0.3,
                              width: size.width * 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 0.9,
                                ),
                              ),
                              child: const Center(child: Text("Add Image")),
                            ),
                          )
                        : GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: size.height * 0.3,
                              width: size.width * 1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(image!),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      hintText: "Provider Name",
                      controller: providerNameController,
                    ),
                    SizedBox(height: size.height * 0.3),
                    SizedBox(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      child: CustomElevatedButton(
                        child: const Text(
                          "Create",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final provider = Provider.of<RechargeSimProvider>(
                            context,
                            listen: false,
                          );
                          final bool isSuccess = await provider.createProvider(
                            context: context,
                            image: image!,
                            providerName: providerNameController.text,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          if (isSuccess && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                height: size.height * 1,
                width: size.width * 1,
                color: Colors.black38,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.pink),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
