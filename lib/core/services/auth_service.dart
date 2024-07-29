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
      String yemekTuru,
      String yemekIcerigi,
      String fiyat,
      String teslimat,
      String yemeKategori,
      String imageUrl // Add the imageUrl parameter here
      ) async {
    await FirebaseFirestore.instance.collection('Post').add({
      'text': text,
      'fullname': fullname,
      'cinsiyet': cinsiyet,
      'email': email,
      'ilanAciklamasi': ilanAciklamasi,
      'YemekTuru': yemekTuru,
      'YemekIcerigi': yemekIcerigi,
      'Fiyat': fiyat,
      'Teslimat': teslimat,
      'YemeKategori': yemeKategori,
      'link': imageUrl, // Save the imageUrl field
      'timestamp': DateTime.now(),
    });
  }
}
