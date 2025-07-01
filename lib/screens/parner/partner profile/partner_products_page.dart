import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/add_product_screen.dart';
import 'package:desi_shopping_seller/screens/admin/add%20products/componenets/view_products.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerProductsPage extends StatefulWidget {
  const PartnerProductsPage({super.key});

  @override
  State<PartnerProductsPage> createState() => _PartnerProductsPageState();
}

class _PartnerProductsPageState extends State<PartnerProductsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PartnerProvider>(
      context,
      listen: false,
    ).getPartnerAddedProductsOnly(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        shape: const CircleBorder(),
        elevation: 0.0,
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddProductScreen(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<PartnerProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.filterproducts.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final products = value.filterproducts[index];
              return GestureDetector(
                onTap: () => moveToNextPageWithFadeAnimations(
                  context: context,
                  route: ViewProductDetails(product: products),
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
    );
  }
}
