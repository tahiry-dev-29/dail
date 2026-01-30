import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:daily_os/features/settings/presentation/providers/theme_provider.dart';

class AppIcons {
  // Navigation
  static IconData home(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.house,
    Icons.home_rounded,
    Icons.home_outlined,
  );

  static IconData planner(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.barsStaggered,
    Icons.list_alt_rounded,
    Icons.format_list_bulleted_rounded,
  );

  static IconData calendar(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.calendarDays,
    Icons.calendar_month_rounded,
    Icons.calendar_today_outlined,
  );

  static IconData assistant(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.wandMagicSparkles,
    Icons.auto_awesome_rounded,
    Icons.assistant_rounded,
  );

  // Actions
  static IconData settings(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.gear,
    Icons.settings_rounded,
    Icons.settings_outlined,
  );

  static IconData add(BuildContext context) =>
      _wrap(context, FontAwesomeIcons.plus, Icons.add_rounded, Icons.add);

  static IconData favorite(BuildContext context, bool active) => active
      ? _wrap(
          context,
          FontAwesomeIcons.solidHeart,
          Icons.favorite_rounded,
          Icons.favorite,
        )
      : _wrap(
          context,
          FontAwesomeIcons.heart,
          Icons.favorite_outline_rounded,
          Icons.favorite_border_rounded,
        );

  static IconData delete(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.trash,
    Icons.delete_rounded,
    Icons.delete_outline_rounded,
  );

  static IconData check(BuildContext context) =>
      _wrap(context, FontAwesomeIcons.check, Icons.check_rounded, Icons.done);

  static IconData xmark(BuildContext context) =>
      _wrap(context, FontAwesomeIcons.xmark, Icons.close_rounded, Icons.close);

  static IconData _wrap(
    BuildContext context,
    IconData faIcon,
    IconData materialIcon,
    IconData systemIcon,
  ) {
    final style = iconStyleSignal.watch(context);
    switch (style) {
      case 'material':
        return materialIcon;
      case 'system':
        return systemIcon;
      default:
        return faIcon;
    }
  }
}
