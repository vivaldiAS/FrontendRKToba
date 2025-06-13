import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/pembayaran/pembayaran_page.dart';

import '../../base/snackbar_message.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/pesanan_controller.dart';
import '../../controllers/popular_produk_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/currency_format.dart';
import '../../widgets/price_text.dart';
import '../../widgets/small_text.dart';
import '../home/home_page.dart';
import 'detail_pesanan_page.dart';

class MenungguPembayaranPage extends StatefulWidget {
  const MenungguPembayaranPage({Key? key}) : super(key: key);

  @override
  State<MenungguPembayaranPage> createState() => _MenungguPembayaranPageState();
}

class _MenungguPembayaranPageState extends State<MenungguPembayaranPage> {
  @override
  void initState() {
    super.initState();
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUser();
      Get.find<PesananController>().getPesananMenungguBayaranList();
    }
  }

  Map<String, List<dynamic>> groupByKodePembelian(List<dynamic> list) {
    Map<String, List<dynamic>> map = {};
    for (var item in list) {
      final kode = item.kodePembelian;
      if (!map.containsKey(kode)) {
        map[kode] = [];
      }
      map[kode]!.add(item);
    }
    return map;
  }

  Future<void> _getDetailPesanan(int purchaseId) async {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      var controller = Get.find<PesananController>();
      controller.getDetailPesananList(purchaseId).then((status) async {
        if (status.isSuccess) {
          Get.to(DetailPesananPage());
        } else {
          AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
        }
      });
    }
  }

  Future<void> _hapusPesanan(String kodePembelian) async {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      var controller = Get.find<PesananController>();
      await controller.hapusPesanan(kodePembelian);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Get.find<PesananController>().getPesananMenungguBayaranList(),
        child: GetBuilder<PesananController>(builder: (pesananController) {
          final grouped = groupByKodePembelian(pesananController.pesananMenungguPembayaranList);
          final List<String> kodeList = grouped.keys.toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Dimensions.height30),
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(HomePage(initialIndex: 3)),
                        child: AppIcon(
                          icon: Icons.arrow_back,
                          iconColor: AppColors.redColor,
                          backgroundColor: Colors.transparent,
                          iconSize: Dimensions.iconSize24,
                        ),
                      ),
                      SizedBox(width: Dimensions.width20),
                      BigText(
                        text: "Menunggu Konfirmasi",
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: kodeList.length,
                  itemBuilder: (context, index) {
                    final kode = kodeList[index];
                    final items = grouped[kode]!;
                    final firstItem = items.first;

                    return Container(
                      width: Dimensions.screenWidth,
                      margin: EdgeInsets.all(Dimensions.height10),
                      padding: EdgeInsets.all(Dimensions.height10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.buttonBackgroundColor),
                        borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  AppIcon(
                                    icon: Icons.shopping_bag_outlined,
                                    iconSize: Dimensions.iconSize24,
                                    iconColor: AppColors.redColor,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BigText(text: "Belanja", size: Dimensions.font16),
                                      SmallText(text: firstItem.name),
                                      Container(
                                        height: Dimensions.height20,
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                                          color: AppColors.notification_success.withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: BigText(
                                            text: firstItem.statusPembelian,
                                            size: Dimensions.font16 / 1.5,
                                            color: AppColors.notification_success,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _hapusPesanan(firstItem.kodePembelian),
                                child: AppIcon(
                                  icon: Icons.delete,
                                  iconColor: AppColors.redColor,
                                  backgroundColor: Colors.white,
                                  iconSize: Dimensions.iconSize24,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.buttonBackgroundColor),
                          Column(
                            children: items.map((item) {
                              var gambarproduk = Get.find<PopularProdukController>()
                                  .imageProdukList
                                  .firstWhere((p) => p.productId == item.productId, orElse: () => null);
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: Dimensions.height20 * 3,
                                      height: Dimensions.height20 * 3,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: gambarproduk != null && gambarproduk.productImageName.isNotEmpty
                                              ? NetworkImage('${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambarproduk.productImageName}')
                                              : AssetImage("assets/images/logo_rkt.png") as ImageProvider,
                                        ),
                                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BigText(text: item.productName, size: Dimensions.font16),
                                          Row(
                                            children: [
                                              SmallText(text: "${item.jumlahPembelianProduk} x "),
                                              PriceText(
                                                text: CurrencyFormat.convertToIdr(item.price, 0),
                                                size: Dimensions.font16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: Dimensions.height10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(text: "Total Belanja"),
                                  PriceText(
                                    text: CurrencyFormat.convertToIdr(firstItem.hargaPembelian + firstItem.ongkir, 0),
                                    size: Dimensions.font16,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _getDetailPesanan(firstItem.purchaseId),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.height10 / 2,
                                    horizontal: Dimensions.height10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.redColor),
                                    borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                                    color: Colors.white,
                                  ),
                                  child: BigText(
                                    text: "Lihat Detail",
                                    size: Dimensions.iconSize16,
                                    color: AppColors.redColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
