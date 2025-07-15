import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnerProfilePage extends StatelessWidget {
  const PartnerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserDetails = context.read<AuthProviders>().currentUser;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textFormFieldColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textFormFieldColor.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentUserDetails!.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textFormFieldColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentUserDetails.email,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  _buildIndividualCard(
                    context: context,
                    icon: Icons.person,
                    text: 'Change Password',
                    onTap: () {},
                  ),

                  _buildIndividualCard(
                    context: context,
                    icon: Icons.privacy_tip,
                    text: 'Privacy and Policies',
                    onTap: () {},
                  ),

                  _buildIndividualCard(
                    context: context,
                    icon: Icons.logout,
                    text: 'Logout',
                    isLast: true,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndividualCard({
    required BuildContext context,
    required IconData icon,
    required String text,
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textFormFieldColor,
              ),
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
