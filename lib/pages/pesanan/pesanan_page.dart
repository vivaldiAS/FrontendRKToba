import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/pesanan/detail_pesanan_page.dart';
import 'package:rumah_kreatif_toba/pages/review/ulasan_form.dart';

import '../../base/snackbar_message.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/review_controller.dart';
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
import '../account/main_account_page.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({Key? key}) : super(key: key);

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  @override
  void initState() {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    Get.find<ReviewController>().getUserReviews();

    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<ReviewController>().getUserReviews(); // tambahkan ini
      super.initState();
      selectedValue = filters[0];
      Get.find<PesananController>().getPesanan();
      _list = Get.find<PesananController>().pesananList.toList();
    }
  }

  Filter? selectedValue;

  List<Filter?> filters = [
    Filter(id: 1, name: "Semua"),
    Filter(id: 2, name: "Sedang Dikemas"),
    Filter(id: 3, name: "Dalam Perjalanan"),
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

    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    bool _cekPesanan = Get.find<PesananController>().pesananList.isEmpty;

    return Scaffold(
      body: _userLoggedIn
          ? RefreshIndicator(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height30 * 1.2),
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: BigText(
                      text: "Pesananku",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                            RouteHelper.getMenungguPembayaranPage());
                      },
                      child: Container(
                        width: Dimensions.screenWidth,
                        margin: EdgeInsets.only(
                            top: Dimensions.height10,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        padding: EdgeInsets.all(Dimensions.height10),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.redColor),
                            borderRadius: BorderRadius.circular(
                                Dimensions.radius20 / 2),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/indonesian-rupiah.png"))),
                                ),
                                SizedBox(
                                  width: Dimensions.width10,
                                ),
                                SmallText(
                                  text: "Menunggu Konfirmasi",
                                  size: Dimensions.font16,
                                ),
                              ],
                            ),
                            AppIcon(
                              icon: Icons.chevron_right,
                              size: Dimensions.iconSize24,
                              iconColor: AppColors.redColor,
                              backgroundColor:
                              Colors.white.withOpacity(0.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: Dimensions.height45,
                          margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20,
                            top: Dimensions.height10,
                            bottom: Dimensions.height10,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filters.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              Filter? filter = filters[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedValue = filter;
                                  });
                                  _filter(selectedValue?.name);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: Dimensions.height10 / 2,
                                      top: Dimensions.height10,
                                      right: Dimensions.width10),
                                  padding: EdgeInsets.only(
                                    right: Dimensions.width10,
                                    left: Dimensions.width10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: filter?.name ==
                                            selectedValue?.name
                                            ? Colors.green
                                            : AppColors
                                            .buttonBackgroundColor),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius20 / 2),
                                    color: filter?.name ==
                                        selectedValue?.name
                                        ? AppColors.notification_success
                                        .withOpacity(0.3)
                                        : Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SmallText(
                                        text: '${filter?.name}',
                                        size: Dimensions.font16,
                                        color: filter?.name ==
                                            selectedValue?.name
                                            ? AppColors
                                            .notification_success
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        GetBuilder<PesananController>(
                            builder: (pesananController) {
                              return selectedValue?.name == "Semua"
                                  ? Obx(() => GridView.builder(
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisExtent:
                                      Dimensions.height45 * 5.5),
                                  itemCount: pesananController
                                      .pesananList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var gambarproduk = Get.find<
                                        PopularProdukController>()
                                        .imageProdukList
                                        .where((produk) =>
                                    produk.productId ==
                                        pesananController
                                            .pesananList[index]
                                            .productId);
                                    return Container(
                                      width: Dimensions.screenWidth,
                                      height: Dimensions.height45 * 3.5,
                                      margin: EdgeInsets.only(
                                          bottom: Dimensions.height10,
                                          top: Dimensions.height10 / 2,
                                          left: Dimensions.width20,
                                          right: Dimensions.width20),
                                      padding: EdgeInsets.all(
                                          Dimensions.height10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors
                                                  .buttonBackgroundColor),
                                          borderRadius:
                                          BorderRadius.circular(
                                              Dimensions.radius20 /
                                                  2),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: AppIcon(
                                                          icon: Icons
                                                              .shopping_bag_outlined,
                                                          iconSize: Dimensions
                                                              .iconSize24,
                                                          iconColor:
                                                          AppColors
                                                              .redColor,
                                                          backgroundColor:
                                                          Colors.white
                                                              .withOpacity(
                                                              0.0),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          BigText(
                                                            text:
                                                            "Belanja",
                                                            size: Dimensions
                                                                .font16,
                                                          ),
                                                          SmallText(
                                                              text: pesananController
                                                                  .pesananList[
                                                              index]
                                                                  .name
                                                                  .toString()),
                                                          Container(
                                                              height: Dimensions
                                                                  .height20,
                                                              padding: EdgeInsets.only(
                                                                  right: Dimensions
                                                                      .width10,
                                                                  left: Dimensions
                                                                      .width10),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions.radius30),
                                                                color: AppColors
                                                                    .notification_success
                                                                    .withOpacity(
                                                                    0.3),
                                                              ),
                                                              child:
                                                              Center(
                                                                child: BigText(
                                                                    text: pesananController
                                                                        .pesananList[
                                                                    index]
                                                                        .statusPembelian
                                                                        .toString(),
                                                                    size: Dimensions.font16 /
                                                                        1.5,
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
                                                    text: pesananController
                                                        .pesananList[
                                                    index]
                                                        .createdAt
                                                        .toString() ??
                                                        'N/A',
                                                    size: Dimensions
                                                        .font20 /
                                                        1.5,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(
                                              color: AppColors
                                                  .buttonBackgroundColor),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          var produkIndex =
                                                          pesananController
                                                              .pesananList[
                                                          index]
                                                              .productId!;
                                                          if (produkIndex >=
                                                              0) {
                                                            Get.toNamed(RouteHelper
                                                                .getProdukDetail(
                                                                produkIndex));
                                                          }
                                                        },
                                                        child: Container(
                                                          width: Dimensions
                                                              .height20 *
                                                              3,
                                                          height: Dimensions
                                                              .height20 *
                                                              3,
                                                          margin: EdgeInsets.only(
                                                              top: Dimensions
                                                                  .height10),
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: NetworkImage(
                                                                    '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                                                  )),
                                                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions
                                                            .width20,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            width: Dimensions
                                                                .screenWidth /
                                                                1.6,
                                                            child:
                                                            BigText(
                                                              text: pesananController
                                                                  .pesananList[
                                                              index]
                                                                  .productName,
                                                              size: Dimensions
                                                                  .font16,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              SmallText(
                                                                  text:
                                                                  "${pesananController.pesananList[index].jumlahPembelianProduk} x "),
                                                              PriceText(
                                                                text: CurrencyFormat.convertToIdr(
                                                                    pesananController
                                                                        .pesananList[index]
                                                                        .price,
                                                                    0),
                                                                size: Dimensions
                                                                    .font16,
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
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SmallText(
                                                              text:
                                                              "Total Belanja"),
                                                          PriceText(
                                                            text: CurrencyFormat.convertToIdr(
                                                                pesananController
                                                                    .pesananList[
                                                                index]
                                                                    .hargaPembelian,
                                                                0),
                                                            size: Dimensions
                                                                .font16,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _getDetailPesananList(
                                                        pesananController
                                                            .pesananList[
                                                        index]
                                                            .purchaseId);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: Dimensions
                                                            .height10 /
                                                            2,
                                                        bottom: Dimensions
                                                            .height10 /
                                                            2,
                                                        left: Dimensions
                                                            .height10,
                                                        right: Dimensions
                                                            .height10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .redColor),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            Dimensions.radius20 /
                                                                2),
                                                        color:
                                                        Colors.white),
                                                    child: BigText(
                                                      text:
                                                      "Lihat Detail",
                                                      size: Dimensions
                                                          .iconSize16,
                                                      color: AppColors
                                                          .redColor,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))
                                  : GridView.builder(
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisExtent:
                                      Dimensions.height45 * 5.5),
                                  itemCount: _list.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var gambarproduk = Get.find<
                                        PopularProdukController>()
                                        .imageProdukList
                                        .where((produk) =>
                                    produk.productId ==
                                        _list[index].productId);
                                    return Container(
                                      width: Dimensions.screenWidth,
                                      height: Dimensions.height45 * 3.5,
                                      margin: EdgeInsets.only(
                                          bottom: Dimensions.height10,
                                          top: Dimensions.height10 / 2,
                                          left: Dimensions.width20,
                                          right: Dimensions.width20),
                                      padding: EdgeInsets.all(
                                          Dimensions.height10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors
                                                  .buttonBackgroundColor),
                                          borderRadius:
                                          BorderRadius.circular(
                                              Dimensions.radius20 /
                                                  2),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: AppIcon(
                                                          icon: Icons
                                                              .shopping_bag_outlined,
                                                          iconSize: Dimensions
                                                              .iconSize24,
                                                          iconColor:
                                                          AppColors
                                                              .redColor,
                                                          backgroundColor:
                                                          Colors.white
                                                              .withOpacity(
                                                              0.0),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          BigText(
                                                            text:
                                                            "Belanja",
                                                            size: Dimensions
                                                                .font16,
                                                          ),
                                                          SmallText(
                                                              text: _list[
                                                              index]
                                                                  .name
                                                                  .toString()),
                                                          Container(
                                                              height: Dimensions
                                                                  .height20,
                                                              padding: EdgeInsets.only(
                                                                  right: Dimensions
                                                                      .width10,
                                                                  left: Dimensions
                                                                      .width10),
                                                              decoration:
                                                              BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions.radius30),
                                                                color: AppColors
                                                                    .notification_success
                                                                    .withOpacity(
                                                                    0.3),
                                                              ),
                                                              child:
                                                              Center(
                                                                child: BigText(
                                                                    text: _list[index]
                                                                        .statusPembelian
                                                                        .toString(),
                                                                    size: Dimensions.font16 /
                                                                        1.5,
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
                                                    text: _list[index]
                                                        .createdAt
                                                        .toString() ??
                                                        'N/A',
                                                    size: Dimensions
                                                        .font20 /
                                                        1.5,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(
                                              color: AppColors
                                                  .buttonBackgroundColor),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        // onTap: () {
                                                        //   // Memastikan list tidak kosong dan index valid
                                                        //   if (_list.isNotEmpty && index >= 0 && index < _list.length) {
                                                        //     var produkIndex = _list[index].productId;
                                                        //     // Memeriksa apakah productId tidak null
                                                        //     if (produkIndex != null) {
                                                        //       Get.toNamed(RouteHelper.getProdukDetail(produkIndex));
                                                        //     } else {
                                                        //       print('Product ID is null!');
                                                        //     }
                                                        //   } else {
                                                        //     print('List is empty or invalid index!');
                                                        //   }
                                                        // },
                                                        child: Container(
                                                          width: Dimensions.height20 * 3,
                                                          height: Dimensions.height20 * 3,
                                                          margin: EdgeInsets.only(top: Dimensions.height10),
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                                              ),
                                                            ),
                                                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions.width20,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                              SmallText(text: "${_list[index].jumlahPembelianProduk} x "),
                                                              PriceText(
                                                                text: CurrencyFormat.convertToIdr(_list[index].price, 0),
                                                                size: Dimensions.font16,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: Dimensions.height10,
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SmallText(
                                                              text:
                                                              "Total Belanja"),
                                                          PriceText(
                                                            text: CurrencyFormat
                                                                .convertToIdr(
                                                                _list[index]
                                                                    .hargaPembelian,
                                                                0),
                                                            size: Dimensions
                                                                .font16,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _getDetailPesananList(
                                                        _list[index]
                                                            .purchaseId);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: Dimensions
                                                            .height10 /
                                                            2,
                                                        bottom: Dimensions
                                                            .height10 /
                                                            2,
                                                        left: Dimensions
                                                            .height10,
                                                        right: Dimensions
                                                            .height10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .redColor),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            Dimensions.radius20 /
                                                                2),
                                                        color:
                                                        Colors.white),
                                                    child: BigText(
                                                      text:"Lihat Detail",
                                                      size: Dimensions.iconSize16,
                                                      color: AppColors.redColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                // Tombol "Beri Ulasan" (jika status == "Berhasil" dan productId tidak null)
                                                GetBuilder<ReviewController>(
                                                  builder: (reviewController) {
                                                    // Debugging - untuk memastikan nilai statusPesanan
                                                    print("Status Pesanan: ${pesananController.pesananList[index].statusPembelian}");

// Kondisi untuk menampilkan tombol "Beri Ulasan"
                                                    if (pesananController.pesananList[index].statusPembelian?.trim() == "Berhasil" &&
                                                        pesananController.pesananList[index].productId != null &&
                                                        !reviewController.reviewedProductIds.contains(pesananController.pesananList[index].productId)) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                            ),
                                                            isScrollControlled: true,
                                                            builder: (context) {
                                                              return UlasanForm(
                                                                productId: pesananController.pesananList[index].productId!,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions.height10,
                                                            vertical: Dimensions.height10 / 2,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: AppColors.redColor),
                                                            borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                                                            color: Colors.white,
                                                          ),
                                                          child: BigText(
                                                            text: "Beri Ulasan",
                                                            size: Dimensions.iconSize16,
                                                            color: AppColors.redColor,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return SizedBox.shrink();
                                                    }
                                                  },
                                                )

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            })
                      ],
                    ),
                    SizedBox(height: Dimensions.height10)
                  ],
                ),
              ),
            )
          ],
        ),
        onRefresh: () async {
          await Get.find<PesananController>().getPesanan();
          setState(() {
            _list = Get.find<PesananController>().pesananList.toList();
          });
        },
      )
          : MainAccountPage(),
    );
  }
}
