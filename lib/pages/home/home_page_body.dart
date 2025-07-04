import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/pages/home/pakaian_diminati_page.dart';
import 'package:rumah_kreatif_toba/pages/home/produk_terbaru_page.dart';
import 'package:rumah_kreatif_toba/pages/home/produk_unggulan_page.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/price_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'package:rumah_kreatif_toba/widgets/tittle_text.dart';
import 'package:rumah_kreatif_toba/widgets/carousel_widget.dart';

import '../../utils/dimensions.dart';
import '../../widgets/card_kategori.dart';
import '../../widgets/card_produk.dart';
import '../../widgets/currency_format.dart';
import 'home_page.dart';


class HomePageBody extends StatefulWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final PopularProdukController _produkController =
      Get.find<PopularProdukController>();
  PageController pageController = PageController(viewportFraction: 0.90);
  PageController pageControllerPopulerProduct =
      PageController(viewportFraction: 0.90);

  var _currPageValue = 0.0;
  var _currPageValuePopulerProduct = 0.0;
  double _scaleFactor = 0.8;
  double _height = 200;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageControllerPopulerProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var kategori;
    Future<void> _getProduk(PopularProdukController produkController) async {
      produkController.getKategoriProdukList(kategori);
    }

    Future<void> _getProdukList(int product_id) async {
      var controller = Get.find<PopularProdukController>();
      controller.detailProduk(product_id).then((status) async {});
    }

    return RefreshIndicator(
        child: Column(
          children: [
            CarouselWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: Dimensions.width20),
              width: Dimensions.screenWidth / 1.8,
              child: BigText(
                text: "Kategori",
                fontWeight: FontWeight.bold,
                size: Dimensions.font16,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(ProdukUnggulanPage());
              },
              child: Container(
                  width: Dimensions.screenWidth / 4,
                  height: Dimensions.height45,
                  margin: EdgeInsets.only(right: Dimensions.width20),
                  child: Center(
                      child: BigText(
                          text: "Lihat Semua",
                          size: Dimensions.font20 / 1.5,
                          color: AppColors.redColor,
                          fontWeight: FontWeight.bold)
                  )),
            ),
          ],
        ),
            GetBuilder<PopularProdukController>(builder: (_produkController) {

              return Container(

                margin: EdgeInsets.only(
                  // top: Dimensions.width20,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.width20),
                height: Dimensions.height45 * 2.2, // tinggi yang cukup agar tidak terpotong
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CardKategori(kategori: "Makanan"),
                      SizedBox(width: 10),
                      CardKategori(kategori: "Minuman"),
                      SizedBox(width: 10),
                      CardKategori(kategori: "Pakaian"),
                      SizedBox(width: 10),
                      CardKategori(kategori: "Ulos"),
                      SizedBox(width: 10),
                      CardKategori(kategori: "Souvenir"),
                      SizedBox(width: 10),
                      CardKategori(kategori: "Perlengkapan Rumah"),
                      SizedBox(width: 10),
                      CardKategori(kategori: "Non Halal"),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => HomePage(initialIndex: 1));
                        },
                        child: Container(
                          width: 90,
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10,
                            horizontal: Dimensions.width10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.rectangle_grid_2x2_fill,
                                color: AppColors.redColor,
                                size: Dimensions.iconSize24,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Lihat Semua",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: Dimensions.font16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            }),
            SizedBox(
              height: Dimensions.height10,
            ),
            //Produk Terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.width20),
                  width: Dimensions.screenWidth / 1.8,
                  child: BigText(
                    text: "Makanan dan Minuman Terfavorit Untukmu",
                    fontWeight: FontWeight.bold,
                    size: Dimensions.font16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(ProdukUnggulanPage());
                  },
                  child: Container(
                      width: Dimensions.screenWidth / 4,
                      height: Dimensions.height45,
                      margin: EdgeInsets.only(right: Dimensions.width20),
                      child: Center(
                        child: BigText(
                            text: "Lihat Semua",
                            size: Dimensions.font20 / 1.5,
                            color: AppColors.redColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            Container(
              height: Dimensions.height45 * 7,
              margin: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,),
              child: GetBuilder<PopularProdukController>(
                builder: (popularProduk) {
                  return Obx(() => popularProduk.isLoading.value
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            var gambarproduk = popularProduk.imageProdukList
                                .where((produk) =>
                                    produk.productId ==
                                    popularProduk
                                        .produkMakananMinumanList[index]
                                        .productId);
                            return CardProduk(
                              product_id: popularProduk.produkMakananMinumanList[index].productId,
                              productImageName: gambarproduk.single.productImageName,
                              productName: popularProduk.produkMakananMinumanList[index].productName ?? '',
                              merchantAddress: popularProduk.produkMakananMinumanList[index].subdistrictName ?? '',
                              price: popularProduk.produkMakananMinumanList[index].price ?? 0,
                              countPurchases: popularProduk.produkMakananMinumanList[index].countProductPurchases,
                              average_rating: popularProduk.produkMakananMinumanList[index].averageRating,
                            );
                          },
                        )
                      : Container(
                          height:
                              50, // set the height of the container to your desired height
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.redColor,
                            ),
                          ),
                        ));
                },
              ),
            ),
            // SizedBox(
            //   height: Dimensions.height,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.width20),
                  width: Dimensions.screenWidth / 1.8,
                  child: BigText(
                    text: "Pakaian Paling Diminati",
                    fontWeight: FontWeight.bold,
                    size: Dimensions.font16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(PakaianDiminatiPage());
                  },
                  child: Container(
                      width: Dimensions.screenWidth / 4,
                      height: Dimensions.height45,
                      margin: EdgeInsets.only(right: Dimensions.width20),

                      child: Center(
                        child: BigText(
                            text: "Lihat Semua",
                            size: Dimensions.font20 / 1.5,
                            color: AppColors.redColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            Container(
              height: Dimensions.height45 * 7,
              margin: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,),
              child: GetBuilder<PopularProdukController>(
                builder: (popularProduk) {
                  return popularProduk.isLoading.value
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            var gambarproduk = popularProduk.imageProdukList
                                .where((produk) =>
                                    produk.productId ==
                                    popularProduk
                                        .produkPakaianList[index].productId);
                            return CardProduk(
                              product_id: popularProduk.produkPakaianList[index].productId,
                              productImageName: gambarproduk.single.productImageName,
                              productName: popularProduk.produkPakaianList[index].productName ?? '',
                              merchantAddress: popularProduk.produkPakaianList[index].subdistrictName ?? '',
                              price: popularProduk.produkPakaianList[index].price ?? 0,
                              countPurchases: popularProduk.produkPakaianList[index].countProductPurchases,
                              average_rating: popularProduk.produkPakaianList[index].averageRating,
                            );
                          })
                      : Container(
                          height:
                              50, // set the height of the container to your desired height
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.redColor,
                            ),
                          ),
                        );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.width20),
                  width: Dimensions.screenWidth / 1.8,
                  child: BigText(
                    text: "Produk Terbaru",
                    fontWeight: FontWeight.bold,
                    size: Dimensions.font16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(ProdukTerbaruPage());
                  },
                  child: Container(
                      width: Dimensions.screenWidth / 4,
                      height: Dimensions.height45,
                      margin: EdgeInsets.only(right: Dimensions.width20),
                      child: Center(
                        child: BigText(
                            text: "Lihat Semua",
                            size: Dimensions.font20 / 1.5,
                            color: AppColors.redColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            Container(
              height: Dimensions.height45 * 7,
              margin: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: GetBuilder<PopularProdukController>(
                builder: (popularProduk) {
                  return popularProduk.isLoading.value
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            var gambarproduk = popularProduk.imageProdukList
                                .where((produk) =>
                                    produk.productId ==
                                    popularProduk
                                        .produkTerbaruList[index].productId);
                            return CardProduk(
                              product_id: popularProduk.produkTerbaruList[index].productId,
                              productImageName: gambarproduk.single.productImageName,
                              productName: popularProduk.produkTerbaruList[index].productName ?? '',
                              merchantAddress: popularProduk.produkTerbaruList[index].subdistrictName ?? '',
                              price: popularProduk.produkTerbaruList[index].price ?? 0,
                              countPurchases: popularProduk.produkTerbaruList[index].countProductPurchases,
                              average_rating: popularProduk.produkTerbaruList[index].averageRating,
                            );
                          })
                      : Container(
                          height:
                              50, // set the height of the container to your desired height
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.redColor,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        onRefresh: () =>
            Get.find<PopularProdukController>().getPopularProdukList());
  }


  Widget _buildPageItemPopulerProduct(int index) {
    return Stack(
      children: [
        GetBuilder<PopularProdukController>(builder: (popularProduk) {
          return popularProduk.isLoaded
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 11,
                  itemBuilder: (context, index) {
                    if (index >= 10) {
                      // Return an empty container for the last index to create a blank card
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.getProdukDetail(popularProduk
                              .popularProdukList[index].productId));
                        },
                        child: Container(
                          width: 150,
                          height: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radius15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              ],
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.none,
                                  image: AssetImage(
                                      "assets/images/kategori/Lihat Semua.png"))),
                          margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20,),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.getProdukDetail(
                                  popularProduk
                                      .popularProdukList[index].productId));
//                        Get.toNamed(RouteHelper.getProdukDetail(index));
                            },
                          ),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getProdukDetail(
                            popularProduk.popularProdukList[index].productId));
                      },
                      child: Container(
                        width: 150,
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              )
                            ]),
                        margin: EdgeInsets.only(
                            left: Dimensions.width10 / 2,
                            right: Dimensions.width10,
                            bottom: Dimensions.height20,
                            top: Dimensions.height10),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getProdukDetail(
                                popularProduk
                                    .popularProdukList[index].productId));
//                        Get.toNamed(RouteHelper.getProdukDetail(index));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //image section
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            Dimensions.radius15),
                                        topRight: Radius.circular(
                                            Dimensions.radius15)),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/images/coffee.jpg"))),
                              ),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TittleText(
                                      text: popularProduk
                                          .popularProdukList[index].productName
                                          .toString(),
                                      size: Dimensions.font16,
                                    ),
                                    SmallText(
                                      text: popularProduk
                                          .popularProdukList[index].namaMerchant
                                          .toString(),
                                    ),
                                    PriceText(
                                      text: CurrencyFormat.convertToIdr(
                                          popularProduk
                                              .popularProdukList[index].price,
                                          0),
                                      color: AppColors.redColor,
                                      size: Dimensions.font16,
                                    ),
                                  ],

                                  
                                ),
                              ),
                              
                              //text container
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator(
                  color: AppColors.redColor,
                );
        })
      ],
    );
  }
}
