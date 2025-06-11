// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/screens/banners/components/add_banners.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        elevation: 0.0,
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddBanners(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        height: size.height * 1,
        width: size.width * 1,
        child: Column(
          children: [
            Consumer<BannersProvider>(
              builder: (context, value, child) {
                final bannerCount = value.filterBanners.length;
                return ListView.builder(
                  itemCount: bannerCount,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final banners = value.filterBanners[index];
                    return Container(
                      // border container
                      height: size.height * 0.2,
                      width: size.width * 1,
                      decoration: BoxDecoration(
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
                          Container(
                            height: size.height * 0.2,
                            width: size.width * 1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  banners.imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              height: size.height * 0.2,
                              width: size.width * 1,
                              child: Column(
                                children: [
                                  Text(
                                    banners.product.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    banners.product.brand.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    banners.product.offerPrice.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
