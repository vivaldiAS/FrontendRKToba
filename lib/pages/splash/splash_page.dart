import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/pesanan_controller.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';

import '../../controllers/alamat_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/bank_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/popular_produk_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void init() async {
    Future.delayed(Duration(seconds: 3), () async {
      // Ambil produk populer dan keranjang lebih awal
      await Get.find<PopularProdukController>().getPopularProdukList();
      await Get.find<CartController>().getKeranjangList();
      await Get.find<WishlistController>().getWishlistList();
      await Get.find<BankController>().getBankList();

      // Ambil data user terlebih dahulu
      var userController = Get.find<UserController>();
      await userController.getUser();

      // Pastikan usersList tidak kosong sebelum mengambil alamat
      if (userController.usersList.isNotEmpty) {
        await Get.find<AlamatController>().getAlamat();
        await Get.find<AlamatController>().getAlamatUser();
        await Get.find<PesananController>().getPesanan();
        await Get.find<PesananController>().getPesananMenungguBayaranList();
        await Get.find<CartController>().getKeranjangList();
        await Get.find<WishlistController>().getWishlistList();
        await Get.find<BankController>().getBankList();
        await Get.find<AlamatController>().getAlamatToko();
      } else {
        print("Error: usersList masih kosong setelah pemanggilan getUser().");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularProdukController>(
      builder: (_) {
        return GetBuilder<CartController>(builder: (_) {
          return GetBuilder<WishlistController>(builder: (_) {
            return InitialSplashScreen();
          });
        });
      },
    );
  }
}

class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({super.key});

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen> {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    if (Platform.isIOS) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }

    await Get.find<PopularProdukController>().getPopularProdukList();
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();

    if (_userLoggedIn) {
      await Get.find<CartController>().getKeranjangList();
      var userController = Get.find<UserController>();
      await userController.getUser();

      if (userController.usersList.isNotEmpty) {
        await Get.find<AlamatController>().getAlamat();
        await Get.find<AlamatController>().getAlamatUser();
        await Get.find<AlamatController>().getAlamatToko();
        await Get.find<PesananController>().getPesanan();
        await Get.find<WishlistController>().getWishlistList();
        await Get.find<BankController>().getBankList();
      } else {
        print("Error: usersList masih kosong setelah getUser() di _loadResource.");
      }
    }

    Timer(Duration(seconds: 2), () => Get.offNamed(RouteHelper.getInitial()));
  }

  @override
  void initState() {
    super.initState();
    _loadResource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo_rkt.png",
              width: Dimensions.splashImg,
            ),
          ),
        ],
      ),
    );
  }
}