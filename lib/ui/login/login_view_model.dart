import 'package:bootcamp_app/app/app.router.dart';
import 'package:bootcamp_app/app/app_base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends AppbaseViewModel {
  init() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (FirebaseAuth.instance.currentUser != null) {
        navigationService.navigateTo(Routes.mainView);
      }
    });
  }
}
