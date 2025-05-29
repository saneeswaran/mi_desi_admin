import 'package:flutter/material.dart';

final List<String> dashBoardItems = [
  'Today Orders',
  'Today Pending Orders',
  'Today Delivery',
  'Today Cancelled',
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
