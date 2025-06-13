import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/pembelian_controller.dart';
import 'package:rumah_kreatif_toba/pages/toko/pembelian/pembelian_detailpage.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../controllers/pesanan_controller.dart';
import '../../../controllers/popular_produk_controller.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/Filter.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/currency_format.dart';
import '../../../widgets/price_text.dart';
import '../../../widgets/small_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class DaftarPembelianPage extends StatefulWidget {
  const DaftarPembelianPage({Key? key}) : super(key: key);

  @override
  State<DaftarPembelianPage> createState() => _DaftarPembelianPageState();
}

class _DaftarPembelianPageState extends State<DaftarPembelianPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;


  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  Filter? selectedValue;

  List<Filter?> filters = [
    Filter(
        id: 1,
        name: "Semua"
    ),
    Filter(
        id: 2,
        name: "Sedang Dikemas"
    ),
    Filter(
        id: 3,
        name: "Belum Diambil"
    ),
    Filter(
        id: 4,
        name: "Belum Dikonfirmasi Pembeli"
    ),
    Filter(
        id: 5,
        name: "Berhasil [Belum Konfirmasi Pembayaran]"
    ),
    Filter(
        id: 6,
        name: "Berhasil [Telah Konfirmasi Pembayaran]"
    ),
    Filter(
        id: 7,
        name: "Berhasil"
    )
  ];

  List<dynamic> _list = Get.find<PesananController>().pesananList.toList();


  Future<void> _filter(String? keyword) async {
    try {
      List<dynamic> results = Get.find<PesananController>().pesananList.toList();
      if(keyword != "Semua"){
        results = Get.find<PesananController>().pesananList.where((purchase) => purchase.statusPembelian.toString() == "${keyword}").toList();
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
    Get.find<PembelianController>().getPembelianList();
    Future<void> _detailPembelianList(int purchase_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<PembelianController>();
        controller.detailPembelian(purchase_id).then((status) async {
          if (status.isSuccess) {
            Get.to(PembelianDetailPage());
          } else {
            AwesomeSnackbarButton("Gagal",status.message,ContentType.failure);
          }
        });
      }
    }

    return Scaffold(
        body: Column(
      children: [
        Container(
          child: Container(
            margin: EdgeInsets.only(
                top: Dimensions.height30, bottom: Dimensions.height10),
            padding: EdgeInsets.only(
                left: Dimensions.width20, right: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: BigText(
                    text: "Daftar Pembelian",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: Dimensions.screenWidth,
          child: TabBar(
            indicatorColor: AppColors.notification_success,
            indicatorWeight: 3,
            labelColor: AppColors.notification_success,
            unselectedLabelColor: AppColors.buttonBackgroundColor,
            controller: _tabController,
            tabs: [
              Tab(text: "Menunggu Konfirmasi"),
              Tab(
                text: "Riwayat",
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              GetBuilder<PembelianController>(builder: (controller) {
                var _menungguKonfirmasiList = controller.pembelianList
                    .where((item) => item.statusPembelian == "Perlu Dikemas")
                    .toList();
                return Scrollbar(thumbVisibility: true, thickness: 7, radius: Radius.circular(20),child: RefreshIndicator(child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: Dimensions.height45 * 5.5),
                    itemCount: _menungguKonfirmasiList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var gambarproduk = Get.find<PopularProdukController>().imageProdukList.where(
                              (produk) =>
                          produk.productId ==
                              _menungguKonfirmasiList[index].productId);
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
                                                text: _menungguKonfirmasiList[index].name
                                                    .toString()),
                                            Container(
                                                height: Dimensions.height20,
                                                padding: EdgeInsets.only(right: Dimensions.width10, left: Dimensions.width10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                                  color: AppColors.notification_success.withOpacity(0.3),
                                                ),
                                                child: Center(
                                                  child: BigText(
                                                      text: _menungguKonfirmasiList[index].statusPembelian
                                                          .toString(),
                                                      size: Dimensions.font16/1.5,
                                                      color: AppColors.notification_success,
                                                      fontWeight: FontWeight.bold),
                                                )),
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
                                        GestureDetector(
                                          onTap: () {
                                            var produkIndex =
                                            controller
                                                .detailPembelianList[index]
                                                .productId!;
                                            if (produkIndex >= 0) {
                                              Get.toNamed(RouteHelper
                                                  .getProdukDetail(
                                                  produkIndex));
                                            }
                                          },
                                          child: Container(
                                            width:
                                            Dimensions.height20 *
                                                3,
                                            height:
                                            Dimensions.height20 *
                                                3,
                                            margin: EdgeInsets.only(
                                                top: Dimensions
                                                    .height10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                                    )
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    Dimensions
                                                        .radius20),
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.width20,),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width : Dimensions.screenWidth/1.6,
                                              child: BigText(
                                                text: _menungguKonfirmasiList[index]
                                                    .productName,
                                                size: Dimensions.font16,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SmallText(
                                                    text: "${ _menungguKonfirmasiList[index]
                                                        .jumlahPembelianProduk} x "),
                                                PriceText(
                                                  text: CurrencyFormat
                                                      .convertToIdr(
                                                      _menungguKonfirmasiList[index]
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
                            SizedBox(height: Dimensions.height10,),
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
                                            SmallText(text: "Total Belanja"),
                                            PriceText(
                                              text: _menungguKonfirmasiList[index].hargaPembelian != null
                                                  ? CurrencyFormat.convertToIdr(
                                                _menungguKonfirmasiList[index].hargaPembelian + _menungguKonfirmasiList[index].ongkir ?? 0,
                                                0,
                                              )
                                                  : 'N/A',
                                              size: Dimensions.font16,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _detailPembelianList(_menungguKonfirmasiList[index].purchaseId);
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
                    }), onRefresh: () => Get.find<PembelianController>().getPembelianList()));
              }),
              GetBuilder<PembelianController>(builder: (controller) {
                var _sudahKonfirmasiList = controller.pembelianList
                    .where((item) => item.statusPembelian != "Perlu Dikemas")
                    .toList();
                return Scrollbar(
                    thumbVisibility: true, thickness: 7, radius: Radius.circular(20),child: RefreshIndicator(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: Dimensions.height45 * 5.5),
                        itemCount: _sudahKonfirmasiList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var gambarproduk = Get.find<PopularProdukController>().imageProdukList.where(
                                  (produk) =>
                              produk.productId ==
                                  _sudahKonfirmasiList[index].productId);
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
                                                    text: _sudahKonfirmasiList[index].name
                                                        .toString()),
                                                Container(
                                                    height: Dimensions.height20,
                                                    padding: EdgeInsets.only(right: Dimensions.width10, left: Dimensions.width10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                                      color: AppColors.notification_success.withOpacity(0.3),
                                                    ),
                                                    child: Center(
                                                      child: BigText(
                                                          text: _sudahKonfirmasiList[index].statusPembelian
                                                              .toString(),
                                                          size: Dimensions.font16/1.5,
                                                          color: AppColors.notification_success,
                                                          fontWeight: FontWeight.bold),
                                                    )),
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
                                            GestureDetector(
                                              onTap: () {
                                                var produkIndex =
                                                controller
                                                    .detailPembelianList[index]
                                                    .productId!;
                                                if (produkIndex >= 0) {
                                                  Get.toNamed(RouteHelper
                                                      .getProdukDetail(
                                                      produkIndex));
                                                }
                                              },
                                              child: Container(
                                                width:
                                                Dimensions.height20 *
                                                    3,
                                                height:
                                                Dimensions.height20 *
                                                    3,
                                                margin: EdgeInsets.only(
                                                    top: Dimensions
                                                        .height10),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                                        )
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .radius20),
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: Dimensions.width20,),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width : Dimensions.screenWidth/1.6,
                                                  child: BigText(
                                                    text: _sudahKonfirmasiList[index]
                                                        .productName,
                                                    size: Dimensions.font16,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SmallText(
                                                        text: "${ _sudahKonfirmasiList[index]
                                                            .jumlahPembelianProduk} x "),
                                                    PriceText(
                                                      text: CurrencyFormat
                                                          .convertToIdr(
                                                          _sudahKonfirmasiList[index]
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
                                SizedBox(height: Dimensions.height10,),
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
                                                SmallText(text: "Total Belanja"),
                                                PriceText(
                                                  text: _sudahKonfirmasiList[index].hargaPembelian != null
                                                      ? CurrencyFormat.convertToIdr(
                                                    _sudahKonfirmasiList[index].hargaPembelian + _sudahKonfirmasiList[index].hargaPembelian ?? 0,
                                                    0,
                                                  )
                                                      : 'N/A',
                                                  size: Dimensions.font16,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _detailPembelianList(_sudahKonfirmasiList[index].purchaseId);
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
                        }), onRefresh: () => Get.find<PembelianController>().getPembelianList()));
              })
            ],
          ),
        ),
      ],
    ));
  }
}
