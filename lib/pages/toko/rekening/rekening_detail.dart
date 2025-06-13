import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/controllers/bank_controller.dart';
import 'package:rumah_kreatif_toba/main.dart';
import 'package:rumah_kreatif_toba/models/rekening_model.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';

import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/tittle_text.dart';
import '../databank.dart';
import '../hometoko/hometoko_page.dart';
import 'package:get/get.dart';

import 'daftarrekening.dart';
class RekeningDetail extends StatefulWidget {
  final int rekeningid;
  const RekeningDetail({Key? key, required this.rekeningid}) : super(key: key);

  @override
  State<RekeningDetail> createState() => _RekeningDetailState();
}

class _RekeningDetailState extends State<RekeningDetail> {
  @override
  Widget build(BuildContext context) {
    Get.find<BankController>().getRekeningList();

    var rekeningList = Get.find<BankController>().daftarRekeningList;
    var daftarrekening = rekeningList.firstWhere(
            (rekening) => rekening.rekeningId == widget.rekeningid);


    @override
    void initState() {
      Get.find<BankController>().getRekeningList();
      super.initState();
    }

    Future<void> _hapusRekening() async {
      var controller = Get.find<BankController>();
      controller.hapusRekening(daftarrekening.rekeningId).then((status) async {

      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: Dimensions.height45, left: Dimensions.width20, right: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(DaftarRekening()); // Pass the initial index to the HomeTokoPage constructor
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
                          text: "Rekening Bank",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              width: Dimensions.screenWidth,
              margin: EdgeInsets.only(right: Dimensions.width20, left: Dimensions.width20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(text: 'Nama Lengkap'),
                  BigText(text: daftarrekening.atasNama.toString())
                ],
              ),
            ),
            Divider(color: AppColors.buttonBackgroundColor),
            Container(
              width: Dimensions.screenWidth,
              margin: EdgeInsets.only(right: Dimensions.width20, left: Dimensions.width20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(text: 'Nomor Rekening'),
                  BigText(text: daftarrekening.nomorRekening.toString())
                ],
              ),
            ),
            Divider(color: AppColors.buttonBackgroundColor),
            Container(
              width: Dimensions.screenWidth,
              margin: EdgeInsets.only(right: Dimensions.width20, left: Dimensions.width20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(text: 'Nama Bank'),
                  BigText(text: daftarrekening.namaBank.toString())
                ],
              ),
            ),
            Divider(color: AppColors.buttonBackgroundColor),
            GestureDetector(
              onTap: (){
                _hapusRekening();
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
                      text: "Hapus",
                      fontWeight: FontWeight.bold,
                      size: Dimensions.font20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
