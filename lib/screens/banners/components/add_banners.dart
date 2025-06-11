import 'dart:io';
import 'package:desi_shopping_seller/screens/banners/components/product_details_for_banners.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class AddBanners extends StatefulWidget {
  const AddBanners({super.key});

  @override
  State<AddBanners> createState() => _AddBannersState();
}

class _AddBannersState extends State<AddBanners> {
  File? bannerImage;
  void pickImage() async {
    final picker = await pickBrandImage(context: context);
    setState(() {
      bannerImage = picker;
    });
  }

  void resetImage() {
    setState(() {
      bannerImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: size.height * 0.1,
        width: size.width * 1,
        child: Center(
          child: CustomElevatedButton(text: "Add Banner", onPressed: () {}),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(size.width * 0.03),
          height: size.height * 1,
          width: size.width * 1,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              bannerImage != null
                  ? Container(
                      height: size.height * 0.3,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(bannerImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: resetImage,
                          icon: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => pickImage(),
                      child: Container(
                        height: size.height * 0.3,
                        width: size.width * 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(child: Text("Add Banners")),
                      ),
                    ),

              Expanded(child: ProductDetailsForBanners(size: size)),
            ],
          ),
        ),
      ),
    );
  }
}
