// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/product_details.dart';
import 'package:desi_shopping_seller/screens/admin/banners/components/add_banners.dart';
import 'package:desi_shopping_seller/screens/admin/banners/components/banner_update.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class BannersPage extends StatefulWidget {
  const BannersPage({super.key});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BannersProvider>(
      context,
      listen: false,
    ).fetchIfNeeded(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        shape: const CircleBorder(),
        elevation: 0.0,
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddBanners(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(size.width * 0.03),
          height: size.height * 1,
          width: size.width * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.backgroundImages),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Banner Image",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Product Image",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<BannersProvider>(
                builder: (context, value, child) {
                  final bannerCount = value.filterBanners.length;
                  return ListView.builder(
                    itemCount: bannerCount,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).filterProduct;
                      final selectedProduct = product.where(
                        (e) => e.id == value.filterBanners[index].productId,
                      );
                      final banners = value.filterBanners[index];
                      return GestureDetector(
                        onTap: () {
                          moveToNextPageWithFadeAnimations(
                            context: context,
                            route: ProductDetails(
                              product: selectedProduct.first,
                            ),
                          );
                        },
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  final bool isSuccess = await value
                                      .deleteBanner(
                                        context: context,
                                        productId: banners.productId,
                                      );
                                  log(isSuccess.toString());
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                              ),
                              SlidableAction(
                                onPressed: (context) =>
                                    moveToNextPageWithFadeAnimations(
                                      context: context,
                                      route: BannerUpdate(banner: banners),
                                    ),
                                backgroundColor: Colors.white,
                                icon: Icons.edit,
                              ),
                            ],
                          ),
                          child: Container(
                            margin: EdgeInsets.all(size.width * 0.03),
                            // border container
                            height: size.height * 0.15,
                            width: size.width * 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: size.height * 0.15,
                                    width: size.width * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(size.width * 0.02),
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          cacheKey: banners.bannerId,
                                          banners.imageUrl,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(size.width * 0.02),
                                    height: size.height * 0.2,
                                    width: size.width * 1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          selectedProduct.first.imageUrl[0],
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
