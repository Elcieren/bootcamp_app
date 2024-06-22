import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  Future<String?> GirisYap(String email, String sifre) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: sifre);
      res = "basarili";
    } on FirebaseAuthException catch (eror) {}
    return res;
  }
}
