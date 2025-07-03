import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRechargePage extends StatefulWidget {
  const AddRechargePage({super.key});

  @override
  State<AddRechargePage> createState() => _AddRechargePageState();
}

class _AddRechargePageState extends State<AddRechargePage> {
  final priceController = TextEditingController();
  final dataInfoController = TextEditingController();
  final validityController = TextEditingController();
  String? simProviderName;
  @override
  void dispose() {
    priceController.dispose();
    dataInfoController.dispose();
    validityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rechargeProvider = Provider.of<ReachargesProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Recharge Plan",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: AbsorbPointer(
        absorbing: rechargeProvider.isLoading,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: size.height * 0.02,
                  children: [
                    _simProviderDropDown(),
                    CustomTextFormField(
                      hintText: "Price",
                      controller: priceController,
                    ),
                    CustomTextFormField(
                      hintText: "data info",
                      controller: dataInfoController,
                    ),
                    CustomTextFormField(
                      hintText: "validity",
                      controller: validityController,
                    ),
                    SizedBox(height: size.height * 0.4),
                    SizedBox(
                      height: size.height * 0.08,
                      width: size.width * 1,
                      child: CustomElevatedButton(
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          final bool isSuccess = await rechargeProvider
                              .createRechargePlan(
                                context: context,
                                price: double.parse(priceController.text),
                                dataInfo: dataInfoController.text,
                                validity: validityController.text,
                                rechargeProvider: simProviderName!,
                                status: "Active",
                              );
                          if (isSuccess && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (rechargeProvider.isLoading)
              Container(
                height: size.height * 1,
                width: size.width * 1,
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _simProviderDropDown() {
    return Consumer<RechargeSimProvider>(
      builder: (context, provider, child) {
        final items = provider.allProvider
            .map(
              (e) => DropdownMenuItem(
                value: e.providerName,
                child: Text(e.providerName),
              ),
            )
            .toList();
        return DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: "Select Sim Provider",
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
          items: items,
          onChanged: (value) {
            setState(() {
              simProviderName = value;
            });
          },
        );
      },
    );
  }
}
