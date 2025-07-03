import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCustomersList extends StatelessWidget {
  const AllCustomersList({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.backgroundImages)),
        ),
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            final allCustomers = provider.allUsers;
            return ListView.builder(
              itemCount: allCustomers.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final customer = allCustomers[index];
                return ListTile(title: Text(customer.name));
              },
            );
          },
        ),
      ),
    );
  }
}
