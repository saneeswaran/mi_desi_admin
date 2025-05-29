import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:desi_shopping_seller/model/product_model.dart';
import 'package:flutter/material.dart';

class ViewProducts extends StatelessWidget {
  final ProductModel product;
  const ViewProducts({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    List<Widget>? getCarouselItems() {
      final item = product.imageUrl
          .map((e) => CachedNetworkImage(imageUrl: e))
          .toList();
      return item;
    }

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.40,
            width: size.width * 1,
            child: CarouselSlider(
              items: getCarouselItems(),
              options: CarouselOptions(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(size.width * 0.02),
            child: const Column(children: [
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
