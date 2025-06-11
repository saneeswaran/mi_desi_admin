import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsForBanners extends StatelessWidget {
  const ProductDetailsForBanners({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, value, index) {
        return ListView.builder(
          itemCount: value.filterProduct.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final products = value.filterProduct[index];
            return Container(
              margin: EdgeInsets.all(size.width * 0.03),
              height: size.height * 0.25,
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
                    height: size.height * 0.2,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(products.imageUrl[0]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(size.width * 0.03),
                      height: size.height * 0.2,
                      width: size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            products.brand.title,
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
                          Container(
                            height: size.height * 0.05,
                            width: size.width * 1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: products.stock == 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            child: Center(
                              child: Icon(
                                products.stock == 0 ? Icons.close : Icons.check,
                                color: Colors.white,
                              ),
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
    );
  }
}
