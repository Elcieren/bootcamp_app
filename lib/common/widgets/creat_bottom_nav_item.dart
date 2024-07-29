import 'package:bootcamp_app/ui/home_page.dart';
import 'package:bootcamp_app/ui/post_page.dart';
import 'package:bootcamp_app/ui/profil/profil_view.dart';
import 'package:bootcamp_app/ui/yapayzeka/yapay_zeka_view.dart';
import 'package:flutter/material.dart';

class TabItemData {
  String title;
  Widget icon;
  TabItemData({
    required this.title,
    required this.icon,
  });
  static Map<TabItem, TabItemData> tabs = {
    TabItem.Plant: TabItemData(
      title: "Menuler",
      icon: Icon(Icons.fastfood, color: Color(0xffFAB703)),
    ),
    TabItem.Help: TabItemData(
      title: "İşletmeler",
      icon: Icon(
        Icons.home,
        color: Color(0xffFAB703),
      ),
    ),
    /* TabItem.Post: TabItemData(
      title: "Paylaşım",
      icon: Icon(Icons.add_circle, color: Color(0xffFAB703)),
    ), */
    TabItem.YapayZeka: TabItemData(
      title: "Yapay Zeka",
      icon: Icon(Icons.question_answer, color: Color(0xffFAB703)),
    ),
    TabItem.Profil: TabItemData(
      title: "Profil",
      icon: Icon(Icons.people, color: Color(0xffFAB703)),
    ),
  };
}

BottomNavigationBarItem createNavItem(TabItem tabItem) {
  final currentTab = TabItemData.tabs[tabItem]!;
  return BottomNavigationBarItem(
    icon: currentTab.icon,
    label: currentTab.title,
  );
}

enum TabItem { Profil, Plant, Help, YapayZeka }

Widget getViewForIndex(int index) {
  switch (index) {
    case 0:
      return PostPage();
    case 1:
      return HomePage();
    case 2:
      return YapayZekaView();
    case 3:
      return ProfilView();

    default:
      return Container();
  }
}
