import 'dart:developer' as console;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogleWeb() async {
    try {
      // Create Google provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Optionally add scopes
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      googleProvider.setCustomParameters({'prompt': 'select_account'});
      // Trigger the Google Sign-In popup
      UserCredential userCredential = await _auth.signInWithPopup(
        googleProvider,
      );

      return userCredential.user;
    } catch (e) {
      console.log("Error in Google Sign-In Web: $e");
      return null;
    }
  }

  /// ✅ Google Sign-In (Handles Web + Mobile)
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        console.log("Starting Google Sign-In on Web...");
        final googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        final userCredential = await _auth.signInWithPopup(googleProvider);

        console.log("Google Sign-In successful (Web)");
        return userCredential.user;
      } else {
        console.log("Starting Google Sign-In on Mobile...");
        // ✅ Use the named constructor in google_sign_in ^7.x.x
        final googleSignIn = GoogleSignIn.instance;
        final googleUser = await googleSignIn.authenticate();

        final googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.idToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);

        console.log("Google Sign-In successful (Mobile)");
        return userCredential.user;
      }
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

  /// ✅ Check Access from API (After Google Sign-In)
  Future<bool> checkAccess(User user) async {
    try {
      if (user.emailVerified) {
        return true;
      }
      // You can also add custom logic like restricting certain domains:
      // return user.email!.endsWith("@yourcompany.com");
      return true;
    } catch (e) {
      console.log("Error in checkAccess: $e");
      return false;
    }
  }

  /// ✅ Combined Google Sign-In + API Check
  Future<User?> signInWithGoogleAndCheckAccess() async {
    final user = await signInWithGoogleWeb();
    if (user == null) return null;
    console.log('google user - ${user.email}');
    return user;
    // return await checkAccess(user);
  }

  /// ✅ Combined Email/Password Sign-In + API Check
  Future<bool> signInWithEmailAndCheckAccess(
    String email,
    String password,
  ) async {
    final user = await signInWithEmail(email, password);
    if (user == null) return false;
    return await checkAccess(user);
  }

  /// ✅ Sign-Out
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
      console.log("Sign-out successful");
    } catch (e) {
      console.log("Error signing out: $e");
    }
  }

  /// ✅ Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
