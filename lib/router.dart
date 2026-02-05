import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/cells/pages/cell_detail_page.dart';
import 'package:garden_connect/settings/area/page/area_add_edit_page.dart';
import 'package:garden_connect/settings/area/page/area_settings_page.dart';
import 'package:garden_connect/settings/cells/pages/cells_settings_page.dart';
import 'package:garden_connect/settings/cells/views/cell_add_view.dart';
import 'package:garden_connect/settings/cells/views/cell_configure_view.dart';
import 'package:garden_connect/settings/cells/views/cell_pair_pending_view.dart';
import 'package:go_router/go_router.dart';
import 'package:garden_connect/alerts/page/alerts_page.dart';
import 'package:garden_connect/areas/pages/areas_page.dart';
import 'package:garden_connect/auth/auth.dart';
import 'package:garden_connect/dashboard/view/dashboard_page.dart';
import 'package:garden_connect/cells/pages/cells_page.dart';
import 'package:garden_connect/menu/view/menu_page.dart';
import 'package:garden_connect/settings/dashboard/page/settings_page.dart';
import 'package:garden_connect/settings/users/bloc/users_bloc.dart';
import 'package:garden_connect/settings/users/page/users_page.dart';

import 'alerts/bloc/alert_bloc.dart';
import 'analytics/bloc/analytics_bloc.dart';
import 'areas/bloc/area_bloc.dart';

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
            child: MultiBlocProvider(
              providers: [
                BlocProvider<AnalyticsBloc>(
                  create: (context) => AnalyticsBloc(),
                ),
                BlocProvider<AreaBloc>(create: (context) => AreaBloc()),
                BlocProvider<CellBloc>(create: (context) => CellBloc()),
                BlocProvider<AlertBloc>(create: (context) => AlertBloc()),
              ],
              child: MenuPage(child: child),
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(child: const DashboardPage()),
          ),
          GoRoute(
            path: '/areas',
            pageBuilder:
                (context, state) => NoTransitionPage(child: const AreasPage()),
            routes: [
              GoRoute(
                path: 'cells/:id',
                pageBuilder: (context, GoRouterState state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return NoTransitionPage(
                    child: BlocProvider(
                      create:
                          (context) => CellBloc()..add(LoadCellDetail(id: id)),
                      child: CellDetailPage(id: id, isFromAreaPage: true),
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/cells',
            pageBuilder:
                (context, state) => NoTransitionPage(child: const CellsPage()),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, GoRouterState state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return NoTransitionPage(
                    child: BlocProvider(
                      create:
                          (context) => CellBloc()..add(LoadCellDetail(id: id)),
                      child: CellDetailPage(id: id),
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/alerts',
            pageBuilder:
                (context, state) => NoTransitionPage(child: const AlertsPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const SettingsPage(),
            ),
          ),
          GoRoute(
            path: '/settings/users',
            pageBuilder: (context, state) => NoTransitionPage(
              child:
                   BlocProvider(
                    create: (context) => UsersBloc(),
               child:
               UsersPage(),)
            ),
          ),
          GoRoute(
            path: '/settings/areas',
            pageBuilder: (context, state) => NoTransitionPage(child: const AreaSettingsPage()),
            routes: [
              GoRoute(
                path: '/areas',
                builder: (context, state) => const AreaSettingsPage(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AreaAddEditPage(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, GoRouterState state) {
                      final viewMode =
                          state.uri.queryParameters['view'] == 'true';
                      return AreaAddEditPage(
                        id: int.parse(state.pathParameters['id']!),
                        isViewMode: viewMode,
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/cells',
                pageBuilder:
                    (context, state) =>
                        NoTransitionPage(child: const CellsSettingsPage()),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder:
                        (context, state) =>
                            NoTransitionPage(child: const CellAddView()),
                    routes: [
                      GoRoute(
                        path: 'pairing',
                        pageBuilder:
                            (context, state) => NoTransitionPage(
                              child: const CellPairPendingView(),
                            ),
                        routes: [
                          GoRoute(
                            path: 'configure',
                            pageBuilder:
                                (context, state) => NoTransitionPage(
                                  child: const CellConfigureView(),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
