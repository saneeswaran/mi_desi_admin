import 'package:desi_shopping_seller/screens/admin/drawer/components/drawer_item_tile.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/components/log_out_tile.dart';
import 'package:desi_shopping_seller/screens/admin/drawer/model/drawer_items.dart';
import 'package:flutter/material.dart';

class DrawerMenuList extends StatelessWidget {
  const DrawerMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: drawerItemsList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = drawerItemsList[index];
            return DrawerItemTile(item: item);
          },
        ),
        const LogoutTile(),
      ],
    );
  }
}
