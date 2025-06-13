import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'package:rumah_kreatif_toba/widgets/tittle_text.dart';

import '../controllers/popular_produk_controller.dart';
import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'currency_format.dart';

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
    Future<void> _getProdukList(int product_id) async {
      var controller = Get.find<PopularProdukController>();
      controller.detailProduk(product_id).then((status) async {});
    }

    // Debug: Menampilkan URL gambar yang akan digunakan
    String imageUrl = productImageName.startsWith('http')
        ? productImageName  // Jika sudah berupa URL lengkap
        : '${AppConstants.BASE_URL_IMAGE}u_file/product_image/$productImageName';  // Jika hanya nama file gambar

    print('Product Image URL: $imageUrl');

    return Container(
      width: Dimensions.width45 * 3.5,
      height: Dimensions.height45 * 6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
        left: Dimensions.width10/2,
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
                    topLeft: Radius.circular(Dimensions.radius15),
                    topRight: Radius.circular(Dimensions.radius15),
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
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20,
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
