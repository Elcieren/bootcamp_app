import 'package:bootcamp_app/core/di/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppbaseViewModel extends BaseViewModel {
  NavigationService navigationService = getIt<NavigationService>();
  initialise() {}
}
