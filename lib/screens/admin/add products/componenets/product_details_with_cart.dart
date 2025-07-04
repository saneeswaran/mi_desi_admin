import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsWithCart extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsWithCart({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: size.height * 0.006,
              width: size.width * 0.1,
              decoration: BoxDecoration(
                color: Colors.pink.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Text(
            product.categoryBrand.title,
            style: const TextStyle(
              color: Colors.pink,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            product.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currency ${product.price}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    final bool isLiked = provider.checkAlreadyBestSelling(
                      product.id.toString(),
                    );
                    return IconButton(
                      onPressed: () async {
                        if (isLiked) {
                          await provider.removeBestSelling(
                            context: context,
                            productId: product.id.toString(),
                          );
                          if (context.mounted) {
                            showSnackBar(
                              context: context,
                              e: "Removed from best selling",
                            );
                          }
                        } else {
                          await provider.makeBestSelling(
                            context: context,
                            productId: product.id.toString(),
                          );
                          if (context.mounted) {
                            showSnackBar(
                              context: context,
                              e: "Added to best selling",
                            );
                          }
                        }
                      },
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.pink : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Text(
            "(Inclusive of all taxes)",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
