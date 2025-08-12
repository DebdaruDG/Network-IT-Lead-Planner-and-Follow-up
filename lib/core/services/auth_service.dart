import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiService _apiService = ApiService();

  Future<bool> signInAndCheckAccess() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return false;

    final response = await _apiService.get(
      "/users/check-access",
      query: {"email": account.email},
    );

    return response.data['access'] ?? false;
  }
}
