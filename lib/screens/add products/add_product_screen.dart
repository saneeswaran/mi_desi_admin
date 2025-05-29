// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/add%20products/componenets/add_brands.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final taxAmountController = TextEditingController();
  final quantityController = TextEditingController();
  final offerPriceController = TextEditingController();

  List<File> images = [];
  List<File> videos = [];
  List<String> videoThumbnails = [];
  List<VideoPlayerController> videoControllers = [];

  bool isBrandLoading = true;
  bool isAddingProduct = false;
  BrandModel? selectedBrand;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandProvider>(
        context,
        listen: false,
      ).getBrands(context: context).then((_) {
        setState(() => isBrandLoading = false);
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    taxAmountController.dispose();
    quantityController.dispose();
    offerPriceController.dispose();
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await pickListOfImages(context: context);
    setState(() => images = picked);
  }

  Future<void> pickVideos() async {
    final pickedVideos = await pickMultipleVideos(context: context);

    // Reset old controllers and thumbnails
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

    setState(() => videos = pickedVideos);
  }

  void addProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedBrand == null) {
      showSnackBar(context: context, e: 'Please select a brand');
      return;
    }

    setState(() => isAddingProduct = true);

    final provider = context.read<ProductProvider>();
    final success = await provider.addProduct(
      context: context,
      title: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      stock: int.parse(stockController.text),
      taxAmount: double.parse(taxAmountController.text),
      quantity: quantityController.text,
      brand: selectedBrand!,
      imageFiles: images,
      videoFiles: videos,
    );

    if (success && mounted) {
      showSnackBar(context: context, e: 'Successfully added product');
      formKey.currentState?.reset();
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      stockController.clear();
      taxAmountController.clear();
      quantityController.clear();
      offerPriceController.clear();
      setState(() {
        images.clear();
        videos.clear();
        videoThumbnails.clear();
        for (var c in videoControllers) {
          c.dispose();
        }
        videoControllers.clear();
        selectedBrand = null;
      });
    }

    setState(() => isAddingProduct = false);
  }

  Widget _brandDropDown() {
    return Consumer<BrandProvider>(
      builder: (_, value, __) {
        final brands = value.allBrands;
        return DropdownButtonFormField<BrandModel>(
          value: selectedBrand,
          items: brands
              .map((e) => DropdownMenuItem(value: e, child: Text(e.title)))
              .toList(),
          onChanged: (val) => setState(() => selectedBrand = val),
          validator: (val) => val == null ? 'Please select a brand' : null,
          decoration: InputDecoration(
            labelText: 'Select Brand',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        tooltip: "Add Brands",
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddBrands(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isAddingProduct,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: size.height * 0.01,
                  children: [
                    // Images
                    images.isEmpty
                        ? GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: size.height * 0.3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('Tap to select images'),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: pickImage,
                            child: CarouselSlider(
                              items: images
                                  .map((e) => Image.file(e, fit: BoxFit.cover))
                                  .toList(),
                              options: CarouselOptions(height: 200),
                            ),
                          ),
                    const SizedBox(height: 10),

                    // Videos
                    videos.isEmpty
                        ? GestureDetector(
                            onTap: pickVideos,
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('Tap to select videos'),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: videoThumbnails.length,
                              itemBuilder: (_, i) => GestureDetector(
                                onTap: () {
                                  videoControllers[i].play();
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      content: AspectRatio(
                                        aspectRatio: videoControllers[i]
                                            .value
                                            .aspectRatio,
                                        child: VideoPlayer(videoControllers[i]),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            videoControllers[i].pause();
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
                                  child: Image.file(
                                    File(videoThumbnails[i]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),

                    CustomTextFormField(
                      hintText: 'Name',
                      controller: nameController,
                    ),
                    CustomTextFormField(
                      hintText: 'Description',
                      controller: descriptionController,
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
                    CustomTextFormField(
                      hintText: 'Quantity',
                      controller: quantityController,
                    ),
                    isBrandLoading
                        ? const CircularProgressIndicator()
                        : _brandDropDown(),
                    CustomTextFormField(
                      hintText: 'Tax',
                      controller: taxAmountController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      text: isAddingProduct ? 'Adding...' : 'Submit',
                      onPressed: addProduct,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isAddingProduct)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
