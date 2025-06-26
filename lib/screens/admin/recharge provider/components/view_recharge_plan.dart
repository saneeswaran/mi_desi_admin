import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/model/recharge_model.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewRechargePlan extends StatefulWidget {
  final RechargeProvider recharge;
  const ViewRechargePlan({super.key, required this.recharge});

  @override
  State<ViewRechargePlan> createState() => _ViewRechargePlanState();
}

class _ViewRechargePlanState extends State<ViewRechargePlan> {
  File? image;
  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.recharge.providerName;
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              image != null
                  ? GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(image!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.recharge.image,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 40),
              CustomTextFormField(
                hintText: "Recharge Provider Name",
                controller: nameController,
              ),
              SizedBox(height: size.height * 0.3),
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 1,
                child: Consumer<RechargeSimProvider>(
                  builder: (context, provider, child) {
                    final isLoading = provider.isLoading;
                    return CustomElevatedButtonWithChild(
                      onPressed: () async {
                        final bool isSuccess = await provider.deleteProvider(
                          context: context,
                          id: widget.recharge.id,
                        );
                        if (isSuccess && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.red,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 1,
                child: Consumer<RechargeSimProvider>(
                  builder: (context, provider, child) {
                    final isLoading = provider.isUpdateLoading;
                    return CustomElevatedButtonWithChild(
                      onPressed: () async {
                        final bool isSuccess = await provider.updateRecharge(
                          context: context,
                          id: widget.recharge.id,
                          providerName: nameController.text,
                          image: image!,
                        );

                        if (isSuccess && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.pink,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
