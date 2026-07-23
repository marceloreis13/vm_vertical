import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'screen/demo_detail_screen.dart';
import 'screen/demo_home_screen.dart';
import 'screen/demo_profile_screen.dart';
import 'screen/demo_search_screen.dart';

/// Branch 0: a scrolled Home list with a pushed sub-route, mirroring the
/// same "each branch declares its own routes" contract any real module
/// follows (see `route-registration`).
List<RouteBase> demoHomeBranchRoutes() => [
  GoRoute(
    path: '/home',
    builder: (context, state) => const DemoHomeScreen(),
    routes: [
      GoRoute(
        path: 'detail',
        builder: (context, state) => const DemoDetailScreen(),
      ),
    ],
  ),
];

/// Branch 1: a plain Search placeholder.
List<RouteBase> demoSearchBranchRoutes() => [
  GoRoute(
    path: '/search',
    builder: (context, state) => const DemoSearchScreen(),
  ),
];

/// Branch 2: Profile, showing the example's live badge.
List<RouteBase> demoProfileBranchRoutes({GetIt? getIt}) => [
  GoRoute(
    path: '/profile',
    builder: (context, state) => DemoProfileScreen(getIt: getIt),
  ),
];
