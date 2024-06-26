import 'package:bootcamp_app/core/services/auth_service.dart';
import 'package:bootcamp_app/ui/Ilan/advert_view_model.dart';
import 'package:bootcamp_app/ui/main/main_view.dart';
import 'package:bootcamp_app/ui/profil/profil_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class AdvertView extends StatefulWidget {
  const AdvertView({super.key});

  @override
  State<AdvertView> createState() => _AdvertViewState();
}

class _AdvertViewState extends State<AdvertView> {
  late String text;
  late String ilanAciklamasi;
  late String YemekTuru;
  List<String> YemeKategorisi = [
    'Vegan',
    'Vejeteryan',
    'Etli',
    'Diyet',
    'Glütensiz'
  ];
  String? YemeKategori;
  late String YemekIcerigi;
  late String Fiyat;
  List<String> TeslimatSekli = [
    'Kendi Teslim Alacak',
    'Kurye teslimatı',
  ];
  String? Teslimat;
  final formkeyPost = GlobalKey<FormState>();
  User? _user;
  Map<String, dynamic>? _userData;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authService = AuthService();
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdvertViewModel>.reactive(
      viewModelBuilder: () => AdvertViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        body: _userData != null
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.6,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.6,
                      decoration: const BoxDecoration(
                        color: Color(0xffFAB703),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(70),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/chef.png",
                          scale: 0.8,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.666,
                        decoration: const BoxDecoration(
                          color: Color(0xffFAB703),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.666,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formkeyPost,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Center(
                                    child: Opacity(
                                      opacity: 0.9,
                                      child: Text(
                                        "Yemeklerinizi pazarlamak ve reklam yapmak için çok az efor sarf ederek uygulamamızda yerinizi alabilirsiniz.Öğle yemekleri ve davetler için rahatlıkla planlama yapabilir, iş gücünüzü verimli kullanabilirsiniz.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 400,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(0.2)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextTextField()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 400,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(0.2)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: IlanAciklamasiField()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 400,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(0.2)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: YemekTuruField()),
                                ),
                                customSizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: YemekKategorisi(),
                                ),
                                customSizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 400,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(0.2)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: YemekIcerigiField()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 400,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(0.2)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: FiyatField()),
                                ),
                                customSizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TeslimatSekl(),
                                ),
                                PostUpButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50.0,
                      left: 16.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MainView()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(
                                  255, 246, 193, 49)), // Buton arka plan rengi
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Buton içerik rengi
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(width: 4),
                            Text(""),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  TextFormField TextTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksizksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        text = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("İlan Başlığınız"),
    );
  }

  TextFormField IlanAciklamasiField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksizksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        ilanAciklamasi = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("İlan Açıklaması"),
    );
  }

  TextFormField YemekTuruField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksizksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        YemekTuru = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("Yemek Türü"),
    );
  }

  Container YemekKategorisi() {
    return Container(
      width: 400,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButton<String>(
          value: YemeKategori,
          onChanged: (String? newValue) {
            setState(() {
              YemeKategori = newValue!;
            });
          },
          style: TextStyle(color: Colors.black),
          underline: SizedBox(),
          hint: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Yemek Kategorisi',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          iconSize: 32,
          isExpanded: true,
          items: YemeKategorisi.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  TextFormField YemekIcerigiField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksizksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        YemekIcerigi = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("Yemek İçeriği"),
    );
  }

  TextFormField FiyatField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksizksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        Fiyat = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("Fiyat"),
    );
  }

  Container TeslimatSekl() {
    return Container(
      width: 400,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButton<String>(
          value: Teslimat,
          onChanged: (String? newValue) {
            setState(() {
              Teslimat = newValue!;
            });
          },
          style: TextStyle(color: Colors.black),
          underline: SizedBox(),
          hint: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Teslimat Türü',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          iconSize: 32,
          isExpanded: true,
          items: TeslimatSekli.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Center PostUpButton() {
    return Center(
      child: TextButton(
        onPressed: Post,
        child: Container(
          height: 50,
          width: 140,
          margin: const EdgeInsets.symmetric(horizontal: 60),
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

  void Post() async {
    if (formkeyPost.currentState!.validate()) {
      formkeyPost.currentState!.save();

      if (YemeKategori == null) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Uyarı"),
              content: Text("Lütfen Yemek Kategorisini seçiniz."),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.pop(context); // Dialog kutusunu kapat
                  },
                ),
              ],
            );
          },
        );
      } else if (Teslimat == null) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Uyarı"),
              content: Text("Lütfen Teslimat Şeklini seçiniz."),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.pop(context); // Dialog kutusunu kapat
                  },
                ),
              ],
            );
          },
        );
      } else {
        await authService.createPost(
            text,
            _userData!['fullname'],
            _userData!['Cinsiyet'],
            _userData!['email'],
            ilanAciklamasi,
            YemekTuru,
            YemekIcerigi,
            Fiyat,
            Teslimat!,
            YemeKategori!);
        formkeyPost.currentState!.reset();
        setState(() {
          YemeKategori = null;
          Teslimat = null;
        });
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Bilgilendirme"),
              content: Text(
                  "İlanınız başarıyla iletildi. Ekibimiz tarafından incelendikten sonra paylaşılacaktır "),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Tamam"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dialog kutusunu kapat
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Hata"),
            content: Text("Üzgünüz, bir hata ile karşılaştık."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog kutusunu kapat
                },
              ),
            ],
          );
        },
      );
    }
  }

  /* void Post() async {
    if (formkeyPost.currentState!.validate()) {
      formkeyPost.currentState!.save();
      await authService.createPost(
        text,
        _userData!['fullname'],
        _userData!['Cinsiyet'],
        _userData!['email'],
        ilanAciklamasi,
        YemekTuru,
        YemekIcerigi,
        Fiyat,
        Teslimat!,
      );
      formkeyPost.currentState!.reset();
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Bilgilendirme"),
            content: Text("Gönderin başarıyla paylaşıldı"),
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
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Hata"),
            content: Text("Üzgünüz Bir hata ile karşılaştık"),
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
  } */

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('Kullanıcılar').doc(_user!.uid).get();
      setState(() {
        _userData = userData.data() as Map<String, dynamic>?; // Dönüşüm işlemi
      });
    }
  }

  InputDecoration customInputDecaration(String hintText) {
    return InputDecoration(hintText: hintText, border: InputBorder.none);
  }

  Widget customSizedBox() => const SizedBox(
        height: 5,
      );
  Widget customSizedBoxLarge() => const SizedBox(
        height: 60,
      );
}
