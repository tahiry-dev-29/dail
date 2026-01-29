import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatelessWidget {
  final VoidCallback onBack;
  final Color textPrimary;
  final Color textMuted;
  final Color surface;
  const Header({
    required this.onBack,
    required this.textPrimary,
    required this.textMuted,
    required this.surface,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                size: 14,
                color: textMuted,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Apparence',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
