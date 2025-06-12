import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UpdateProductScreen extends StatefulWidget {
  final ProductModel product;
  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController taxAmountController;
  late TextEditingController offerPriceController;

  List<File> newImages = [];
  List<File> newVideos = [];
  List<String> videoThumbnails = [];
  List<VideoPlayerController> videoControllers = [];

  bool isBrandLoading = true;
  bool isUpdatingProduct = false;
  BrandModel? selectedBrand;
  String? cashOnDelivery;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.title);
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );
    taxAmountController = TextEditingController(
      text: widget.product.taxAmount.toString(),
    );
    offerPriceController = TextEditingController(
      text: widget.product.offerPrice?.toString() ?? "",
    );
    cashOnDelivery = widget.product.cashOnDelivery;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BrandProvider>(context, listen: false);
      await provider.getBrands(context: context);
      selectedBrand = provider.allBrands.firstWhere(
        (b) => b.id == widget.product.id,
        orElse: () => provider.allBrands.first,
      );
      setState(() => isBrandLoading = false);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    taxAmountController.dispose();
    offerPriceController.dispose();
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> pickNewImages() async {
    final picked = await pickListOfImages(context: context);
    setState(() => newImages = picked);
  }

  Future<void> pickNewVideos() async {
    final pickedVideos = await pickMultipleVideos(context: context);
    for (var c in videoControllers) {
      c.dispose();
    }
    videoControllers.clear();
    videoThumbnails.clear();

    for (var video in pickedVideos) {
      final thumb = await VideoThumbnail.thumbnailFile(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
      );
      if (thumb != null) videoThumbnails.add(thumb);

      final controller = VideoPlayerController.file(video);
      await controller.initialize();
      videoControllers.add(controller);
    }
    setState(() => newVideos = pickedVideos);
  }

  void updateProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedBrand == null) {
      showSnackBar(context: context, e: 'Please select a brand');
      return;
    }

    setState(() => isUpdatingProduct = true);

    final provider = context.read<ProductProvider>();
    final success = await provider.updateProduct(
      context: context,
      productId: widget.product.id.toString(),
      title: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      stock: int.parse(stockController.text),
      taxAmount: double.parse(taxAmountController.text),
      cashOnDelivery: cashOnDelivery!,
      brand: selectedBrand!,
      imageUrl: newImages,
      videoUrl: newVideos,
    );

    if (success && mounted) {
      showSnackBar(context: context, e: 'Product updated successfully');
      Navigator.pop(context);
    }

    setState(() => isUpdatingProduct = false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: isUpdatingProduct,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: size.height * 0.02,
                    children: [
                      newImages.isEmpty
                          ? GestureDetector(
                              onTap: pickNewImages,
                              child: Container(
                                height: size.height * 0.30,
                                width: size.width * 1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: const Center(
                                  child: Text("Update Images"),
                                ),
                              ),
                            )
                          : CarouselSlider(
                              items: newImages
                                  .map(
                                    (e) => Container(
                                      height: size.height * 0.3,
                                      width: size.width * 1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(e),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              options: CarouselOptions(),
                            ),
                      newVideos.isEmpty
                          ? GestureDetector(
                              onTap: pickNewVideos,
                              child: Container(
                                height: size.height * 0.10,
                                width: size.width * 1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: const Center(
                                  child: Text("Pick New Video"),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: size.height * 0.1,
                              width: size.width * 1,
                              child: ListView.builder(
                                itemCount: videoThumbnails.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      videoControllers[index].play();
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          content: AspectRatio(
                                            aspectRatio: videoControllers[index]
                                                .value
                                                .aspectRatio,
                                            child: VideoPlayer(
                                              videoControllers[index],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                videoControllers[index].pause();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      width: size.width * 0.3,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(videoThumbnails[index]),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      CustomTextFormField(
                        hintText: 'Name',
                        controller: nameController,
                      ),
                      CustomTextFormField(
                        hintText: 'Description',
                        controller: descriptionController,
                        maxLines: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              hintText: 'Price',
                              controller: priceController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              hintText: 'Offer Price',
                              controller: offerPriceController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        hintText: 'Stock',
                        controller: stockController,
                        keyboardType: TextInputType.number,
                      ),
                      isBrandLoading
                          ? const CircularProgressIndicator()
                          : Consumer<BrandProvider>(
                              builder: (_, value, __) {
                                return DropdownButtonFormField<BrandModel>(
                                  value: selectedBrand,
                                  items: value.allBrands
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.title),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => selectedBrand = val),
                                  validator: (val) => val == null
                                      ? 'Please select a brand'
                                      : null,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Brand',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              },
                            ),
                      DropdownButtonFormField<String>(
                        value: cashOnDelivery,
                        items: ['Yes', 'No']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => cashOnDelivery = val),
                        decoration: const InputDecoration(
                          labelText: 'Cash On Delivery',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      CustomTextFormField(
                        hintText: 'Tax %',
                        controller: taxAmountController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        text: isUpdatingProduct ? 'Updating...' : 'Update',
                        onPressed: updateProduct,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isUpdatingProduct)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
