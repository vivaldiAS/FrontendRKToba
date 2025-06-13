import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rumah_kreatif_toba/controllers/popular_produk_controller.dart';
import 'package:rumah_kreatif_toba/controllers/produk_controller.dart';
import 'package:rumah_kreatif_toba/models/produk_models.dart';
import 'package:rumah_kreatif_toba/pages/toko/hometoko/hometoko_page.dart';
import 'package:rumah_kreatif_toba/pages/toko/produk/produk_page.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'package:get/get.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../controllers/toko_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_dropdown_field_kategori.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/input_text_field.dart';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class UbahProdukPage extends StatelessWidget {
  const UbahProdukPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var detailProduk = Get.find<PopularProdukController>().detailProdukList;
    var NamaProdukController = TextEditingController(text: detailProduk[0].productName);
    var DeskripsiProdukController = TextEditingController(text: detailProduk[0].productDescription);
    var HargaController = TextEditingController(text: detailProduk[0].price.toString());
    var BeratController = TextEditingController(text: detailProduk[0].heavy.toString());
    var StokController = TextEditingController(text: detailProduk[0].stok.toString());
    var KategoriController = TextEditingController(text: detailProduk[0].namaKategori.toString());

    Future<void> _ubahProduk() async {
      String namaproduk = NamaProdukController.text.trim();
      String deskripsi = DeskripsiProdukController.text.trim();
      int harga = int.parse(HargaController.text.trim());
      int berat = int.parse(BeratController.text.trim());
      int stok = int.parse(StokController.text.trim());
      String kategori = KategoriController.text.trim();

      if (namaproduk.isEmpty) {
        AwesomeSnackbarButton("Warning","Nama produk masih kosong",ContentType.warning);
      } else if (deskripsi.isEmpty) {
        AwesomeSnackbarButton("Warning","Deskripsi masih kosong",ContentType.warning);
      } else if (harga == null) {
        AwesomeSnackbarButton("Warning","Harga masih kosong",ContentType.warning);
      } else if (stok == null) {
        AwesomeSnackbarButton("Warning","Stok masih kosong",ContentType.warning);
      } else if (berat == null) {
        AwesomeSnackbarButton("Warning","Berat masih kosong",ContentType.warning);
      } else if (kategori.isEmpty) {
        AwesomeSnackbarButton("Warning","Kategori masih kosong",ContentType.warning);
      } else {
        var controller = Get.find<ProdukController>();
        controller
            .ubahProduk(detailProduk[0].productId, namaproduk, deskripsi, harga,
            berat, kategori, stok)
            .then((status) async {});
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: Dimensions.height45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(HomeTokoPage(initialIndex: 1)); // Pass the initial index to the HomeTokoPage constructor
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
                    Container(
                      child: BigText(
                        text: "Ubah Produk",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              // Nama Produk
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Nama Produk",
                  size: Dimensions.font16,
                ),
              ),
              InputTextField(
                textController: NamaProdukController,
                hintText: 'Nama Produk',
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              //Kategori
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Kategori",
                  size: Dimensions.font16,
                ),
              ),
              AppDropdownFieldKategori(
                hintText: 'Kategori',
                controller: KategoriController,
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              //Deskripsi Produk
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Deskripsi Produk",
                  size: Dimensions.font16,
                ),
              ),
              InputTextField(
                textController: DeskripsiProdukController,
                hintText: 'Deskripsi Produk',
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              //Harga
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Harga",
                  size: Dimensions.font16,
                ),
              ),
              InputTextField(
                textController: HargaController,
                hintText: 'Harga',
                textInputType: TextInputType.number,
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              //Gambar Produk Lama
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Gambar Produk Lama",
                  size: Dimensions.font16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Dimensions.width45*1.5,
                    height: Dimensions.height45*1.5,
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height10),
                    padding: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        top: Dimensions.height20,
                        bottom: Dimensions.height20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius15),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${detailProduk[0].productImageName.toString()}',
                            ) )),
                  ),
                  Container(
                    width: Dimensions.width45*1.5,
                    height: Dimensions.height45*1.5,
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height10),
                    padding: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        top: Dimensions.height20,
                        bottom: Dimensions.height20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius15),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${detailProduk[1].productImageName.toString()}',
                            ) )),
                  ),
                  Container(
                    width: Dimensions.width45*1.5,
                    height: Dimensions.height45*1.5,
                    margin: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        bottom: Dimensions.height10),
                    padding: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        top: Dimensions.height20,
                        bottom: Dimensions.height20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.radius15),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              '${AppConstants.BASE_URL_IMAGE}u_file/product_image/${detailProduk[2].productImageName.toString()}',
                            ) )),
                  ),
                ],
              ),


              //Gambar Produk
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Gambar Produk",
                  size: Dimensions.font16,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<ProdukController>(builder: (controller) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.pickImageGambarUbahProduk1();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                                bottom: Dimensions.height20),
                            padding: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                                top: Dimensions.height20,
                                bottom: Dimensions.height20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2))
                                ]),
                            child: Icon(
                              Icons.add,
                              color: AppColors.redColor,
                            ),
                          ),
                        ),
                        controller.pickedFileGambarUbahProduk1 != null
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(controller
                                  .pickedFileGambarUbahProduk1!.path),
                              fit: BoxFit.cover,
                              width: Dimensions.width45*2,
                              height: Dimensions.height45*2,
                            ),
                          ),
                        )
                            : Text(
                          "Tidak Ada Gambar",
                          style: TextStyle(
                              fontSize: Dimensions.font16 / 2),
                        ),
                      ],
                    );
                  }),
                  GetBuilder<ProdukController>(builder: (controller) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.pickImageGambarUbahProduk2();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                                bottom: Dimensions.height20),
                            padding: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                                top: Dimensions.height20,
                                bottom: Dimensions.height20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2))
                                ]),
                            child: Icon(
                              Icons.add,
                              color: AppColors.redColor,
                            ),
                          ),
                        ),
                        controller.pickedFileGambarUbahProduk2 != null
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(controller
                                  .pickedFileGambarUbahProduk2!.path),
                              fit: BoxFit.cover,
                              width: Dimensions.width45*2,
                              height: Dimensions.height45*2,
                            ),
                          ),
                        )
                            : Text(
                          "Tidak Ada Gambar",
                          style: TextStyle(
                              fontSize: Dimensions.font16 / 2),
                        ),
                      ],
                    );
                  }),
                  GetBuilder<ProdukController>(builder: (controller) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.pickImageGambarUbahProduk3();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                                bottom: Dimensions.height20),
                            padding: EdgeInsets.only(
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                                top: Dimensions.height20,
                                bottom: Dimensions.height20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: Offset(1, 1),
                                      color: Colors.grey.withOpacity(0.2))
                                ]),
                            child: Icon(
                              Icons.add,
                              color: AppColors.redColor,
                            ),
                          ),
                        ),
                        controller.pickedFileGambarUbahProduk3 != null
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              //to show image, you type like this.
                              File(controller
                                  .pickedFileGambarUbahProduk3!.path),
                              fit: BoxFit.cover,
                              width: Dimensions.width45*2,
                              height: Dimensions.height45*2,
                            ),
                          ),
                        )
                            : Text(
                          "Tidak Ada Gambar",
                          style: TextStyle(
                              fontSize: Dimensions.font16 / 2),
                        ),
                      ],
                    );
                  }),

                ],
              ),

              //Berat
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Berat",
                  size: Dimensions.font16,
                ),
              ),
              InputTextField(
                textController: BeratController,
                hintText: 'Berat',
                textInputType: TextInputType.number,
              ),
              Container(
                child: SmallText(text: "Berat dihitung dalam gram (gr)."),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              //Stok
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Stok",
                  size: Dimensions.font16,
                ),
              ),
              InputTextField(
                textController: StokController,
                hintText: 'Stok',
                textInputType: TextInputType.number,
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

             Center(
               child:  GestureDetector(
                   onTap: () {
                     _ubahProduk();
                   },
                   child: Container(
                     width: Dimensions.width45 * 3,
                     height: Dimensions.height45,
                     margin: EdgeInsets.only(bottom: Dimensions.height10),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(Dimensions.radius30),
                         color: AppColors.redColor),
                     child: Center(
                       child:BigText(
                         text: "Ubah",
                         size: Dimensions.font20,
                         color: Colors.white,
                       ) ,
                     )
                   )
               ),
             )
            ],
          ),
        ));
  }
}
