// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRealBrands extends StatefulWidget {
  const AddRealBrands({super.key});

  @override
  State<AddRealBrands> createState() => _AddRealBrandsState();
}

class _AddRealBrandsState extends State<AddRealBrands> {
  final formKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  File? imageUrl;
  File? backgroundImage;
  bool isLoading = false;

  // Image picker
  void pickerImage() async {
    final picked = await pickBrandImage(context: context);

    if (picked != null) {
      setState(() {
        imageUrl = picked;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image not selected')));
      }
    }
  }

  void addBrand() async {
    if (imageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final bool isSuccess =
          await Provider.of<BrandProvider>(
            context,
            listen: false,
          ).addRealbrands(
            context: context,
            title: brandController.text.trim(),
            imageFile: imageUrl!,
          );

      if (isSuccess && mounted) {
        brandController.clear();
        setState(() {
          imageUrl = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brand added successfully')),
        );
        Navigator.pop(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Failed to add brand')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: AbsorbPointer(
              absorbing: isLoading,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.10),
                      GestureDetector(
                        onTap: pickerImage,
                        child: Container(
                          height: size.height * 0.30,
                          width: size.width * 0.90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlue),
                            borderRadius: BorderRadius.circular(12),
                            image: imageUrl != null
                                ? DecorationImage(
                                    image: FileImage(imageUrl!),
                                    fit: BoxFit.fitWidth,
                                  )
                                : null,
                          ),
                          child: imageUrl == null
                              ? const Center(
                                  child: Text(
                                    'Add Brand Image',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Brand Name',
                        controller: brandController,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width,
                        child: CustomElevatedButton(
                          onPressed: addBrand,
                          child: Text(
                            isLoading ? 'Adding...' : 'Add',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              height: size.height,
              width: size.width,
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
