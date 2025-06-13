import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/pesanan/menunggu_pembayaran_page.dart';

import '../../controllers/pesanan_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';
import '../../widgets/price_text.dart';
import '../../widgets/small_text.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  Future<void> uploadProofOfPayment() async {
    var controller = Get.find<PesananController>();
    var detailPesanan = controller.detailPesanan;
    if (detailPesanan.isNotEmpty) {
      controller.postBuktiPembayaran(detailPesanan[0].purchaseId).then((status) async {
        Get.to(MenungguPembayaranPage());
      });
    } else {
      Get.snackbar("Error", "Data pesanan belum tersedia");
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PesananController>();
    var detailPesanan = controller.detailPesanan;

    // Jika data pesanan kosong, tampil loading
    if (detailPesanan.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pembayaran"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Pastikan properti tidak null, kalau null pakai default 0 atau string kosong
    final kodePembelian = detailPesanan[0].kodePembelian ?? "Tidak tersedia";
    final hargaPembelian = detailPesanan[0].hargaPembelian ?? 0;
    final ongkir = detailPesanan[0].ongkir ?? 0;
    final totalBayar = hargaPembelian + ongkir;
    final purchaseId = detailPesanan[0].purchaseId ?? 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dan navigasi balik
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(MenungguPembayaranPage());
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                  BigText(
                    text: "Pembayaran",
                    size: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),

            // Informasi Pembayaran
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ]),
              margin: EdgeInsets.only(top: Dimensions.height20),
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height30, horizontal: Dimensions.width20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: kodePembelian,
                        size: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(text: "Total Harga", size: Dimensions.font16),
                      PriceText(
                          text: CurrencyFormat.convertToIdr(hargaPembelian, 0),
                          size: Dimensions.font16),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(text: "Total Ongkos Kirim", size: Dimensions.font16),
                      PriceText(
                          text: CurrencyFormat.convertToIdr(ongkir, 0),
                          size: Dimensions.font16),
                    ],
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: "Total Belanja",
                        size: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                      ),
                      PriceText(
                          text: CurrencyFormat.convertToIdr(totalBayar, 0),
                          size: Dimensions.font16),
                    ],
                  ),
                ],
              ),
            ),

            // Informasi rekening pembayaran
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ]),
              margin: EdgeInsets.only(top: Dimensions.height20),
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height30, horizontal: Dimensions.width20),
              child: Column(
                children: [
                  SmallText(
                    text:
                    "SILAHKAN LAKUKAN PEMBAYARAN PESANAN ANDA KE NOMOR REKENING DIBAWAH INI.A/N Riyanthi A Sianturi",
                    size: Dimensions.font16,
                  ),
                  Container(
                    width: Dimensions.screenWidth / 1.35,
                    margin: EdgeInsets.only(
                        bottom: Dimensions.height10 / 2, top: Dimensions.height10),
                    padding: EdgeInsets.all(Dimensions.height10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.redColor),
                        borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/images/Mandiri.png"))),
                        ),
                        SmallText(
                          text: "1070018822454",
                          size: Dimensions.font20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FlutterClipboard.copy("1070018822454");
                            Get.snackbar('Salin', 'Berhasil disalin');
                          },
                          child: AppIcon(
                            icon: Icons.copy,
                            size: Dimensions.height45,
                            iconColor: AppColors.redColor,
                            backgroundColor: Colors.white.withOpacity(0.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bagian upload bukti pembayaran
            GetBuilder<PesananController>(builder: (pesananController) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(Dimensions.height20),
                    padding: EdgeInsets.all(Dimensions.height20),
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(Dimensions.radius20 / 2),
                        color: AppColors.redColor),
                    child: GestureDetector(
                        onTap: () {
                          pesananController.pickImage();
                        },
                        child: Row(children: [
                          BigText(
                            text: "Pilih Gambar",
                            color: Colors.white,
                            size: Dimensions.height15,
                          ),
                        ])),
                  ),
                  pesananController.pickedFile != null
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(pesananController.pickedFile!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                      : Text(
                    "Tidak ada gambar",
                    style: TextStyle(fontSize: Dimensions.font16),
                  )
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<PesananController>(
        builder: (pesananController) {
          return Container(
            height: Dimensions.height45 * 2,
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10, horizontal: Dimensions.width20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
                      color: AppColors.redColor),
                  child: GestureDetector(
                    onTap: () {
                      uploadProofOfPayment();
                    },
                    child: Row(children: [
                      BigText(
                        text: "Beli",
                        color: Colors.white,
                        size: Dimensions.height15,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}