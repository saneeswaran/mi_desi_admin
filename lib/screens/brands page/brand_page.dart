import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/screens/add%20products/componenets/add_brands.dart';
import 'package:desi_shopping_seller/screens/brands%20page/components/view_brands.dart';
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
  @override
  void initState() {
    super.initState();
    Future.wait([context.read<BrandProvider>().getBrands(context: context)]);
    searchController.addListener(() {
      context.read<BrandProvider>().filterBrandsByQuery(
        query: searchController.text,
      );
    });
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
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
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
            child: Consumer<BrandProvider>(
              builder: (context, value, index) {
                final brand = value.filterBrands;
                return GridView.builder(
                  itemCount: brand.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    fit: BoxFit.cover,
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
    );
  }
}
