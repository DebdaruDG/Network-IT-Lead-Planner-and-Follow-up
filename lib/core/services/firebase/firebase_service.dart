import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../firebase_options.dart';

class FirebaseService {
  // Singleton instance
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _initialized = false;

  // Firebase Initialization
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
  }

  // Firebase Auth instance (lazy getter)
  FirebaseAuth get auth {
    if (!_initialized) {
      throw Exception(
        "Firebase has not been initialized yet. Call initializeFirebase() first.",
      );
    }
    return FirebaseAuth.instance;
  }

  /// Current logged in user
  User? get currentUser => auth.currentUser;

  /// Auth State Changes
  Stream<User?> get authStateChanges => auth.authStateChanges();
}
