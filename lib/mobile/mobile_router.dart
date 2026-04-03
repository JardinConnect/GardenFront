import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/mobile/users/pages/mobile_profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/mobile/cells/pages/mobile_cell_detail_page.dart';
import 'package:garden_connect/mobile/dashboard/pages/mobile_activity_calendar_page.dart';
import 'package:garden_connect/mobile/dashboard/pages/mobile_home_page.dart';
import 'package:garden_connect/mobile/areas/pages/mobile_area_detail_page.dart';
import 'package:garden_connect/mobile/mobile_home.dart';
import 'package:garden_connect/mobile/pages/mobile_alerts_page.dart';
import 'package:garden_connect/mobile/cells/pages/mobile_cells_page.dart';
import 'package:garden_connect/alerts/bloc/alert_bloc.dart';
import 'package:garden_connect/mobile/alerts/pages/mobile_alert_form_page.dart';

import 'areas/pages/mobile_areas_page.dart';

class MobileAppRouter {
  final AuthBloc authBloc;

  MobileAppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/m/home',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/m/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MobileHome(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/m/home',
                builder: (context, state) => const MobileHomePage(),
                routes: [
                  GoRoute(
                    path: 'calendar',
                    builder:
                        (context, state) =>
                            const MobileActivityCalendarPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/m/areas',
                builder: (context, state) => const MobileAreasPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final extra = state.extra;
                      return MobileAreaDetailPage(
                        areaId: id,
                        initialArea: extra is Area ? extra : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/m/cells',
                builder: (context, state) => const MobileCellsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return NoTransitionPage(
                        child: BlocProvider(
                          create:
                              (context) =>
                                  CellBloc()..add(LoadCellDetail(id: id)),
                          child: MobileCellDetailPage(id: id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (_) => AlertBloc()..add(const AlertLoadData()),
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: '/m/alerts',
                    pageBuilder: (context, state) => const NoTransitionPage(child: MobileAlertsPage()),
                    routes: [
                      GoRoute(
                        path: 'add',
                        pageBuilder: (context, state) => const NoTransitionPage(child: MobileAlertFormPage()),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        pageBuilder: (context, GoRouterState state) {
                          final id = state.pathParameters['id']!;
                          return NoTransitionPage(child: MobileAlertFormPage(alertId: id));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/m/profile',
                builder: (context, state) => const MobileProfilePage(),
              ),
            ],
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
