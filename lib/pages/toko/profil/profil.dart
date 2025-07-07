import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/pages/toko/profil/ubah_toko.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/expandable_text_widget.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<TokoController>().profilToko();
    var profilToko = Get.find<TokoController>().profilTokoList;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<TokoController>(
          builder: (controller) {
            var toko = profilToko[0];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: Dimensions.radius20,
                          child: Icon(Icons.store, color: Colors.grey),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: BigText(
                            text: toko.nama_merchant ?? 'Nama Toko',
                            size: Dimensions.font20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gambar toko (full width)
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          '${AppConstants.BASE_URL_IMAGE}u_file/foto_merchant/${toko.foto_merchant}',
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // Informasi Profil
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Profil Toko"),
                        SizedBox(height: Dimensions.height10),

                        // Info dua kolom
                        infoRow("Nama Toko", toko.nama_merchant),
                        infoRow("Kontak Toko", toko.kontak_toko),
                        infoRow("Alamat Toko", "Italia"),

                        SizedBox(height: Dimensions.height20),

                        // Deskripsi (label + isi satu kolom)
                        BigText(
                          text: "Deskripsi",
                          size: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: Dimensions.height10),
                        ExpandableTextWidget(text: toko.deskripsi_toko ?? "-"),

                        SizedBox(height: Dimensions.height20),

                        // Tombol Aksi
                        Row(
                          children: [
                            // Liburkan
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Logika liburkan toko
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.redColor,
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Liburkan Toko", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            // Edit
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.to(UbahTokoPage());
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.redColor),
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Edit", style: TextStyle(color: AppColors.redColor)),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Dimensions.height30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Judul bagian seperti "Profil Toko"
  Widget sectionTitle(String title) {
    return BigText(
      text: title,
      size: Dimensions.font16,
      fontWeight: FontWeight.bold,
    );
  }

  // Label + data dalam satu baris dua kolom
  Widget infoRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 2,
            child: BigText(
              text: label,
              size: Dimensions.font16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Nilai
          Expanded(
            flex: 3,
            child: BigText(
              text: value ?? "-",
              size: Dimensions.font16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
