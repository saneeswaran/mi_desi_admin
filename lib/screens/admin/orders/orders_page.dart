import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/model/order_model.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
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
    context.read<UserProvider>().getAllUsers(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.15,
              width: size.width,
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  final statuses = orderProvider.allOrderStatusForFilter;
                  final selectedStatus = orderProvider.selectedStatus;

                  // Build counts map to show count per status dynamically
                  final counts = _calculateStatusCounts(
                    orderProvider.allOrders,
                  );

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statuses.length,
                    itemBuilder: (context, index) {
                      final status = statuses[index];
                      final isSelected = status == selectedStatus;
                      final count = counts[status.toLowerCase()] ?? 0;
                      final displayCount = status.toLowerCase() == 'all'
                          ? orderProvider.allOrders.length
                          : count;

                      return GestureDetector(
                        onTap: () {
                          orderProvider.filterOrdersByStatus(
                            orderStatus: status,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isSelected
                                  ? [Colors.pinkAccent, Colors.pink]
                                  : [Colors.grey.shade300, Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  displayCount.toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
            Expanded(
              child: Consumer2<OrderProvider, UserProvider>(
                builder: (context, orderProvider, userProvider, child) {
                  final orders = orderProvider.filterOrders;
                  final users = userProvider.filterUsers;

                  if (orders.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders found",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 350,
                        ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final userIndex = users.indexWhere(
                        (u) => u.uid == order.userId,
                      );
                      final user = userIndex != -1 ? users[userIndex] : null;
                      final product = order.products.isNotEmpty
                          ? order.products[0]
                          : null;

                      return GestureDetector(
                        onTap: () => moveToNextPageWithFadeAnimations(
                          context: context,
                          route: ShowOrderDetailsPage(
                            order: order,
                            customer: user!,
                          ),
                        ),
                        child: GridTile(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (product != null)
                                  Container(
                                    height: size.height * 0.25,
                                    width: double.infinity,
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
                                const SizedBox(height: 12),
                                Text(
                                  product?['title'] ?? 'No Product',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Status: ${order.orderStatus}",
                                  style: const TextStyle(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }

  /// Helper function to count orders per status (case-insensitive)
  Map<String, int> _calculateStatusCounts(List<OrderModel> allOrders) {
    final Map<String, int> counts = {
      'all': allOrders.length,
      'pending': 0,
      'processing': 0,
      'delivered': 0,
      'cancelled': 0,
    };

    for (final order in allOrders) {
      final status = order.orderStatus.toLowerCase();
      if (counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
      }
    }

    return counts;
  }
}
