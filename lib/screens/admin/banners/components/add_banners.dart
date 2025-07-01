import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/screens/admin/banners/components/product_details_for_banners.dart';
import 'package:flutter/material.dart';

class AddBanners extends StatefulWidget {
  const AddBanners({super.key});

  @override
  State<AddBanners> createState() => _AddBannersState();
}

class _AddBannersState extends State<AddBanners> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Please select a product',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(size.width * 0.03),
          height: size.height * 1,
          width: size.width * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.backgroundImages),
              fit: BoxFit.cover,
            ),
          ),
          child: const Column(
            children: [Expanded(child: ProductDetailsForBanners())],
          ),
        ),
      ),
    );
  }
}
