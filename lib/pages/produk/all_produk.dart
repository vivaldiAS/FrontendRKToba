import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/app_constants.dart';
import '../../widgets/card_produk.dart';

class AllProduk extends StatefulWidget {
  const AllProduk({Key? key}) : super(key: key);

  @override
  _AllProdukState createState() => _AllProdukState();
}

class _AllProdukState extends State<AllProduk> {
  bool isLoading = true;
  List<dynamic> produkList = [];
  Map<int, String> gambarMap = {};
  int visibleCount = 40;

  final int incrementCount = 20; // jumlah produk ditambah per klik

  @override
  void initState() {
    super.initState();
    fetchAllProduk();
  }

  void fetchAllProduk() async {
    try {
      var response = await http.get(Uri.parse('${AppConstants.BASE_URL}produk'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("✔ Response berhasil diambil");

        if (data is Map) {
          List<dynamic> products = [];
          List<dynamic> productImages = [];

          /// ambil products
          if (data.containsKey("products")) {
            var list = data["products"];
            if (list is List) {
              products.addAll(list);
              print("✅ Dapat ${list.length} produk dari products");
            }
          }

          /// ambil product_images
          if (data.containsKey("product_images")) {
            var list = data["product_images"];
            if (list is List) {
              for (var img in list) {
                if (img['product_id'] != null && img['product_image_name'] != null) {
                  gambarMap[int.parse(img['product_id'].toString())] =
                  img['product_image_name'];
                }
              }
            }
          }

          setState(() {
            produkList = products;
            isLoading = false;
          });
        } else {
          print("❌ Data bukan Map");
          setState(() => isLoading = false);
        }
      } else {
        print("❌ Status code ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ Terjadi kesalahan: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🔄 isLoading: $isLoading, Jumlah produk: ${produkList.length}");

    int itemCount =
    visibleCount > produkList.length ? produkList.length : visibleCount;

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 7,
        radius: Radius.circular(20),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height10),
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height10),
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                      child: Text(
                        'Produk',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.redColor,
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(color: AppColors.redColor),
                ),
              )
            else if (produkList.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text("❗ Tidak ada produk tersedia")),
              )
            else
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  children: [
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: Dimensions.height45 * 7,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        var produk = produkList[index];

                        String productName = produk['product_name'] ?? 'Nama Tidak Ada';
                        int productId = int.tryParse(produk['product_id'].toString()) ?? 0;

                        String? productImageNameRaw = gambarMap[productId];

                        String imageUrl = 'assets/images/default.jpg';

                        if (productImageNameRaw != null) {
                          String trimmed = productImageNameRaw.trim().toLowerCase();
                          if (trimmed.isNotEmpty && trimmed != 'null') {
                            imageUrl =
                            '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${Uri.encodeComponent(productImageNameRaw.trim())}';
                          }
                        }

                        return CardProduk(
                          product_id: productId,
                          productImageName: imageUrl,
                          productName: productName,
                          merchantAddress: produk['subdistrict_name'] ?? '',
                          price: produk['price'] ?? 0,
                          countPurchases:
                          produk['count_product_purchases']?.toString() ?? '0',
                          average_rating: double.tryParse(
                              produk['average_rating']?.toString() ?? '0.0') ??
                              0.0,
                        );
                      },
                    ),

                    if (visibleCount < produkList.length)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              visibleCount += incrementCount;
                            });
                          },
                          child: Text(
                            "Lihat Selengkapnya",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.redColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
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
