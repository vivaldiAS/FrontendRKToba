import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/popular_produk_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/card_produk.dart';

class ProdukTerbaruPage extends StatelessWidget {
  const ProdukTerbaruPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height30),
                padding: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      width: Dimensions.width20,
                    ),
                    Container(
                      child: BigText(
                        text: "Produk Terbaru",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<PopularProdukController>(builder: (controller) {
              return controller.isLoading.value
                  ? GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: Dimensions.height45*7),
                  itemCount: controller.produkTerbaruList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var gambarproduk = controller
                        .imageProdukList
                        .where((produk) => produk.productId == controller
                        .produkTerbaruList[index].productId);
                    return CardProduk(product_id : controller.produkTerbaruList[index].productId,productImageName : gambarproduk.single.productImageName, productName : controller.produkTerbaruList[index].productName, merchantAddress : controller.produkTerbaruList[index].subdistrictName, price: controller.produkTerbaruList[index].price, countPurchases: controller.produkTerbaruList[index].countProductPurchases,
                      average_rating: controller.produkTerbaruList[index].averageRating,);
                  }
              )
                  : CircularProgressIndicator(
                color: AppColors.redColor,
              );
            })
          ],
        ),
      ),
    );
  }
}

