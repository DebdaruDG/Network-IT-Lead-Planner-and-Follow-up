import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/firebase/auth_service.dart';

enum LoginUIState { form, success, error }

class AuthState {
  final bool isLoading;
  final String? error;
  final dynamic data;
  final LoginUIState uiState;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.data,
    this.uiState = LoginUIState.form,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    dynamic data,
    LoginUIState? uiState,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      data: data ?? this.data,
      uiState: uiState ?? this.uiState,
    );
  }
}

/// ViewModel for Auth
class AuthViewModel extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthViewModel(this._apiService) : super(const AuthState());
  final AuthService _authService = AuthService();

  Future<void> loginWithEmail(String email) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      uiState: LoginUIState.form,
    );

    try {
      final response = await _apiService.post(
        'https://o3osprfadl.execute-api.eu-west-2.amazonaws.com/Dev/mvp/user-login',
        data: {"Email": email},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "x-api-key": "oJuPUA89sUd7X7ubswoD8KQKjceoIF72LAZDMPxg",
          },
        ),
      );

      final resData = response.data;

      if (resData != null && resData['Success'] == true) {
        // Show success state
        state = state.copyWith(
          isLoading: false,
          data: resData,
          uiState: LoginUIState.success,
        );
      } else {
        // Show error state
        state = state.copyWith(
          isLoading: false,
          error: resData?['Message'] ?? 'Unknown error occurred',
          uiState: LoginUIState.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        uiState: LoginUIState.error,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      uiState: LoginUIState.form,
    );

    try {
      final hasAccess = await _authService.signInWithGoogleAndCheckAccess();
      if (hasAccess) {
        state = state.copyWith(
          isLoading: false,
          data: {'Success': true, 'Message': 'Google Sign-In Successful'},
          uiState: LoginUIState.success,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Access denied or user not found',
          uiState: LoginUIState.error,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'cancelled-popup-request' ||
          e.code == 'popup-closed-by-user') {
        // just log and return gracefully
        return;
      }
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Google Sign-In failed: $e',
        uiState: LoginUIState.error,
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      data: null,
      uiState: LoginUIState.form,
    );

    try {
      // Run sign-out and minimum delay together
      await Future.wait([
        _authService.signOut(),
        Future.delayed(
          const Duration(milliseconds: 400),
        ), // ensures loader is visible
      ]);

      state = state.copyWith(
        isLoading: false,
        error: null,
        data: null,
        uiState: LoginUIState.form,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sign-out failed: $e',
        uiState: LoginUIState.error,
      );
    }
  }

  void resetUIState() {
    state = state.copyWith(uiState: LoginUIState.form, error: null);
  }
}

/// Riverpod Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ApiService());
});
