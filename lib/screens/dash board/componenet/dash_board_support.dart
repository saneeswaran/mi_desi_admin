import 'package:flutter/material.dart';

final List<String> dashBoardItems = [
  'Today Orders',
  'Total Pending Orders',
  'Today Total Orders',
  'Today Delivery',
  'Total Orders',
  "Total Pending",
  "Total Delivery",
  "Total Cancelled",
  "Total Products",
  "Total Brands",
  "Total Customers",
];

List<Color> generateColors(int count) {
  return List.generate(count, (index) {
    final hue = (360 / count) * index;
    return HSVColor.fromAHSV(1, hue, 0.5, 0.9).toColor();
  });
}
