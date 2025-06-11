import 'dart:io';

import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerOfferPage extends StatefulWidget {
  final ProductModel product;
  const BannerOfferPage({super.key, required this.product});

  @override
  State<BannerOfferPage> createState() => _BannerOfferPageState();
}

class _BannerOfferPageState extends State<BannerOfferPage> {
  File? bannerImage;
  final offerController = TextEditingController();
  final bannerName = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void pickImage() async {
    final pickedFIle = await pickBrandImage(context: context);
    setState(() {
      bannerImage = pickedFIle;
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
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.15),
                bannerImage == null
                    ? GestureDetector(
                        onTap: () => pickImage(),
                        child: Container(
                          height: size.height * 0.3,
                          width: size.width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 1.2),
                          ),
                          child: const Center(
                            child: Text(
                              " Add Banner",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : Container(
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
                      ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  hintText: "Banner Name",
                  controller: bannerName,
                ),
                const SizedBox(height: 40),
                CustomTextFormField(
                  hintText: "Offer Amount",
                  controller: offerController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.70,
                  child: CustomElevatedButton(
                    text: "Submit",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final productProvider = Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        );
                        final brandProvider = Provider.of<BannersProvider>(
                          context,
                          listen: false,
                        );
                        final bool isBrandSuccess = await brandProvider
                            .addBanners(
                              context: context,
                              productId: widget.product.id.toString(),
                              image: bannerImage!,
                            );

                        final bool isProductUpdate = await productProvider
                            .bannerOfferValueUpdate(
                              // ignore: use_build_context_synchronously
                              context: context,
                              productId: widget.product.id.toString(),
                              offerPrice: int.parse(offerController.text),
                            );

                        if (isProductUpdate &&
                            isBrandSuccess &&
                            context.mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        return;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
