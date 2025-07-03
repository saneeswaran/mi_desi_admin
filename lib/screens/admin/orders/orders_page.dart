import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/screens/admin/orders/components/show_order_details_page.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().getAllOrders(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<OrderProvider>(
          builder: (context, value, child) {
            final order = value.filterOrders;
            return GridView.builder(
              itemCount: order.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                mainAxisExtent: 350,
              ),
              itemBuilder: (context, index) {
                final orders = order[index];

                // Safely get first product
                final product = orders.products.isNotEmpty
                    ? orders.products[0]
                    : null;

                return GestureDetector(
                  onTap: () => moveToNextPageWithFadeAnimations(
                    context: context,
                    route: ShowOrderDetailsPage(order: orders),
                  ),
                  child: GridTile(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (product != null)
                            Container(
                              height: size.height * 0.30,
                              width: size.width * 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    product['imageUrl'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            product?['title'] ?? 'No product',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
