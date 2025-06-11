import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:desi_shopping_seller/providers/order_provider.dart';
import 'package:desi_shopping_seller/providers/product_provider.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/screens/dash%20board/componenet/dash_board_support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final brandProvider = Provider.of<BrandProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      //   final userProvider = Provider.of<UserProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      await Future.wait([
        brandProvider.fetchIfNeeded(context: context),
        productProvider.fetchIfNeeded(context: context),
        //    userProvider.getAllUsers(context: context),
        orderProvider.fetchIfNeeded(context: context),
      ]);

      _loadDashboardData();
    });
  }

  List<int> dashboardData = [];

  void _loadDashboardData() {
    final productProvider = context.read<ProductProvider>();
    final brandProvider = context.read<BrandProvider>();
    final userProvider = context.read<UserProvider>();
    final orderProvider = context.read<OrderProvider>();

    final allOrders = orderProvider.allOrders;

    final today = DateTime.now();
    final todayOrders = allOrders
        .where(
          (e) =>
              e.createdAt.toDate().day == today.day &&
              e.createdAt.toDate().month == today.month &&
              e.createdAt.toDate().year == today.year,
        )
        .toList();

    setState(() {
      dashboardData = [
        todayOrders.length,
        todayOrders.where((e) => e.status == 'pending').length,
        todayOrders.where((e) => e.status == 'delivered').length,
        todayOrders.where((e) => e.status == 'cancelled').length,
        allOrders.length,
        allOrders.where((e) => e.status == 'pending').length,
        allOrders.where((e) => e.status == 'delivered').length,
        allOrders.where((e) => e.status == 'cancelled').length,
        productProvider.allProduct.length,
        brandProvider.allBrands.length,
        userProvider.allUsers.length,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Consumer<ProductProvider>(
          builder: (context, value, child) {
            return GridView.builder(
              itemCount: dashBoardItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: size.height * 0.02,
                mainAxisExtent: size.height * 0.24,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: generateColors(dashBoardItems.length)[index],
                      border: Border(
                        left: BorderSide(
                          color: generateColors(dashBoardItems.length)[index],
                        ),
                        right: BorderSide(
                          color: generateColors(dashBoardItems.length)[index],
                        ),
                        top: BorderSide(
                          color: generateColors(dashBoardItems.length)[index],
                        ),
                      ),
                    ),
                    child: Column(
                      spacing: size.height * 0.04,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Text(
                          dashBoardItems[index],
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dashboardData.length > index
                              ? dashboardData[index].toString()
                              : '0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
