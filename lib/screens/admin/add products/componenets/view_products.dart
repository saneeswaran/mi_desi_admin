import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/photo_view/photo_view_page.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/product_details_with_cart.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/update_product.dart';
import 'package:desi_shopping_seller/screens/admin/products/product_details_dropdown.dart';
import 'package:desi_shopping_seller/screens/admin/products/video%20player/video_list_screen.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProductDetails extends StatefulWidget {
  final ProductModel product;
  const ViewProductDetails({super.key, required this.product});

  @override
  State<ViewProductDetails> createState() => _ViewProductDetailsState();
}

class _ViewProductDetailsState extends State<ViewProductDetails> {
  final reviewController = TextEditingController();
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    List<Widget> carouselImage() => widget.product.imageUrl
        .map(
          (e) => GestureDetector(
            onTap: () => moveToNextPageWithFadeAnimations(
              context: context,
              route: PhotoViewPage(e: e),
            ),
            child: Container(
              height: size.height * 0.35,
              width: size.width * 1,
              decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider(e)),
              ),
              child: widget.product.videoUrl.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          onPressed: () => moveToNextPageWithFadeAnimations(
                            context: context,
                            route: VideoGridView(
                              videoUrls: widget.product.videoUrl,
                            ),
                          ),
                          icon: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        )
        .toList();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.40,
                    width: size.width * 1,
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.05),
                        CarouselSlider(
                          items: carouselImage(),
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                          ),
                        ),
                        DotsIndicator(
                          dotsCount: carouselImage().length,
                          position: _selectedImageIndex.toDouble(),
                          decorator: const DotsDecorator(
                            activeColor: Colors.pink,
                          ),
                          animate: true,
                        ),
                      ],
                    ),
                  ),
                  ProductDetailsWithCart(product: widget.product),
                  Row(
                    children: [
                      const Spacer(),
                      Consumer<ProductProvider>(
                        builder: (context, value, child) {
                          final isAvailable = value.filterProduct.any(
                            (product) => product.stock > 0,
                          );
                          return Column(
                            children: [
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                child: Center(
                                  child: Icon(
                                    isAvailable ? Icons.check : Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                isAvailable ? "Available" : "Not Available",
                                style: TextStyle(
                                  color: isAvailable
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromRGBO(237, 244, 242, 1),
                    thickness: 1.2,
                  ),
                  ProductDetailsDropdown(product: widget.product),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.4,
                        child: CustomElevatedButton(
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            final provider = Provider.of<ProductProvider>(
                              context,
                              listen: false,
                            );
                            final bool isSuccess = await provider.deleteProduct(
                              context: context,
                              productId: widget.product.id.toString(),
                              brandId: widget.product.brand.id.toString(),
                            );
                            if (isSuccess && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.4,
                        child: CustomElevatedButton(
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => moveToNextPageWithFadeAnimations(
                            context: context,
                            route: UpdateProductScreen(product: widget.product),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
