import 'package:bootcamp_app/common/widgets/creat_bottom_nav_item.dart';
import 'package:bootcamp_app/core/services/auth_service.dart';
import 'package:bootcamp_app/ui/main/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
        viewModelBuilder: () => MainViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel, child) => Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Color(0xffFAB703),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                createNavItem(TabItem.Plant),
                createNavItem(TabItem.Help),
                createNavItem(TabItem.Post),
                createNavItem(TabItem.YapayZeka),
                createNavItem(TabItem.Profil),
              ],
              onTap: (value) {
                viewModel.setTabIndex(value);
              },
              currentIndex: viewModel.currentTabIndex,
            ),
            body: getViewForIndex(viewModel.currentTabIndex)));
  }
}
