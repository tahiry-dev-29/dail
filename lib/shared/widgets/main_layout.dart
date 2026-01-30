import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/ai_chat/presentation/screens/ai_chat_page.dart';
import 'package:daily_os/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:daily_os/features/home/logic/home_signals.dart';
import 'package:daily_os/features/home/presentation/screens/home_screen.dart';
import 'package:daily_os/features/planner/logic/task_input_provider.dart';
import 'package:daily_os/features/planner/presentation/screens/planner_dashboard_screen.dart';
import 'package:daily_os/features/settings/logic/theme_provider.dart';
import 'package:daily_os/shared/widgets/atomic_header.dart';
import 'package:daily_os/shared/widgets/atomic_nav_bar.dart';
import 'package:daily_os/shared/widgets/floating_add_task_button.dart';
import 'package:daily_os/shared/widgets/safe_back_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final current = currentTab.watch(context);

    return SafeBackHandler(
      onBack: () {
        if (isAddTaskVisible.value) {
          isAddTaskVisible.value = false;
          return;
        }
        if (current != 0) {
          switchTab(0);
          return;
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: GlassScaffold(
          body: Stack(
            children: [
              NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  final direction = notification.direction;
                  if (direction == ScrollDirection.reverse) {
                    if (isNavBarVisible.value) isNavBarVisible.value = false;
                  } else if (direction == ScrollDirection.forward) {
                    if (!isNavBarVisible.value) isNavBarVisible.value = true;
                  }
                  return true;
                },
                child: _PageSwitcher(current: current),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Watch(
                  (context) => AnimatedSlide(
                    offset: (isNavBarVisible.value && !isAddTaskVisible.value)
                        ? Offset.zero
                        : const Offset(0, 1.2),
                    duration: getAdaptedDuration(
                      const Duration(milliseconds: 300),
                    ),
                    curve: Curves.easeInOutCubic,
                    child: const AtomicNavBar(),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                right: 16,
                child: Watch(
                  (context) => AnimatedScale(
                    scale: isNavBarVisible.value ? 1.0 : 0.0,
                    duration: getAdaptedDuration(
                      const Duration(milliseconds: 300),
                    ),
                    curve: Curves.easeInOutCubic,
                    child: const FloatingAddTaskButton(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageSwitcher extends StatefulWidget {
  final int current;
  const _PageSwitcher({required this.current});

  @override
  State<_PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<_PageSwitcher> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.current);
  }

  @override
  void didUpdateWidget(_PageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.current != _pageController.page?.round()) {
      _pageController.animateToPage(
        widget.current,
        duration: getAdaptedDuration(const Duration(milliseconds: 400)),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.current != AppTabs.aiChat.index) const AtomicHeader(),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (index != currentTab.value) {
                switchTab(index);
              }
            },
            physics: const BouncingScrollPhysics(),
            children: const [
              HomeScreen(),
              PlannerDashboardScreen(),
              CalendarScreen(),
              AiChatPage(),
            ],
          ),
        ),
      ],
    );
  }
}
