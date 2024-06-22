import 'package:bootcamp_app/app/app_base_view_model.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends AppbaseViewModel {
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  init() {}

  void setTabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }
}
