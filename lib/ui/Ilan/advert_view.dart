import 'package:bootcamp_app/core/services/auth_service.dart';
import 'package:bootcamp_app/ui/Ilan/advert_view_model.dart';
import 'package:bootcamp_app/ui/main/main_view.dart';
import 'package:bootcamp_app/ui/profil/profil_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late String imageUrl;

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
                    Positioned(
                      top: 0,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: Container(
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
                    ),
                    Positioned(
                      bottom: 0,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.4,
                      child: Container(
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
                                        "Yemeklerinizi pazarlamak ve reklam yapmak için çok az efor sarf ederek uygulamamızda yerinizi alabilirsiniz. Öğle yemekleri ve davetler için rahatlıkla planlama yapabilir, iş gücünüzü verimli kullanabilirsiniz.",
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
                                      child:
                                          ImageUrlField()), // Added Image URL field
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
          return "Mesajını Eksiksiz Doldurunuz";
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
          return "Mesajını Eksiksiz Doldurunuz";
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
          return "Mesajını Eksiksiz Doldurunuz";
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
      child: Center(
        child: DropdownButtonFormField<String>(
          value: YemeKategori,
          decoration: customInputDecaration("Yemek Kategorisi"),
          items: YemeKategorisi.map((String kategori) {
            return DropdownMenuItem<String>(
              value: kategori,
              child: Text(kategori),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              YemeKategori = value!;
            });
          },
          onSaved: (value) {
            YemeKategori = value!;
          },
        ),
      ),
    );
  }

  TextFormField YemekIcerigiField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksiksiz Doldurunuz";
        }
      },
      onSaved: (value) {
        YemekIcerigi = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("Yemek İçeriği"),
    );
  }

  TextFormField ImageUrlField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Lütfen bir URL girin";
        } else if (!Uri.parse(value).isAbsolute) {
          return "Geçerli bir URL girin";
        }
      },
      onSaved: (value) {
        imageUrl = value!;
      },
      style: TextStyle(color: Colors.black),
      decoration: customInputDecaration("Resim URL"),
    );
  }

  TextFormField FiyatField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mesajını Eksiksiz Doldurunuz";
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
      child: Center(
        child: DropdownButtonFormField<String>(
          value: Teslimat,
          decoration: customInputDecaration("Teslimat Şekli"),
          items: TeslimatSekli.map((String teslimat) {
            return DropdownMenuItem<String>(
              value: teslimat,
              child: Text(teslimat),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              Teslimat = value!;
            });
          },
          onSaved: (value) {
            Teslimat = value!;
          },
        ),
      ),
    );
  }

  Widget PostUpButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            if (formkeyPost.currentState!.validate()) {
              formkeyPost.currentState!.save();
              final advertData = {
                'ilanBasligi': text,
                'ilanAciklamasi': ilanAciklamasi,
                'YemekTuru': YemekTuru,
                'YemekKategorisi': YemeKategori,
                'YemekIcerigi': YemekIcerigi,
                'imageUrl': imageUrl, // Save the image URL
                'Fiyat': Fiyat,
                'TeslimatSekli': Teslimat,
                'userID': _user!.uid,
                'timestamp': FieldValue.serverTimestamp(),
              };

              await _firestore.collection('ilanlar').add(advertData);
              _showSuccessMessage();
            }
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xffFAB703)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontSize: 18),
            ),
          ),
          child: Text("Paylaş"),
        ),
      ),
    );
  }

  InputDecoration customInputDecaration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black),
      border: InputBorder.none,
    );
  }

  SizedBox customSizedBox() {
    return SizedBox(height: 10);
  }

  void _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _user = user;
        _userData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("İlanınız başarıyla paylaşıldı!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
