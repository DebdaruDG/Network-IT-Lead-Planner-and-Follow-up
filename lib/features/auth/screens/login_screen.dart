import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../../core/config/app_routes.dart';
import '../../../core/widgets/auth_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF001BCE); // Exact blue from design

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // LEFT SECTION
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'Images/logo.png',
                      width: 250,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // RIGHT SECTION
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Lead Follow Up Planner",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),

                        // Google Sign-in Button
                        SignInButton(
                          Buttons.google,
                          text: "Sign in with Google",
                          onPressed: () => context.go(AppRoutes.dashboard),
                          elevation: 0, // flat look
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: const BorderSide(
                              color: Color(0xFFDADCE0), // light grey border
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("or sign in with Email"),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        AuthTextField(
                          label: "Email",
                          hintText: "mail@website.com",
                          isRequired: true,
                        ),
                        const SizedBox(height: 15),
                        AuthTextField(
                          label: "Password",
                          hintText: "Min. 8 character",
                          isRequired: true,
                          obscureText: true,
                        ),

                        const SizedBox(height: 10),

                        // Remember me + Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(value: true, onChanged: (v) {}),
                                const Text("Remember me"),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(color: primaryBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => context.go(AppRoutes.dashboard),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Create Account Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Not registered yet? "),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Create an Account",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
