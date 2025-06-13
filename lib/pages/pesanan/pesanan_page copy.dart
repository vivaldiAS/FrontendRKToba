import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/pesanan/detail_pesanan_page.dart';

import '../../base/snackbar_message.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/pesanan_controller.dart';
import '../../controllers/popular_produk_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/Filter.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';
import '../../widgets/price_text.dart';
import '../../widgets/small_text.dart';
import '../home/home_page.dart';

class PesananPageCopy extends StatefulWidget {
  const PesananPageCopy({Key? key}) : super(key: key);

  @override
  State<PesananPageCopy> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPageCopy> {
  @override
  void initState() {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<PesananController>().getPesanan();
      _list = Get.find<PesananController>().pesananList.toList();
    }
  }

  Filter? selectedValue;

  List<Filter?> filters = [
    Filter(id: 1, name: "Semua"),
    Filter(id: 2, name: "Sedang Dikemas"),
    Filter(id: 3, name: "Dalam Perjalanan"),
    Filter(id: 4, name: "Dalam Perjalanan"),
    Filter(id: 5, name: "Belum Diambil"),
    Filter(id: 6, name: "Belum Dikonfirmasi Pembeli"),
    Filter(id: 7, name: "Berhasil")
  ];

  List<dynamic> _list = Get.find<PesananController>().pesananList.toList();

  Future<void> _filter(String? keyword) async {
    try {
      List<dynamic> results =
          Get.find<PesananController>().pesananList.toList();
      if (keyword != "Semua") {
        results = Get.find<PesananController>()
            .pesananList
            .where((purchase) =>
                purchase.statusPembelian.toString() == "${keyword}")
            .toList();
      }

      setState(() {
        _list = results;
      });
    } catch (e) {
      print('Error filtering products: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _getDetailPesananList(int purchase_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<PesananController>();
        controller.getDetailPesananList(purchase_id).then((status) async {
          if (status.isSuccess) {
            Get.to(DetailPesananPage());
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height30),
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(HomePage(initialIndex: 4));
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
                  Container(
                    child: BigText(
                      text: "Pesananku",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getMenungguPembayaranPage());
              },
              child: Container(
                width: Dimensions.screenWidth,
                margin: EdgeInsets.only(
                    bottom: Dimensions.height10 / 2,
                    top: Dimensions.height10,
                    left: Dimensions.width20,
                    right: Dimensions.width20),
                padding: EdgeInsets.all(Dimensions.height10),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.redColor),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius20 / 2),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/images/indonesian-rupiah.png"))),
                    ),
                    SmallText(
                      text: "Menunggu Pembayaran",
                      size: Dimensions.font20,
                    ),
                    AppIcon(
                      icon: Icons.chevron_right,
                      size: Dimensions.iconSize24,
                      iconColor: AppColors.redColor,
                      backgroundColor: Colors.white.withOpacity(0.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.width20, top: Dimensions.height10),
                  width: Dimensions.screenWidth / 1.5,
                  height: Dimensions.height45,
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.width10 / 2,
                      horizontal: Dimensions.height10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius15 / 3)),
                  child: DropdownButton<Filter?>(
                      items: filters
                          .map<DropdownMenuItem<Filter?>>(
                              (e) => DropdownMenuItem(
                                    child: Text((e?.name ?? '').toString()),
                                    value: e,
                                  ))
                          .toList(),
                      isExpanded: true,
                      underline: SizedBox(),
                      value: selectedValue,
                      hint: Text('Urutkan berdasarkan'),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                        _filter(selectedValue?.name);
                      }),
                ),
              ],
            ),
            GetBuilder<PesananController>(builder: (pesananController) {
              return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: Dimensions.height45 * 5),
                  itemCount: _list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var gambarproduk = Get.find<PopularProdukController>()
                        .imageProdukList
                        .where((produk) =>
                            produk.productId == _list[index].productId);
                    return Container(
                      width: Dimensions.screenWidth,
                      height: Dimensions.height45 * 3.5,
                      margin: EdgeInsets.only(
                          bottom: Dimensions.height10,
                          top: Dimensions.height10 / 2,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.buttonBackgroundColor),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20 / 2),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: AppIcon(
                                          icon: Icons.shopping_bag_outlined,
                                          iconSize: Dimensions.iconSize24,
                                          iconColor: AppColors.redColor,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.0),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BigText(
                                            text: "Belanja",
                                            size: Dimensions.font16,
                                          ),
                                          SmallText(
                                              text:
                                                  _list[index].name.toString()),
                                          Container(
                                              height: Dimensions.height20,
                                              padding: EdgeInsets.only(
                                                  right: Dimensions.width10,
                                                  left: Dimensions.width10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radius30),
                                                color: AppColors
                                                    .notification_success
                                                    .withOpacity(0.3),
                                              ),
                                              child: Center(
                                                child: BigText(
                                                    text: _list[index]
                                                        .statusPembelian
                                                        .toString(),
                                                    size:
                                                        Dimensions.font16 / 1.5,
                                                    color: AppColors
                                                        .notification_success,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: SmallText(
                                    text: _list[index].createdAt.toString() ??
                                        'N/A',
                                    size: Dimensions.font20 / 1.5,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(color: AppColors.buttonBackgroundColor),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          var produkIndex =
                                              _list[index].productId!;
                                          if (produkIndex >= 0) {
                                            Get.toNamed(
                                                RouteHelper.getProdukDetail(
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
                                                      Dimensions.radius20),
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
                                            width: Dimensions.screenWidth / 1.6,
                                            child: BigText(
                                              text: _list[index].productName,
                                              size: Dimensions.font16,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SmallText(
                                                  text:
                                                      "${_list[index].jumlahPembelianProduk} x "),
                                              PriceText(
                                                text:
                                                    CurrencyFormat.convertToIdr(
                                                        _list[index].price, 0),
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
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          SmallText(text: "Total Belanja"),
                                          PriceText(
                                            text: CurrencyFormat.convertToIdr(
                                                _list[index].hargaPembelian, 0),
                                            size: Dimensions.font16,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _getDetailPesananList(
                                        _list[index].purchaseId);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.height10 / 2,
                                        bottom: Dimensions.height10 / 2,
                                        left: Dimensions.height10,
                                        right: Dimensions.height10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.redColor),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20 / 2),
                                        color: Colors.white),
                                    child: BigText(
                                      text: "Lihat Detail",
                                      size: Dimensions.iconSize16,
                                      color: AppColors.redColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }),

            // GetBuilder<PesananController>(builder: (pesananController) {
            //   return Expanded(child: ListView.builder(
            //       itemCount: pesananController.pesananList.length,
            //       itemBuilder: (_, index) {
            //         Container(
            //           width: Dimensions.screenWidth,
            //           height: Dimensions.height45 * 3.5,
            //           margin: EdgeInsets.only(
            //               bottom: Dimensions.height10 / 2,
            //               top: Dimensions.height10 / 2,
            //               left: Dimensions.width20,
            //               right: Dimensions.width20),
            //           padding: EdgeInsets.all(Dimensions.height10),
            //           decoration: BoxDecoration(
            //               border: Border.all(
            //                   color: AppColors.buttonBackgroundColor),
            //               borderRadius:
            //               BorderRadius.circular(Dimensions.radius20),
            //               color: Colors.white),
            //           child: Column(
            //             children: [
            //               Container(
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Container(
            //                       child: Row(
            //                         children: [
            //                           Container(
            //                             child: AppIcon(
            //                               icon: Icons.shopping_bag_outlined,
            //                               iconSize: Dimensions.iconSize24,
            //                               iconColor: AppColors.redColor,
            //                               backgroundColor:
            //                               Colors.white.withOpacity(0.0),
            //                             ),
            //                           ),
            //                           Column(
            //                             mainAxisAlignment:
            //                             MainAxisAlignment.start,
            //                             crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                             children: [
            //                               BigText(
            //                                 text: "Belanja",
            //                                 size: Dimensions.font16,
            //                               ),
            //                               SmallText(text: "3 Okt 2021")
            //                             ],
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                     Container(
            //                       padding:
            //                       EdgeInsets.all(Dimensions.height10 / 2),
            //                       decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.circular(
            //                               Dimensions.radius20 / 2),
            //                           color: AppColors.notification_success),
            //                       child: BigText(
            //                         text: "Selesai",
            //                         size: Dimensions.iconSize16,
            //                         color: Colors.white,
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               Divider(color: AppColors.buttonBackgroundColor),
            //               Container(
            //                 child: BigText(text: "rkt131231"),
            //               ),
            //               Container(
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Container(
            //                       child: Row(
            //                         children: [
            //                           Column(
            //                             mainAxisAlignment:
            //                             MainAxisAlignment.start,
            //                             crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                             children: [
            //                               SmallText(text: "Total Belanja"),
            //                               PriceText(
            //                                 text: CurrencyFormat.convertToIdr(
            //                                     20000, 0),
            //                                 size: Dimensions.font16,
            //                               ),
            //                             ],
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                     Container(
            //                       padding: EdgeInsets.only(
            //                           top: Dimensions.height10 / 2,
            //                           bottom: Dimensions.height10 / 2,
            //                           left: Dimensions.height10,
            //                           right: Dimensions.height10),
            //                       decoration: BoxDecoration(
            //                           border:
            //                           Border.all(color: AppColors.redColor),
            //                           borderRadius: BorderRadius.circular(
            //                               Dimensions.radius20 / 2),
            //                           color: Colors.white),
            //                       child: BigText(
            //                         text: "Lihat Detail",
            //                         size: Dimensions.iconSize16,
            //                         color: AppColors.redColor,
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       }));
            // })
          ],
        ),
      ),
    );
  }
}
