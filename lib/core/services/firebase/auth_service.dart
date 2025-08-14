import 'dart:developer' as console;
import 'package:firebase_auth/firebase_auth.dart';
import '../api_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();

  /// ✅ Google Sign-In using Firebase
  Future<User?> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');

      final userCredential = await _auth.signInWithPopup(googleProvider);
      return userCredential.user;
    } catch (e) {
      console.log("Error signing in with Google: $e");
      return null;
    }
  }

  /// ✅ Email/Password Sign-Up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      console.log("Sign-up error: $e");
      return null;
    }
  }

  /// ✅ Email/Password Sign-In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      console.log("Sign-in error: $e");
      return null;
    }
  }

  /// ✅ Check Access from API (After Sign-In)
  Future<bool> checkAccess(String email) async {
    try {
      final response = await _apiService.get(
        "/users/check-access",
        query: {"email": email},
      );
      return response.data['access'] ?? false;
    } catch (e) {
      console.log("API Check Access Error: $e");
      return false;
    }
  }

  /// ✅ Combined Google Sign-In + API Check
  Future<bool> signInWithGoogleAndCheckAccess() async {
    final user = await signInWithGoogle();
    if (user == null) return false;
    return await checkAccess(user.email!);
  }

  /// ✅ Combined Email/Password Sign-In + API Check
  Future<bool> signInWithEmailAndCheckAccess(
    String email,
    String password,
  ) async {
    final user = await signInWithEmail(email, password);
    if (user == null) return false;
    return await checkAccess(email);
  }

  /// ✅ Sign-Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// ✅ Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
