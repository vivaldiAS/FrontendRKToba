import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rumah_kreatif_toba/controllers/produk_controller.dart';
import 'package:rumah_kreatif_toba/models/produk_models.dart';
import 'package:rumah_kreatif_toba/pages/toko/hometoko/hometoko_page.dart';
import 'package:rumah_kreatif_toba/pages/toko/produk/produk_page.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';
import 'package:get/get.dart';
import '../../../base/show_custom_message.dart';
import '../../../base/snackbar_message.dart';
import '../../../controllers/toko_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/app_dropdown_field_kategori.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/input_text_field.dart';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class TambahProdukPage extends StatefulWidget {
  const TambahProdukPage({Key? key}) : super(key: key);

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final NamaProdukController = TextEditingController();
  final DeskripsiProdukController = TextEditingController();
  final HargaController = TextEditingController();
  final BeratController = TextEditingController();
  final StokController = TextEditingController();
  final KategoriController = TextEditingController();

  bool _isLoading = false;

  Future<void> _tambahProduk() async {
    if (_isLoading) return;

    String namaproduk = NamaProdukController.text.trim();
    String deskripsi = DeskripsiProdukController.text.trim();
    String kategori = KategoriController.text.trim();

    int? harga = int.tryParse(HargaController.text.trim());
    int? berat = int.tryParse(BeratController.text.trim());
    int? stok = int.tryParse(StokController.text.trim());

    var controller = Get.find<ProdukController>();

    if (namaproduk.isEmpty) {
      AwesomeSnackbarButton("Warning", "Nama produk masih kosong", ContentType.warning);
    } else if (deskripsi.isEmpty) {
      AwesomeSnackbarButton("Warning", "Deskripsi masih kosong", ContentType.warning);
    } else if (harga == null) {
      AwesomeSnackbarButton("Warning", "Harga tidak valid", ContentType.warning);
    } else if (stok == null) {
      AwesomeSnackbarButton("Warning", "Stok tidak valid", ContentType.warning);
    } else if (berat == null) {
      AwesomeSnackbarButton("Warning", "Berat tidak valid", ContentType.warning);
    } else if (kategori.isEmpty) {
      AwesomeSnackbarButton("Warning", "Kategori masih kosong", ContentType.warning);
    } else if (controller.pickedFileGambarProduk1 == null ||
        controller.pickedFileGambarProduk2 == null ||
        controller.pickedFileGambarProduk3 == null) {
      AwesomeSnackbarButton("Warning", "Semua gambar harus diisi", ContentType.warning);
    } else {
      setState(() {
        _isLoading = true;
      });

      var user = Get.find<UserController>().usersList[0];
      await controller.tambahProduk(
        user.id, namaproduk, deskripsi, harga, berat, kategori, stok,
      );

      setState(() {
        _isLoading = false;
      });

      // Arahkan atau tampilkan pesan berhasil jika perlu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                margin: EdgeInsets.only(top: Dimensions.height30, left: Dimensions.width10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(HomeTokoPage(initialIndex: 1));
                      },
                      child: AppIcon(
                        icon: Icons.arrow_back,
                        iconColor: AppColors.redColor,
                        backgroundColor: Colors.white,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    SizedBox(width: Dimensions.width10),
                    BigText(text: "Tambah Produk", fontWeight: FontWeight.bold),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // Input Fields
              _buildLabel("Nama Produk"),
              InputTextField(textController: NamaProdukController, hintText: 'Nama Produk'),

              _buildLabel("Kategori"),
              AppDropdownFieldKategori(hintText: 'Kategori', controller: KategoriController),

              _buildLabel("Deskripsi Produk"),
              InputTextField(textController: DeskripsiProdukController, hintText: 'Deskripsi Produk'),

              _buildLabel("Harga"),
              InputTextField(textController: HargaController, hintText: 'Harga', textInputType: TextInputType.number),

              _buildLabel("Gambar Produk"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildImagePicker(1),
                  _buildImagePicker(2),
                  _buildImagePicker(3),
                ],
              ),

              _buildLabel("Berat"),
              InputTextField(textController: BeratController, hintText: 'Berat', textInputType: TextInputType.number),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: SmallText(text: "Berat dihitung dalam gram (gr)."),
              ),

              SizedBox(height: Dimensions.height20),

              _buildLabel("Stok"),
              InputTextField(textController: StokController, hintText: 'Stok', textInputType: TextInputType.number),

              SizedBox(height: Dimensions.height20),

              Center(
                child: _isLoading
                    ? CircularProgressIndicator(color: AppColors.redColor)
                    : GestureDetector(
                  onTap: _tambahProduk,
                  child: Container(
                    width: Dimensions.width45 * 3,
                    height: Dimensions.height45,
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                      color: AppColors.redColor,
                    ),
                    child: Center(
                      child: BigText(text: "Tambah", color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: EdgeInsets.only(
          left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
      child: BigText(text: text, size: Dimensions.font16),
    );
  }

  Widget _buildImagePicker(int index) {
    return GetBuilder<ProdukController>(builder: (controller) {
      final imageFile = index == 1
          ? controller.pickedFileGambarProduk1
          : index == 2
          ? controller.pickedFileGambarProduk2
          : controller.pickedFileGambarProduk3;

      final pickImageFn = index == 1
          ? controller.pickImageGambarProduk1
          : index == 2
          ? controller.pickImageGambarProduk2
          : controller.pickImageGambarProduk3;

      return Column(
        children: [
          GestureDetector(
            onTap: pickImageFn,
            child: Container(
              margin: EdgeInsets.all(Dimensions.width10),
              padding: EdgeInsets.all(Dimensions.width20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 7,
                    offset: Offset(1, 1),
                    color: Colors.grey.withOpacity(0.2),
                  )
                ],
              ),
              child: Icon(Icons.add, color: AppColors.redColor),
            ),
          ),
          imageFile != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imageFile.path),
              fit: BoxFit.cover,
              width: Dimensions.width45 * 2,
              height: Dimensions.height45 * 2,
            ),
          )
              : Text(
            "Tidak Ada Gambar",
            style: TextStyle(fontSize: Dimensions.font16 / 2),
          ),
        ],
      );
    });
  }
}
