import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/update_product.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/view_products.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfoPage extends StatefulWidget {
  final ProductModel product;
  const ProductInfoPage({super.key, required this.product});

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                ViewProductDetails(product: product),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      color: Colors.red,
                      onPressed: () async {
                        setState(() => isDeleting = true);
                        Provider.of<BrandProvider>(
                          context,
                          listen: false,
                        ).decrementProductCountForBrand(product.brand.id!);
                        final success = await context
                            .read<ProductProvider>()
                            .deleteProduct(
                              context: context,
                              productId: product.id!,
                              brandId: product.brand.id!,
                            );
                        if (success && context.mounted) {
                          setState(() => isDeleting = false);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    CustomElevatedButton(
                      color: Colors.pink,
                      onPressed: () {
                        moveToNextPageWithFadeAnimations(
                          context: context,
                          route: UpdateProductScreen(product: product),
                        );
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isDeleting)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
