import 'package:desi_shopping_seller/model/recharge_model.dart';
import 'package:desi_shopping_seller/providers/reacharge_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRechargePage extends StatefulWidget {
  final RechargeModel rechargeModel;
  const EditRechargePage({super.key, required this.rechargeModel});

  @override
  State<EditRechargePage> createState() => _EditRechargePageState();
}

class _EditRechargePageState extends State<EditRechargePage> {
  final priceController = TextEditingController();
  final dataInfoController = TextEditingController();
  final validityController = TextEditingController();
  String? simProviderName;

  @override
  void initState() {
    super.initState();
    priceController.text = widget.rechargeModel.price.toString();
    dataInfoController.text = widget.rechargeModel.dataInfo.toString();
    validityController.text = widget.rechargeModel.validity.toString();
  }

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
          "Edit Recharge Plan",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
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
              SizedBox(height: size.height * 0.3),
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 1,
                child: Consumer<ReachargesProvider>(
                  builder: (context, provider, child) {
                    final isLoading = provider.delLoading;
                    return CustomElevatedButtonWithChild(
                      color: Colors.red,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      onPressed: () async {
                        final isSuccess = await provider.removePlan(
                          context: context,
                          id: widget.rechargeModel.id.toString(),
                        );
                        if (isSuccess && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 1,
                child: Consumer<ReachargesProvider>(
                  builder: (context, value, child) {
                    final isLoading = value.isLoading;
                    return CustomElevatedButtonWithChild(
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      onPressed: () async {
                        final bool isSuccess = await rechargeProvider
                            .updateRechargePlan(
                              id: widget.rechargeModel.id.toString(),
                              context: context,
                              dataInfo: dataInfoController.text,
                              price: double.parse(priceController.text),
                              rechargeProvider: simProviderName!,
                              validity: validityController.text,
                              status: widget.rechargeModel.status.toString(),
                            );
                        if (isSuccess && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
