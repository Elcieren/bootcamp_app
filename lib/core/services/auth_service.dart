import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFireStore = FirebaseFirestore.instance;

  Future<String?> GirisYap(String email, String sifre) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: sifre);
      res = "basarili";
    } on FirebaseAuthException catch (eror) {}
    return res;
  }

  Future<String?> Register(String email, String password, String fullname,
      String cinsiyet, String durum) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      try {
        final resultData = await firebaseFireStore
            .collection("Kullanıcılar")
            .doc(result.user!.uid)
            .set({
          "email": email,
          "fullname": fullname,
          "Cinsiyet": cinsiyet,
          "Durum": durum
        });
      } catch (e) {
        print("$e");
      }
      res = "basarili";
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<String?> forgotPassword(String email) async {
    String? res;
    try {
      final result = await firebaseAuth.sendPasswordResetEmail(email: email);
      res = "success";
      print("Email Kontrol Ediniz");
    } catch (e) {
      print("email unuttum kısmında hata var");
    }
    return res;
  }

  Future signOutAccount() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> createPost(
      String text,
      String fullname,
      String cinsiyet,
      String email,
      String ilanAciklamasi,
      String YemekTuru,
      String YemekIcerigi,
      String Fiyat,
      String TeslimatSekli) async {
    try {
      await firebaseFireStore.collection('Post').add({
        'text': text,
        'username': fullname,
        'cinsiyet': cinsiyet,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
        'ilanAciklamasi': ilanAciklamasi,
        'YemekTuru': YemekTuru,
        'YemekIcerigi': YemekIcerigi,
        'Fiyat': Fiyat,
        'Teslimat': TeslimatSekli,
      });
      print('Post başarıyla oluşturuldu.');
    } catch (e) {
      print('Post oluşturulurken bir hata oluştu: $e');
    }
  }
}
