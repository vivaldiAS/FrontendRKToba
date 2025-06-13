import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../base/show_custom_message.dart';
import '../../base/snackbar_message.dart';
import '../../controllers/alamat_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/pengiriman_controller.dart';
import '../../controllers/popular_produk_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/alamat_model.dart';
import '../../models/courier_models.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';
import '../../widgets/pengiriman_option_button.dart';
import '../../widgets/price_text.dart';

class BeliLangsungPage extends StatefulWidget {
  const BeliLangsungPage({Key? key}) : super(key: key);

  @override
  State<BeliLangsungPage> createState() => _BeliLangsungPageState();
}

class _BeliLangsungPageState extends State<BeliLangsungPage> {
  AlamatController controller = Get.find<AlamatController>();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PengirimanController(pengirimanRepo: Get.find()));
    Get.put(() => PengirimanController(pengirimanRepo: Get.find()));

    Future<void> _beliLangsung(
      int productId, int jumlahMasukKeranjang, int hargapembelian) async {
      bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
      if (_userLoggedIn) {
        var controller = Get.find<PengirimanController>();
        var userController = Get.find<UserController>().usersList[0];
        var courier = Get.find<AlamatController>().kurir.value;
        var service = Get.find<AlamatController>().service.value;
        var alamat = Get.find<AlamatController>().alamatID.value;
        var ongkir = Get.find<AlamatController>().HargaPengiriman.value;

        if (controller.paymentIndex.value == 1) {
          controller
              .beliLangsung(
                  userController.id,
                  productId,
                  Get.find<PengirimanController>().paymentIndex.value,
                  jumlahMasukKeranjang,
                  hargapembelian,
                  "",
                  0,
                  "",
                  "",
                  0)
              .then((status) async {
            if (status.isSuccess) {
            } else {
              showCustomSnackBar(status.message);
            }
          });
        } else if (controller.paymentIndex.value == 2) {
          if (alamat == 0) {
            AwesomeSnackbarButton(
                "Gagal", "Alamat masih kosong", ContentType.failure);
          } else if (courier == 0) {
            AwesomeSnackbarButton(
                "Gagal", "Courir masih kosong", ContentType.failure);
          } else if (service == null) {
            AwesomeSnackbarButton(
                "Gagal", "Service masih kosong", ContentType.failure);
          } else if (ongkir == null) {
            AwesomeSnackbarButton(
                "Gagal", "Ongkos kirim masih kosong", ContentType.failure);
          } else {
            controller
                .beliLangsung(
                    userController.id,
                    productId,
                    Get.find<PengirimanController>().paymentIndex.value,
                    jumlahMasukKeranjang,
                    hargapembelian,
                    "",
                    alamat,
                    courier,
                    service,
                    ongkir)
                .then((status) async {
              if (status.isSuccess) {
              } else {
                showCustomSnackBar(status.message);
              }
            });
          }
        }
      }
    }

    void ongkosKirim(address_id, destination_id, berat, kurir) async {
      controller.showButton();
      Uri url = Uri.parse("https://pro.rajaongkir.com/api/cost");
      if (controller.cityUserId.value == "0") {
        AwesomeSnackbarButton(
            "Gagal",
            "Alamat pengiriman masih kosong. Silahkan pilih alamat pengiriman",
            ContentType.failure);
      } else {
        try {
          print("tes ${controller.cityUserId}");
          print("tes ini ${controller.cityTujuanId.value}");
          print("berat ${controller.berat}");
          print("kurir ${controller.kurir}");
          final response = await http.post(
            url,
            body: {
              "origin": "${controller.cityTujuanId}",
              "originType": "city",
              "destination": "${controller.cityUserId.value}",
              "destinationType": "subdistrict",
              "weight": "${controller.berat}",
              "courier": "${controller.kurir}",
            },
            headers: {
              "key": "41df939eff72c9b050a81d89b4be72ba",
              "content-type": "application/x-www-form-urlencoded"
            },
          );

          var data = jsonDecode(response.body) as Map<String, dynamic>;
          var results = data["rajaongkir"]["results"] as List<dynamic>;
          var listAllCourier = Courier.fromJsonList(results);
          var courier = listAllCourier[0];
          Get.defaultDialog(
            title: courier.name!,
            content: Column(
              children: courier.costs!
                  .map((e) => GestureDetector(
                        child: ListTile(
                          title: Text("${e.service}"),
                          subtitle: PriceText(
                            text: CurrencyFormat.convertToIdr(
                                e.cost![0].value, 0),
                            size: Dimensions.font16,
                          ),
                          trailing: Text(courier.code == "pos"
                              ? "${e.cost![0].etd}"
                              : "${e.cost![0].etd} HARI"),
                        ),
                        onTap: () {
                          controller.setHargaPengiriman(e.cost![0].value);
                          controller.setServicePengiriman(e.service);
                          print(Get.find<AlamatController>().alamatID.value);
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          );
        } catch (err) {
          Get.defaultDialog(
            title: "Eror",
          );
        }
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
                        backgroundColor: Colors.white,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.width20,
                    ),
                    BigText(
                      text: "Beli Langsung",
                      size: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height30,
                    left: Dimensions.width20,
                    right: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Alamat Pengiriman",
                      size: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.getAlamat();
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                  width: Dimensions.screenWidth,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius20 / 4),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[200]!,
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  padding: EdgeInsets.only(
                                      top: Dimensions.height30,
                                      left: Dimensions.width20,
                                      right: Dimensions.width20),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: AppIcon(
                                            icon: CupertinoIcons.xmark,
                                            size: Dimensions.iconSize24,
                                            iconColor: AppColors.redColor,
                                            backgroundColor:
                                                Colors.white.withOpacity(0.0),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimensions.width20,
                                        ),
                                        BigText(
                                          text: "Pilih Alamat",
                                          size: Dimensions.font26,
                                        ),
                                      ]),
                                      Divider(
                                          color:
                                              AppColors.buttonBackgroundColor),
                                      Obx(
                                        () => Container(
                                          height: 300,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .daftarAlamatList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Alamat alamat = controller
                                                  .daftarAlamatList[index];
                                              return Container(
                                                height: 120,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimensions.width20,
                                                  vertical: Dimensions.height20,
                                                ),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                      .radius20 /
                                                                  4),
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .grey[200]!,
                                                              blurRadius: 5,
                                                              spreadRadius: 1,
                                                            ),
                                                          ],
                                                        ),
                                                        child: GetBuilder<
                                                                AlamatController>(
                                                            builder:
                                                                (alamatController) {
                                                          return ListTile(
                                                            title: Text(
                                                              "Alamat ${index + 1}",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    Dimensions
                                                                        .font20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            subtitle: Text(
                                                              "${alamat.user_street_address?.toString() ?? ""}, ${alamat.city_name?.toString() ?? ""}, ${alamat.province_name?.toString() ?? ""}",
                                                            ),
                                                            trailing: Radio(
                                                              value:
                                                                  "${alamat.user_street_address?.toString() ?? ""}, ${alamat.city_name?.toString() ?? ""}, ${alamat.province_name?.toString() ?? ""}",
                                                              groupValue:
                                                                  controller
                                                                      .selected
                                                                      .value,
                                                              onChanged: (String?
                                                                      value) =>
                                                                  {
                                                                controller
                                                                    .setTypeAlamat(
                                                                        value!),
                                                                controller.setId(
                                                                    alamat
                                                                        .user_address_id),
                                                                controller
                                                                        .cityUserId
                                                                        .value =
                                                                    alamat
                                                                        .city_id
                                                                        .toString()!,
                                                              },
                                                              activeColor: Theme
                                                                      .of(context)
                                                                  .primaryColor,
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Row(
                        children: [
                          BigText(
                            text: "Pilih Alamat Lain",
                            size: Dimensions.font16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.notification_success,
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
              Divider(color: AppColors.buttonBackgroundColor),
              Obx(() => BigText(
                    text: controller.selected.value.toString(),
                    size: 15,
                  )),
              Divider(color: AppColors.buttonBackgroundColor),
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
                            text: "Barang yang dibeli",
                            size: Dimensions.font20,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    GetBuilder<CartController>(builder: (cartController) {
                      var _beliList = cartController.getItems;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: cartController.getItems.length,
                          itemBuilder: (_, index) {
                            var gambarproduk =
                                Get.find<PopularProdukController>()
                                    .imageProdukList
                                    .where((produk) =>
                                        produk.productId ==
                                        cartController
                                            .getItems[index].productId);
                            controller.berat.value =
                                cartController.getItems[index].heavy ?? 0;
                            controller.cityTujuanId.value = cartController
                                .getItems[index].cityId
                                .toString();
                            return Container(
                              width: Dimensions.screenWidth / 1.2,
                              height: Dimensions.height45 * 4,
                              margin: EdgeInsets.only(
                                  right: Dimensions.width10 / 2,
                                  left: Dimensions.width10 / 2,
                                  bottom: Dimensions.height10 / 2,
                                  top: Dimensions.height10 / 2),
                              padding: EdgeInsets.only(
                                  left: Dimensions.width10,
                                  right: Dimensions.width10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.buttonBackgroundColor),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: Dimensions.height20 * 4,
                                          height: Dimensions.height20 * 4,
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
                                      SizedBox(width: Dimensions.width10),
                                      ExcludeFocus(
                                        child: Container(
                                          height: Dimensions.height20 * 5,
                                          width: Dimensions.width45 * 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BigText(
                                                text: cartController
                                                    .getItems[index]
                                                    .productName!,
                                                size: Dimensions.font26 / 1.5,
                                              ),
                                              PriceText(
                                                text:
                                                    CurrencyFormat.convertToIdr(
                                                        cartController
                                                            .getItems[index]!
                                                            .price,
                                                        0),
                                                size: Dimensions.font16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: Dimensions.width45 * 3,
                                        padding: EdgeInsets.only(
                                            left: Dimensions.width10,
                                            right: Dimensions.width10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors
                                                    .buttonBackgroundColor),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20),
                                            color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                cartController.addItem(
                                                    _beliList[index].produk!,
                                                    -1);
                                              },
                                              child: AppIcon(
                                                  iconSize:
                                                      Dimensions.iconSize24,
                                                  iconColor: AppColors.redColor,
                                                  backgroundColor: Colors.white,
                                                  icon: Icons.remove),
                                            ),
                                            BigText(
                                              text: _beliList[index]
                                                  .jumlahMasukKeranjang
                                                  .toString(),
                                              size: Dimensions.font26 / 1.5,
                                            ), //produk.inCartItems.toString()),
                                            GestureDetector(
                                              onTap: () {
                                                cartController.addItem(
                                                    _beliList[index].produk!,
                                                    1);
                                              },
                                              child: AppIcon(
                                                  iconSize:
                                                      Dimensions.iconSize24,
                                                  iconColor: AppColors.redColor,
                                                  backgroundColor: Colors.white,
                                                  icon: Icons.add),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
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
                            text: "Rincian Pengiriman",
                            size: Dimensions.font20,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    Divider(color: AppColors.buttonBackgroundColor),
                    Container(
                      padding: EdgeInsets.only(
                          top: Dimensions.height10,
                          bottom: Dimensions.height10,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      margin: EdgeInsets.only(
                          top: Dimensions.height10,
                          bottom: Dimensions.height20),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.redColor),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20 / 2),
                          color: Colors.white),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return LayoutBuilder(builder:
                                    (BuildContext context,
                                        BoxConstraints constraints) {
                                  return SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight),
                                      child: IntrinsicHeight(
                                        child: Container(
                                          height: Dimensions.screenHeight / 2,
                                          width: Dimensions.screenWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  Dimensions.radius20),
                                              topRight: Radius.circular(
                                                  Dimensions.radius20),
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                              top: Dimensions.height30,
                                              left: Dimensions.width20,
                                              right: Dimensions.width20),
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: AppIcon(
                                                    icon: CupertinoIcons.xmark,
                                                    size: Dimensions.iconSize24,
                                                    iconColor:
                                                        AppColors.redColor,
                                                    backgroundColor: Colors
                                                        .white
                                                        .withOpacity(0.0),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Dimensions.width20,
                                                ),
                                                BigText(
                                                  text: "Pilih Pengiriman",
                                                  size: Dimensions.font26,
                                                ),
                                              ]),
                                              Divider(
                                                  color: AppColors
                                                      .buttonBackgroundColor),
                                              Column(
                                                children: [
                                                  PengirimanOptionButton(
                                                    icon: Icons.money,
                                                    title: 'Ambil Ditempat Rp0',
                                                    index: 1,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimensions.height10),
                                                  PengirimanOptionButton(
                                                    icon: Icons.money,
                                                    title: 'Pesanan Dikirim',
                                                    index: 2,
                                                  ),
                                                  Obx(
                                                    () =>
                                                        Get.find<PengirimanController>()
                                                                    .paymentIndex
                                                                    .value ==
                                                                2
                                                            ? Visibility(
                                                                visible:
                                                                    true, // Set visibility to true when index is 2
                                                                child: Column(
                                                                  children: [
                                                                    DropdownSearch<
                                                                        Map<String,
                                                                            dynamic>>(
                                                                      mode: Mode
                                                                          .MENU,
                                                                      showClearButton:
                                                                          true,
                                                                      label:
                                                                          "Tipe Kurir",
                                                                      hint:
                                                                          "Pilih tipe pengiriman...",
                                                                      showSearchBox:
                                                                          true,
                                                                      items: [
                                                                        {
                                                                          "code":
                                                                              "jne",
                                                                          "name":
                                                                              "Jalur Nugraha Ekakurir (JNE)"
                                                                        },
                                                                        {
                                                                          "code":
                                                                              "pos",
                                                                          "name":
                                                                              "Perusahaan Opsional Surat (POS Indonesia)"
                                                                        },
                                                                        {
                                                                          "code":
                                                                              "tiki",
                                                                          "name":
                                                                              "Titipan Kilat (TIKI)"
                                                                        }
                                                                      ],
                                                                      dropdownSearchDecoration:
                                                                          InputDecoration(
                                                                              labelText: "Pengiriman"),
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          controller
                                                                              .kurir
                                                                              .value = value['code'];
                                                                          controller
                                                                              .namakurir
                                                                              .value = value['name'];
                                                                          ongkosKirim(
                                                                              controller.cityAsalId,
                                                                              controller.cityTujuanId,
                                                                              controller.berat,
                                                                              controller.kurir);
                                                                        } else {
                                                                          controller
                                                                              .hiddenButton
                                                                              .value = true;
                                                                          controller
                                                                              .kurir
                                                                              .value = "";
                                                                        }
                                                                      },
                                                                      itemAsString:
                                                                          (item) =>
                                                                              "${item?['name']}",
                                                                      popupItemBuilder: (context,
                                                                              item,
                                                                              isSelected) =>
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(20),
                                                                        child:
                                                                            Text(
                                                                          "${item['name']}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Dimensions
                                                                          .height10,
                                                                    ),
                                                                    // Obx(
                                                                    //   () => controller.hiddenButton.isTrue
                                                                    //       ? SizedBox()
                                                                    //       : Row(
                                                                    //     mainAxisAlignment: MainAxisAlignment.end,
                                                                    //     children: [
                                                                    //       GestureDetector(
                                                                    //         onTap: () {
                                                                    //           ongkosKirim(controller.cityAsalId, controller.cityTujuanId, controller.berat, controller.kurir);
                                                                    //         },
                                                                    //         child: Container(
                                                                    //           width: Dimensions.width45*3,
                                                                    //           height: Dimensions.width45,
                                                                    //           // alignment: Alignment.topCenter,
                                                                    //           decoration: BoxDecoration(
                                                                    //               borderRadius: BorderRadius.circular(10),
                                                                    //               color: AppColors.redColor),
                                                                    //           child: Center(
                                                                    //             child: BigText(
                                                                    //               text: "Selanjutnya",
                                                                    //               fontWeight: FontWeight.bold,
                                                                    //               size: Dimensions.font20,
                                                                    //               color: Colors.white,
                                                                    //             ),
                                                                    //           ),
                                                                    //         ),)
                                                                    //     ],
                                                                    //   ),
                                                                    // )
                                                                  ],
                                                                ),
                                                              )
                                                            : Visibility(
                                                                visible:
                                                                    false, // Set visibility to false when index is not 2
                                                                child:
                                                                    Container(),
                                                              ),
                                                  ),
                                                  Obx(() => controller.service
                                                                  .value !=
                                                              "" &&
                                                          Get.find<PengirimanController>()
                                                                  .paymentIndex
                                                                  .value ==
                                                              2 &&
                                                          controller.namakurir
                                                                  .value !=
                                                              ""
                                                      ? Visibility(
                                                          visible: true,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: Dimensions
                                                                    .height10,
                                                              ),
                                                              BigText(
                                                                text:
                                                                    "Jenis Pengiriman",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              Container(
                                                                width: Dimensions
                                                                    .screenWidth,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: BigText(
                                                                          text:
                                                                              "Kurir"),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Container(
                                                                      width: Dimensions
                                                                              .screenWidth /
                                                                          1.4,
                                                                      child:
                                                                          BigText(
                                                                        text: controller
                                                                            .namakurir
                                                                            .value,
                                                                      ),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width: Dimensions
                                                                    .screenWidth,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: BigText(
                                                                          text:
                                                                              "Service"),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        width: Dimensions.screenWidth /
                                                                            1.4,
                                                                        child:
                                                                            BigText(
                                                                          text: controller
                                                                              .service
                                                                              .value,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width: Dimensions
                                                                    .screenWidth,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: BigText(
                                                                          text:
                                                                              "Ongkir"),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          PriceText(
                                                                        text: CurrencyFormat.convertToIdr(
                                                                            controller.HargaPengiriman.value,
                                                                            0),
                                                                        color: AppColors
                                                                            .redColor,
                                                                        size: Dimensions
                                                                            .font16,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                width: Dimensions
                                                                    .screenWidth,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: BigText(
                                                                          text:
                                                                              "Estimasi"),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          BigText(
                                                                        text: controller
                                                                            .estimasi
                                                                            .value,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: Dimensions
                                                                    .height10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          Dimensions.width45 *
                                                                              3,
                                                                      height: Dimensions
                                                                          .width45,
                                                                      // alignment: Alignment.topCenter,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          color:
                                                                              AppColors.redColor),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            BigText(
                                                                          text:
                                                                              "Selanjutnya",
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          size:
                                                                              Dimensions.font20,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ))
                                                      : Visibility(
                                                          visible:
                                                              false, // Set visibility to false when index is not 2
                                                          child: Container(),
                                                        ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AppIcon(
                                    icon: Icons.note,
                                    iconColor: AppColors.redColor,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.0),
                                  ),
                                  Obx(
                                    () => BigText(
                                      text: Get.find<PengirimanController>()
                                          .checkedtypePengiriman
                                          .value,
                                      size: Dimensions.height15,
                                    ),
                                  ),
                                ],
                              ),
                              AppIcon(
                                icon: Icons.arrow_drop_down_outlined,
                                iconColor: AppColors.redColor,
                                backgroundColor: Colors.white.withOpacity(0.0),
                              ),
                            ]),
                      ),
                    ),
                    Obx(() =>
                        Get.find<PengirimanController>().paymentIndex.value == 2
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      BigText(
                                        text: "Ongkir : ",
                                        size: Dimensions.font16,
                                      ),
                                      PriceText(
                                        text: CurrencyFormat.convertToIdr(
                                            controller.HargaPengiriman.value,
                                            0),
                                        color: AppColors.redColor,
                                        size: Dimensions.font16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: Dimensions.screenWidth / 1.3,
                                        child: BigText(
                                          text:
                                              "Pengiriman : ${controller.namakurir.value}",
                                          size: Dimensions.font16,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (cartController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: Dimensions.bottomHeightBar,
                  padding: EdgeInsets.only(
                      top: Dimensions.height10,
                      bottom: Dimensions.height10,
                      left: Dimensions.width20,
                      right: Dimensions.width20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height10,
                              bottom: Dimensions.height10,
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          height: Dimensions.height30 * 2.3,
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //     color: AppColors.buttonBackgroundColor),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white),
                          child: Column(
                            children: [
                              BigText(
                                  text: "Total Harga",
                                  size: Dimensions.height15),
                              Obx(
                                () => PriceText(
                                  text: CurrencyFormat.convertToIdr(
                                      Get.find<PengirimanController>()
                                                  .paymentIndex
                                                  .value ==
                                              2
                                          ? cartController.totalAmount +
                                              controller.HargaPengiriman
                                                  .toDouble()
                                          : cartController.totalAmount,
                                      0),
                                  size: Dimensions.font16,
                                ),
                              )
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
                                BorderRadius.circular(Dimensions.radius20),
                            color: AppColors.redColor),
                        child: GestureDetector(
                            onTap: () {
                              _beliLangsung(
                                  cartController.getItems[0]!.productId!,
                                  cartController
                                      .getItems[0].jumlahMasukKeranjang!,
                                  cartController.totalAmount.toInt());
                            },
                            child: Row(children: [
                              BigText(
                                  text: "Bayar",
                                  color: Colors.white,
                                  size: Dimensions.height15),
                            ])),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
