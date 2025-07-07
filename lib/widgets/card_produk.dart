import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'package:rumah_kreatif_toba/widgets/tittle_text.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'currency_format.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/controllers/wishlist_controller.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/base/snackbar_message.dart'; // Import this for AwesomeSnackbarButton
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class CardProduk extends StatelessWidget {
  final int product_id;
  final String productImageName;
  final String productName;
  final String merchantAddress;
  final String? countPurchases;
  final int price;
  final double? average_rating;

  const CardProduk({
    Key? key,
    required this.product_id,
    required this.productImageName,
    required this.productName,
    required this.price,
    required this.merchantAddress,
    this.countPurchases,
    this.average_rating,
  }) : super(key: key);

  String formatCountPurchases(String count) {
    int value = int.tryParse(count) ?? 0;
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}rb';
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final authController = Get.find<AuthController>();

    Future<void> _getProdukList(int product_id) async {
      var controller = Get.find<PopularProdukController>();
      controller.detailProduk(product_id).then((status) async {});
    }

    int _getWishlistIdByProductId(int productId) {
      for (var item in wishlistController.wishlistList) {
        if (item.productId == productId) {
          return item.wishlistId!;
        }
      }
      return -1; // Jika tidak ditemukan, return -1
    }

    // Debug: Menampilkan URL gambar yang akan digunakan
    String imageUrl = productImageName.startsWith('http')
        ? productImageName  // Jika sudah berupa URL lengkap
        : '${AppConstants.BASE_URL_IMAGE}u_file/product_image/$productImageName';  // Jika hanya nama file gambar

    print('Product Image URL: $imageUrl');

    return Container(
      width: Dimensions.width45 * 3.75,
      height: Dimensions.height45 * 7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(
        left: Dimensions.width10 / 2,
        right: Dimensions.width10,
        bottom: Dimensions.height45,
        top: Dimensions.height10,
      ),
      child: GestureDetector(
        onTap: () {
          _getProdukList(product_id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  child: SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/default.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (authController.userLoggedIn()) {
                        bool isFavorit = wishlistController.getcheckedtypeWishlist[product_id] ?? false;

                        // Set wishlist status
                        wishlistController.setTypeWishlist(product_id, !isFavorit);

                        if (!isFavorit) {
                          // Tambahkan produk ke wishlist
                          wishlistController.tambahWishlist(authController.getUserId()!, product_id);
                        } else {
                          // Dapatkan wishlistId dan hapus produk dari wishlist
                          int wishlistId = _getWishlistIdByProductId(product_id);
                          if (wishlistId != -1) {
                            wishlistController.hapusWishlist(wishlistId);
                          } else {
                            print('Error: Wishlist ID tidak ditemukan untuk produk ID $product_id');
                          }
                        }
                      } else {
                        Get.toNamed(RouteHelper.getMasukPage());
                      }
                    },
                    child: Obx(() => wishlistController.getcheckedtypeWishlist[product_id] ?? false
                        ? Icon(Icons.favorite, color: Colors.pink)
                        : Icon(Icons.favorite_border, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TittleText(
                    text: productName,
                    size: Dimensions.font16,
                    maxLines: 1,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  SmallText(
                    text: merchantAddress,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 4),
                  PriceText(
                    text: CurrencyFormat.convertToIdr(price, 0),
                    color: AppColors.redColor,
                    size: Dimensions.font16,
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      if (average_rating != null)
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.orangeAccent),
                            SizedBox(width: 4),
                            SmallText(
                              text: average_rating!.toStringAsFixed(1),
                              color: Colors.orangeAccent,
                            ),
                          ],
                        ),
                      if (average_rating != null && countPurchases != null)
                        SizedBox(width: 10),
                      if (countPurchases != null)
                        SmallText(
                          text: '${formatCountPurchases(countPurchases!)} terjual',
                          color: Colors.grey[600],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
