import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/models/alamat_toko_model.dart';
import 'package:rumah_kreatif_toba/pages/home/home_page.dart';
import 'package:rumah_kreatif_toba/pages/toko/AlamatToko/tambah_alamat_toko.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/controllers/alamat_controller.dart';
import 'package:rumah_kreatif_toba/models/alamat_model.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../utils/colors.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../hometoko/hometoko_page.dart';
class DaftarAlamatTokoPage extends GetView<AlamatController> {
  int index = 0;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Get.find<AlamatController>().getAlamatToko();

    Future<void>_hapusAlamatToko(int? merchant_address_id) async {
      var Controller = Get.find<AlamatController>();
      Controller.hapusAlamatToko(merchant_address_id).then((status) {
        if (status.isSuccess) {
        } else {
          AwesomeSnackbarButton("Gagal",status.message,ContentType.failure);
        }
      });
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width10,
                  right: Dimensions.width10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(HomeTokoPage(initialIndex: 3));
                        },
                        child: AppIcon(
                          icon: Icons.arrow_back,
                          iconColor: AppColors.redColor,
                          backgroundColor: Colors.white,
                          iconSize: Dimensions.iconSize24,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10,),
                      BigText(
                        text: "Alamat Toko",
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Get.find<AlamatController>().daftarAlamatTokoList.isEmpty ?
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              TambahAlamatToko()
                          );
                        },
                        child: Container(
                            child: Icon(
                              Icons.add,
                              color: AppColors.redColor,
                            )),
                      ),
                    ],
                  ) : SizedBox(),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            //   height: 220,
            //   width: double.maxFinite,
            //   child: Card(
            //     elevation: 5,
            //     child: InkWell(
            //       // onTap: () {
            //       //   if (index == _selectedIndex) {
            //       //     _selectedIndex = -1;
            //       //   } else {
            //       //     _selectedIndex = index;
            //       //   }
            //       // },
            //       child: Container(
            //         // color: index == _selectedIndex
            //         //     ? AppColors.redColor
            //         //     : Colors.white,
            //         child: Padding(
            //           padding: EdgeInsets.all(7),
            //           child: Stack(
            //             children: <Widget>[
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 10, top: 5),
            //                 child: GetBuilder<AlamatController>(
            //                   builder: (AlamatController) {
            //                     return ListView.builder(
            //                       itemCount:
            //                       AlamatController.daftarAlamatTokoList.length,
            //                       itemBuilder:
            //                           (BuildContext context, int index) {
            //                         AlamatToko alamattoko =
            //                         AlamatController.daftarAlamatTokoList[index];
            //                         return ListTile(
            //                           title: Text("Alamat Toko ${index + 1}"),
            //                           subtitle: Text(alamattoko
            //                               .merchant_street_address
            //                               ?.toString() ??
            //                               ""),
            //                           trailing: Text(alamattoko
            //                               .merchant_street_address
            //                               ?.toString() ??
            //                               ""),
            //                         );
            //                       },
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            GetBuilder<AlamatController>(
              builder: (AlamatController) {
                return Obx(() =>  ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: AlamatController.daftarAlamatTokoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    AlamatToko alamattoko = AlamatController.daftarAlamatTokoList[index];
                    return Container(
                      width: Dimensions.screenWidth,
                      height: Dimensions.height45 * 5,
                      margin: EdgeInsets.only(
                          bottom: Dimensions.height10,
                          top: Dimensions.height10 / 2,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      padding: EdgeInsets.all(Dimensions.height20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.buttonBackgroundColor),
                          borderRadius:
                          BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(text: "Alamat Toko", fontWeight: FontWeight.bold, ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  alamattoko.province_name?.toString() ?? "",
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  alamattoko.city_name?.toString() ?? "",
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  alamattoko.subdistrict_name?.toString() ?? "",
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                width: Dimensions.screenWidth/1.5,
                                child: Text(
                                  alamattoko.merchant_street_address?.toString() ?? "",
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _hapusAlamatToko(alamattoko.merchant_address_id);
                            },
                            child: AppIcon(
                                iconSize: Dimensions
                                    .iconSize16,
                                iconColor: AppColors
                                    .redColor,
                                backgroundColor:
                                Colors.white,
                                icon: Icons.delete),
                          )
                        ],
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
