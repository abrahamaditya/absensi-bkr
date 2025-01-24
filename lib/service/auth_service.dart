import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> masuk({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  Future<void> keluar() async {
    await _auth.signOut();
  }

  // Fungsi untuk mendapatkan status autentikasi saat ini
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
