import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/lead_creation/add_lead_screen.dart';

class AppRoutes {
  static const dashboard = '/dashboard';
  static const leadCreation = '/lead-creation';
  static const login = '/login';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.leadCreation,
      builder: (context, state) {
        final leadId = state.uri.queryParameters['leadId'];
        return AddLeadScreen(leadId: leadId);
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
