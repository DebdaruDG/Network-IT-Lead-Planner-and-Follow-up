import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/lead_creation/add_lead_screen.dart';

/// Named route paths
class AppRoutes {
  static const dashboard = '/';
  static const leadCreation = '/lead-creation';
}

/// GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.leadCreation,
      builder: (context, state) => const AddLeadScreen(),
    ),
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
