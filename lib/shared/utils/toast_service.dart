import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:daily_os/features/settings/presentation/providers/theme_provider.dart';

class ToastService {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: _ToastContent(
          message: message,
          type: type,
          duration: duration,
          onClose: () => messenger.hideCurrentSnackBar(),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
        padding: EdgeInsets.zero,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

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

class _ToastContent extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onClose;

  const _ToastContent({
    required this.message,
    required this.type,
    required this.duration,
    required this.onClose,
  });

  @override
  State<_ToastContent> createState() => _ToastContentState();
}

class _ToastContentState extends State<_ToastContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: getAdaptedDuration(const Duration(milliseconds: 400)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getGradientColors(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _getMainColor().withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIcon(), color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white70,
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              // Progress indicator
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: 1.0 - _progressController.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.3),
                    ),
                    minHeight: 4,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMainColor() {
    switch (widget.type) {
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
    switch (widget.type) {
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
    switch (widget.type) {
      case ToastType.success:
        return FontAwesomeIcons.check;
      case ToastType.error:
        return FontAwesomeIcons.circleExclamation;
      case ToastType.warning:
        return FontAwesomeIcons.triangleExclamation;
      case ToastType.info:
        return FontAwesomeIcons.bolt;
    }
  }
}
