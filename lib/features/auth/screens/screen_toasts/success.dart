import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_routes.dart';
import 'login_error.dart';

class LoginSuccessView extends StatefulWidget {
  const LoginSuccessView({super.key});

  @override
  State<LoginSuccessView> createState() => _LoginSuccessViewState();
}

class _LoginSuccessViewState extends State<LoginSuccessView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      context.go(AppRoutes.dashboard); // redirect after animation
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseAnimatedStatusView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login Successful",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
          ],
        ),
      ),
    );
  }
}
