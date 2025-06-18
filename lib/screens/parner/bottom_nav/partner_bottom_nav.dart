import 'package:desi_shopping_seller/screens/parner/dashboard/partner_dashboard.dart';
import 'package:desi_shopping_seller/screens/parner/partner%20profile/partner_products_page.dart';
import 'package:flutter/material.dart';

class PartnerBottomNav extends StatefulWidget {
  const PartnerBottomNav({super.key});

  @override
  State<PartnerBottomNav> createState() => _PartnerBottomNavState();
}

class _PartnerBottomNavState extends State<PartnerBottomNav> {
  int _currentIndex = 0;
  List<String> titles = ['Home', 'Products', 'Profile'];
  List<Widget> pages = [
    const PartnerDashboard(),
    const PartnerProductsPage(),
    const PartnerProductsPage(),
  ];
  List<IconData> icons = [Icons.home, Icons.shopping_bag, Icons.person];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: List.generate(
          titles.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: titles[index],
          ),
        ),
      ),
      body: pages[_currentIndex],
    );
  }
}
