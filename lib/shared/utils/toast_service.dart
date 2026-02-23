import 'dart:ui';

import 'package:daily_os/design_system/atoms/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToastService {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();
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
        margin: const EdgeInsets.only(
          bottom: 90, // Above navbar (~80px high)
          left: 20,
          right: 20,
        ),
        padding: EdgeInsets.zero,
        dismissDirection: DismissDirection.down,
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
  late final AnimationController _progressController;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black : Colors.white).withValues(
                    alpha: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: _getAccentColor().withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getAccentColor().withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(context),
                              color: _getAccentColor(),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.message,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onClose,
                            icon: Icon(
                              AppIcons.xmark(context),
                              color: isDark ? Colors.white54 : Colors.black45,
                              size: 14,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    // Progress indicator (Sleek line)
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 3,
                          child: FractionallySizedBox(
                            widthFactor: 1.0 - _progressController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getAccentColor().withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAccentColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.greenAccent;
      case ToastType.error:
        return Colors.redAccent;
      case ToastType.warning:
        return Colors.orangeAccent;
      case ToastType.info:
        return Colors.blueAccent;
    }
  }

  IconData _getIcon(BuildContext context) {
    switch (widget.type) {
      case ToastType.success:
        return AppIcons.check(context);
      case ToastType.error:
        return AppIcons.circleExclamation(context);
      case ToastType.warning:
        return AppIcons.triangleExclamation(context);
      case ToastType.info:
        return AppIcons.bolt(context);
    }
  }
}
