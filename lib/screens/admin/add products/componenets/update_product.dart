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
  late TextEditingController netVolumeController;
  late TextEditingController dosageController;
  late TextEditingController compositionController;
  late TextEditingController storageController;
  late TextEditingController manufacturedByController;
  late TextEditingController marketedByController;
  late TextEditingController shelfLifeController;
  late TextEditingController additionalInformationController;

  List<File> newImages = [];
  List<File> newVideos = [];
  List<String> videoThumbnails = [];
  List<VideoPlayerController> videoControllers = [];

  bool isBrandLoading = true;
  bool isRealBrandLoading = true;
  bool isUpdatingProduct = false;
  BrandModel? selectedCategoryBrand;
  BrandModel? selectedRealBrand;
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
    netVolumeController = TextEditingController(text: widget.product.netVolume);
    dosageController = TextEditingController(text: widget.product.dosage);
    compositionController = TextEditingController(
      text: widget.product.composition,
    );
    storageController = TextEditingController(text: widget.product.storage);
    manufacturedByController = TextEditingController(
      text: widget.product.manufacturedBy,
    );
    marketedByController = TextEditingController(
      text: widget.product.manufacturedBy,
    );
    shelfLifeController = TextEditingController(text: widget.product.shelfLife);
    additionalInformationController = TextEditingController(
      text: widget.product.additionalInformation,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BrandProvider>(context, listen: false);
      await provider.getBrands(context: context);
      selectedCategoryBrand = provider.allBrands.firstWhere(
        (b) => b.id == widget.product.id,
        orElse: () => provider.allBrands.first,
      );
      selectedRealBrand = provider.realBrands.firstWhere(
        (b) => b.id == widget.product.id,
        orElse: () => provider.realBrands.first,
      );
      setState(() {
        isBrandLoading = false;
        isRealBrandLoading = false;
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
    offerPriceController.dispose();
    netVolumeController.dispose();
    dosageController.dispose();
    compositionController.dispose();
    storageController.dispose();
    manufacturedByController.dispose();
    marketedByController.dispose();
    shelfLifeController.dispose();
    additionalInformationController.dispose();
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

    if (selectedCategoryBrand == null) {
      showSnackBar(context: context, e: 'Please select a brand');
      return;
    }

    if (selectedRealBrand == null) {
      showSnackBar(context: context, e: 'Please select a real brand');
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
      categoryBrand: selectedCategoryBrand!,
      realBrand: selectedRealBrand!,
      imageUrl: newImages,
      videoUrl: newVideos,
      additionalInformation: additionalInformationController.text,
      composition: compositionController.text,
      dosage: dosageController.text,
      manufacturedBy: manufacturedByController.text,
      marketedBy: marketedByController.text,
      netVolume: netVolumeController.text,
      offerPrice: int.parse(offerPriceController.text),
      shelfLife: shelfLifeController.text,
      storage: storageController.text,
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
        appBar: AppBar(
          title: const Text(
            'Update Product',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                        hintText: 'Net Volume',
                        controller: netVolumeController,
                        maxLines: 2,
                      ),
                      CustomTextFormField(
                        hintText: 'Dosage',
                        controller: dosageController,
                        maxLines: 2,
                      ),
                      CustomTextFormField(
                        hintText: 'Composition',
                        controller: compositionController,
                        maxLines: 2,
                      ),
                      CustomTextFormField(
                        hintText: 'Storage',
                        controller: storageController,
                        maxLines: 2,
                      ),
                      CustomTextFormField(
                        hintText: 'Manufactured',
                        controller: manufacturedByController,
                        maxLines: 3,
                      ),
                      CustomTextFormField(
                        hintText: 'Shelf Life',
                        controller: shelfLifeController,
                        maxLines: 2,
                      ),
                      CustomTextFormField(
                        hintText: 'Additional Information',
                        maxLines: 5,
                        controller: additionalInformationController,
                      ),
                      CustomTextFormField(
                        hintText: "Marked By",
                        controller: marketedByController,
                        maxLines: 3,
                      ),
                      CustomTextFormField(
                        hintText: 'Stock',
                        controller: stockController,
                        keyboardType: TextInputType.number,
                      ),
                      isBrandLoading
                          ? const CircularProgressIndicator()
                          : _brandDropDown(),
                      isRealBrandLoading
                          ? const CircularProgressIndicator()
                          : _realBrandDropDown(),

                      _cashOnDeliveryDropDown(),
                      CustomTextFormField(
                        hintText: 'Tax %',
                        controller: taxAmountController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 1,
                        child: CustomElevatedButton(
                          onPressed: updateProduct,
                          child: Text(
                            isUpdatingProduct ? 'Updating...' : 'Update',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
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

  Widget _brandDropDown() {
    return Consumer<BrandProvider>(
      builder: (context, provider, child) {
        final items = provider.filteredBrands
            .map((e) => DropdownMenuItem(value: e, child: Text(e.title)))
            .toList();
        return DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Select Brand",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          items: items,
          value: selectedCategoryBrand,
          onChanged: (value) {
            setState(() {
              selectedCategoryBrand = value;
            });
          },
        );
      },
    );
  }

  Widget _realBrandDropDown() {
    return Consumer<BrandProvider>(
      builder: (context, provider, child) {
        final items = provider.filterRealBrands
            .map((e) => DropdownMenuItem(value: e, child: Text(e.title)))
            .toList();
        return DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Select Brand",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          items: items,
          value: selectedRealBrand,
          onChanged: (value) {
            setState(() {
              selectedRealBrand = value;
            });
          },
        );
      },
    );
  }

  Widget _cashOnDeliveryDropDown() {
    return Consumer<BrandProvider>(
      builder: (context, provider, child) {
        final list = ['Yes', 'No'];
        final items = list
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList();
        return DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Cash On Delivery",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          items: items,
          value: cashOnDelivery,
          onChanged: (value) {
            setState(() {
              cashOnDelivery = value;
            });
          },
        );
      },
    );
  }
}
