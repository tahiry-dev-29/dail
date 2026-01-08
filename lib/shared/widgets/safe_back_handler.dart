import 'package:flutter/material.dart';

/// Reusable back button handler for Android/iOS
/// Wraps any widget and intercepts back navigation
class SafeBackHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBack;
  final bool canPop;

  const SafeBackHandler({
    super.key,
    required this.child,
    this.onBack,
    this.canPop = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (onBack != null) {
          onBack!();
        } else {
          Navigator.maybePop(context);
        }
      },
      child: child,
    );
  }
}
