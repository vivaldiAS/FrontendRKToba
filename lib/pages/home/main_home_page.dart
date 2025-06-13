import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/pages/home/home_page_body.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/chat/chat_page.dart';

import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../search/search_page.dart';
import '../../widgets/footer_widget.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  void initState() {
    super.initState();
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<CartController>().getKeranjangList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<CartController>().getKeranjangList();
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: Dimensions.height30),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width10), // dikurangi padding agar muat
            child: Row(
              children: [
                // Bagian avatar + nama menggunakan Expanded supaya maksimal pakai ruang
                Expanded(
                  child: GetBuilder<UserController>(builder: (controller) {
                    String userName = controller.usersList.isNotEmpty
                        ? controller.usersList[0].name ?? ''
                        : '';
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 20,
                          child: Icon(
                            Icons.person,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: _userLoggedIn
                              ? Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.getMasukPage()); // Halaman login
                            },
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.redColor, // Anda bisa mengubah warnanya
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(width: Dimensions.width10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => SearchPage(kategori: 'All'));
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.search,
                      color: AppColors.redColor,
                      size: Dimensions.iconSize24,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                GetBuilder<CartController>(builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      if (Get.find<AuthController>().userLoggedIn()) {
                        Get.toNamed(RouteHelper.getKeranjangPage());
                      } else {
                        Get.toNamed(RouteHelper.getMasukPage());
                      }
                    },
                    child: Stack(
                      children: [
                        AppIcon(
                          icon: Icons.shopping_cart_outlined,
                          size: 40.0,
                          iconColor: AppColors.redColor,
                          backgroundColor: Colors.transparent,
                        ),
                        Get.find<AuthController>().userLoggedIn()
                            ? Obx(() => controller.keranjangList.length >= 1
                            ? Positioned(
                          right: 0,
                          top: 0,
                          child: AppIcon(
                            icon: Icons.circle,
                            size: 20,
                            iconColor: AppColors.notification_success,
                          ),
                        )
                            : Container())
                            : SizedBox(),
                        Get.find<AuthController>().userLoggedIn()
                            ? Obx(() => controller.keranjangList.length >= 1
                            ? Positioned(
                          right: 6,
                          top: 3,
                          child: BigText(
                            text: controller.keranjangList.length.toString(),
                            size: 10,
                            color: Colors.white,
                          ),
                        )
                            : Container())
                            : SizedBox(),
                      ],
                    ),
                  );
                }),
                SizedBox(width: Dimensions.width10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ChatPage());
                  },
                  child: AppIcon(
                    icon: Icons.chat,
                    size: 40.0,
                    iconColor: AppColors.redColor,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HomePageBody(),
                  FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
