import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../../core/config/app_routes.dart';
import '../../../core/widgets/auth_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF001BCE);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
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
                  padding: const EdgeInsets.fromLTRB(
                    40,
                    20,
                    40,
                    40,
                  ), // Less top, more bottom
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Vertically centered
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          "Lead Follow Up Planner",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Google Sign-in Button
                      SignInButton(
                        Buttons.google,
                        text: "Sign in with Google",
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                        onPressed: () => context.go(AppRoutes.dashboard),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(color: Color(0xFFDADCE0)),
                        ),
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          right: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "or sign in with Email",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Email Field
                      AuthTextField(
                        label: "Email",
                        hintText: "mail@website.com",
                        isRequired: true,
                      ),
                      const SizedBox(height: 15),

                      // Password Field
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
                              Checkbox(
                                value: true,
                                onChanged: (v) {},
                                activeColor: primaryBlue,
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password?",
                              style: GoogleFonts.poppins(
                                color: primaryBlue,
                                fontSize: 13,
                              ),
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
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Create Account Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not registered yet? ",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Create an Account",
                              style: GoogleFonts.poppins(
                                color: primaryBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
