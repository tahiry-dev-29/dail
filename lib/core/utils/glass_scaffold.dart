import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GlassScaffold extends StatelessWidget {
  final Widget body;

  const GlassScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF0F4F8), // HTML bg: #f0f4f8
      body: Stack(
        children: [
          // Background - Switch between Image (Dark) and Blob Animation (Light)
          Positioned.fill(
            child: isDark
                ? Image.asset(
                    'assets/images/background.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDarkGradient(),
                  )
                : const _ModernLightBlobs(),
          ),

          // Dark Mode Overlay
          if (isDark)
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),

          // Body
          SafeArea(child: body),
        ],
      ),
    );
  }

  Widget _buildDarkGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _ModernLightBlobs extends StatefulWidget {
  const _ModernLightBlobs();

  @override
  State<_ModernLightBlobs> createState() => _ModernLightBlobsState();
}

class _ModernLightBlobsState extends State<_ModernLightBlobs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Slow breathing
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Subtle movement range
        final move = _controller.value * 20.0;

        return Stack(
          children: [
            // Blob 1: Indigo-100 (Top Left)
            Positioned(
              top: -50 + move,
              left: -50 + move,
              child: _Blob(
                color: const Color(0xFFE0E7FF), // #E0E7FF
                size: 400,
              ),
            ),

            // Blob 2: Teal-100 (Top Right/Mid)
            Positioned(
              top: 150 - move,
              right: -80,
              child: _Blob(
                color: const Color(0xFFCCFBF1), // #CCFBF1
                size: 350,
              ),
            ),

            // Blob 3: Purple-100 (Bottom Left)
            Positioned(
              bottom: -50 + move,
              left: 50,
              child: _Blob(
                color: const Color(0xFFF3E8FF), // #F3E8FF
                size: 300,
              ),
            ),

            // Whole screen blur for smooth blending
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox.expand(),
            ),
          ],
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
