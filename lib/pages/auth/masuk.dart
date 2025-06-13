import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher terbaru

import 'package:rumah_kreatif_toba/pages/auth/register.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../../base/snackbar_message.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_text_field_password.dart';

class Masuk extends StatefulWidget {
  const Masuk({Key? key}) : super(key: key);

  @override
  State<Masuk> createState() => _MasukState();
}

class _MasukState extends State<Masuk> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void _login(AuthController authController) {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty) {
      AwesomeSnackbarButton(
          "Warning", "Username masih kosong", ContentType.warning);
    } else if (password.isEmpty) {
      AwesomeSnackbarButton(
          "Warning", "Password masih kosong", ContentType.warning);
    } else {
      authController.login(username, password).then((status) {
        if (status?.isSuccess ?? false) {
          Get.toNamed(RouteHelper.getInitial());
        } else {
          AwesomeSnackbarButton(
              "Gagal", status?.message ?? "Gagal", ContentType.failure);
        }
      });
    }
  }

  void _launchForgotPasswordURL() async {
    final Uri url = Uri.parse('https://kreatif.tobakab.go.id/password/reset');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error",
        "Tidak dapat membuka browser.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height30, left: Dimensions.height10),
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
                      width: Dimensions.width20,
                    ),
                  ],
                ),
              ),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return !authController.isLoading
                      ? Column(
                    children: [
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      Container(
                        width: Dimensions.width45 * 3,
                        height: Dimensions.height45 * 3,
                        margin: EdgeInsets.only(
                            left: Dimensions.width10,
                            right: Dimensions.width10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    "assets/images/logo_rkt.png"))),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                        textController: usernameController,
                        hintText: 'Username',
                        icon: Icons.person,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextFieldPassword(
                        textController: passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                      ),
                      SizedBox(height: Dimensions.height10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _launchForgotPasswordURL,
                          child: Padding(
                            padding: EdgeInsets.only(right: Dimensions.width10),
                            child: Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: AppColors.redColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _login(authController);
                        },
                        child: Container(
                            width: Dimensions.width45 * 3,
                            height: Dimensions.height45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20 / 2),
                                color: AppColors.redColor),
                            child: Center(
                              child: BigText(
                                text: "Masuk",
                                color: Colors.white,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Tidak memiliki Akun? ",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.font16),
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.to(() => Register(),
                                          transition: Transition.fadeIn),
                                    text: "Daftar",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: Dimensions.font16))
                              ])),
                      SizedBox(
                        height: Dimensions.height15,
                      ),
                    ],
                  )
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
              )
            ],
          ),
        ));
  }
}
