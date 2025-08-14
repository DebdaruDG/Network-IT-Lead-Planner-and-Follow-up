import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../core/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<void> loginWithEmail(String email) async {
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

      // Handle success
      debugPrint('Login response: ${response.data}');
    } catch (e) {
      // Handle error
      debugPrint('Login error: $e');
    }
  }
}
