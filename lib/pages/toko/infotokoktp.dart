import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'instruksi_ktp.dart';
import 'instruksi_ktp.dart';

class TokoKTP extends StatefulWidget {
  const TokoKTP({super.key});

  @override
  State<TokoKTP> createState() => _TokoKTPState();
}

class _TokoKTPState extends State<TokoKTP> {
  bool isChecked = false;

  Future<void> verifikasiToko() async {
    var userController = Get.find<UserController>().usersList[0];
    var controller = Get.find<TokoController>();
    await controller.verifikasiToko(userController.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Back
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: Dimensions.height10),

            // Logo
            Center(
              child: Container(
                width: Dimensions.width45 * 3,
                height: Dimensions.height45 * 3,
                margin: EdgeInsets.only(bottom: Dimensions.height20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/logo_rkt.png"),
                  ),
                ),
              ),
            ),

            // Foto KTP
            BigText(
              text: "Foto KTP",
              fontWeight: FontWeight.bold,
              size: Dimensions.font16,
            ),
            GetBuilder<TokoController>(builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2196F3),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text("Pilih File KTP"),
                  ),
                  controller.pickedFileKTP != null
                      ? Image.file(
                    File(controller.pickedFileKTP!.path),
                    width: 80,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const InstruksiKTP());
                        },
                        child: Image.asset(
                          "assets/images/ktp.png",
                          width: 80,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: 65,
                        color: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        child: const Text(
                          "Intruksi >",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  )
                  ,
                ],
              );
            }),
            SizedBox(height: 4),
            SmallText(
                text:
                "Pastikan gambar yang anda masukkan dapat dilihat dengan jelas."),
            SizedBox(height: 20),

            // Selfie KTP
            BigText(
              text: "Photo Selfie dengan KTP",
              fontWeight: FontWeight.bold,
              size: Dimensions.font16,
            ),
            GetBuilder<TokoController>(builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.pickImageSelfieKTP();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2196F3),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text("Pilih File Selfie KTP"),
                  ),
                  controller.pickedFileSelfieKTP != null
                      ? Image.file(
                    File(controller.pickedFileSelfieKTP!.path),
                    width: 80,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    "assets/images/selfiektp.png",
                    width: 80,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                ],
              );
            }),
            SizedBox(height: 4),
            SmallText(
                text:
                "Pastikan gambar yang anda masukkan dapat dilihat dengan jelas."),
            SizedBox(height: 20),

            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val ?? false;
                    });
                  },
                ),
                Expanded(
                  child:
                  SmallText(text: "Saya Menyetujui Syarat dan Ketentuan"),
                )
              ],
            ),
            SizedBox(height: 20),

            // Tombol Kirim
            GetBuilder<TokoController>(builder: (controller) {
              bool canSubmit = isChecked &&
                  controller.pickedFileKTP != null &&
                  controller.pickedFileSelfieKTP != null;

              return ElevatedButton(
                onPressed: canSubmit ? verifikasiToko : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redColor,
                  minimumSize: Size(double.infinity, 45),
                ),
                child: BigText(
                  text: "Kirim",
                  color: Colors.white,
                  size: Dimensions.font16,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
