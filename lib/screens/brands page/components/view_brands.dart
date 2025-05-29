import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewBrands extends StatefulWidget {
  final BrandModel brand;
  const ViewBrands({super.key, required this.brand});

  @override
  State<ViewBrands> createState() => _ViewBrandsState();
}

class _ViewBrandsState extends State<ViewBrands> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.brand.title;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          spacing: size.height * 0.02,
          children: [
            Container(
              height: size.height * 0.50,
              width: size.width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.brand.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CustomTextFormField(
              hintText: "Brand Name",
              controller: nameController,
            ),
            const Spacer(),
            SizedBox(
              height: size.height * 0.07,
              width: size.width * 1,
              child: CustomElevatedButton(
                text: "Delete",
                color: Colors.red,
                onPressed: () async {
                  final bool isSuccess = await context
                      .read<BrandProvider>()
                      .deleteBrand(
                        context: context,
                        brandId: '${widget.brand.id}',
                      );
                  if (isSuccess && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.07,
              width: size.width * 1,
              child: CustomElevatedButton(
                text: "Update",
                onPressed: () async {
                  final bool isSuccess = await context
                      .read<BrandProvider>()
                      .updateBrand(
                        context: context,
                        brandId: widget.brand.id.toString(),
                        title: nameController.text,
                        imageUrl: widget.brand.imageUrl,
                      );
                  if (isSuccess && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
