import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rumah_kreatif_toba/base/custom_loader.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/models/users_models.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

import '../../base/snackbar_message.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_date_field.dart';
import '../../widgets/app_dropdown_field.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_text_field_password.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController dateinput = TextEditingController();
    var namaLengkapController = TextEditingController();
    var usernameController = TextEditingController();
    var passwordController = TextEditingController();
    var konfirmasiPasswordController = TextEditingController();
    var emailController = TextEditingController();
    var nomorTeleponController = TextEditingController();
    var tanggalLahirController = TextEditingController();
    var jenisKelaminController = TextEditingController();
    var genderValue;
    var birthdayValue;

    Future<void> _registration(AuthController authController) async {
      String name = namaLengkapController.text.trim();
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();
      String konfirmasiPassword = konfirmasiPasswordController.text.toString();
      String email = emailController.text.trim();
      String no_hp = nomorTeleponController.text.trim();
      String birthday = tanggalLahirController.text.trim();
      String gender = jenisKelaminController.text.trim();

      if (jenisKelaminController.text.trim() == "Laki-laki") {
        gender = "L";
      } else if (jenisKelaminController.text.trim() == "Perempuan") {
        gender = "P";
      }
      if (Platform.isIOS) {
        if (birthday.isEmpty) {
          birthday = "01-08-1995";
        }
        if (gender.isEmpty) {
          gender = "L";
        }
      }

      if (name.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Nama masih kosong", ContentType.warning);
      } else if (username.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Username masih kosong", ContentType.warning);
      } else if (email.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Email masih kosong", ContentType.warning);
      } else if (!GetUtils.isEmail(email)) {
        AwesomeSnackbarButton(
            "Warning", "Email tidak sesuai", ContentType.warning);
      } else if (password.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Password masih kosong", ContentType.warning);
      } else if (konfirmasiPassword.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Konfirmasi Password masih kosong", ContentType.warning);
      } else if (no_hp.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Nomor Telepon masih kosong", ContentType.warning);
      } else if (gender == null) {
        AwesomeSnackbarButton(
            "Warning", "Jenis Kelamin masih kosong", ContentType.warning);
      } else if (birthday.isEmpty) {
        AwesomeSnackbarButton(
            "Warning", "Tanggal Lahir masih kosong", ContentType.warning);
      } else if (konfirmasiPassword != password) {
        AwesomeSnackbarButton(
            "Warning",
            "Password tidak sama dengan Konfirmasi Password",
            ContentType.warning);
      } else {
        DateTime parsedBirthday = DateFormat('dd-MM-yyyy').parse(birthday);
        String formattedDate = DateFormat('yyyy-MM-dd').format(parsedBirthday);
        birthdayValue = formattedDate;

        Users users = Users(
            name: name,
            username: username,
            password: password,
            email: email,
            noHp: no_hp,
            birthday: birthdayValue,
            gender: gender);
        authController.registrasi(users).then((status) {
          if (status.isSuccess) {
            AwesomeSnackbarButton("Berhasil", "Akun sudah berhasil di daftar!",
                ContentType.success);
            Get.offNamed(RouteHelper.getInitial());
          } else {
            AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<AuthController>(builder: (_authController) {
          return !_authController.isLoading
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
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
                                image:
                                    AssetImage("assets/images/logo_rkt.png"))),
                      ),
                      AppTextField(
                        textController: namaLengkapController,
                        hintText: 'Nama Lengkap',
                        icon: Icons.person,
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
                      AppTextField(
                        textController: emailController,
                        hintText: 'Email',
                        icon: Icons.mail,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextFieldPassword(
                        textController: passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextFieldPassword(
                        textController: konfirmasiPasswordController,
                        hintText: 'Konfirmasi Password',
                        icon: Icons.lock,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                        textController: nomorTeleponController,
                        hintText: 'Nomor Telepon',
                        icon: Icons.phone_android,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppDropdownField(
                        hintText: 'Jenis Kelamin',
                        icon: Icons.people,
                        controller: jenisKelaminController,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppDateField(
                        textController: tanggalLahirController,
                        hintText: 'Tanggal Lahir',
                        icon: Icons.calendar_today,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _registration(_authController);
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
                                text: "Daftar",
                                color: Colors.white,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Sudah memiliki Akun? ",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.font16),
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.back(),
                                text: "Masuk",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: Dimensions.font16))
                          ])),
                      SizedBox(
                        height: Dimensions.height15,
                      ),
                    ],
                  ),
                )
              : CustomLoader();
        }));
  }
}
