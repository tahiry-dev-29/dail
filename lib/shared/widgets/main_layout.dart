import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/structures/glass_scaffold.dart';
import 'package:daily_os/features/ai_chat/presentation/screens/ai_chat_page.dart';
import 'package:daily_os/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:daily_os/features/home/presentation/screens/home_screen.dart';
import 'package:daily_os/features/home/presentation/state/home_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/components/sidebar/sidebar.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/tag_view_model.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/workspace_view_model.dart';
import 'package:daily_os/features/planner/presentation/screens/workspace_screen.dart';
import 'package:daily_os/features/planner/presentation/state/task_list_view_model.dart';
import 'package:daily_os/features/settings/presentation/state/theme_view_model.dart';
import 'package:daily_os/shared/widgets/atomic_header.dart';
import 'package:daily_os/shared/widgets/atomic_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MainLayout extends HookWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.microtask(() {
        sl<TaskListViewModel>().loadTasks();
        sl<WorkspaceViewModel>().loadWorkspaces();
        sl<TagViewModel>().loadTags();
      });
      return null;
    }, []);

    final homeVM = sl<HomeViewModel>();
    final current = homeVM.currentTab.watch(context);

    // TEST 4: Adding AtomicHeader
    return GlassScaffold(
      drawer: const KnowledgeBaseSidebar(),
      body: _PageSwitcher(current: current),
      extendBody: true,
      bottomNavigationBar: const AtomicNavBar(),
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
        // TEST 4: Adding AtomicHeader here
        if (current != 3) const AtomicHeader(),
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
