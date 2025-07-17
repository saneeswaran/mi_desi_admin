import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/user_provider.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCustomersList extends StatefulWidget {
  const AllCustomersList({super.key});

  @override
  State<AllCustomersList> createState() => _AllCustomersListState();
}

class _AllCustomersListState extends State<AllCustomersList> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      context.read<UserProvider>().getAllUserAddress(context: context),
    ]);
  }

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
                return ListTile(
                  title: Text(customer.name),
                  onTap: () {
                    provider.filterUserAddressById(
                      query: customer.uid.toString(),
                    );
                    final address = provider.filterUserAddress;
                    normalDialog(
                      context: context,
                      title: "Customer Details",
                      size: size,
                      height: size.height * 0.5,
                      width: size.width * 1,
                      widget: Column(
                        children: [
                          Text("Name: ${customer.name}"),
                          Text("Email: ${customer.email}"),
                          address.isEmpty
                              ? const Text("No Saved Address")
                              : Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final addr = address[index];
                                      return Container(
                                        height: size.height * 0.20,
                                        width: size.width * 1,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.pink,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text("Address: ${addr.address}"),
                                            Text("Pincode: ${addr.pincode}"),
                                            Text("Phone: ${addr.pincode}"),
                                            Text("Latitude: ${addr.latitude}"),
                                            Text(
                                              "Longitude: ${addr.longitude}",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
