import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
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
      body: Consumer<OrderProvider>(
        builder: (context, value, child) {
          final order = value.filterOrders;
          return GridView.builder(
            itemCount: order.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final orders = order[index];
              return GridTile(
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.30,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            orders.product[index].imageUrl[0],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      orders.product[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
