import 'package:flutter/material.dart';
import 'core/config/app_routes.dart';
// import 'features/dashboard/dashboard_screen.dart'; // uncomment when dashboard is ready

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lead Follow-Up Planner',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF233B7A)),
        fontFamily: 'Inter', // Matches your HTML’s default font
      ),
      routerConfig: appRouter,
    );
  }
}
