import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double radius;
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.pink,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(radius),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class CustomElevatedButtonWithChild extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final double radius;
  const CustomElevatedButtonWithChild({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Colors.pink,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(radius),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class CustomElevatedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomElevatedOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        side: const BorderSide(color: Colors.blue),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.blue)),
    );
  }
}
