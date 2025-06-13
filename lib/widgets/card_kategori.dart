import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:get/get.dart';
import '../controllers/popular_produk_controller.dart';
import '../pages/kategori/kategori_produk_detail.dart';
import '../utils/colors.dart';
import 'big_text.dart';

class CardKategori extends StatelessWidget {
  final String kategori;

  CardKategori({
    Key? key,
    required this.kategori,
  }) : super(key: key);

  Future<void> _getProduk(PopularProdukController produkController) async {
    produkController.getKategoriProdukList(kategori);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularProdukController>(builder: (_produkController) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Get.to(KategoriProdukDetail(), arguments: kategori);
            _getProduk(_produkController);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //image section
              Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(
                    left: Dimensions.width10 / 2,
                    right: Dimensions.width10 / 2,
                    top: Dimensions.height10 / 2,
                    bottom: Dimensions.height10 / 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          AssetImage("assets/images/kategori/${kategori}.png")),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.width10 / 4,
                    right: Dimensions.width10 / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(kategori,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: Dimensions.height20 / 2))
                  ],
                ),
              )
              //text container
            ],
          ),
        ),
      );
    });
  }
}
