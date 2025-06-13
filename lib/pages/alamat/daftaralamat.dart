import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/home/home_page.dart';
import 'package:rumah_kreatif_toba/routes/route_helper.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/controllers/alamat_controller.dart';
import 'package:rumah_kreatif_toba/models/alamat_model.dart';
import '../../base/show_custom_message.dart';
import '../../base/snackbar_message.dart';
import '../../utils/colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import 'editalamat.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class DaftarAlamatPage extends GetView<AlamatController> {
  int index = 0;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Get.find<AlamatController>().getAlamat();

    Future<void> _hapusAlamat(int? user_address_id) async {
      var Controller = Get.find<AlamatController>();
      Controller.hapusAlamat(user_address_id).then((status) {
        if (status.isSuccess) {
        } else {
          AwesomeSnackbarButton("Gagal", status.message, ContentType.failure);
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
                          Get.to(HomePage(initialIndex: 4));
                        },
                        child: AppIcon(
                          icon: Icons.arrow_back,
                          iconColor: AppColors.redColor,
                          backgroundColor: Colors.white,
                          iconSize: Dimensions.iconSize24,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      BigText(
                        text: "Daftar Alamat",
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Get.find<AlamatController>().daftarAlamatList.length <= 5
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.getTambahAlamatPage());
                              },
                              child: Container(
                                  child: Icon(
                                Icons.add,
                                color: AppColors.redColor,
                              )),
                            ),
                          ],
                        )
                      : SizedBox()
                ],
              ),
            ),
            GetBuilder<AlamatController>(
              builder: (AlamatController) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: AlamatController.daftarAlamatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Alamat alamat = AlamatController.daftarAlamatList[index];
                    return Container(
                      width: Dimensions.screenWidth,
                      height: Dimensions.height45 * 4,
                      margin: EdgeInsets.only(
                          bottom: Dimensions.height10,
                          top: Dimensions.height10 / 2,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      padding: EdgeInsets.all(Dimensions.height20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.buttonBackgroundColor),
                          borderRadius: BorderRadius.circular(
                              Dimensions.radius20 / 4),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  text: "Alamat ${index + 1}",
                                  fontWeight: FontWeight.bold,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    alamat.province_name?.toString() ?? "",
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    alamat.city_name?.toString() ?? "",
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    alamat.subdistrict_name?.toString() ?? "",
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    alamat.user_street_address?.toString() ??
                                        "",
                                    maxLines: 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              GestureDetector(
  onTap: () {
    Get.to(
    EditAlamatPage(
  alamatId: alamat.user_address_id ?? 0,
  province_id: alamat.province_id ?? 0,
  city_id: alamat.city_id ?? 0,
  subdistrict_id: alamat.subdistrict_id ?? 0,
  province_name: alamat.province_name ?? "",
  city_name: alamat.city_name ?? "",
  subdistrict_name: alamat.subdistrict_name ?? "",
  user_street_address: alamat.user_street_address ?? "",
),
    );
  },
  child: AppIcon(
    iconSize: Dimensions.iconSize16,
    iconColor: AppColors.redColor,
    backgroundColor: Colors.white,
    icon: Icons.edit,
  ),
),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  _hapusAlamat(alamat.user_address_id);
                                },
                                child: AppIcon(
                                  iconSize: Dimensions.iconSize16,
                                  iconColor: AppColors.redColor,
                                  backgroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
