import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../../utils/colors.dart';
import '../../widgets/card_kategori.dart';
import '../../widgets/card_unggulan.dart';

class KategoriProduk extends StatelessWidget {
  const KategoriProduk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kategori;
    Future<void> _getProduk(PopularProdukController produkController) async {
      produkController.getKategoriProdukList(kategori);
    }

    return Scaffold(
        //backgroundColor: Colors.blue[100],
        body: GetBuilder<PopularProdukController>(builder: (_produkController) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: kToolbarHeight,
              bottom: Dimensions.height10,
              left: Dimensions.width20,
              right: Dimensions.width20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text: "Produk",
                  fontWeight: FontWeight.bold,
                ),
                Center(
                    child: Row(
                  children: [
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
                              size: Dimensions.height45,
                              iconColor: AppColors.redColor,
                              backgroundColor: Colors.white.withOpacity(0.0),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Visibility(
                                visible:
                                    Get.find<AuthController>().userLoggedIn() &&
                                        controller.keranjangList.length >= 1,
                                child: Badge.count(
                                  count: controller.keranjangList.length,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      AppColors.notification_success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              child: Column(
                children: [
                  Row(
                    children: [BigText(text: "Kategori")],
                  ),
                  Divider(
                    color: AppColors.buttonBackgroundColor,
                    thickness: 2.0,
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    CardKategori(kategori: "Makanan"),
                    CardKategori(kategori: "Minuman"),
                    CardKategori(kategori: "Pakaian"),
                    CardKategori(kategori: "Ulos"),
                    CardKategori(kategori: "Souvenir"),
                    CardKategori(kategori: "Perlengkapan Rumah"),
                    CardKategori(kategori: "Non Halal"),
                    // CardKategori(kategori: "Jasa"),
                  ])),
          Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              child: Column(
                children: [
                  Row(
                    children: [BigText(text: "Unggulan")],
                  ),
                  Divider(
                    color: AppColors.buttonBackgroundColor,
                    thickness: 2.0,
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    CardUnggulan(
                      kategori: "Makanan dan Minuman",
                      kategoris: "Makanan_dan_Minuman",
                    ),
                    CardUnggulan(
                      kategori: "Pakaian Diminati",
                      kategoris: "Pakaian_Diminati",
                    ),
                    CardUnggulan(
                      kategori: "Produk Terbaru",
                      kategoris: "Produk_Terbaru",
                    ),
                  ]))
        ],
      );
    }));
  }
}
