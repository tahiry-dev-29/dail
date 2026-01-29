import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const SectionTitle({required this.title, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }
}
