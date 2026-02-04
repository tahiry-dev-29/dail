import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/ai_chat/presentation/screens/ai_chat_page.dart';
import 'package:daily_os/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:daily_os/features/home/presentation/screens/home_screen.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/knowledge_base_screen.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/presentation/screens/planner_dashboard_screen.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:daily_os/shared/widgets/atomic_header.dart';
import 'package:daily_os/shared/widgets/atomic_nav_bar.dart';
import 'package:daily_os/shared/widgets/floating_add_task_button.dart';
import 'package:daily_os/shared/widgets/safe_back_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MainLayout extends HookWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      // Load initial data for all main features
      Future.microtask(() {
        sl<TaskListViewModel>().loadTasks();
        sl<WorkspaceViewModel>().loadWorkspaces();
      });
      return null;
    }, []);

    final homeVM = sl<HomeViewModel>();
    final current = homeVM.currentTab.watch(context);

    return SafeBackHandler(
      onBack: () {
        if (homeVM.isAddTaskVisible.value) {
          homeVM.isAddTaskVisible.value = false;
          return;
        }
        if (current != 0) {
          homeVM.switchTab(0);
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
                    if (homeVM.isNavBarVisible.value) {
                      homeVM.isNavBarVisible.value = false;
                    }
                  } else if (direction == ScrollDirection.forward) {
                    if (!homeVM.isNavBarVisible.value) {
                      homeVM.isNavBarVisible.value = true;
                    }
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
                    offset:
                        (homeVM.isNavBarVisible.value &&
                            !homeVM.isAddTaskVisible.value)
                        ? Offset.zero
                        : const Offset(0, 1.2),
                    duration: sl<ThemeViewModel>().getAdaptedDuration(
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
                    scale: homeVM.isNavBarVisible.value ? 1.0 : 0.0,
                    duration: sl<ThemeViewModel>().getAdaptedDuration(
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

class _PageSwitcher extends HookWidget {
  final int current;
  const _PageSwitcher({required this.current});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: current);
    final homeVM = sl<HomeViewModel>();

    useEffect(() {
      if (pageController.hasClients &&
          current != pageController.page?.round()) {
        pageController.animateToPage(
          current,
          duration: sl<ThemeViewModel>().getAdaptedDuration(
            const Duration(milliseconds: 400),
          ),
          curve: Curves.easeOutCubic,
        );
      }
      return null;
    }, [current]);

    return Column(
      children: [
        if (current != 4) const AtomicHeader(), // 4 is aiChat index
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              if (index != homeVM.currentTab.value) {
                homeVM.switchTab(index);
              }
            },
            physics: const BouncingScrollPhysics(),
            children: const [
              HomeScreen(),
              PlannerDashboardScreen(),
              CalendarScreen(),
              KnowledgeBaseScreen(),
              AiChatPage(),
            ],
          ),
        ),
      ],
    );
  }
}
