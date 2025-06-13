import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../../controllers/popular_produk_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/Filter.dart';
import '../../widgets/card_produk.dart';
import '../search/search_page.dart';

class KategoriProdukDetail extends StatefulWidget {
  @override
  State<KategoriProdukDetail> createState() => _KategoriProdukDetailState();
}

class _KategoriProdukDetailState extends State<KategoriProdukDetail> {
  var kategori = Get.arguments;
  Filter? selectedValue;

  List<Filter?> filters = [
    Filter(id: 1, name: "Harga Tertinggi"),
    Filter(id: 2, name: "Harga Terendah")
  ];

  List<dynamic> _list =
      Get.find<PopularProdukController>().kategoriProdukList.toList();

  @override
  void initState() {
    _list = Get.find<PopularProdukController>().kategoriProdukList.toList();
    super.initState();
  }

  Future<void> _filter(int? keyword) async {
    try {
      List<dynamic> results = Get.find<PopularProdukController>()
          .kategoriProdukList
          .where((produk) => produk.namaKategori.toString() == kategori)
          .toList();

      if (keyword == 1) {
        results.sort((a, b) => b.price.compareTo(a.price));
      } else if (keyword == 2) {
        results.sort((a, b) => a.price.compareTo(b.price));
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
    Future<void> _getProdukList(int product_id) async {
      var controller = Get.find<PopularProdukController>();
      controller.detailProduk(product_id).then((status) async {});
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 10,
          radius: Radius.circular(20),
          child: Column(
            children: [
              Container(
                child: Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.height30, bottom: Dimensions.height10),
                  padding: EdgeInsets.only(
                      left: Dimensions.width10, right: Dimensions.width20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: Dimensions.height45,
                              height: Dimensions.height45,
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.redColor,
                                size: Dimensions.iconSize24,
                              ),
                            ),
                          ),
                        ],
                      )),
                      Center(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(SearchPage(
                                kategori: kategori,
                              ));
                            },
                            child: Container(
                              width: Dimensions.height45,
                              height: Dimensions.height45,
                              child: Icon(
                                Icons.search,
                                color: AppColors.redColor,
                                size: Dimensions.iconSize24,
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              Container(
                height: Dimensions.pageViewContainer,
                margin: EdgeInsets.only(
                    left: Dimensions.width10, right: Dimensions.width10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                            "assets/images/kategori_detail/$kategori.png"))),
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              Divider(color: AppColors.buttonBackgroundColor),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width10 / 4,
                        top: Dimensions.height10 / 2,
                        bottom: Dimensions.height10 / 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              "assets/images/kategori/$kategori.png")),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BigText(
                            text: "$kategori", size: Dimensions.font20 * 1.5),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.height10, top: Dimensions.height10),
                    width: Dimensions.screenWidth / 2,
                    height: Dimensions.height45,
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.width10 / 2,
                        horizontal: Dimensions.height10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15 / 3)),
                    child: DropdownButton<Filter?>(
                        items: filters
                            .map<DropdownMenuItem<Filter?>>(
                                (e) => DropdownMenuItem(
                                      child: Container(
                                        width: Dimensions.width45 * 3,
                                        child: Text((e?.name ?? '').toString()),
                                      ),
                                      value: e,
                                    ))
                            .toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        value: selectedValue,
                        hint: Text('Urutkan berdasarkan'),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                          _filter(selectedValue?.id);
                          print(selectedValue?.id);
                        }),
                  ),
                ],
              ),
              GetBuilder<PopularProdukController>(builder: (produkKategori) {
                return produkKategori.isLoading.value
                    ? selectedValue?.id == null
                        ? GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: Dimensions.height45 * 7),
                            itemCount: produkKategori.kategoriProdukList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var gambarproduk = produkKategori.imageProdukList
                                  .where((produk) =>
                                      produk.productId ==
                                      produkKategori
                                          .kategoriProdukList[index].productId);
                              return CardProduk(
                                product_id: produkKategori
                                    .kategoriProdukList[index].productId,
                                productImageName:
                                    gambarproduk.single.productImageName,
                                productName: produkKategori
                                    .kategoriProdukList[index].productName,
                                merchantAddress: produkKategori
                                    .kategoriProdukList[index].subdistrictName,
                                price: produkKategori
                                    .kategoriProdukList[index].price,
                                countPurchases: produkKategori
                                    .kategoriProdukList[index]
                                    .countProductPurchases,
                              );
                            })
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: Dimensions.height45 * 6.5),
                            itemCount: _list.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var gambarproduk = produkKategori.imageProdukList
                                  .where((produk) =>
                                      produk.productId ==
                                      _list[index].productId);
                              return CardProduk(
                                product_id: _list[index].productId,
                                productImageName:
                                    gambarproduk.single.productImageName,
                                productName: _list[index].productName,
                                merchantAddress: _list[index].subdistrictName,
                                price: _list[index].price,
                                countPurchases:
                                    _list[index].countProductPurchases,
                              );
                            })
                    : CircularProgressIndicator(
                        color: AppColors.redColor,
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
