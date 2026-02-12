import 'package:daily_os/features/knowledge_base/presentation/screens/page_editor_screen.dart';
import 'package:daily_os/features/knowledge_base/presentation/screens/trash/trash_screen.dart';
import 'package:daily_os/shared/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainLayout()),
      GoRoute(
        path: '/knowledge',
        redirect: (context, state) => '/', // Redirect root knowledge to home
        routes: [
          GoRoute(
            path: 'page/:pageId',
            builder: (context, state) {
              final pageId = state.pathParameters['pageId']!;
              return PageEditorScreen(pageId: pageId);
            },
          ),
          GoRoute(
            path: 'trash',
            builder: (context, state) => const TrashScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
});
