import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfPartners extends StatefulWidget {
  const ListOfPartners({super.key});

  @override
  State<ListOfPartners> createState() => _ListOfPartnersState();
}

class _ListOfPartnersState extends State<ListOfPartners> {
  String? selectedStatus;
  int currentIndex = 0;

  final List<String> filterTypes = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    Future.wait([
      context.read<PartnerProvider>().fetchAllPartners(context: context),
    ]);
    context.read<PartnerProvider>().filterByType(
      query: filterTypes[currentIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _filterButtons(size: size),
            const SizedBox(height: 10),
            Expanded(child: _listOfPartners(size: size)),
          ],
        ),
      ),
    );
  }

  Widget _filterButtons({required Size size}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(filterTypes.length, (index) {
        final isSelected = index == currentIndex;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.35,
            child: Consumer<PartnerProvider>(
              builder: (context, provider, child) {
                return CustomElevatedButton(
                  color: isSelected ? Colors.pink : Colors.grey,
                  onPressed: () {
                    provider.filterByType(query: filterTypes[index]);
                    setState(() => currentIndex = index);
                  },
                  child: Text(
                    filterTypes[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _listOfPartners({required Size size}) {
    return Consumer<PartnerProvider>(
      builder: (context, provider, child) {
        if (provider.filterPartners.isEmpty) {
          return const Center(child: Text("No partners found"));
        }

        return ListView.builder(
          itemCount: provider.filterPartners.length,
          itemBuilder: (context, index) {
            final partner = provider.filterPartners[index];
            return GestureDetector(
              onTap: () {
                normalDialog(
                  context: context,
                  title: "Change Status",
                  size: size,
                  height: size.height * 0.25,
                  width: size.width * 1,
                  widget: Column(
                    spacing: size.height * 0.02,
                    children: [
                      Text("Do you want to change status of ${partner.name}?"),
                      _statusDropDown(),
                      Consumer<PartnerProvider>(
                        builder: (context, provider, child) {
                          final isLoading = provider.isLoading;
                          return CustomElevatedButton(
                            onPressed: () async {
                              final bool isSuccess = await provider
                                  .changePartnerStatus(
                                    context: context,
                                    id: partner.uid,
                                    status: selectedStatus!,
                                  );
                              if (context.mounted && isSuccess) {
                                showSnackBar(
                                  context: context,
                                  e: "Status changed successfully",
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: isLoading
                                ? const Loader()
                                : const Text(
                                    "Change",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.01,
                ),
                child: ListTile(
                  title: Text(partner.name),
                  subtitle: Text(partner.email),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusDropDown() {
    return DropdownButtonFormField(
      value: selectedStatus,
      decoration: InputDecoration(
        labelText: "Change Status",
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
      items: filterTypes
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedStatus = value;
        });
      },
    );
  }
}
