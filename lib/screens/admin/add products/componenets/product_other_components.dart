import 'package:desi_shopping_seller/model/brand_model.dart';
import 'package:desi_shopping_seller/providers/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOtherComponents {
  static Widget brandDropDown({
    required BrandModel selectedBrand,
    required ValueChanged onchanged,
  }) {
    return Consumer<BrandProvider>(
      builder: (_, value, __) {
        final brands = value.allBrands;
        return DropdownButtonFormField<BrandModel>(
          value: selectedBrand,
          items: brands
              .map((e) => DropdownMenuItem(value: e, child: Text(e.title)))
              .toList(),
          onChanged: onchanged,
          validator: (val) => val == null ? 'Please select a brand' : null,
          decoration: InputDecoration(
            labelText: 'Select Brand',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        );
      },
    );
  }

  static Widget cashOnDelivery({required ValueChanged onChanged}) {
    final List<String> options = ['Yes', 'No'];
    final items = options
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList();

    return DropdownButtonFormField<String>(
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: "Cash On Delivery",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
