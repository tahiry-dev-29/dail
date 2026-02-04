import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  // Navigation
  static IconData home(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.house,
    Icons.home_rounded,
    Icons.home_outlined,
    CupertinoIcons.home,
  );

  static IconData planner(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.barsStaggered,
    Icons.list_alt_rounded,
    Icons.format_list_bulleted_rounded,
    CupertinoIcons.list_bullet,
  );

  static IconData calendar(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.calendarDays,
    Icons.calendar_month_rounded,
    Icons.calendar_today_outlined,
    CupertinoIcons.calendar,
  );

  static IconData assistant(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.wandMagicSparkles,
    Icons.auto_awesome_rounded,
    Icons.assistant_rounded,
    CupertinoIcons.sparkles,
  );

  // General UI
  static IconData clock(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.clock,
    Icons.access_time_rounded,
    Icons.access_time,
    CupertinoIcons.clock,
  );

  static IconData bell(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.bell,
    Icons.notifications_rounded,
    Icons.notifications_outlined,
    CupertinoIcons.bell,
  );

  static IconData user(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.user,
    Icons.person_rounded,
    Icons.person_outline,
    CupertinoIcons.person,
  );

  static IconData refresh(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.arrowsRotate,
    Icons.refresh_rounded,
    Icons.refresh,
    CupertinoIcons.refresh,
  );

  static IconData search(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.magnifyingGlass,
    Icons.search_rounded,
    Icons.search,
    CupertinoIcons.search,
  );

  static IconData arrowLeft(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.arrowLeft,
    Icons.arrow_back_rounded,
    Icons.arrow_back,
    CupertinoIcons.arrow_left,
  );

  static IconData arrowRight(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.arrowRight,
    Icons.arrow_forward_rounded,
    Icons.arrow_forward,
    CupertinoIcons.arrow_right,
  );

  static IconData logout(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.arrowRightFromBracket,
    Icons.logout_rounded,
    Icons.logout,
    CupertinoIcons.square_arrow_right,
  );

  // Status & Alerts
  static IconData checkDouble(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.checkDouble,
    Icons.done_all_rounded,
    Icons.done_all,
    CupertinoIcons.checkmark_alt_circle,
  );

  static IconData circleCheck(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.circleCheck,
    Icons.check_circle_rounded,
    Icons.check_circle_outline,
    CupertinoIcons.checkmark_circle,
  );

  static IconData circleExclamation(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.circleExclamation,
    Icons.error_rounded,
    Icons.error_outline,
    CupertinoIcons.exclamationmark_circle,
  );

  static IconData triangleExclamation(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.triangleExclamation,
    Icons.warning_rounded,
    Icons.warning_amber_rounded,
    CupertinoIcons.exclamationmark_triangle,
  );

  static IconData bolt(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.bolt,
    Icons.bolt_rounded,
    Icons.bolt,
    CupertinoIcons.bolt,
  );

  static IconData description(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.alignLeft,
    Icons.notes_rounded,
    Icons.description,
    CupertinoIcons.text_alignleft,
  );

  static IconData priority(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.flag,
    Icons.flag_rounded,
    Icons.flag_outlined,
    CupertinoIcons.flag,
  );

  // Settings & Features
  static IconData palette(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.palette,
    Icons.palette_rounded,
    Icons.palette_outlined,
    CupertinoIcons.paintbrush,
  );

  static IconData calendarCheck(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.calendarCheck,
    Icons.event_available_rounded,
    Icons.event_available,
    CupertinoIcons.calendar_badge_plus,
  );

  static IconData circleQuestion(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.circleQuestion,
    Icons.help_outline_rounded,
    Icons.help_outline,
    CupertinoIcons.question_circle,
  );

  static IconData volume(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.volumeHigh,
    Icons.volume_up_rounded,
    Icons.volume_up,
    CupertinoIcons.volume_up,
  );

  // Pro / Gamification
  static IconData gem(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.gem,
    Icons.diamond_rounded,
    Icons.diamond_outlined,
    CupertinoIcons.suit_diamond,
  );

  static IconData trophy(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.trophy,
    Icons.emoji_events_rounded,
    Icons.emoji_events_outlined,
    CupertinoIcons
        .game_controller, // Trophy not standard in Cupertino, using game/star
  );

  static IconData chart(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.chartLine,
    Icons.show_chart_rounded,
    Icons.show_chart,
    CupertinoIcons.graph_circle,
  );

  // Actions match original location
  static IconData settings(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.gear,
    Icons.settings_rounded,
    Icons.settings_outlined,
    CupertinoIcons.settings,
  );

  static IconData add(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.plus,
    Icons.add_rounded,
    Icons.add,
    CupertinoIcons.add,
  );

  static IconData favorite(BuildContext context, bool active) => active
      ? _wrap(
          context,
          FontAwesomeIcons.solidHeart,
          Icons.favorite_rounded,
          Icons.favorite,
          CupertinoIcons.heart_fill,
        )
      : _wrap(
          context,
          FontAwesomeIcons.heart,
          Icons.favorite_outline_rounded,
          Icons.favorite_border_rounded,
          CupertinoIcons.heart,
        );

  static IconData delete(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.trash,
    Icons.delete_rounded,
    Icons.delete_outline_rounded,
    CupertinoIcons.trash,
  );

  static IconData promote(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.arrowUpFromBracket,
    Icons.publish_rounded,
    Icons.upgrade_rounded,
    CupertinoIcons.arrow_up_to_line,
  );

  static IconData view(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.eye,
    Icons.visibility_rounded,
    Icons.visibility_outlined,
    CupertinoIcons.eye,
  );

  static IconData check(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.check,
    Icons.check_rounded,
    Icons.done,
    CupertinoIcons.check_mark,
  );

  static IconData xmark(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.xmark,
    Icons.close_rounded,
    Icons.close,
    CupertinoIcons.clear,
  );

  // Arrows & Navigation
  static IconData chevronLeft(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.chevronLeft,
    Icons.chevron_left_rounded,
    Icons.chevron_left,
    CupertinoIcons.left_chevron,
  );

  static IconData chevronRight(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.chevronRight,
    Icons.chevron_right_rounded,
    Icons.chevron_right,
    CupertinoIcons.right_chevron,
  );

  static IconData chevronUp(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.chevronUp,
    Icons.keyboard_arrow_up_rounded,
    Icons.keyboard_arrow_up,
    CupertinoIcons.chevron_up,
  );

  static IconData chevronDown(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.chevronDown,
    Icons.keyboard_arrow_down_rounded,
    Icons.keyboard_arrow_down,
    CupertinoIcons.chevron_down,
  );

  static IconData caretDown(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.caretDown,
    Icons.arrow_drop_down_rounded,
    Icons.arrow_drop_down,
    CupertinoIcons
        .arrow_down, // or caret_down if available, arrow_down is close
  );

  // UI Elements
  static IconData dragHandle(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.gripVertical,
    Icons.drag_indicator_rounded,
    Icons.drag_handle,
    CupertinoIcons.line_horizontal_3,
  );

  static IconData send(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.paperPlane,
    Icons.send_rounded,
    Icons.send,
    CupertinoIcons.paperplane_fill,
  );

  static IconData close(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.xmark,
    Icons.close_rounded,
    Icons.close,
    CupertinoIcons.xmark,
  );

  static IconData solidCircle(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.solidCircle,
    Icons.circle,
    Icons.circle,
    CupertinoIcons.circle_fill,
  );

  static IconData robot(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.robot,
    Icons.smart_toy_rounded,
    Icons.smart_toy_outlined,
    CupertinoIcons.sparkles,
  );

  static IconData listCheck(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.listCheck,
    Icons.checklist_rounded,
    Icons.checklist,
    CupertinoIcons.list_bullet_below_rectangle,
  );

  static IconData mobile(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.mobile,
    Icons.smartphone_rounded,
    Icons.smartphone,
    CupertinoIcons.device_phone_portrait,
  );

  static IconData moon(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.moon,
    Icons.dark_mode_rounded,
    Icons.dark_mode_outlined,
    CupertinoIcons.moon,
  );

  static IconData sun(BuildContext context) => _wrap(
    context,
    FontAwesomeIcons.sun,
    Icons.light_mode_rounded,
    Icons.light_mode_outlined,
    CupertinoIcons.sun_max,
  );

  // Internal Helper
  static IconData _wrap(
    BuildContext context,
    IconData faIcon,
    IconData materialIcon,
    IconData systemIcon, [
    IconData? cupertinoIcon, // Add optional parameter
  ]) {
    try {
      final style = sl<ThemeViewModel>().iconStyle.peek();
      switch (style) {
        case 'material':
          return materialIcon;
        case 'system':
          return systemIcon;
        case 'cupertino': // Add cupertino case
          return cupertinoIcon ?? systemIcon; // Fallback to system if null
        default:
          return faIcon;
      }
    } catch (_) {
      return faIcon;
    }
  }
}
