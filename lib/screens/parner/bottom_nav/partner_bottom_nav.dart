import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/screens/parner/dashboard/partner_dashboard.dart';
import 'package:desi_shopping_seller/screens/parner/partner%20profile%20page/partner_profile_page.dart';
import 'package:desi_shopping_seller/screens/parner/partner%20profile/partner_products_page.dart';
import 'package:desi_shopping_seller/screens/parner/recharge%20request%20screen/partner_recharge_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerBottomNav extends StatefulWidget {
  const PartnerBottomNav({super.key});

  @override
  State<PartnerBottomNav> createState() => _PartnerBottomNavState();
}

class _PartnerBottomNavState extends State<PartnerBottomNav> {
  int _currentIndex = 0;
  List<String> titles = ['Home', 'Products', "Recharge", 'Profile'];
  List<Widget> pages = [
    const PartnerDashboard(),
    const PartnerProductsPage(),
    const PartnerRechargeRequestScreen(),
    const PartnerProfilePage(),
  ];
  List<IconData> icons = [
    Icons.home,
    Icons.shopping_bag,
    Icons.receipt_sharp,
    Icons.person,
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final partnerProvider = Provider.of<PartnerProvider>(context);
    final status = partnerProvider.partner?.activeStatus;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (int index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: List.generate(
          titles.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: titles[index],
          ),
        ),
      ),
      body: status == "inactive"
          ? SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(
                child: Text(
                  "You don't have access until you get verified",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : pages[_currentIndex],
    );
  }
}
