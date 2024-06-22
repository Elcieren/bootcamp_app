import 'package:bootcamp_app/app/app.router.dart';
import 'package:bootcamp_app/core/services/auth_service.dart';
import 'package:bootcamp_app/ui/login/login_view_model.dart';
import 'package:bootcamp_app/ui/main/main_view.dart';
import 'package:bootcamp_app/ui/register/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late String email;
  late String password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();
  bool isPasswordVisible = true;
  bool init = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel, child) => Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/den2.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hoş Geldin \nYemek Seçimine \nHazır mısın?",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Opacity(
                                  opacity: 1, // Şeffaflık değeri
                                  child: Text(
                                    'Henüz bir hesabınız yok mu?',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterView()),
                                      );
                                    },
                                    child: const Text(
                                      "Hesap Oluştur ",
                                      style: TextStyle(
                                          color: Color(0xffFAB703),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xffFAB703)),
                                    )),
                              ],
                            ),
                            Container(
                                width: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.withOpacity(0.2)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: emailTextField()),
                            customSizedBox(),
                            Container(
                                width: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.withOpacity(0.2)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: passwordTextField()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    viewModel.navigationService
                                        .navigateTo(Routes.forgotPasswordView);
                                  },
                                  child: const Text(
                                    "Şifremi unuttum ",
                                    style: TextStyle(
                                        color: Color(0xffFAB703),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            signUpButton(),
                            customSizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: Color(0xffFAB703),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "veya bunlarla giriş yapın",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xffFAB703),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 1,
                                  color: Color(0xffFAB703),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      customSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {},
                            child: Image.asset(
                              "assets/google.jpg",
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Image.asset(
                              "assets/person11.png",
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: signIn,
        child: Container(
          height: 50,
          width: 140,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xffFAB703)),
          child: Center(
              child: Text(
            "Giris Yap",
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final result = await authService.GirisYap(email, password);
      if (result == "basarili") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainView()),
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Hata"),
              content: Text("Email yada Şifre Yanlış"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dialog kutusunu kapatır
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  TextFormField passwordTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Şifreyi Eksiksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: isPasswordVisible,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          hintText: "Şifre",
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          )),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email Eksiksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        email = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("Email"),
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 10,
      );
  InputDecoration customInputDecaration(String hintText) {
    return InputDecoration(hintText: hintText, border: InputBorder.none);
  }
}
