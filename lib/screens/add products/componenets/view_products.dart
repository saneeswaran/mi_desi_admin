// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/add%20products/componenets/product_details.dart';
import 'package:desi_shopping_seller/screens/add%20products/componenets/update_product.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ViewProducts extends StatefulWidget {
  final ProductModel product;
  const ViewProducts({super.key, required this.product});

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  List<String> videos = [];
  List<String> images = [];
  int currentIndex = 0;
  int imageIndex = 0;
  int videoIndex = 0;
  bool isDelete = false;

  late List<VideoPlayerController> _videoControllers;

  @override
  void initState() {
    super.initState();
    videos = widget.product.videoUrl;
    images = widget.product.imageUrl;
    _videoControllers = videos
        .map(
          (url) =>
              VideoPlayerController.networkUrl(Uri.parse(url))
                ..initialize().then((_) => setState(() {})),
        )
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SafeArea(
            child: AbsorbPointer(
              absorbing: isDelete,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Column(
                            children: [
                              currentIndex == 0
                                  ? _customImageBuilder(
                                      size: size,
                                      context: context,
                                    )
                                  : videos.isEmpty
                                  ? SizedBox(
                                      height: size.height * 0.4,
                                      width: size.width,
                                      child: const Center(
                                        child: Text("No videos found"),
                                      ),
                                    )
                                  : _customVideoBuilder(size: size),
                              SizedBox(height: size.height * 0.02),
                              _customRow(size: size),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      ProductDetails(product: widget.product),
                      SizedBox(height: size.height * 0.02),
                      _rowButtons(size: size),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isDelete
              ? Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.black38,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _rowButtons({required Size size}) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: size.height * 0.06,
          width: size.width * 0.4,
          child: CustomElevatedButton(
            text: "Delete",
            onPressed: () async {
              Provider.of<BrandProvider>(
                context,
                listen: false,
              ).decrementProductCountForBrand(
                widget.product.brand.id.toString(),
              );
              final bool isSuccess = await provider.deleteProduct(
                context: context,
                productId: widget.product.id.toString(),
                brandId: widget.product.brand.id.toString(),
              );

              log(isSuccess.toString());
              setState(() {
                isDelete = true;
              });
              if (isSuccess && mounted) {
                setState(() => isDelete = false);
                Navigator.pop(context);
              }
            },
            color: Colors.red,
          ),
        ),
        SizedBox(
          height: size.height * 0.06,
          width: size.width * 0.4,
          child: CustomElevatedButton(
            text: "Update",
            onPressed: () => moveToNextPageWithFadeAnimations(
              context: context,
              route: UpdateProductScreen(product: widget.product),
            ),
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _outlinedButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blueAccent,
        side: const BorderSide(color: Colors.blueAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Row _customRow({required Size size}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _outlinedButton(
          text: "Photos",
          onPressed: () => setState(() {
            currentIndex = 0;
            if (videos.isNotEmpty) {
              _videoControllers[videoIndex].pause();
            }
          }),
        ),
        SizedBox(width: size.width * 0.05),
        _outlinedButton(
          text: "Videos",
          onPressed: () => setState(() => currentIndex = 1),
        ),
      ],
    );
  }

  Widget _customVideoBuilder({required Size size}) {
    final controller = _videoControllers[videoIndex];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          child: controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: VideoPlayer(controller),
                  ),
                )
              : SizedBox(
                  height: size.height * 0.4,
                  child: const Center(child: CircularProgressIndicator()),
                ),
        ),
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height * 0.1,
          width: size.width,
          child: ListView.builder(
            itemCount: videos.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final thumbController = _videoControllers[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    for (var c in _videoControllers) {
                      c.pause();
                    }
                    videoIndex = index;
                    thumbController.seekTo(Duration.zero);
                    thumbController.play();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: size.height * 0.1,
                  width: size.width * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: thumbController.value.isInitialized
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: thumbController.value.aspectRatio,
                                child: VideoPlayer(thumbController),
                              ),
                            ),
                            const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _customImageBuilder({
    required Size size,
    required BuildContext context,
  }) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.40,
          width: size.width,
          child: GestureDetector(
            onTap: () => dialog(context: context, size: size),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: images[imageIndex],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height * 0.1,
          width: size.width,
          child: ListView.builder(
            itemCount: images.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => imageIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: size.height * 0.1,
                  width: size.width * 0.30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: imageIndex == index
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void dialog({required BuildContext context, required Size size}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.black,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: size.height * 0.6,
            width: size.width * 0.9,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              imageProvider: CachedNetworkImageProvider(images[imageIndex]),
            ),
          ),
        ),
      ),
    );
  }
}
