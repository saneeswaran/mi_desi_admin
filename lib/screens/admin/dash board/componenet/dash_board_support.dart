import 'package:flutter/material.dart';

final List<String> dashBoardItems = [
  'Today\'s Orders',
  'Today\'s Pending Orders',
  'Today\'s Delivered Orders',
  'Today\'s Cancelled Orders',
  'Total Orders',
  'Total Pending Orders',
  'Total Delivered Orders',
  'Total Cancelled Orders',
  'Total Products',
  'Total Brands',
  'Total Customers',
];

List<Color> generateColors(int count) {
  return List.generate(count, (index) {
    final hue = (360 / count) * index;
    return HSVColor.fromAHSV(1, hue, 0.5, 0.9).toColor();
  });
}
