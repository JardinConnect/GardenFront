import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_connect/cells/pages/cell_detail_page.dart';
import 'package:go_router/go_router.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/menu/view/menu_page.dart';
import 'package:garden_connect/dashboard/view/dashboard_page.dart';
import 'package:garden_connect/areas/pages/areas_page.dart';
import 'package:garden_connect/cells/pages/cells_page.dart';
import 'package:garden_connect/alerts/page/alerts_page.dart';
import 'package:garden_connect/settings/page/settings_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      ShellRoute(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MenuPage(child: child),
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/areas',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const AreasPage(),
            ),
          ),
          GoRoute(
            path: '/cells',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const CellsPage(),
            ),
            routes: [
              GoRoute(
                path: '/:id',
                pageBuilder: (context, GoRouterState state) => NoTransitionPage(
                  child: CellDetailPage(id: int.parse(state.pathParameters['id']!)),
                )
              )
            ]
          ),
          GoRoute(
            path: '/alerts',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const AlertsPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
