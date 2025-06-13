import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/models/cart_models.dart';
import 'package:rumah_kreatif_toba/pages/pembelian/pembelian_page.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';

import '../../base/snackbar_message.dart';
import '../../controllers/alamat_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utils/app_constants.dart';
import '../../widgets/currency_format.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  bool? allChecked = false;
  bool? isChecked = false;
  Map<String, bool> map = {};
  late bool _cekKeranjang;

  @override
  void initState() {
    super.initState();
    var controller = Get.find<CartController>();
    controller.getKeranjangList();
    allChecked = false;
    map = Map.fromIterable(
      Get.find<CartController>()
          .merchantKeranjangList
          .where((item) => item.namaMerchant != null),
      key: (item) => item.namaMerchant,
      value: (item) => false,
    );
    _cekKeranjang = Get.find<CartController>().keranjangList.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _cekKeranjang = Get.find<CartController>().keranjangList.isEmpty;

    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
    }

    Future<void> _hapusKeranjang(int cart_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<CartController>();
        controller.hapusKeranjang(cart_id).then((status) async {
          if (status.isSuccess) {
            AwesomeSnackbarButton(
                "Berhasil",
                "Produk berhasil ditambahkan ke keranjang",
                ContentType.success);
            await controller.getKeranjangList();
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
        controller.getKeranjangList();
      }
    }

    Future<void> _kurangKeranjang(int cart_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<CartController>();
        controller.kurangKeranjang(cart_id).then((status) async {
          if (status.isSuccess) {
            await controller.getKeranjangList();
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
        controller.getKeranjangList();
      }
    }

    Future<void> _jumlahKeranjang(int cart_id) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        final controller = Get.find<CartController>();
        controller.jumlahKeranjang(cart_id).then((status) async {
          if (status.isSuccess) {
            await controller.getKeranjangList();
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
        controller.getKeranjangList();
      }
    }

    Future<void> _getProdukList(int product_id) async {
      var controller = Get.find<PopularProdukController>();
      controller.detailProduk(product_id).then((status) async {});
    }

    return Scaffold(
      body: !_cekKeranjang
          ? Container(
        padding: EdgeInsets.all(Dimensions.font16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(RouteHelper.getInitial());
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
                    width: Dimensions.width10,
                  ),
                  BigText(
                    text: "Keranjang",
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            Expanded(
              child:
              GetBuilder<CartController>(builder: (cartController) {
                var _keranjangList = cartController.keranjangList;
                var groupedKeranjangList = <String, List<CartModel>>{};

                // Group items by merchant name
                for (var item in _keranjangList) {
                  var merchantName = item.namaMerchant!;
                  if (groupedKeranjangList[merchantName] == null) {
                    groupedKeranjangList[merchantName] = [item];
                  } else {
                    groupedKeranjangList[merchantName]!.add(item);
                  }
                }

                return ListView.builder(
                    itemCount: groupedKeranjangList.length,
                    itemBuilder: (_, merchantIndex) {
                      var merchantName = groupedKeranjangList.keys
                          .elementAt(merchantIndex);
                      var merchantItems =
                      groupedKeranjangList[merchantName]!;
                      double totalperToko() {
                        double total = 0.0;
                        for (final item in merchantItems) {
                          if (item.price != null &&
                              item.jumlahMasukKeranjang != null) {
                            total +=
                                item.price! * item.jumlahMasukKeranjang!;
                          }
                        }
                        return total;
                      }

                      return Container(
                        margin:
                        EdgeInsets.only(bottom: Dimensions.height10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BigText(
                                  text: merchantName,
                                  size: Dimensions.font16,
                                ),
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: merchantItems.length,
                                itemBuilder: (_, index) {
                                  CartModel item = merchantItems[index];

                                  var gambarproduk =
                                  Get.find<PopularProdukController>()
                                      .imageProdukList
                                      .where((produk) =>
                                  produk.productId ==
                                      item.productId);

                                  return Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: Dimensions.screenWidth /
                                              1.2,
                                          height: Dimensions.height45 * 4,
                                          margin: EdgeInsets.only(
                                              right:
                                              Dimensions.width10 / 2,
                                              left:
                                              Dimensions.width10 / 2,
                                              bottom:
                                              Dimensions.height10 / 2,
                                              top: Dimensions.height10 /
                                                  2),
                                          padding: EdgeInsets.only(
                                              left: Dimensions.width10,
                                              right: Dimensions.width10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors
                                                      .buttonBackgroundColor),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  Dimensions
                                                      .radius20 /
                                                      4),
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      var produkIndex =
                                                      item.productId!;
                                                      if (produkIndex >=
                                                          0) {
                                                        _getProdukList(item
                                                            .productId!);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: Dimensions
                                                          .height20 *
                                                          4,
                                                      height: Dimensions
                                                          .height20 *
                                                          4,
                                                      margin: EdgeInsets.only(
                                                          top: Dimensions
                                                              .height10),
                                                      decoration:
                                                      BoxDecoration(
                                                          image:
                                                          DecorationImage(
                                                              fit: BoxFit
                                                                  .cover,
                                                              image:
                                                              NetworkImage(
                                                                '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.single.productImageName}',
                                                              )),
                                                          borderRadius:
                                                          BorderRadius.circular(Dimensions
                                                              .radius20),
                                                          color: Colors
                                                              .white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .width10),
                                                  ExcludeFocus(
                                                    child: Container(
                                                      height: Dimensions
                                                          .height20 *
                                                          5,
                                                      width: Dimensions
                                                          .width45 *
                                                          3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: [
                                                          BigText(
                                                            text: item
                                                                .productName!,
                                                            size: Dimensions
                                                                .font26 /
                                                                1.5,
                                                          ),
                                                          PriceText(
                                                            text: CurrencyFormat
                                                                .convertToIdr(
                                                                item.price,
                                                                0),
                                                            size: Dimensions
                                                                .font16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _hapusKeranjang(
                                                          item.cartId!);
                                                    },
                                                    child: AppIcon(
                                                        iconSize: Dimensions
                                                            .iconSize24,
                                                        iconColor:
                                                        AppColors
                                                            .redColor,
                                                        backgroundColor:
                                                        Colors.white,
                                                        icon:
                                                        Icons.delete),
                                                  ),
                                                  Container(
                                                    width: Dimensions
                                                        .width45 *
                                                        3,
                                                    padding: EdgeInsets.only(
                                                        left: Dimensions
                                                            .width10,
                                                        right: Dimensions
                                                            .width10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .buttonBackgroundColor),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radius20),
                                                        color:
                                                        Colors.white),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            //produk.setQuantity(false);
                                                            //cartController.addItem(_keranjangList[index].produk!, -1);
                                                            _kurangKeranjang(
                                                                item.cartId!);
                                                          },
                                                          child: AppIcon(
                                                              iconSize:
                                                              Dimensions
                                                                  .iconSize24,
                                                              iconColor:
                                                              AppColors
                                                                  .redColor,
                                                              backgroundColor:
                                                              Colors
                                                                  .white,
                                                              icon: Icons
                                                                  .remove),
                                                        ),
                                                        BigText(
                                                          text: item
                                                              .jumlahMasukKeranjang
                                                              .toString(),
                                                          size: Dimensions
                                                              .font26 /
                                                              1.5,
                                                        ), //produk.inCartItems.toString()),
                                                        GestureDetector(
                                                          onTap: () {
                                                            //cartController.addItem(_keranjangList[index].produk!, 1);
                                                            _jumlahKeranjang(
                                                                item.cartId!);
                                                          },
                                                          child: AppIcon(
                                                              iconSize:
                                                              Dimensions
                                                                  .iconSize24,
                                                              iconColor:
                                                              AppColors
                                                                  .redColor,
                                                              backgroundColor:
                                                              Colors
                                                                  .white,
                                                              icon: Icons
                                                                  .add),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: Dimensions.height45 * 2,
                                  padding: EdgeInsets.only(
                                      left: Dimensions.width20,
                                      right: Dimensions.width20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: Dimensions.width20,
                                              right: Dimensions.width20),
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //     color: AppColors
                                            //         .buttonBackgroundColor),
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.radius20),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              BigText(
                                                text: "Total Harga",
                                                size: Dimensions.font16 /
                                                    1.5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: Dimensions
                                                        .width10 /
                                                        2,
                                                  ),
                                                  PriceText(
                                                    text: CurrencyFormat
                                                        .convertToIdr(
                                                        totalperToko(),
                                                        0),
                                                    size:
                                                    Dimensions.font16,
                                                  ),
                                                  SizedBox(
                                                    width: Dimensions
                                                        .width10 /
                                                        2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: Dimensions.height10,
                                            bottom: Dimensions.height10,
                                            left: Dimensions.width20,
                                            right: Dimensions.width20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.radius20 /
                                                    4),
                                            color: AppColors.redColor),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                cartController
                                                    .checkedCartIds
                                                    .clear();
                                                for (var item
                                                in merchantItems) {
                                                  cartController
                                                      .checkedCartIds
                                                      .add(
                                                      item.productId);
                                                }
                                              });
                                              Get.to(
                                                PembelianPageState(),
                                              );
                                              Get.find<AlamatController>()
                                                  .getAlamatMerchant(
                                                  merchantItems[
                                                  merchantIndex]
                                                      .merchantId);
                                            },
                                            child: Row(children: [
                                              BigText(
                                                text: "Checkout",
                                                color: Colors.white,
                                                size: Dimensions.height15,
                                              ),
                                            ])),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColors.buttonBackgroundColor,
                              thickness: 2.0,
                            ),
                          ],
                        ),
                      );
                    });
              }),
            )
          ],
        ),
      )
          : Stack(
        children: [
          Positioned(
            top: Dimensions.height30,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.toNamed(RouteHelper.getInitial());
                    Get.back();
                  },
                  child: AppIcon(
                    icon: Icons.arrow_back,
                    iconColor: AppColors.redColor,
                    backgroundColor: Colors.white,
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                SizedBox(
                  width: Dimensions.width20,
                ),
                BigText(
                  text: "Keranjang",
                  size: Dimensions.font20,
                ),
              ],
            ),
          ),
          Positioned(
            top: Dimensions.height30 * 5,
            left: Dimensions.width20,
            right: Dimensions.width20,
            bottom: 0,
            child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: Dimensions.height45 * 5,
                        width: Dimensions.width45 * 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.radius15)),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    "assets/images/keranjang_kosong.png"))),
                      ),
                      BigText(text: "Keranjang Kosong! Ayo belanja sekarang")
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  void onMerchantClicked(String merchantName, bool value) {
    var controller = Get.find<CartController>();
    var merchantItems = controller.merchantKeranjangList.firstWhere(
          (element) => element.namaMerchant == merchantName,
      orElse: () => null,
    );
    if (merchantItems != null) {
      for (var item in merchantItems.items) {
        item.isChecked = value;
      }
    }
  }

  void onItemClicked(String merchantName, CartModel item, bool value) {
    var controller = Get.find<CartController>();
    var merchantItems = controller.merchantKeranjangList.firstWhere(
          (element) => element.namaMerchant == merchantName,
      orElse: () => null,
    );
    if (merchantItems != null) {
      var currentItem = merchantItems.items.firstWhere(
            (element) => element.id == item.id,
        orElse: () => null,
      );
      if (currentItem != null) {
        currentItem.isChecked = value ?? false;
      }
    }
  }

  onAllClicked(ckbItem) {
    final newValue = ckbItem;
    setState(() {
      ckbItem = newValue;
      // checkBoxList.forEach((element){
      //   element.value = newValue;
      // });
      allChecked = ckbItem ?? false;
      print(allChecked);
    });
  }

// onItemClicked(CheckBoxModal ckbItem){
//   final newValue = !ckbItem.value;
//   setState(() {
//     ckbItem.value = newValue;
//
//     if(!newValue){
//       allChecked.value = false;
//     }else{
//       final allListChecked = checkBoxList.every((element) => element.value);
//       allChecked.value = allListChecked;
//     }
//   });
// }
}

class CheckBoxModal {
  String title;
  bool value;

  CheckBoxModal({required this.title, this.value = false});
}
