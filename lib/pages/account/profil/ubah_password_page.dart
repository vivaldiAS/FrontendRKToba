import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/widgets/app_text_field_password.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/input_text_field.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({Key? key}) : super(key: key);

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final PasswordController = TextEditingController();
    final PasswordBaruController = TextEditingController();

    Future<void> _ubahPassword() async {
      String password = PasswordController.text.trim();
      String passwordBaru = PasswordBaruController.text.trim();

      if (password.isEmpty) {
        AwesomeSnackbarButton("Warning","Password lama masih kosong",ContentType.warning);
      } else if (passwordBaru.isEmpty) {
        AwesomeSnackbarButton("Warning","Password baru masih kosong",ContentType.warning);
      } else{
        var controller = Get.find<UserController>();
        var userController = Get.find<UserController>().usersList[0];
        controller
            .ubahPassword(userController.id,password, passwordBaru )
            .then((status) async {
        });
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.height30, bottom: Dimensions.height20),
                  padding: EdgeInsets.only(
                      left: Dimensions.width10, right: Dimensions.width20),
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
                        width: Dimensions.width10,
                      ),
                      Container(
                        child: BigText(
                          text: "Ubah Password",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Password Lama
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Password Lama",
                  size: Dimensions.font16,
                ),
              ),
              AppTextFieldPassword(
                textController: PasswordController,
                hintText: "Masukkan password lama",
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              // Password Baru
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: Dimensions.height10),
                child: BigText(
                  text: "Password Baru",
                  size: Dimensions.font16,
                ),
              ),
              AppTextFieldPassword(
                textController: PasswordBaruController,
                hintText: "Masukkan password baru",
              ),
              SizedBox(
                height: Dimensions.height45,
              ),

              GestureDetector(
                onTap: (){
                  _ubahPassword();
                },
                child: Center(
                  child: Container(
                    width: Dimensions.width45*3,
                    height: Dimensions.width45,
                    // alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.redColor),
                    child: Center(
                      child: BigText(
                        text: "Ubah",
                        fontWeight: FontWeight.bold,
                        size: Dimensions.font20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
