import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:rumah_kreatif_toba/controllers/alamat_controller.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/models/province.dart';
import 'package:rumah_kreatif_toba/models/city.dart';
import 'package:rumah_kreatif_toba/models/subdistrict.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';
import 'package:rumah_kreatif_toba/pages/auth/masuk.dart';

import 'package:rumah_kreatif_toba/widgets/app_icon.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

class EditAlamatPage extends StatefulWidget {
  final int alamatId;
  final int province_id;
  final int city_id;
  final int subdistrict_id;
  final String province_name;
  final String city_name;
  final String subdistrict_name;
  final String user_street_address;

  EditAlamatPage({
    required this.alamatId,
    required this.province_id,
    required this.city_id,
    required this.subdistrict_id,
    required this.province_name,
    required this.city_name,
    required this.subdistrict_name,
    required this.user_street_address,
  });

  @override
  _EditAlamatPageState createState() => _EditAlamatPageState();
}

class _EditAlamatPageState extends State<EditAlamatPage> {
  final controller = Get.find<AlamatController>();
  final userController = Get.find<UserController>().usersList[0];
  final AuthController authController = Get.find<AuthController>();

  TextEditingController jalanController = TextEditingController();
  final String apiKey = "41df939eff72c9b050a81d89b4be72ba";

  bool isEditing = false; // Variabel untuk melacak status pengeditan

  @override
  void initState() {
    super.initState();
    _checkAuthentication();

    jalanController.text = widget.user_street_address;
    controller.province.value = widget.province_name;
    controller.city.value = widget.city_name;
    controller.sub.value = widget.subdistrict_name;
    controller.provAsalId.value = widget.province_id.toString();
    controller.cityAsalId.value = widget.city_id.toString();
    controller.subAsalId.value = widget.subdistrict_id.toString();

    debugPrint("[EditAlamatPage] initState - Data awal diset");
  }

  Future<void> _checkAuthentication() async {
    debugPrint("[EditAlamatPage] Mengecek autentikasi...");
    bool isLoggedIn = await authController.userLoggedIn();
    if (!isLoggedIn) {
      debugPrint("[EditAlamatPage] Tidak login, redirect ke login page");
      Get.off(() => Masuk());
    } else {
      debugPrint("[EditAlamatPage] Autentikasi OK");
    }
  }

  Future<void> _editAlamat() async {
    String provinsi = controller.province.value;
    String kota = controller.city.value;
    String kecamatan = controller.sub.value;
    String jalan = jalanController.text.trim();

    debugPrint("[EditAlamatPage] Mulai proses edit alamat...");

    if (provinsi.isEmpty || kota.isEmpty || kecamatan.isEmpty || jalan.isEmpty) {
      Get.snackbar("Gagal", "Semua field harus diisi!",
          backgroundColor: Colors.orange, colorText: Colors.white);
      debugPrint("[EditAlamatPage] Validasi gagal - Field kosong");
      return;
    }

    setState(() {
      isEditing = true; // Set isEditing menjadi true ketika proses edit dimulai
    });

    try {
      String token = await authController.authRepo.getUserToken();
      debugPrint("[EditAlamatPage] Token: $token");

      final response = await http.post(
        Uri.parse("${AppConstants.BASE_URL}alamat/edit"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "user_address_id": widget.alamatId,
          "province_id": controller.provAsalId.value,
          "province_name": provinsi,
          "city_id": controller.cityAsalId.value,
          "city_name": kota,
          "subdistrict_id": controller.subAsalId.value,
          "subdistrict_name": kecamatan,
          "user_street_address": jalan,
        }),
      );

      debugPrint("[EditAlamatPage] Status response: ${response.statusCode}");
      debugPrint("[EditAlamatPage] Body response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          Get.snackbar("Berhasil", "Alamat berhasil diperbarui",
              backgroundColor: Colors.green, colorText: Colors.white);

          debugPrint("[EditAlamatPage] Alamat berhasil diperbarui. Navigasi kembali...");
          await Future.delayed(Duration(seconds: 1)); // Tunggu snackbar tampil
          Navigator.pop(context); // Pastikan kembali
        } else {
          debugPrint("[EditAlamatPage] API response gagal: ${responseData['message']}");
          Get.snackbar("Gagal", responseData['message'] ?? "Gagal memperbarui alamat",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        debugPrint("[EditAlamatPage] Request gagal status ${response.statusCode}");
        Get.snackbar("Gagal", "Status: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("[EditAlamatPage] Exception error: $e");
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isEditing = false; // Set isEditing menjadi false setelah proses selesai
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width10,
                  right: Dimensions.width20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      debugPrint("[EditAlamatPage] Tombol back ditekan");
                      Navigator.pop(context);
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back,
                      iconColor: AppColors.redColor,
                      backgroundColor: Colors.white,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  BigText(text: "Edit Alamat", fontWeight: FontWeight.bold),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Dropdown Provinsi
                  DropdownSearch<Province>(
                    selectedItem: Province(
                      provinceId: controller.provAsalId.value,
                      province: controller.province.value,
                    ),
                    items: [],
                    onFind: (String? filter) async {
                      final response = await http.get(Uri.parse(
                          "https://pro.rajaongkir.com/api/province?key=$apiKey"));
                      return Province.fromJsonList(
                          jsonDecode(response.body)["rajaongkir"]["results"]);
                    },
                    showSearchBox: true,
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Provinsi",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.provAsalId.value = value?.provinceId ?? "0";
                      controller.province.value = value?.province ?? "0";
                      controller.city.value = '';
                      controller.sub.value = '';
                      controller.cityAsalId.value = "0";
                      controller.subAsalId.value = "0";
                      debugPrint("[EditAlamatPage] Provinsi dipilih: ${value?.province}");
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),

                  // Dropdown Kota
                  DropdownSearch<City>(
                    selectedItem: City(
                      cityId: controller.cityAsalId.value,
                      cityName: controller.city.value,
                    ),
                    items: [],
                    onFind: (String? filter) async {
                      final provId = controller.provAsalId.value;
                      if (provId == "0") return [];
                      final response = await http.get(Uri.parse(
                          "https://pro.rajaongkir.com/api/city?province=$provId&key=$apiKey"));
                      return City.fromJsonList(
                          jsonDecode(response.body)["rajaongkir"]["results"]);
                    },
                    showSearchBox: true,
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Kota / Kabupaten",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.cityAsalId.value = value?.cityId ?? "0";
                      controller.city.value = value?.cityName ?? "0";
                      controller.sub.value = '';
                      controller.subAsalId.value = "0";
                      debugPrint("[EditAlamatPage] Kota dipilih: ${value?.cityName}");
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),

                  // Dropdown Kecamatan
                  DropdownSearch<Subdistrict>(
                    selectedItem: Subdistrict(
                      subdistrictId: controller.subAsalId.value,
                      subdistrictName: controller.sub.value,
                    ),
                    items: [],
                    onFind: (String? filter) async {
                      final cityId = controller.cityAsalId.value;
                      if (cityId == "0") return [];
                      final response = await http.get(Uri.parse(
                          "https://pro.rajaongkir.com/api/subdistrict?city=$cityId&key=$apiKey"));
                      return Subdistrict.fromJsonList(
                          jsonDecode(response.body)["rajaongkir"]["results"]);
                    },
                    showSearchBox: true,
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Kecamatan",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.subAsalId.value = value?.subdistrictId ?? "0";
                      controller.sub.value = value?.subdistrictName ?? "0";
                      debugPrint("[EditAlamatPage] Kecamatan dipilih: ${value?.subdistrictName}");
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),

                  // Input Jalan
                  TextFormField(
                    controller: jalanController,
                    decoration: InputDecoration(
                      labelText: "Jalan",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Tombol Simpan
                  GestureDetector(
                    onTap: isEditing ? null : _editAlamat, // Nonaktifkan tombol jika sedang mengedit
                    child: Container(
                      alignment: Alignment.center,
                      width: Dimensions.width45 * 3,
                      height: Dimensions.height45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.redColor,
                      ),
                      child: isEditing
                          ? BigText(text: "Mengedit...", color: Colors.white)
                          : BigText(text: "Simpan", color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
