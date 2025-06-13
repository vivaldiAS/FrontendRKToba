import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/pembelian_controller.dart';
import 'package:rumah_kreatif_toba/widgets/app_text_field.dart';

import '../../../base/snackbar_message.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/pesanan_controller.dart';
import '../../../controllers/popular_produk_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/currency_format.dart';
import '../../../widgets/price_text.dart';
import '../../../widgets/small_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../hometoko/hometoko_page.dart';
class PembelianDetailPage extends StatefulWidget {
  const PembelianDetailPage({Key? key}) : super(key: key);

  @override
  State<PembelianDetailPage> createState() => _PembelianDetailPageState();
}

class _PembelianDetailPageState extends State<PembelianDetailPage> {
  @override
  void initState() {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
    }
  }

  bool _cekStatusstatus2 =
      Get.find<PembelianController>().detailPembelianList[0].statusPembelian ==
          "Perlu Dikemas dan Masukkan Nomor Resi";

  bool _cekStatusstatus3 =
      Get.find<PembelianController>().detailPembelianList[0].statusPembelian ==
          "Dalam Perjalanan";

  bool _cekStatusstatus5 =
      Get.find<PembelianController>().detailPembelianList[0].statusPembelian ==
          "Belum Diambil";

  bool _cekStatusstatus4 =
      Get.find<PembelianController>().detailPembelianList[0].statusPembelian ==
          "Belum Dikonfirmasi Pembeli";

  bool _cekStatus =
      Get.find<PembelianController>().detailPembelianList[0].statusPembelian ==
          "Perlu Dikemas";

  @override
  Widget build(BuildContext context) {
    var noResiController = TextEditingController();
    void _updateNoResiPembelian(int purchase_id) {
      String noresi = noResiController.text.trim();

      if (noresi.isEmpty) {
        AwesomeSnackbarButton("Warning","Nomor resi masih kosong",ContentType.warning);
      }else {
        Get.find<PembelianController>().updateNoResiPembelian(purchase_id, noresi).then((status) {
          if (status.isSuccess) {
          } else {
            AwesomeSnackbarButton("Gagal",status.message,ContentType.failure);
          }
        });
      }
    }


    var detailPembelian = Get.find<PembelianController>().detailPembelianList;
    Future<void> _updateStatusPembelian(int purchase_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<PembelianController>();
        controller.updateStatusPembelian(purchase_id).then((status) async {
          Get.to(HomeTokoPage(initialIndex: 2));
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
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width20,
                  ),
                  BigText(
                    text: "Detail Pembelian",
                    size: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
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
                      width: Dimensions.screenWidth,
                      child: BigText(
                        text: detailPembelian[0].statusPembelian.toString(),
                        size: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                      )),
                  Divider(color: AppColors.buttonBackgroundColor),
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        BigText(
                          text: detailPembelian[0].kodePembelian != null
                              ? detailPembelian[0].kodePembelian.toString()
                              : 'N/A',
                          size: Dimensions.font16,
                        )
                      ],
                    ),
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
                          text: "Detail Pembelian",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  GetBuilder<PembelianController>(builder: (controller) {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: Dimensions.height45 * 3.8),
                        itemCount: controller.detailPembelianList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var gambarproduk = Get.find<PopularProdukController>()
                              .imageProdukList
                              .where((produk) =>
                                  produk.productId ==
                                  controller
                                      .detailPembelianList[index].productId);
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
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
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
                                                var produkIndex = controller
                                                    .detailPembelianList[index]
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
                                                    text: controller
                                                        .detailPembelianList[
                                                            index]
                                                        .productName,
                                                    size: Dimensions.font16,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SmallText(
                                                        text:
                                                            "${controller.detailPembelianList[index].jumlahPembelianProduk} x "),
                                                    PriceText(
                                                      text: CurrencyFormat
                                                          .convertToIdr(
                                                              controller
                                                                  .detailPembelianList[
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SmallText(text: "Total Harga"),
                                          PriceText(
                                            text: controller
                                                        .detailPembelianList[
                                                            index]
                                                        .hargaPembelianProduk !=
                                                    null
                                                ? CurrencyFormat.convertToIdr(
                                                    controller
                                                        .detailPembelianList[
                                                            index]
                                                        .hargaPembelianProduk,
                                                    0)
                                                : 'N/A',
                                            size: Dimensions.font16,
                                          ),
                                        ],
                                      )
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
                              text: detailPembelian[0].hargaPembelian != null
                                  ? CurrencyFormat.convertToIdr(
                                      detailPembelian[0].hargaPembelian, 0)
                                  : 'N/A',
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
                              detailPembelian[0].ongkir, 0),
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
                        text: detailPembelian[0].hargaPembelian != null
                            ? CurrencyFormat.convertToIdr(
                                detailPembelian[0].hargaPembelian +
                                    detailPembelian[0].ongkir,
                                0)
                            : 'N/A',
                        size: Dimensions.font16,
                      ),
                    ],
                  )
                ],
              ),
            ),


            _cekStatusstatus4
                ? Container(
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
                      width: Dimensions.screenWidth,
                      margin:
                      EdgeInsets.only(bottom: Dimensions.height10),
                      child: SmallText(
                        text:
                        "TUNGGU PELANGGAN MENGKONFIRMASI PESANAN YANG TELAH DIAMBIL.",
                      )),
                ],
              ),
            )
                : SizedBox(),

            _cekStatusstatus5
                ? Container(
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
                      width: Dimensions.screenWidth,
                      margin:
                      EdgeInsets.only(bottom: Dimensions.height10),
                      child: SmallText(
                        text:
                        "Jika pesanan telah diambil pelanggan. SILAHKAN KONFIRMASI PESANAN.",
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      GestureDetector(
                        onTap: () {
                          _updateStatusPembelian(
                              detailPembelian[0].purchaseId);
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
              ),
            )
                : SizedBox(),

            _cekStatusstatus2  || _cekStatusstatus3 ?
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
                        )
                    ),
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
                            text: detailPembelian[0].provinceName.toString() ?? "N/A",
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
                            text: detailPembelian[0].cityName.toString() ?? "N/A",
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
                            text: detailPembelian[0].subdistrictName.toString() ?? "N/A",
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
                            text: detailPembelian[0].userStreetAddress.toString() ?? "N/A",
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
                            text: detailPembelian[0].noHp.toString() ?? "N/A",
                            size: Dimensions.font16,
                          ),
                        ),
                      ],
                    ),
                  ],
                )) : SizedBox(),

            _cekStatusstatus3 ?
            //UPDATE NOMOR RESI
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
                        )
                    ),
                    Divider(color: AppColors.buttonBackgroundColor),
                    Container(
                      width: Dimensions.screenWidth,
                      child: BigText(text: "SILAHKAN CEK RESI MENGUNAKAN NOMOR RESI : ${detailPembelian[0].noResi.toString() ?? 'N/A'} ${detailPembelian[0].courierCode.toString() ?? 'N/A'} - ${detailPembelian[0].service.toString() ?? 'N/A'}", size: Dimensions.font16),
                    ),
                    Container(
                      width: Dimensions.screenWidth,
                      child: BigText(text: "Atau update nomor resi", size: Dimensions.font16,),
                    ),
                    SizedBox(height: Dimensions.height10,),
                    AppTextField(
                      textController: noResiController,
                      hintText: 'Nomor Resi',
                      icon: Icons.confirmation_num,
                    ),
                    SizedBox(height: Dimensions.height10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        GestureDetector(
                          onTap: () {
                            _updateNoResiPembelian(
                                detailPembelian[0].purchaseId);
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
                                text: "Edit",
                                size: Dimensions.font16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )) : SizedBox(),

            _cekStatusstatus2 ?
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
                        )
                    ),
                    Divider(color: AppColors.buttonBackgroundColor),
                    BigText(text: "Jika pesanan telah dikirim dan sedang dalam perjalanan.",size: Dimensions.font16,),
                    Container(
                      width: Dimensions.screenWidth,
                      child: BigText(text: "SILAHKAN GUNAKAN KIRIM MELALUI  ${detailPembelian[0].courierCode.toString() ?? 'N/A'} - ${detailPembelian[0].service.toString() ?? 'N/A'} UNTUK PESANAN", size: Dimensions.font16),
                    ),

                    SizedBox(height: Dimensions.height10,),
                    AppTextField(
                      textController: noResiController,
                      hintText: 'Nomor Resi',
                      icon: Icons.confirmation_num,
                    ),
                    SizedBox(height: Dimensions.height10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        GestureDetector(
                          onTap: () {
                            _updateNoResiPembelian(
                                detailPembelian[0].purchaseId);
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
                                text: "Kirim",
                                size: Dimensions.font16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )) : SizedBox(),

            _cekStatus
                ? Container(
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
                            width: Dimensions.screenWidth,
                            margin:
                                EdgeInsets.only(bottom: Dimensions.height10),
                            child: SmallText(
                              text:
                                  "Jika pesanan telah disiapkan. SILAHKAN KONFIRMASI PESANAN.",
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            GestureDetector(
                              onTap: () {
                                _updateStatusPembelian(
                                    detailPembelian[0].purchaseId);
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
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
