import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/banners_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/admin/banners/components/banner_offer_page.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsForBanners extends StatelessWidget {
  const ProductDetailsForBanners({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer2<ProductProvider, BannersProvider>(
      builder: (context, value, banner, index) {
        return ListView.builder(
          itemCount: value.filterProduct.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final products = value.filterProduct[index];
            return GestureDetector(
              onTap: () {
                final banners = banner.filterBanners;
                final bannerHasProduct = banners.any(
                  (e) => e.productId == products.id,
                );

                if (bannerHasProduct) {
                  showSnackBar(
                    context: context,
                    e: "Banner already added to this product.",
                  );
                } else {
                  moveToNextPageWithFadeAnimations(
                    context: context,
                    route: BannerOfferPage(product: products),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.all(size.width * 0.03),
                height: size.height * 0.30,
                width: size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.height * 0.30,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            products.imageUrl[0],
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.02),
                        height: size.height * 0.30,
                        width: size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: size.height * 0.0019,
                          children: [
                            SizedBox(height: size.height * 0.02),
                            Text(
                              products.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              products.categoryBrand.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "$currency ${products.price}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Stock:  ${products.stock}',
                              style: TextStyle(
                                color: products.stock == 0
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.11,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: products.stock == 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  child: Icon(
                                    products.stock == 0
                                        ? Icons.close
                                        : Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  products.stock == 0
                                      ? 'Out of Stock'
                                      : 'In Stock',
                                  style: TextStyle(
                                    color: products.stock == 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
