import 'package:bootcamp_app/app/app.router.dart';
import 'package:bootcamp_app/app/app_base_view_model.dart';
import 'package:bootcamp_app/ui/main/main_view_model.dart';

class SplashViewModel extends AppbaseViewModel {
  init() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      navigationService.navigateTo(Routes.loginView);
    });
  }
}
