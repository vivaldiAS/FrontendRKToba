import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/pesanan/pesanan_page.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/pembelian_controller.dart';
import '../../controllers/pesanan_controller.dart';
import '../../controllers/popular_produk_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';
import '../../widgets/price_text.dart';
import '../../widgets/small_text.dart';

class DetailPesananPage extends StatefulWidget {
  const DetailPesananPage({Key? key}) : super(key: key);

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  @override
  void initState() {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<PesananController>().getPesanan();
    }
  }

  bool _cekStatusstatus5 =
      Get.find<PesananController>().detailPesanan[0].statusPembelian ==
          "Belum Diambil";

  bool _cekStatusstatus4 =
      Get.find<PesananController>().detailPesanan[0].statusPembelian ==
          "Belum Dikonfirmasi Pembeli";

  bool _cekStatusstatus3 =
      Get.find<PesananController>().detailPesanan[0].statusPembelian ==
          "Dalam Perjalanan";

  bool _cekStatusstatus2 =
      Get.find<PesananController>().detailPesanan[0].statusPembelian ==
          "Sedang Dikemas";

  @override
  Widget build(BuildContext context) {
    var detailPesanan = Get.find<PesananController>().detailPesanan;
    Future<void> _updateStatusPembelian(int purchase_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<PembelianController>();
        controller.updateStatusPembelian(purchase_id).then((status) async {
          Get.to(PesananPage());
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      Get.back();
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back,
                      iconColor: AppColors.redColor,
                      backgroundColor: Colors.white.withOpacity(0.0),
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width20,
                  ),
                  BigText(
                    text: "Detail Pesanan",
                    size: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
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
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        BigText(
                          text: detailPesanan[0].statusPembelian.toString(),
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Row(
                          children: [
                            BigText(
                              text: detailPesanan[0].kodePembelian.toString(),
                              size: Dimensions.font16,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Row(
                          children: [
                            BigText(
                              text: detailPesanan[0].createdAt.toString() ??
                                  'N/A',
                              size: Dimensions.font16,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //List View Detail Produk
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
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        BigText(
                          text: "Detail Produk",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  GetBuilder<PesananController>(builder: (pesananController) {
                    print(pesananController.detailPesananList.length);
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: Dimensions.height45 * 3.8),
                        itemCount: pesananController.detailPesananList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var gambarproduk = Get.find<PopularProdukController>()
                              .imageProdukList
                              .where((produk) =>
                                  produk.productId ==
                                  pesananController
                                      .detailPesananList[index].productId);
                          return Container(
                            width: Dimensions.screenWidth,
                            height: Dimensions.height45 * 3.5,
                            margin: EdgeInsets.only(
                              bottom: Dimensions.height10,
                            ),
                            padding: EdgeInsets.all(Dimensions.height10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.buttonBackgroundColor),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20 / 2),
                                color: Colors.white),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var produkIndex =
                                                    pesananController
                                                        .detailPesananList[
                                                            index]
                                                        .productId!;
                                                if (produkIndex >= 0) {
                                                  Get.toNamed(RouteHelper
                                                      .getProdukDetail(
                                                          produkIndex));
                                                }
                                              },
                                              child: Container(
                                                width: Dimensions.height20 * 3,
                                                height: Dimensions.height20 * 3,
                                                margin: EdgeInsets.only(
                                                    top: Dimensions.height10),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                                        )),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radius20),
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.width20,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width:
                                                      Dimensions.screenWidth /
                                                          1.6,
                                                  child: BigText(
                                                    text: pesananController
                                                        .detailPesananList[
                                                            index]
                                                        .productName,
                                                    size: Dimensions.font16,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SmallText(
                                                        text:
                                                            "${pesananController.detailPesananList[index].jumlahPembelianProduk} x "),
                                                    PriceText(
                                                      text: CurrencyFormat
                                                          .convertToIdr(
                                                              pesananController
                                                                  .detailPesananList[
                                                                      index]
                                                                  .price,
                                                              0),
                                                      size: Dimensions.font16,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: AppColors.buttonBackgroundColor),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SmallText(text: "Total Harga"),
                                                PriceText(
                                                  text: CurrencyFormat.convertToIdr(
                                                      pesananController
                                                          .detailPesananList[
                                                              index]
                                                          .hargaPembelianProduk,
                                                      0),
                                                  size: Dimensions.font16,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     var produkIndex = pesananController
                                      //         .detailPesananList[index]
                                      //         .productId!;
                                      //     if (produkIndex >= 0) {
                                      //       Get.toNamed(
                                      //           RouteHelper.getProdukDetail(
                                      //               produkIndex));
                                      //     }
                                      //   },
                                      //   child: Container(
                                      //     padding: EdgeInsets.only(
                                      //         top: Dimensions.height10 / 2,
                                      //         bottom: Dimensions.height10 / 2,
                                      //         left: Dimensions.height10,
                                      //         right: Dimensions.height10),
                                      //     decoration: BoxDecoration(
                                      //         border: Border.all(
                                      //             color: AppColors.redColor),
                                      //         borderRadius:
                                      //             BorderRadius.circular(
                                      //                 Dimensions.radius20 / 2),
                                      //         color: Colors.white),
                                      //     child: BigText(
                                      //       text: "Beli Lagi",
                                      //       size: Dimensions.iconSize16,
                                      //       color: AppColors.redColor,
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }),
                ],
              ),
            ),

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
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height30),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        BigText(
                          text: "Rincian Pembayaran",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Row(
                          children: [
                            BigText(
                              text: "Total Harga",
                              size: Dimensions.font16,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Row(
                          children: [
                            PriceText(
                              text: CurrencyFormat.convertToIdr(
                                  detailPesanan[0].hargaPembelian, 0),
                              size: Dimensions.font16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: "Total Ongkos Kirim",
                          size: Dimensions.font16,
                        ),
                        PriceText(
                          text: CurrencyFormat.convertToIdr(
                              detailPesanan[0].ongkir, 0),
                          size: Dimensions.font16,
                        ),
                      ],
                    ),
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
                        text: CurrencyFormat.convertToIdr(
                            detailPesanan[0].hargaPembelian +
                                detailPesanan[0].ongkir,
                            0),
                        size: Dimensions.font16,
                      ),
                    ],
                  )
                ],
              ),
            ),

            _cekStatusstatus5
                ?
                //KONFIRMASI
                Container(
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                        Container(
                            alignment: Alignment.topLeft,
                            child: BigText(
                              text: "Konfirmasi",
                              size: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            )),
                        Divider(color: AppColors.buttonBackgroundColor),
                        Container(
                          width: Dimensions.screenWidth,
                          child: BigText(
                            text: "Pesanan Telah Disiapkan. SILAHKAN AMBIL PESANAN ANDA DI TOKO.",
                            size: Dimensions.font16,
                            textAlign: TextAlign.center, // Atur alignment jika perlu
                            overFlow: TextOverflow.visible, // Menghindari teks terpotong
                          ),
                        ),
                      ],
                    ))
                : SizedBox(),

            _cekStatusstatus4
                ?
                //KONFIRMASI
                Container(
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                        Container(
                            alignment: Alignment.topLeft,
                            child: BigText(
                              text: "Konfirmasi",
                              size: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            )),
                        Divider(color: AppColors.buttonBackgroundColor),
                        Container(
                          width: Dimensions.screenWidth,
                          child: BigText(
                              text:
                                  "Jika pesanan telah diambil. SILAHKAN KONFIRMASI",
                              size: Dimensions.font16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            GestureDetector(
                              onTap: () {
                                _updateStatusPembelian(
                                    detailPesanan[0].purchaseId);
                              },
                              child: Container(
                                width: Dimensions.width45 * 3,
                                height: Dimensions.height30,
                                // alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.redColor),
                                child: Center(
                                  child: BigText(
                                    text: "Konfirmasi",
                                    size: Dimensions.font16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
                : SizedBox(),

            _cekStatusstatus3
                ?
                //LOKASI PENGIRIMAN
                Container(
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                        Container(
                            alignment: Alignment.topLeft,
                            child: BigText(
                              text: "Lokasi Pengiriman",
                              size: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            )),
                        Divider(color: AppColors.buttonBackgroundColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BigText(
                                text: "Provinsi",
                                size: Dimensions.font16,
                              ),
                            ),
                            Expanded(
                              child: BigText(
                                text:
                                    detailPesanan[0].provinceName.toString() ??
                                        "N/A",
                                size: Dimensions.font16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BigText(
                                text: "Kota",
                                size: Dimensions.font16,
                              ),
                            ),
                            Expanded(
                              child: BigText(
                                text: detailPesanan[0].cityName.toString() ??
                                    "N/A",
                                size: Dimensions.font16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BigText(
                                text: "Kecamatan",
                                size: Dimensions.font16,
                              ),
                            ),
                            Expanded(
                              child: BigText(
                                text: detailPesanan[0]
                                        .subdistrictName
                                        .toString() ??
                                    "N/A",
                                size: Dimensions.font16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BigText(
                                text: "Alamat",
                                size: Dimensions.font16,
                              ),
                            ),
                            Expanded(
                              child: BigText(
                                text: detailPesanan[0]
                                        .userStreetAddress
                                        .toString() ??
                                    "N/A",
                                size: Dimensions.font16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BigText(
                                text: "Nomor Telepon",
                                size: Dimensions.font16,
                              ),
                            ),
                            Expanded(
                              child: BigText(
                                text: detailPesanan[0].noHp.toString() ?? "N/A",
                                size: Dimensions.font16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))
                : SizedBox(),

            _cekStatusstatus3
                ?
                //NOMOR RESI
                Container(
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                        Container(
                            alignment: Alignment.topLeft,
                            child: BigText(
                              text: "Nomor Resi",
                              size: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            )),
                        Divider(color: AppColors.buttonBackgroundColor),
                        Container(
                          width: Dimensions.screenWidth,
                          child: BigText(
                              text:
                                  "SILAHKAN CEK RESI MENGUNAKAN NOMOR RESI : ${detailPesanan[0].noResi.toString() ?? 'N/A'}  ${detailPesanan[0].courierCode.toString() ?? 'N/A'} - ${detailPesanan[0].service.toString() ?? 'N/A'}",
                              size: Dimensions.font16),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                      ],
                    ))
                : SizedBox(),

            _cekStatusstatus2 || _cekStatusstatus3
                ?
                //KONFIRMASI
                Container(
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                        Container(
                            alignment: Alignment.topLeft,
                            child: BigText(
                              text: "Konfirmasi",
                              size: Dimensions.font20,
                              fontWeight: FontWeight.bold,
                            )),
                        Divider(color: AppColors.buttonBackgroundColor),
                        Container(
                          width: Dimensions.screenWidth,
                          child: BigText(
                              text:
                                  "Jika pesanan telah sampai di lokasi dan telah diterima. SILAHKAN KONFIRMASI PESANAN.",
                              size: Dimensions.font16),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            GestureDetector(
                              onTap: () {
                                _updateStatusPembelian(
                                    detailPesanan[0].purchaseId);
                              },
                              child: Container(
                                width: Dimensions.width45 * 3,
                                height: Dimensions.height30,
                                // alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.redColor),
                                child: Center(
                                  child: BigText(
                                    text: "Konfirmasi",
                                    size: Dimensions.font16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
