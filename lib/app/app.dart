import 'package:bootcamp_app/ui/login/login_view.dart';
import 'package:bootcamp_app/ui/main/main_view.dart';
import 'package:bootcamp_app/ui/splash/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: MainView),
  ],
)
class App {}
