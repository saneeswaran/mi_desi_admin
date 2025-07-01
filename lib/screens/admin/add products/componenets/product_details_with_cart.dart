import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:flutter/material.dart';

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
            product.brand.title,
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
