import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/ai_chat/views/screens/ai_chat_page.dart';
import 'package:daily_os/features/calendar/views/screens/calendar_screen.dart';
import 'package:daily_os/features/home/views/screens/home_screen.dart';
import 'package:daily_os/features/home/views/bloc/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/views/widgets/sidebar/sidebar.dart';
import 'package:daily_os/features/planner/views/widgets/task_form/quick_add_task_overlay.dart';
import 'package:daily_os/features/planner/views/screens/workspace_screen.dart';
import 'package:daily_os/features/settings/views/bloc/theme_view_model.dart';
import 'package:daily_os/design_system/organisms/atomic_header.dart';
import 'package:daily_os/design_system/organisms/atomic_nav_bar.dart';
import 'package:daily_os/design_system/organisms/floating_action_menu.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Main application layout — bootstrap data loading happens in
/// [injection_container.dart] via [bootstrapAppData].
class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = sl<HomeViewModel>();
    final current = homeVM.currentTab.watch(context);

    return Stack(
      children: [
        GlassScaffold(
          drawer: const KnowledgeBaseSidebar(),
          body: _PageSwitcher(current: current),
          extendBody: true,
          bottomNavigationBar: const AtomicNavBar(),
          floatingActionButton: const FloatingActionMenu(),
        ),
        const QuickAddTaskOverlay(),
      ],
    );
  }
}

class _PageSwitcher extends StatefulWidget {
  final int current;
  const _PageSwitcher({required this.current});

  @override
  State<_PageSwitcher> createState() => _PageSwitcherState();
}

/// Surgical StatefulWidget: PageController requires dispose().
/// This is the ONLY exception — controllers need lifecycle management.
class _PageSwitcherState extends State<_PageSwitcher> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.current);
  }

  @override
  void didUpdateWidget(covariant _PageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.current != oldWidget.current &&
        _pageController.hasClients &&
        widget.current != _pageController.page?.round()) {
      _pageController.animateToPage(
        widget.current,
        duration: sl<ThemeViewModel>().getAdaptedDuration(
          const Duration(milliseconds: 400),
        ),
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
    final homeVM = sl<HomeViewModel>();

    return Column(
      children: [
        if (widget.current != 3) const AtomicHeader(),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              if (index != homeVM.currentTab.value) {
                homeVM.switchTab(index);
              }
            },
            physics: const BouncingScrollPhysics(),
            children: const [
              HomeScreen(),
              WorkspaceScreen(),
              CalendarScreen(),
              AiChatPage(),
            ],
          ),
        ),
      ],
    );
  }
}
