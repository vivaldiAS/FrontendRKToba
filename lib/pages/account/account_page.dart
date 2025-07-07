  // import 'dart:io';
  import 'package:flutter/foundation.dart' show kIsWeb;
  import 'dart:io' show Platform;
  
  
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:rumah_kreatif_toba/base/confirmation_dialog.dart';
  import 'package:rumah_kreatif_toba/base/custom_loader.dart';
  import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
  import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
  import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
  import 'package:rumah_kreatif_toba/pages/account/account_widget.dart';
  import 'package:rumah_kreatif_toba/pages/account/profil/profil_page.dart';
  import 'package:rumah_kreatif_toba/pages/account/profil/ubah_password_page.dart';
  import 'package:rumah_kreatif_toba/utils/colors.dart';
  import 'package:rumah_kreatif_toba/utils/dimensions.dart';
  import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
  import 'package:rumah_kreatif_toba/widgets/big_text.dart';
  
  import '../../routes/route_helper.dart';
  import '../../widgets/small_text.dart';
  import '../home/home_page.dart';
  import 'main_account_page.dart';
  import 'profil/about_us_page.dart';
  import 'profil/hubungi_kami.dart';
  import 'package:rumah_kreatif_toba/pages/home/PusatBantuanPage.dart';


  class AccountPage extends StatelessWidget {
    const AccountPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        Get.find<UserController>().getUser();
      }
      return Scaffold(
          body: _userLoggedIn
              ? GetBuilder<UserController>(
            builder: (userController) {
              return userController.isLoading
                  ? Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: Dimensions.height20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profil Section
                      Container(
                        margin: EdgeInsets.only(
                            top: Dimensions.height30,
                            bottom: Dimensions.height10),
                        padding: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: BigText(
                                text: "Profil",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: Dimensions.width45 * 1.5,
                            height: Dimensions.height45 * 1.5,
                            margin: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/ikon/profile.png"))),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                BigText(
                                    text: userController
                                        .usersList[0].username
                                        .toString()),
                                SmallText(
                                    text: userController
                                        .usersList[0].email
                                        .toString()),
                                SmallText(
                                    text: userController
                                        .usersList[0].noHp
                                        .toString())
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // Profil Section Navigation
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.to(ProfilPage());
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.person,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Profil",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // Ganti Password Section
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.to(UbahPasswordPage());
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.lock,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Ubah Password",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // Toko Section
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.find<TokoController>()
                                .cekVerifikasi();
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.store,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Toko",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // Keranjangku Section
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.toNamed(RouteHelper.getKeranjangPage());
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.shopping_cart_outlined,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Keranjangku",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // Pusat dan Bantuan Section
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.to(() => PusatBantuanPage());
                          }
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.help_outline,
                            backgroundColor:
                            Colors.white.withOpacity(0.0),
                            iconColor: AppColors.redColor,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(
                            text: "Pusat dan Bantuan",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // Alamat Section
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.toNamed(RouteHelper.getDaftarAlamatPage());
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.location_on_outlined,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Alamat",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // New Menu for Tentang Kami (About Us)
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.to(() => TentangKamiPage());
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.message_outlined,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Tentang Kami",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      // New Menu for Hubungi Kami (Contact Us)
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.to(() => HubungiKamiPage());
                          }
                        },
                        child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.phone,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(
                              text: "Hubungi Kami",
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      // Menghapus kondisi Platform.isIOS dan kIsWeb untuk menampilkan menu "Hapus Akun" di semua platform
                      GestureDetector(
                        onTap: () async {
                          showConfirmPopUp(
                            title: "Yakin ingin menghapus akun?",
                            subTitle:
                            "Setelah menghapus akun, seluruh data akan dihapus dari aplikasi dan tidak dapat dipulihkan termasuk riwayat transaksi, foto profil, dll",
                            onAccept: () {
                              Get.find<UserController>().hapusAkun();
                            },
                            onCancel: () => Get.back(),
                          );
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.delete_forever,
                            backgroundColor: Colors.white.withOpacity(0.0),
                            iconColor: AppColors.redColor,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(
                            text: "Hapus Akun",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),

                      // Keluar Section
                      GestureDetector(
                        onTap: () {
                          if (Get.find<AuthController>()
                              .userLoggedIn()) {
                            Get.dialog(
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                title: Column(
                                  children: [
                                    Icon(Icons.logout,
                                        size: 48,
                                        color: AppColors.redColor),
                                    SizedBox(height: 10),
                                    Text("Keluar",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold)),
                                  ],
                                ),
                                content:
                                Text("Apakah Anda yakin ingin keluar?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text("Batal",
                                        style: TextStyle(
                                            color: Colors.black)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        AppColors.redColor),
                                    onPressed: () async {
                                      await Get.find<AuthController>()
                                          .clearSharedData();
                                      Get.find<UserController>()
                                          .clearUser();
                                      Get.offAllNamed(
                                          RouteHelper.getInitial());
                                    },
                                    child: Text("Ya"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Get.to(() => HomePage(initialIndex: 0));
                          }
                        },
                        child: AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.logout_sharp,
                            backgroundColor:
                            Colors.white.withOpacity(0.0),
                            iconColor: AppColors.redColor,
                            iconSize: Dimensions.height10 * 5 / 2,
                            size: Dimensions.height10 * 5,
                          ),
                          bigText: BigText(
                            text: "Keluar",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                    ],
                  ),
                ),
              )
                  : CustomLoader();
            },
          )
              : MainAccountPage());
    }
  }
