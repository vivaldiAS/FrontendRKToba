import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/base/custom_loader.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/pages/account/account_widget.dart';
import 'package:rumah_kreatif_toba/pages/toko/AlamatToko/daftar_alamat_toko.dart';
import 'package:rumah_kreatif_toba/pages/toko/profil/profil.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:get/get.dart';

import '../../../routes/route_helper.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/small_text.dart';
import '../rekening/daftarrekening.dart';

class ProfilTokoPage extends StatefulWidget {
  const ProfilTokoPage({Key? key}) : super(key: key);

  @override
  State<ProfilTokoPage> createState() => _ProfilTokoPageState();
}

class _ProfilTokoPageState extends State<ProfilTokoPage> {
  final TokoController tokoController = Get.find<TokoController>();

  @override
  void initState() {
    super.initState();
    // Panggil fetch profil toko via token sekali saat halaman dimuat
    tokoController.profilTokoViaToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<TokoController>(
        builder: (tokoController) {
          return Column(
            children: [
              // Bagian loading indicator hanya jika isLoading true
              if (tokoController.isLoading)
                CustomLoader()
              else if (tokoController.profilTokoList.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height20),
                    child: BigText(
                      text: "Data profil toko tidak tersedia",
                      size: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
              // Tampilkan data profil toko
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: Dimensions.height20),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BigText(
                                text: "Profil Toko",
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Foto dan Info Toko
                        Row(
                          children: [
                            Container(
                              width: Dimensions.width45 * 2,
                              height: Dimensions.height45 * 2,
                              margin: EdgeInsets.only(
                                  left: Dimensions.width20,
                                  right: Dimensions.width10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    '${AppConstants.BASE_URL_IMAGE}u_file/foto_merchant/${tokoController.profilTokoList[0].foto_merchant ?? ''}',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                    text: tokoController.profilTokoList[0]
                                        .nama_merchant ??
                                        "-"),
                                SmallText(
                                    text: tokoController.profilTokoList[0]
                                        .kontak_toko ??
                                        "-"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Profil
                        GestureDetector(
                          onTap: () {
                            if (Get.find<AuthController>().userLoggedIn()) {
                              Get.to(() => Profil());
                            }
                          },
                          child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.store,
                              backgroundColor: Colors.transparent,
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: "Profil"),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Alamat
                        GestureDetector(
                          onTap: () {
                            if (Get.find<AuthController>().userLoggedIn()) {
                              Get.to(() => DaftarAlamatTokoPage());
                            }
                          },
                          child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.location_on_outlined,
                              backgroundColor: Colors.transparent,
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: "Alamat"),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Rekening
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DaftarRekening());
                          },
                          child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.account_balance_wallet_outlined,
                              backgroundColor: Colors.transparent,
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: "Rekening"),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),

                        // Keluar
                        GestureDetector(
                          onTap: () {
                            if (Get.find<AuthController>().userLoggedIn()) {
                              Get.offNamed(RouteHelper.getInitial());
                            } else {
                              Get.toNamed(RouteHelper.getInitial());
                              print("Anda sudah keluar");
                            }
                          },
                          child: AccountWidget(
                            appIcon: AppIcon(
                              icon: Icons.logout_sharp,
                              backgroundColor: Colors.transparent,
                              iconColor: AppColors.redColor,
                              iconSize: Dimensions.height10 * 5 / 2,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: "Keluar"),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
