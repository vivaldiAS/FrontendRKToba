import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/models/response_model.dart';
import 'package:rumah_kreatif_toba/models/toko_models.dart';
import 'package:rumah_kreatif_toba/pages/toko/daftarberhasil.dart';
import 'package:rumah_kreatif_toba/pages/toko/hometoko/hometoko_page.dart';
import 'package:rumah_kreatif_toba/pages/toko/namatoko.dart';
import 'package:rumah_kreatif_toba/pages/toko/passwordtoko.dart';
import 'package:rumah_kreatif_toba/pages/toko/profil/profiltoko_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../base/snackbar_message.dart';
import '../data/repository/toko_repo.dart';
import '../pages/toko/infotokoktp.dart';
import '../pages/toko/menungguverifikasi.dart';
import '../pages/toko/menungguverifikasitoko.dart';
import '../routes/route_helper.dart';
import '../utils/app_constants.dart';

class TokoController extends GetxController {
  final TokoRepo tokoRepo;

  TokoController({
    required this.tokoRepo,
  });
  List<dynamic> _tokoList = [];
  List<dynamic> get tokoList => _tokoList;

  RxList<dynamic> _profilTokoList = <dynamic>[].obs;
  List<dynamic> get profilTokoList => _profilTokoList;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RxMap<String, int> jumlahPesanan = <String, int>{}.obs;

  Map<String, int> get getJumlahPesanan => jumlahPesanan;

  @override
  void initState() {
    pickImage();
    pickImageSelfieKTP();
  }

  PickedFile? _pickedFileKTP;
  PickedFile? get pickedFileKTP => _pickedFileKTP;

  PickedFile? _pickedFileSelfieKTP;
  PickedFile? get pickedFileSelfieKTP => _pickedFileSelfieKTP;

  String? _imagePath;
  String? get imagePath => _imagePath;

  final _picker = ImagePicker();
  Future<void> pickImage() async {
    final result = await _picker.pickImage(source: ImageSource.gallery);
    _pickedFileKTP = PickedFile("${result?.path}");
    update();
  }

  final _pickerSelfieKTP = ImagePicker();
  Future<void> pickImageSelfieKTP() async {
    final result =
        await _pickerSelfieKTP.pickImage(source: ImageSource.gallery);
    _pickedFileSelfieKTP = PickedFile("${result?.path}");
    update();
  }

  Future<bool> verifikasiToko(int? user_id) async {
    update();
    bool success = false;

    // Send the request
    http.StreamedResponse? response = (await uploadVerifikasiToko(
            user_id, _pickedFileKTP, _pickedFileSelfieKTP))
        as http.StreamedResponse?;
    if (response?.statusCode == 200) {
      success = true;
      dynamic decodedData = jsonDecode(await response!.stream.bytesToString());

      if (decodedData is Map) {
        Map map = decodedData;
        // Your code here
        String message = map["message"] ?? "";
        print(message);
        _imagePath = message;
      } else {
        // Handle error
        print('Error: Response was not a map');
      }
    } else {
      print(response);
    }
    _isLoading = true;
    update();
    return success;
  }

  Future<List<http.StreamedResponse>> uploadVerifikasiToko(
      int? user_id, PickedFile? KTP, PickedFile? SelfieKTP) async {
    List<http.StreamedResponse> responses = [];

    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse(AppConstants.BASE_URL + AppConstants.VERIFIKASI_TOKO_URL));
    if (GetPlatform.isMobile && KTP != null && SelfieKTP != null) {
      File _fileKTP = File(KTP.path);
      request.files.add(http.MultipartFile(
          'foto_ktp', _fileKTP.readAsBytes().asStream(), _fileKTP.lengthSync(),
          filename: _fileKTP.path.split('/').last));

      File _fileSelfieKTP = File(SelfieKTP.path);
      request.files.add(http.MultipartFile('ktp_dan_selfie',
          _fileSelfieKTP.readAsBytes().asStream(), _fileSelfieKTP.lengthSync(),
          filename: _fileSelfieKTP.path.split('/').last));
    } else {
      AwesomeSnackbarButton(
          "Warning", "Harap memasukkan gambar!", ContentType.warning);
    }
    request.fields['user_id'] = user_id.toString();
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Get.toNamed(RouteHelper.getInitial());
      print("Uploaded!");
    }
    responses.add(response);
    return responses;
  }

  Future<void> cekVerifikasi() async {
    var controller = Get.find<UserController>().usersList[0];
    Response response = await tokoRepo.cekVerifikasi(controller.id!);
    if (response.statusCode == 200) {
      if (response.body == 0) {
        Get.to(DaftarBerhasil());
      } else if (response.body == 1) {
        Get.to(NamaToko());
      } else if (response.body == 2) {
        Get.to(PasswordTokoPage());
      } else if (response.body == 3) {
        Get.to(MenungguVerifikasiToko());
      } else if (response.body == 4) {
        Get.to(MenungguVerifikasi());
      } else if (response.body == 5) {
        Get.to(TokoKTP());
      }
      _isLoading = true;
      update();
    } else {}
  }

  PickedFile? _pickedFileFotoMerchant;
  PickedFile? get pickedFileFotoMerchant => _pickedFileFotoMerchant;

  String? _imagePathFotoMerchant;
  String? get imagePathFotoMerchant => _imagePathFotoMerchant;

  final _pickerFotoMerchant = ImagePicker();
  Future<void> pickImageFotoMerchant() async {
    _pickedFileFotoMerchant =
        await _pickerFotoMerchant.getImage(source: ImageSource.gallery);
    update();
  }

  Future<bool> tambahToko(int? user_id, String nama_merchant,
      String deskripsi_toko, String kontak_toko) async {
    _isLoading = true;
    update();
    bool success = false;

    // Send the request
    http.StreamedResponse? response = (await uploadTambahToko(
        user_id,
        nama_merchant,
        deskripsi_toko,
        kontak_toko,
        _pickedFileFotoMerchant)) as http.StreamedResponse?;
    if (response?.statusCode == 200) {
      success = true;
      dynamic decodedData = jsonDecode(await response!.stream.bytesToString());

      if (decodedData is Map) {
        Map map = decodedData;
        // Your code here
        String message = map["message"] ?? "";
        print(message);
        _imagePath = message;
      } else {
        // Handle error
        print('Error: Response was not a map');
      }
    } else {
      print(response);
    }
    update();
    return success;
  }

  Future<List<http.StreamedResponse>> uploadTambahToko(
      int? user_id,
      String nama_merchant,
      String deskripsi_toko,
      String kontak_toko,
      PickedFile? fotoMerchant) async {
    List<http.StreamedResponse> responses = [];

    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse(AppConstants.BASE_URL + AppConstants.TAMBAH_TOKO_URL));
    if (GetPlatform.isMobile && fotoMerchant != null) {
      File _fileFotoMerchant = File(fotoMerchant.path);
      request.files.add(http.MultipartFile(
          'foto_merchant',
          _fileFotoMerchant.readAsBytes().asStream(),
          _fileFotoMerchant.lengthSync(),
          filename: _fileFotoMerchant.path.split('/').last));
    }
    request.fields['user_id'] = user_id.toString();
    request.fields['nama_merchant'] = nama_merchant.toString();
    request.fields['deskripsi_toko'] = deskripsi_toko.toString();
    request.fields['kontak_toko'] = kontak_toko.toString();
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Get.offNamed(RouteHelper.getMenungguVerifikasiTokoPage());
      AwesomeSnackbarButton(
          "Berhasil",
          "Pendaftaran toko berhasil, tunggu toko Anda diverifikasi",
          ContentType.success);
      print("Uploaded!");
    }
    responses.add(response);
    return responses;
  }

  PickedFile? _pickedFileUbahFotoMerchant;
  PickedFile? get pickedFileUbahFotoMerchant => _pickedFileUbahFotoMerchant;

  String? _imagePathUbahFotoMerchant;
  String? get imagePathUbahFotoMerchant => _imagePathFotoMerchant;

  final _pickerUbahFotoMerchant = ImagePicker();
  Future<void> pickImageUbahFotoMerchant() async {
    _pickedFileUbahFotoMerchant =
        await _pickerUbahFotoMerchant.getImage(source: ImageSource.gallery);
    update();
  }

  Future<bool> ubahToko(int? merchant_id, String nama_merchant,
      String deskripsi_toko, String kontak_toko) async {
    _isLoading = true;
    update();
    bool success = false;

    // Send the request
    http.StreamedResponse? response = (await uploadUbahToko(
        merchant_id,
        nama_merchant,
        deskripsi_toko,
        kontak_toko,
        _pickedFileUbahFotoMerchant)) as http.StreamedResponse?;
    if (response?.statusCode == 200) {
      success = true;
      dynamic decodedData = jsonDecode(await response!.stream.bytesToString());

      if (decodedData is Map) {
        Map map = decodedData;
        // Your code here
        String message = map["message"] ?? "";
        print(message);
        _imagePath = message;
      } else {
        // Handle error
        print('Error: Response was not a map');
      }
    } else {
      print(response);
    }
    update();
    return success;
  }

  Future<void> uploadUbahToko(
    int? merchant_id,
    String nama_merchant,
    String deskripsi_toko,
    String kontak_toko,
    PickedFile? fotoMerchant,
  ) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(AppConstants.BASE_URL + AppConstants.UBAH_TOKO_URL),
    );

    if (GetPlatform.isMobile && fotoMerchant != null) {
      File _fileFotoMerchant = File(fotoMerchant.path);
      request.files.add(
        http.MultipartFile(
          'foto_merchant',
          _fileFotoMerchant.readAsBytes().asStream(),
          _fileFotoMerchant.lengthSync(),
          filename: _fileFotoMerchant.path.split('/').last,
        ),
      );
    } else {
      request.fields['foto_merchant'] =
          Get.find<TokoController>().profilTokoList[0].foto_merchant.toString();
    }

    request.fields['merchant_id'] = merchant_id.toString();
    request.fields['nama_merchant'] = nama_merchant;
    request.fields['deskripsi_toko'] = deskripsi_toko;
    request.fields['kontak_toko'] = kontak_toko;

    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      // Navigating to ProfilTokoPage
      profilToko();
      Get.to(ProfilTokoPage());
      print('Uploaded!');
    } else {
      print('Upload failed with status code: ${streamedResponse.statusCode}');
    }
  }

  Future<ResponseModel> masukToko(int? user_id, String password) async {
    _isLoading = true;
    update();
    Response response = await tokoRepo.masukToko(user_id!, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body == 200) {
        profilToko();
        Get.to(HomeTokoPage(initialIndex: 0));
      } else {
        AwesomeSnackbarButton(
            "Gagal", response.body["message"], ContentType.failure);
      }
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> profilToko() async {
    _isLoading = true;
    update();

    try {
      var controller = Get.find<UserController>().usersList[0];
      Response response = await tokoRepo.profilToko(controller.id!);

      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.body;
        _profilTokoList.clear();
        for (dynamic item in responseBody) {
          Toko toko = Toko.fromJson(item);
          _profilTokoList.add(toko);
        }
      } else {
        // Bisa handle error disini jika perlu
        print("Error fetch profil toko: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in profilToko: $e");
    }

    _isLoading = false;
    update();
  }

  Future<void> profilTokoViaToken() async {
    _isLoading = true;
    update();

    try {
      final authController = Get.find<AuthController>();
      String token = await authController.getToken();

      if (token.isEmpty) {
        print("Token tidak tersedia");
        _profilTokoList.clear();
        _isLoading = false;
        update();
        return;
      }

      Response response = await tokoRepo.profilTokoWithToken(token);

      if (response.statusCode == 200 && response.body != null) {
        var data = response.body;
        _profilTokoList.clear();
        Toko toko = Toko.fromJson(data);
        _profilTokoList.add(toko);
      } else {
        print("Gagal fetch profil toko via token, status: ${response.statusCode}");
        _profilTokoList.clear();
      }
    } catch (e) {
      print("Exception profilTokoViaToken: $e");
      _profilTokoList.clear();
    }

    _isLoading = false;
    update();
  }



  Future<void> homeToko() async {
    _isLoading = true;
    update();

    try {
      var controller = Get.find<UserController>().usersList[0];
      Response response = await tokoRepo.homeToko(controller.id!);

      if (response.statusCode == 200) {
        try {
          jumlahPesanan.value = {
            'jumlah_pesanan_sedang_berlangsung':
            response.body["jumlah_pesanan_sedang_berlangsung"],
            'jumlah_pesanan_berhasil_belum_dibayar':
            response.body["jumlah_pesanan_berhasil_belum_dibayar"],
            'jumlah_pesanan_berhasil_telah_dibayar':
            response.body["jumlah_pesanan_berhasil_telah_dibayar"],
            'jumlah_produk': response.body["jumlah_produk"]
          };
        } catch (e) {
          print("Error parsing response: $e");
        }
      } else {
        print("Error fetch home toko: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in homeToko: $e");
    }

    _isLoading = false;
    update();
  }

}
