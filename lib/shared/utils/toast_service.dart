import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Magnificent Toast Service - Shows beautiful animated toasts
class ToastService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Get the correct ScaffoldMessenger
    final messenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbars
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: _ToastContent(message: message, type: type),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
        padding: EdgeInsets.zero,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  // Convenience methods
  static void success(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.error);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.info);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: ToastType.warning);
}

enum ToastType { success, error, info, warning }

class _ToastContent extends StatelessWidget {
  final String message;
  final ToastType type;

  const _ToastContent({required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getMainColor().withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMainColor() {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF10B981);
      case ToastType.error:
        return const Color(0xFFEF4444);
      case ToastType.warning:
        return const Color(0xFFF59E0B);
      case ToastType.info:
        return const Color(0xFF6366F1);
    }
  }

  List<Color> _getGradientColors() {
    switch (type) {
      case ToastType.success:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case ToastType.error:
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
      case ToastType.warning:
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      case ToastType.info:
        return [const Color(0xFF6366F1), const Color(0xFF4F46E5)];
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ToastType.success:
        return FontAwesomeIcons.check;
      case ToastType.error:
        return FontAwesomeIcons.xmark;
      case ToastType.warning:
        return FontAwesomeIcons.triangleExclamation;
      case ToastType.info:
        return FontAwesomeIcons.circleInfo;
    }
  }
}
