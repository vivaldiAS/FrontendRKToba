import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rumah_kreatif_toba/pages/account/account_page.dart';
import 'package:rumah_kreatif_toba/pages/home/main_home_page.dart';
import 'package:rumah_kreatif_toba/pages/kategori/kategori_produk.dart';
import 'package:rumah_kreatif_toba/pages/toko/hometoko/hometoko.dart';
import 'package:rumah_kreatif_toba/pages/toko/produk/produk_page.dart';
import 'package:rumah_kreatif_toba/pages/wishlist/wishlist_page.dart';

import '../../../utils/colors.dart';
import '../../pembelian/pembelian_page.dart';
import '../pembelian/pembelian_page.dart';
import '../profil/profiltoko_page.dart';

class HomeTokoPage extends StatefulWidget {
  final int initialIndex; // Add this line

  const HomeTokoPage({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<HomeTokoPage> createState() => _HomeTokoPageState();
}

class _HomeTokoPageState extends State<HomeTokoPage> {
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: widget.initialIndex);
  }


  List<Widget> _buildScreens() {
    return [
      HomeToko(),
      ProdukPage(),
      DaftarPembelianPage(),
      ProfilTokoPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.house_alt),
        title: ("Beranda"),
        activeColorPrimary: AppColors.redColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.cube_box),
        title: ("Produk"),
        activeColorPrimary: AppColors.redColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.doc_text),
        title: ("Pembelian"),
        activeColorPrimary: AppColors.redColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profil"),
        activeColorPrimary: AppColors.redColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
      true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
      true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
      NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }
}
