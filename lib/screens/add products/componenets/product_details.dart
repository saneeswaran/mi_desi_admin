import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.02),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailTile("Name", product.title),
              _divider(),
              _detailTile("Description", product.description),
              _divider(),
              _detailTile("Price", "₹${product.price}"),
              _divider(),
              _detailTile("Stock", product.stock.toString()),
              _divider(),
              _detailTile("Tax", "${product.taxAmount}%"),
              _divider(),
              _detailTile("Cash On Delivery", product.cashOnDelivery),
              _divider(),
              _detailTile("Brand", product.brand.title),
              _divider(),
              _detailTile("Quantity", product.quantity),
              _divider(),
              _detailTile("Rating", product.rating.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(thickness: 1, color: Colors.grey);
}
