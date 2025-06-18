import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: size.height * 0.01,
            children: [
              SizedBox(height: size.height * 0.02),
              Center(child: CircleAvatar(radius: size.height * 0.12)),
              const Text('Name', style: TextStyle(fontSize: 22)),
              const Text('Email', style: TextStyle(fontSize: 22)),
              const Text('Phone', style: TextStyle(fontSize: 22)),
              const Text('Address', style: TextStyle(fontSize: 22)),
              const Text('City', style: TextStyle(fontSize: 22)),
              const Text('State', style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
