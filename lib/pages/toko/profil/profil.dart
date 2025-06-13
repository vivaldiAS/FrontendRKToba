import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/pages/toko/profil/ubah_toko.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../../../controllers/toko_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_icon.dart';
import 'package:get/get.dart';

import '../../../widgets/expandable_text_widget.dart';
class Profil extends StatelessWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<TokoController>().profilToko();
    var profilToko = Get.find<TokoController>().profilTokoList;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height30,
                    left: Dimensions.width10,
                    right: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      width: Dimensions.width10,
                    ),
                    BigText(
                      text: "Profil Toko",
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              GetBuilder<TokoController>(builder: (controller) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20,
                          ),
                          child:  Column(
                            children: [
                              // Divider(color: AppColors.buttonBackgroundColor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BigText(text: "Nama Toko", size: Dimensions.font16, color: AppColors.labelColor,),
                                      BigText(text: profilToko[0].nama_merchant.toString(), size: Dimensions.font16, fontWeight: FontWeight.bold,),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BigText(text: "Deskripsi Toko", size: Dimensions.font16, color: AppColors.labelColor,),
                                      Container(
                                        width: Dimensions.screenWidth/1.2,
                                        child: SingleChildScrollView(
                                          child: ExpandableTextWidget(
                                              text: profilToko[0].deskripsi_toko.toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BigText(text: "Kontak Toko", size: Dimensions.font16, color: AppColors.labelColor,),
                                      BigText(text: profilToko[0].kontak_toko.toString(), size: Dimensions.font16, fontWeight: FontWeight.bold, ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BigText(text: "Gambar Toko",size: Dimensions.font16, color: AppColors.labelColor,),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Container(
                                        height: Dimensions.height45*3,
                                        width: Dimensions.width45*3,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius15)),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  '${AppConstants.BASE_URL_IMAGE}u_file/foto_merchant/${profilToko[0].foto_merchant.toString()}',
                                                ) )
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: Dimensions.width20*3,
                                    padding: EdgeInsets.only(
                                        top: Dimensions.height10/2,
                                        bottom: Dimensions.height10/2 ,
                                        left: Dimensions.width10,
                                        right: Dimensions.width10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.redColor),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20 / 2),
                                        color: Colors.white),
                                    child: GestureDetector(
                                        onTap: () {
                                          Get.to(UbahTokoPage());
                                        },
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              BigText(
                                                text: "Edit",
                                                color: Colors.redAccent,
                                                size: Dimensions.height15,
                                              ),
                                            ])),
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
