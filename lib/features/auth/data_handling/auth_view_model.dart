import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';

/// States for Auth
class AuthState {
  final bool isLoading;
  final String? error;
  final dynamic data;

  const AuthState({this.isLoading = false, this.error, this.data});

  AuthState copyWith({bool? isLoading, String? error, dynamic data}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

/// ViewModel for Auth
class AuthViewModel extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthViewModel(this._apiService) : super(const AuthState());

  Future<void> loginWithEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

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

      state = state.copyWith(isLoading: false, data: response.data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Riverpod Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(ApiService());
});
