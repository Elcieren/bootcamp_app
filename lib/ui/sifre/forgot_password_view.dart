import 'package:bootcamp_app/core/services/auth_service.dart';
import 'package:bootcamp_app/ui/login/login_view.dart';
import 'package:bootcamp_app/ui/sifre/forgot_password_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final formkey = GlobalKey<FormState>();
  late String email;
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
        viewModelBuilder: () => ForgotPasswordViewModel(),
        onViewModelReady: (viewModel) => viewModel.initialise(),
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    viewModel.navigationService.back();
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: height * .45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/key1.png"),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  'Merak etmeyin! Bazen böyle olur. \nE-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                              width: 400,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(0.2)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: emailTextField()),
                        ),
                        ForgotPasswordButton()
                      ],
                    )),
              ),
            ));
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
      decoration: customInputDecaration("E-mail"),
    );
  }

  Center ForgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: ForgotPassword,
        child: Container(
          height: 50,
          width: 140,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xffFAB703)),
          child: const Center(
              child: Text(
            "Gönder",
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  void ForgotPassword() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final result = await authService.forgotPassword(email);
      if (result == "success") {
        return showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Bilgilendirme"),
              content: Text("Şifre yenilme linkini yolladık E-mail kontrol et"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginView()),
                    ); // Dialog kutusunu kapatır
                  },
                ),
              ],
            );
          },
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Hata"),
              content: Text("Email Yanlışlık var"),
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

  InputDecoration customInputDecaration(String hintText) {
    return InputDecoration(hintText: hintText, border: InputBorder.none);
  }
}
