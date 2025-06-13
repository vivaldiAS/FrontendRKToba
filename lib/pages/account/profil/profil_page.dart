import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/pages/account/profil/ubah_password_page.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../../../controllers/user_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_icon.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../home/home_page.dart';
import 'edit_biodata_page.dart';
class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetBuilder<UserController>(
        builder: (userController) {
          var birthdayValue;
          DateTime parsedBirthday = DateFormat('dd-MM-yyyy').parse(userController.usersList[0].birthday);
          String formattedDate = DateFormat('dd MMM yyyy').format(parsedBirthday);
          birthdayValue = formattedDate;
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.height30, bottom: Dimensions.height20),
                      padding: EdgeInsets.only(left: Dimensions.width10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(HomePage(initialIndex: 4));
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
                          Container(
                            child: BigText(
                              text: "Profil",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20,
                            ),
                            child:  Column(
                              children: [
                                Row(
                                  children: [
                                    BigText(text: "Informasi Akun"),
                                  ],
                                ),
                                Divider(color: AppColors.buttonBackgroundColor,thickness: 2.0,),
                                SizedBox(height: Dimensions.height10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: "Username" , color: AppColors.labelColor, size: Dimensions.font16,),
                                    BigText(text: userController.usersList[0].username, size: Dimensions.font16,),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: "Email", color: AppColors.labelColor, size: Dimensions.font16),
                                    BigText(text: userController.usersList[0].email, size: Dimensions.font16 ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20,
                            ),
                            child:  Column(
                              children: [
                                Row(
                                  children: [
                                    BigText(text: "Biodata Diri "),
                                  ],
                                ),
                                Divider(color: AppColors.buttonBackgroundColor,thickness: 2.0,),
                                SizedBox(height: Dimensions.height10,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: "Nama" , color: AppColors.labelColor, size: Dimensions.font16),
                                    BigText(text: userController.usersList[0].name , size: Dimensions.font16),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: "Tanggal Lahir", color: AppColors.labelColor, size: Dimensions.font16),
                                    BigText(text: birthdayValue, size: Dimensions.font16 ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: "Jenis Kelamin", color: AppColors.labelColor, size: Dimensions.font16),
                                    BigText(text: userController.usersList[0].gender, size: Dimensions.font16 ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: "No. HP", color: AppColors.labelColor, size: Dimensions.font16),
                                    BigText(text: userController.usersList[0].noHp, size: Dimensions.font16 ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                            Get.to(EditBiodataPage());
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
                  )
                ],
              )
            ],
          );
        }),
    );
  }
}
