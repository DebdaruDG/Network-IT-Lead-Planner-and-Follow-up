import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/lead_creation/add_lead_screen.dart';
import '../preferences/user_preferences.dart';

class AppRoutes {
  static const dashboard = '/dashboard';
  static const leadCreation = '/lead-creation';
  static const login = '/login';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) async {
    // Check if the current location is the login screen
    final isLoggingIn = state.fullPath == AppRoutes.login;
    // Get the current user
    final user = await UserPreferences.getUser();

    // If no user is found and the user is not on the login screen, redirect to login
    if (user == null && !isLoggingIn) {
      return AppRoutes.login;
    }

    // If user is logged in but trying to access login, redirect to dashboard
    if (user != null && isLoggingIn) {
      return AppRoutes.dashboard;
    }

    // No redirect needed
    return null;
  },
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
