import 'package:bootcamp_app/core/services/auth_service.dart';
import 'package:bootcamp_app/ui/Ilan/advert_view.dart';
import 'package:bootcamp_app/ui/login/login_view.dart';
import 'package:bootcamp_app/ui/profil/profil_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bootcamp_app/ui/BusinessEditPage.dart';
import 'package:bootcamp_app/ui/Ilan/advert_edit.dart';
class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authService = AuthService();
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfilViewModel>.reactive(
      viewModelBuilder: () => ProfilViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: _userData != null
              ? SingleChildScrollView(
            child: Column(
              children: [
                customSizedBoxLarge(),
                CircleAvatar(
                  backgroundColor: Color(0xffFAB703),
                  radius: 70,
                  backgroundImage: AssetImage(
                    _userData!['Cinsiyet'] == 'Erkek'
                        ? "assets/erkek1.png"
                        : "assets/kadın1.png",
                  ),
                ),
                customSizedBox(),
                if (_userData!['Durum'] == 'Kurumsal' ||
                    _userData!['Durum'] == 'Bireysel') ...[
                  Ilan(
                    "İlan",
                    "İlan Paylaşımı",
                    CupertinoIcons.plus_circle,
                    IlanSayafsinaGit,
                  ),
                  customSizedBox(),
                  IlanDuzenlemeButton(), // Add the new button here
                  customSizedBox(),
                  isletmeDuzenlemeButton(), // Add the new button here
                ],
                customSizedBox(),
                itemProfile(
                  "Durum",
                  "${_userData!['Durum']}",
                  CupertinoIcons.person_2,
                ),
                customSizedBox(),
                itemProfile(
                  "Email",
                  "${_userData!['email']}",
                  CupertinoIcons.mail,
                ),
                customSizedBox(),
                itemProfile(
                  "Ad Soyad",
                  "${_userData!['fullname']}",
                  CupertinoIcons.person,
                ),
                customSizedBox(),
                itemProfile(
                  "Cinsiyet",
                  "${_userData!['Cinsiyet']}",
                  CupertinoIcons.check_mark,
                ),
                customSizedBox(),
                itemCikis(
                  "Çıkış",
                  "Oturumu Kapat",
                  Icons.exit_to_app_outlined,
                  signOutAndNavigateToLogin,
                ),
                customSizedBox(),
              ],
            ),
          )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  void signOutAndNavigateToLogin() async {
    await authService.signOutAccount();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

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

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            color: Color(0xff64A6FF).withOpacity(.1),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_back_ios_new),
        tileColor: Colors.white,
      ),
    );
  }

  Widget itemCikis(
      String title, String subtitle, IconData iconData, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                color: Color(0xff64A6FF).withOpacity(.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListTile(
            title: Center(child: Text(title)),
            subtitle: Center(child: Text(subtitle)),
            leading: Icon(iconData),
            tileColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(
    height: 20,
  );

  Widget customSizedBoxLarge() => const SizedBox(
    height: 60,
  );

  Widget Ilan(String title, String subtitle, IconData iconData, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                color: Color(0xff64A6FF).withOpacity(.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListTile(
            title: Center(child: Text(title)),
            subtitle: Center(child: Text(subtitle)),
            leading: Icon(iconData),
            tileColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget IlanDuzenlemeButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdvertEditPage(),
          ),
        );
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                color: Color(0xff64A6FF).withOpacity(.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListTile(
            title: Center(child: Text("İlan Düzenleme")),
            leading: Icon(CupertinoIcons.pencil),
            tileColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget isletmeDuzenlemeButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BusinessEditPage(
              businessId: _userData?['businessId'], // Pass the business ID if available
            ),
          ),
        );
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 5),
                color: Color(0xff64A6FF).withOpacity(.1),
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: ListTile(
            title: Center(child: Text("İşletme Düzenleme")),
            leading: Icon(CupertinoIcons.pencil),
            tileColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void IlanSayafsinaGit() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AdvertView()),
    );
  }
}
