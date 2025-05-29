import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/add%20products/add_product_screen.dart';
import 'package:desi_shopping_seller/screens/add%20products/componenets/view_products.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddProductScreen(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        height: size.height * 0.9,
        width: size.width * 1,
        child: Column(
          spacing: size.height * 0.02,
          children: [
            _brandbuilder(size: size),
            _filterDate(size: size, context: context),
            _allProducts(size: size),
          ],
        ),
      ),
    );
  }

  Widget _brandbuilder({required Size size}) {
    return SizedBox(
      height: size.height * 0.15,
      width: size.width,
      child: Consumer<BrandProvider>(
        builder: (context, value, child) {
          final allBrands = value.filteredBrands;
          final currentIndex = value.currentIndex;
          return ListView.builder(
            itemCount: allBrands.length + 1,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final isSelected = currentIndex == index;

              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<BrandProvider>(
                      context,
                      listen: false,
                    ).switchTab(index);
                    context.read<ProductProvider>().resetFilters();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: size.width * 0.03),
                    height: size.height * 0.10,
                    width: size.width * 0.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [Colors.lightBlue, Colors.blue]
                            : [Colors.grey.shade300, Colors.white],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "All",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Consumer<ProductProvider>(
                          builder: (context, value, child) {
                            final totalProduct = value.allProduct.length;
                            return Text(
                              totalProduct.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Correct index for actual brands
              final brand = allBrands[index - 1];

              return GestureDetector(
                onTap: () {
                  Provider.of<BrandProvider>(
                    context,
                    listen: false,
                  ).switchTab(index);
                  context.read<ProductProvider>().filterByBrand(brand.id);
                },
                child: Container(
                  margin: EdgeInsets.only(right: size.width * 0.03),
                  height: size.height * 0.10,
                  width: size.width * 0.30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isSelected
                          ? [Colors.lightBlue, Colors.blue]
                          : [Colors.grey.shade300, Colors.white],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        brand.title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        brand.productsCount.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _filterDate({required Size size, required BuildContext context}) {
    final provider = Provider.of<ProductProvider>(context);
    return Row(
      spacing: size.width * 0.03,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: "Start Date",
            onPressed: () {
              provider.pickStartDate(context);
            },
          ),
        ),
        Expanded(
          child: CustomElevatedButton(
            text: "End Date",
            onPressed: () {
              provider.pickEndDate(context);
            },
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: const CircleBorder(),
          ),
          onPressed: () {
            provider.resetFilters();
          },
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ],
    );
  }

  Widget _allProducts({required Size size}) {
    return Expanded(
      child: SizedBox(
        height: size.height * 0.60,
        child: Consumer<ProductProvider>(
          builder: (context, value, child) {
            final product = value.filterProduct;
            return ListView.builder(
              itemCount: product.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final products = product[index];
                return GestureDetector(
                  onTap: () => moveToNextPageWithFadeAnimations(
                    context: context,
                    route: ViewProducts(product: products),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(size.width * 0.02),
                    height: size.height * 0.20,
                    width: size.width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: size.height * 0.20,
                          width: size.width * 0.40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                products.imageUrl[0],
                                cacheKey: products.id,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.20,
                          width: size.width * 0.50,
                          padding: EdgeInsets.all(size.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: size.height * 0.011,
                            children: [
                              Text(
                                products.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                products.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                products.brand.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Row(
                                spacing: size.width * 0.02,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: size.width * 0.02,
                                    ),
                                    width: size.width * 0.13,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 223, 163, 1),
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      "MRP",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${products.price}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
