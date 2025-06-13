import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/categories_controller.dart';
import 'package:rumah_kreatif_toba/pages/toko/produk/tambahproduk_page.dart';
import 'package:rumah_kreatif_toba/pages/toko/produk/ubahproduk_page.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';
import 'package:get/get.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/popular_produk_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/currency_format.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  void initState() {
    super.initState();
    // Panggil data produk dan kategori sekali saat init
    Get.find<PopularProdukController>().getProdukList();
    Get.find<CategoriesController>().getKategoriList();
  }

  Future<void> _kategorilist() async {
    var controller = Get.find<CategoriesController>();
    await controller.getKategoriList();
    Get.to(() => TambahProdukPage());
  }

  Future<void> _hapusProduk(int product_id) async {
    var cartController = Get.find<PopularProdukController>();
    var status = await cartController.hapusProduk(product_id);
    if (!status.isSuccess) {
      AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
    }
  }

  Future<void> _detailProdukList(int product_id) async {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      var controller = Get.find<PopularProdukController>();
      var status = await controller.detailProduk(product_id);
      if (status.isSuccess) {
        Get.to(() => UbahProdukPage());
      } else {
        AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _cekProduk = Get.find<PopularProdukController>().daftarProdukList.isEmpty;

    return RefreshIndicator(
      onRefresh: () => Get.find<PopularProdukController>().getProdukList(),
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 7,
        radius: const Radius.circular(20),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
                horizontal: Dimensions.width20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daftar Produk",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font20,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: _kategorilist,
                    child: Icon(
                      Icons.add,
                      color: AppColors.redColor,
                    ),
                  ),
                ],
              ),
            ),
            !_cekProduk
                ? GetBuilder<PopularProdukController>(
              builder: (controller) {
                return Obx(
                      () => controller.isLoaded
                      ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.daftarProdukList.length,
                    itemBuilder: (_, index) {
                      var gambarproduk = controller.imageProdukList.where(
                            (produk) =>
                        produk.productId ==
                            controller.daftarProdukList[index].productId,
                      );

                      if (gambarproduk.isEmpty) {
                        return const SizedBox();
                      }

                      final produk = controller.daftarProdukList[index];
                      final gambar = gambarproduk.single;

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height10,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(Dimensions.radius20 / 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimensions.height20 * 4,
                              height: Dimensions.height20 * 4,
                              margin: EdgeInsets.only(right: Dimensions.width10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20),
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${gambar.productImageName}',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    produk.productName.toString(),
                                    style: TextStyle(
                                      fontSize: Dimensions.font20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  PriceText(
                                    text: CurrencyFormat.convertToIdr(
                                      produk.price,
                                      0,
                                    ),
                                    color: AppColors.redColor,
                                    size: Dimensions.font16,
                                  ),
                                  Text(
                                    "Stok : ${produk.stok.toString()}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<int>(
                              onSelected: (value) {
                                if (value == 1) {
                                  _detailProdukList(produk.productId);
                                } else if (value == 2) {
                                  _hapusProduk(produk.productId);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 1,
                                  child: Text('Ubah'),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text('Hapus'),
                                ),
                              ],
                              offset: const Offset(0, 40),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.more_vert_outlined),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                      : SizedBox(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                );
              },
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.height45 * 3),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: Dimensions.height45 * 5,
                        width: Dimensions.width45 * 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimensions.radius15),
                          ),
                          image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/produk_kosong.png"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Produk Kosong! Ayo tambah produk sekarang",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
          ],
        ),
      ),
    );
  }
}
