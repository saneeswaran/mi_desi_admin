import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsDropdown extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsDropdown({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _customDropDown(
            text: "Product Description",
            value: product.description,
          ),
          _customDivider(),
          _customDropDown(text: "Net Quantity", value: product.netVolume!),
          _customDivider(),
          _customDropDown(text: "Dosage", value: product.dosage!),
          _customDivider(),
          _customDropDown(text: "Ingredients", value: product.composition!),
          _customDivider(),
          _customDropDown(text: "Storage", value: product.storage!),
          _customDivider(),
          _customDropDown(
            text: "Manufactured by",
            value: product.manufacturedBy!,
          ),
          _customDivider(),
          _customDropDown(text: "Marketed by", value: product.marketedBy!),
          _customDivider(),
          _customDropDown(
            text: "Additional Information",
            value: product.additionalInformation!,
          ),
          _customDivider(),
        ],
      ),
    );
  }

  Widget _customDropDown({required String text, required String value}) {
    return ExpansionTile(
      title: Text(
        text,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      children: [Text(value)],
    );
  }

  Widget _customDivider() {
    return Divider(color: Colors.grey[200]);
  }
}
