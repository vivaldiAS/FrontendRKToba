import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../home/home_page.dart';
import 'hometoko/hometoko_page.dart';

class MenungguVerifikasiToko extends StatelessWidget {
  const MenungguVerifikasiToko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Dimensions.height45, bottom: Dimensions.height15),
                    padding: EdgeInsets.only(
                        left: Dimensions.width20, right: Dimensions.width20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(HomePage(initialIndex: 4));
                            // Get.back();
                          },
                          child: AppIcon(
                            icon: Icons.arrow_back,
                            iconColor:AppColors.redColor,
                            backgroundColor:  Colors.white,
                            iconSize: Dimensions.iconSize24,
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.width20,
                        ),
                        BigText(
                          text: "Menunggu Verifikasi",
                          size: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Column(
                  children: [
                    Container(
                      width: Dimensions
                          .screenWidth/1.5,
                      height: Dimensions
                          .height45 *
                          4,
                      margin: EdgeInsets.only(
                          top: Dimensions
                              .height,
                          bottom: Dimensions.height20),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: AssetImage(
                                  "assets/images/ikon/menungguverifikasi.png")),
                          borderRadius:
                          BorderRadius.circular(
                              Dimensions
                                  .radius20),
                          color:
                          Colors.white),
                    ),
                    Container(child: BigText(text:"Menunggu toko anda diverifikasi.", size: Dimensions.font20),)
                  ],
                )

              ],
            ))
    );;
  }
}
