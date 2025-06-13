import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_date_field.dart';
import '../../../widgets/app_dropdown_field.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/input_text_field.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class EditBiodataPage extends StatefulWidget {
  const EditBiodataPage({Key? key}) : super(key: key);

  @override
  State<EditBiodataPage> createState() => _EditBiodataPageState();
}

class _EditBiodataPageState extends State<EditBiodataPage> {
  @override
  Widget build(BuildContext context) {

    var users = Get.find<UserController>().usersList[0];
    final NamaController = TextEditingController(text: users.name);
    final NomorHandphoneController = TextEditingController(text: users.noHp);
    final jenisKelaminController = TextEditingController(text:users.gender);
    var tanggalLahirController = TextEditingController(text : users.birthday);

    Future<void> _ubahProfil() async {
      String name = NamaController.text.trim();
      String noHp = NomorHandphoneController.text.trim();
      String gender = jenisKelaminController.text.trim();
      String birthday = tanggalLahirController.text.toString();

      if (name.isEmpty) {
        AwesomeSnackbarButton("Warning","Nama masih kosong",ContentType.warning);
      } else if (noHp.isEmpty) {
        AwesomeSnackbarButton("Warning","Nomor handphone masih kosong",ContentType.warning);
      } else if (gender.isEmpty) {
        AwesomeSnackbarButton("Warning","Jenis kelamin masih kosong",ContentType.warning);
      } else if (birthday.isEmpty) {
        AwesomeSnackbarButton("Warning","Tanggal lahir Password masih kosong",ContentType.warning);
      }else{
        var controller = Get.find<UserController>();
        var userController = Get.find<UserController>().usersList[0];
        controller
            .ubahProfil(userController.id, name,noHp, birthday, gender)
            .then((status) async {
          if (status.isSuccess) {
            print("Berhasil");
          } else {
            AwesomeSnackbarButton("Gagal",status.message,ContentType.failure);
          }
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
                        text: "Ubah Biodata",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Nama
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: BigText(
                text: "Nama",
                size: Dimensions.font16,
              ),
            ),
            InputTextField(
              textController: NamaController,
              labelText: "A",
            ),
            SizedBox(
              height: Dimensions.height20,
            ),

            // Jenis Kelamin
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: BigText(
                text: "Jenis Kelamin",
                size: Dimensions.font16,
              ),
            ),
            AppDropdownField(
              controller: jenisKelaminController,
            ),
            SizedBox(
              height: Dimensions.height20,
            ),

            // Tanggal Lahir
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: BigText(
                text: "Tanggal Lahir",
                size: Dimensions.font16,
              ),
            ),
            AppDateField(
              textController: tanggalLahirController,
              hintText: 'Tanggal Lahir',
              icon: Icons.calendar_today,
            ),
            SizedBox(
              height: Dimensions.height20,
            ),

            // Nomor Handphone
            Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: Dimensions.height10),
              child: BigText(
                text: "Nomor Handphone",
                size: Dimensions.font16,
              ),
            ),
            InputTextField(
              textController: NomorHandphoneController,
            ),
            SizedBox(
              height: Dimensions.height45,
            ),

            GestureDetector(
              onTap: (){
                _ubahProfil();
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )


          ]),
    ));
  }
}
