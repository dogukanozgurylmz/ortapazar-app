import 'package:flutter/material.dart';
import 'package:ortapazar/feature/ortapazar/presentation/create_news/create_news_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../../core/constants/text_style_constant.dart';
import '../home/home_view.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  String navbarTitle = "Ortapazar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: PersistentTabView(
        context,
        screens: screens(),
        items: _navBarItems(),
        navBarStyle: NavBarStyle.style9,
        backgroundColor: const Color(0xff1C6D00),
      ),
    );
  }

  List<Widget> screens() {
    return [
      const HomeView(),
      const CreateNewsView(),
      // const Center(child: Text("YOHTİR")),
      const Center(child: Text("BU DA YOHTİR")),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: ("Ana Sayfa"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
        // onPressed: (context) => navbarTitle = "Ortapazar",
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_rounded),
        title: ("Haber Ekle"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
        // onPressed: (context) => navbarTitle = "Haber Ekle",
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Profil"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white,
        // onPressed: (context) => navbarTitle = "Profil",
      ),
    ];
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        navbarTitle,
        style: TextStyleConstant.APP_BAR_STYLE,
      ),
      toolbarHeight: 45,
      backgroundColor: const Color(0xff1C6D00),
      elevation: 0,
    );
  }

  // AppBar _buildAppBar(BuildContext context) {
  //   return AppBar(
  //     toolbarHeight: 0,
  //     backgroundColor: const Color(0xff1C6D00),
  //     elevation: 0,
  //   );
  // }
}