import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/model/banner_model.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerUpdate extends StatefulWidget {
  final BannerModel banner;
  const BannerUpdate({super.key, required this.banner});

  @override
  State<BannerUpdate> createState() => _BannerUpdateState();
}

class _BannerUpdateState extends State<BannerUpdate> {
  File? updatedImage;
  final controller = TextEditingController();
  bool isLoading = false;

  void pickImage() async {
    final pickedFile = await pickBrandImage(context: context);
    if (pickedFile != null) {
      setState(() {
        updatedImage = pickedFile;
      });
    }
  }

  void updateBanner() async {
    if (controller.text.isEmpty || updatedImage == null) {
      showSnackBar(context: context, e: 'Please fill all the fields');
      return;
    }

    setState(() => isLoading = true);

    final bool isSuccess =
        await Provider.of<BannersProvider>(
          context,
          listen: false,
        ).updateBanners(
          context: context,
          productId: widget.banner.productId,
          image: updatedImage!,
          offerPrice: int.parse(controller.text),
        );

    setState(() => isLoading = false);

    if (mounted && isSuccess) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Update Banner")),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isLoading,
            child: Container(
              padding: EdgeInsets.all(size.width * 0.03),
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.03),

                    // Image preview
                    updatedImage != null
                        ? Stack(
                            children: [
                              Container(
                                height: size.height * 0.25,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(updatedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() => updatedImage = null);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : widget.banner.imageUrl.isNotEmpty
                        ? Container(
                            height: size.height * 0.25,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  widget.banner.imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: size.height * 0.25,
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: const Center(child: Text("Add Image")),
                            ),
                          ),

                    const SizedBox(height: 20),

                    CustomTextFormField(
                      hintText: "Offer Price",
                      controller: controller,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20),

                    CustomElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Change Image"),
                    ),

                    const SizedBox(height: 20),

                    CustomElevatedButton(
                      onPressed: updateBanner,
                      child: const Text("Update"),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
