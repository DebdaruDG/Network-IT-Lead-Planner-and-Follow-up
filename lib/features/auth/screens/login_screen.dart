import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../../core/utils/animation_constants.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/auth_textfield.dart';
import '../data_handling/auth_view_model.dart';
import 'screen_toasts/fade_scale_transition.dart';
import 'screen_toasts/login_error.dart';
import 'screen_toasts/success.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color primaryBlue = const Color(0xFF001BCE);

  void _handleLogin() async {
    final authNotifier = ref.read(authViewModelProvider.notifier);
    final authState = ref.read(authViewModelProvider);

    if (authState.isLoading) return;

    await authNotifier.loginWithEmail(_emailController.text.trim());

    final updatedAuthState = ref.read(authViewModelProvider);

    if (updatedAuthState.data != null &&
        updatedAuthState.data['Success'] == true) {
      // AppToast.success(
      //   context,
      //   "Login Successful",
      //   subtitle: updatedAuthState.data['Message'],
      // );
    } else if (updatedAuthState.error != null) {
      // AppToast.failure(
      //   context,
      //   "Login Failed",
      //   subtitle: updatedAuthState.error!,
      // );
    } else {
      // AppToast.warning(
      //   context,
      //   "Login Failed",
      //   subtitle: updatedAuthState.data?['Message'] ?? 'Please try again.',
      // );
    }
  }

  void _handleGoogleLogin() async {
    final authNotifier = ref.read(authViewModelProvider.notifier);
    final authState = ref.read(authViewModelProvider);

    if (authState.isLoading) return;

    await authNotifier.loginWithGoogle();

    if (!mounted) return; // Prevent state updates if widget is disposed

    final updatedAuthState = ref.read(authViewModelProvider);

    if (updatedAuthState.data != null &&
        updatedAuthState.data['Success'] == true) {
      // Show success toast
      AppToast.success(
        context,
        "Login Successful",
        subtitle: updatedAuthState.data['Message'],
      );
      // Navigate to the dashboard screen
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (updatedAuthState.error != null) {
      // Show error toast
      AppToast.failure(
        context,
        "Login Failed",
        subtitle: updatedAuthState.error!,
      );
    } else {
      // Show warning toast for unexpected cases
      AppToast.warning(
        context,
        "Login Failed",
        subtitle: updatedAuthState.data?['Message'] ?? 'Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

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
                      'assets/Images/logo.png',
                      // 'Images/logo.png',
                      width: 250,
                      color: Colors.white,
                    ).animate(
                      effects:
                          AnimationEffectConstants
                              .usualAnimationEffects['summaryCardAnimation']
                              ?.effectsBuilder,
                    ),
                  ),
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
                ),
              ),

              // RIGHT SECTION
              Expanded(
                flex: 1,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildRightPanel(authState).animate(
                    effects:
                        AnimationEffectConstants
                            .usualAnimationEffects['summaryCardAnimation']
                            ?.effectsBuilder,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(AuthState authState) {
    if (authState.uiState == LoginUIState.form) {
      return FadeScaleTransitionWrapper(
        key: const ValueKey("login_form"),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  text:
                      authState.isLoading
                          ? "Signing in..."
                          : "Sign in with Google",
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                  onPressed: authState.isLoading ? () {} : _handleGoogleLogin,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Color(0xFFDADCE0)),
                  ),
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 24),
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
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
                  controller: _emailController,
                ),
                const SizedBox(height: 15),

                // Password Field
                AuthTextField(
                  label: "Password",
                  hintText: "Min. 8 characters",
                  isRequired: true,
                  obscureText: true,
                  controller: _passwordController,
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
                    onPressed: authState.isLoading ? () {} : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        if (authState.isLoading) ...[
                          const SizedBox(width: 12),
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
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
      );
    } else if (authState.uiState == LoginUIState.success) {
      return FadeScaleTransitionWrapper(
        key: const ValueKey("success"),
        child: const LoginSuccessView(),
      );
    } else if (authState.uiState == LoginUIState.error) {
      return FadeScaleTransitionWrapper(
        key: const ValueKey("error"),
        child: LoginErrorView(
          onRetry: () {
            final authNotifier = ref.read(authViewModelProvider.notifier);
            authNotifier.resetUIState();
          },
          errorMessage: authState.error ?? '',
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
