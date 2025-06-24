import 'package:desi_shopping_seller/providers/partner_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfPartners extends StatefulWidget {
  const ListOfPartners({super.key});

  @override
  State<ListOfPartners> createState() => _ListOfPartnersState();
}

class _ListOfPartnersState extends State<ListOfPartners> {
  int currentIndex = 0;

  final List<String> filterTypes = ['Active', 'Inactive'];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Partners")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _filterButtons(size: size),
          const SizedBox(height: 10),
          Expanded(child: _listOfPartners(size: size)),
        ],
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
            child: CustomElevatedButton(
              text: filterTypes[index],
              color: isSelected ? Colors.pink : Colors.grey,
              onPressed: () {
                setState(() => currentIndex = index);
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
            return Card(
              margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.01,
              ),
              child: ListTile(
                title: Text(partner.name),
                subtitle: Text(partner.email),
                // trailing: Text(
                //   partner.activeStatus ? "Active" : "Inactive",
                //   style: TextStyle(
                //     color: partner.activeStatus ? Colors.green : Colors.red,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ),
            );
          },
        );
      },
    );
  }
}
