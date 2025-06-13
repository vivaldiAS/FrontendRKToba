import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/tittle_text.dart';

import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import 'hometoko_page.dart';

class HomeToko extends StatefulWidget {
  const HomeToko({Key? key}) : super(key: key);

  @override
  State<HomeToko> createState() => _HomeTokoState();
}

class _HomeTokoState extends State<HomeToko> {
  final TokoController tokoController = Get.find<TokoController>();

  @override
  void initState() {
    super.initState();
    // Panggil data hanya sekali di sini
    tokoController.profilToko();
    tokoController.homeToko();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30, bottom: Dimensions.height10),
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Dimensions.width15 * 2,
                    height: Dimensions.height30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/logo_rkt.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Container(
                    width: Dimensions.width15 * 2,
                    height: Dimensions.height30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/Bangga_Buatan_Indonesia_Logo.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Container(
                    width: Dimensions.screenWidth / 1.8,
                    height: Dimensions.height30,
                    child: Obx(() {
                      if (tokoController.profilTokoList.isEmpty) {
                        return BigText(
                          text: "Toko -",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        );
                      } else {
                        return BigText(
                          text:
                          "Toko ${tokoController.profilTokoList[0].nama_merchant.toString()}",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),

            // Bagian PENJUALAN
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ]),
              margin: EdgeInsets.only(top: Dimensions.height20),
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: "PENJUALAN",
                        fontWeight: FontWeight.bold,
                      ),
                      // Uncomment jika mau enable tombol Riwayat
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(() => HomeTokoPage(initialIndex: 2));
                      //   },
                      //   child:  BigText(
                      //     text: "Lihat Riwayat",
                      //     size: Dimensions.font16,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.notification_success,
                      //   )
                      // )
                    ],
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TittleText(
                        text: "Pesanan Sedang Berlangsung",
                        size: Dimensions.font16 / 1.5,
                      ),
                      Obx(() {
                        var jumlah = tokoController.getJumlahPesanan['jumlah_pesanan_sedang_berlangsung'];
                        return BigText(
                          text: (jumlah != null) ? jumlah.toString() : 'N/A',
                          size: Dimensions.font16 / 1.5,
                        );
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TittleText(
                        text: "Pesanan Berhasil [Belum Konfirmasi Pembayaran]",
                        size: Dimensions.font16 / 1.5,
                      ),
                      Obx(() {
                        var jumlah = tokoController.getJumlahPesanan['jumlah_pesanan_berhasil_belum_dibayar'];
                        return BigText(
                          text: (jumlah != null) ? jumlah.toString() : 'N/A',
                          size: Dimensions.font16 / 1.5,
                        );
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TittleText(
                        text: "Pesanan Berhasil [Telah Konfirmasi Pembayaran]",
                        size: Dimensions.font16 / 1.5,
                      ),
                      Obx(() {
                        var jumlah = tokoController.getJumlahPesanan['jumlah_pesanan_berhasil_telah_dibayar'];
                        return BigText(
                          text: (jumlah != null) ? jumlah.toString() : 'N/A',
                          size: Dimensions.font16 / 1.5,
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            // Bagian PRODUK
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ]),
              margin: EdgeInsets.only(top: Dimensions.height20),
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: "PRODUK",
                        fontWeight: FontWeight.bold,
                      ),
                      // Uncomment jika mau enable tombol Tambah Produk
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(HomeTokoPage(initialIndex: 3));
                      //   },
                      //   child: BigText(
                      //     text: "Tambah Produk",
                      //     size: Dimensions.font16,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.notification_success,
                      //   ),
                      // )
                    ],
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        BigText(
                          text: "Daftar Produkmu",
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    var jumlahProduk = tokoController.getJumlahPesanan['jumlah_produk'];
                    return Row(
                      children: [
                        BigText(
                          text: jumlahProduk != null ? '$jumlahProduk produk' : "N/A",
                          size: Dimensions.font16 / 1.5,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
