import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/data/repository/alamat_repo.dart';
import 'package:rumah_kreatif_toba/models/alamat_model.dart';
import 'package:rumah_kreatif_toba/models/alamat_toko_model.dart';
import 'package:rumah_kreatif_toba/pages/alamat/daftaralamat.dart';
import 'package:rumah_kreatif_toba/pages/toko/AlamatToko/daftar_alamat_toko.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';

import '../base/snackbar_message.dart';
import '../models/response_model.dart';
import 'auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlamatController extends GetxController {
  RxString provAsalId = "0".obs;
  RxString province = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString city = "0".obs;
  RxString subAsalId = "0".obs;
  RxString sub = "0".obs;

  RxString cityTujuanId = "0".obs;
  RxString cityUserId = "0".obs;

  RxString provTujuanId = "0".obs;
  RxString subTujuanId = "0".obs;

  RxInt berat = 0.obs;
  RxInt HargaPengiriman = 0.obs;
  RxString estimasi = "".obs;
  RxString service = "".obs;
  var subAsal = 0.obs;
  RxString selected = "".obs;
  RxInt alamatID = 0.obs;

  var hiddenButton = true.obs;
  var kurir = "".obs;
  var namakurir = "".obs;

  final AlamatRepo alamatRepo;

  AlamatController({required this.alamatRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RxList<dynamic> _daftarAlamatList = <dynamic>[].obs;
  List<dynamic> get daftarAlamatList => _daftarAlamatList.value;

  RxList<dynamic> _daftarAlamatMerchantList = <dynamic>[].obs;
  List<dynamic> get daftarAlamatMerchantList => _daftarAlamatMerchantList.value;

  RxList<dynamic> _daftarAlamatTokoList = <dynamic>[].obs;
  List<dynamic> get daftarAlamatTokoList => _daftarAlamatTokoList.value;

  RxList<Alamat> _daftarAlamatUserList = <Alamat>[].obs;
  List<dynamic> get getDaftarAlamatUserList => _daftarAlamatUserList.value;

  void showButton() {
    if (kurir != "") {
      hiddenButton.value = false;
    } else {
      hiddenButton.value = true;
    }
  }

  void setHargaPengiriman(int? harga) {
    HargaPengiriman.value = harga!;
    update();
  }

  void setEstimasiPengiriman(String? est) {
    estimasi.value = est!;
    update();
  }

  void setServicePengiriman(String? serv) {
    service.value = serv!;
    update();
  }

  void setAsal(int? asal) {
    subAsal.value = asal!;
    update();
  }

  void setTypeAlamat(String? getalamat) {
    selected.value = getalamat!;
    update();
  }

  void setId(int? idAlamat) {
    alamatID.value = idAlamat!;
    update();
  }

  void setAlamat() {}

  Future<void> getAlamat() async {
    if (Get.find<AuthController>().userLoggedIn()) {
      var userController = Get.find<UserController>();

      // Tunggu sampai userController memiliki data pengguna
      if (userController.usersList.isEmpty) {
        print("Error: usersList masih kosong, menunggu data pengguna...");
        return;
      }

      var controller = userController.usersList[0];

      try {
        Response response = await alamatRepo.getAlamat(controller.id!);

        if (response.statusCode == 200) {
          List<dynamic> responseBody = response.body["alamat"] ?? [];

          _daftarAlamatList.value = [].obs;
          for (dynamic item in responseBody) {
            Alamat alamat = Alamat.fromJson(item);
            _daftarAlamatList.add(alamat);
          }

          _isLoading = true;
          update();
        } else {
          print("Gagal mengambil data alamat, statusCode: ${response.statusCode}");
        }
      } catch (e) {
        print("Error saat mengambil alamat: $e");
      }
    } else {
      print("Error: Pengguna belum login.");
    }
  }

  Future<ResponseModel> tambahAlamat(
      int? user_id,
      String province_name,
      String city_name,
      String subdistrict_name,
      String user_street_address,
      String province_id,
      String city_id,
      String subdistrict_id,
      ) async {
    _isLoading = true;
    update();
    Response response = await alamatRepo.tambahAlamat(
      user_id!,
      province_id,
      province_name,
      city_id,
      city_name,
      subdistrict_id,
      subdistrict_name,
      user_street_address,
    );
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Berhasil menambah alamat", ContentType.success);
      Get.to(
            () => DaftarAlamatPage(),
      );
      getAlamat();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> hapusAlamat(int? user_address_id) async {
    Response response = await alamatRepo.hapusAlamat(user_address_id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Alamat berhasil dihapus", ContentType.success);
      getAlamat();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = true;
    update();
    return responseModel;
  }

  Future<void> editAlamat(
      int userId,
      String provinsi,
      String kota,
      String kecamatan,
      String jalan,
      String provAsalId,
      String cityAsalId,
      String subdistrictId,
      int alamatId,
      ) async {
    final url = Uri.parse("${AppConstants.BASE_URL}alamat/edit");

    final body = jsonEncode({
      "user_address_id": alamatId,
      "province_id": int.parse(provAsalId),
      "province_name": provinsi,
      "city_id": int.parse(cityAsalId),
      "city_name": kota,
      "subdistrict_id": int.parse(subdistrictId),
      "subdistrict_name": kecamatan,
      "user_street_address": jalan,
    });


    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${Get.find<AuthController>().getToken()}",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print("Alamat berhasil diupdate");
      } else {
        print("Gagal update alamat: ${response.body}");
      }
    } catch (e) {
      print("Error updating alamat: $e");
    }
  }

  Future<void> getAlamatToko() async {
    if (Get.find<AuthController>().userLoggedIn()) {
      if (Get.find<TokoController>().profilTokoList.isNotEmpty) {
        var controller = Get.find<TokoController>().profilTokoList[0];
        Response response =
        await alamatRepo.getAlamatToko(controller.merchant_id!);
        if (response.statusCode == 200) {
          List<dynamic> responseBody = response.body["alamattoko"];
          _daftarAlamatTokoList.value = [];
          for (dynamic item in responseBody) {
            AlamatToko alamat = AlamatToko.fromJson(item);
            _daftarAlamatTokoList.add(alamat);
          }
          _isLoading = true;
          update();
        } else {}
      }
    }
  }

  Future<void> getAlamatMerchant(int? merchant_id) async {
    Response response = await alamatRepo.getAlamatToko(merchant_id!);
    if (response.statusCode == 200) {
      List<dynamic> responseBody = response.body["alamattoko"];
      _daftarAlamatTokoList.value = [];
      for (dynamic item in responseBody) {
        AlamatToko alamat = AlamatToko.fromJson(item);
        _daftarAlamatTokoList.add(alamat);
      }

      _isLoading = true;
      update();
    } else {}
  }

  Future<ResponseModel> tambahAlamatToko(
      int? merchant_id,
      String province_name,
      String city_name,
      String subdistrict_name,
      String user_street_address,
      String province_id,
      String city_id,
      String subdistrict_id,
      ) async {
    _isLoading = true;
    update();
    Response response = await alamatRepo.tambahAlamatToko(
      merchant_id!,
      province_id,
      province_name,
      city_id,
      city_name,
      subdistrict_id,
      subdistrict_name,
      user_street_address,
    );
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Berhasil menambah alamat toko", ContentType.success);
      Get.to(() => DaftarAlamatTokoPage());
      getAlamatToko();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> hapusAlamatToko(int? merchant_address_id) async {
    Response response = await alamatRepo.hapusAlamatToko(merchant_address_id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Alamat toko berhasil dihapus", ContentType.success);
      getAlamatToko();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = true;
    update();
    return responseModel;
  }

  Future<void> getAlamatUser() async {
    if (Get.find<AuthController>().userLoggedIn()) {
      if (daftarAlamatList.isNotEmpty) {
        var alamat = daftarAlamatList[0];
        Response response =
        await alamatRepo.getAlamatUser(alamat.user_address_id);
        if (response.statusCode == 200) {
          List<dynamic> responseBody = response.body["alamat"];
          _daftarAlamatUserList.value = [];
          for (dynamic item in responseBody) {
            Alamat alamat = Alamat.fromJson(item);
            _daftarAlamatUserList.add(alamat);
          }
          _isLoading = true;
          update();
        } else {}
      }
    }
  }
}
