import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/screens/admin/brands%20page/components/add_brands.dart';
import 'package:desi_shopping_seller/screens/admin/brands%20page/components/view_brands.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  final searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<BrandProvider>().filterBrandsByQuery(
          searchController.text,
        );
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddBrands(),
        ),
        elevation: 0.0,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          spacing: size.height * 0.02,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: CustomTextFormField(
                hintText: 'Search',
                controller: searchController,
              ),
            ),
            Expanded(
              child: Selector<BrandProvider, List<BrandModel>>(
                selector: (context, value) => value.filteredBrands,
                builder: (context, brands, index) {
                  final brand = brands;
                  return GridView.builder(
                    itemCount: brand.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final brands = brand[index];
                      return GestureDetector(
                        onTap: () => moveToNextPageWithFadeAnimations(
                          context: context,
                          route: ViewBrands(brand: brands),
                        ),
                        child: GridTile(
                          child: Card(
                            child: Column(
                              spacing: size.height * 0.02,
                              children: [
                                Container(
                                  height: size.height * 0.20,
                                  width: size.width * 0.40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        brands.imageUrl,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Text(
                                  brands.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
