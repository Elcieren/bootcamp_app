import 'package:bootcamp_app/app/app_base_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerLazySingleton(() => AppbaseViewModel());
  getIt.registerLazySingleton(() => NavigationService());
}
