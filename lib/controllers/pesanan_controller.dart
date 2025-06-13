import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/data/repository/pesanan_repo.dart';
import 'package:rumah_kreatif_toba/models/purchase_models.dart';

import '../base/snackbar_message.dart';
import '../models/response_model.dart';
import '../pages/pesanan/pesanan_page.dart';
import '../utils/app_constants.dart';
import 'auth_controller.dart';

class PesananController extends GetxController {
  final PesananRepo pesananRepo;
  PesananController({required this.pesananRepo});

  RxList<dynamic> _pesananList = <dynamic>[].obs;
  List<dynamic> get pesananList => _pesananList;

  RxList<dynamic> _pesananMenungguPembayaranList = <dynamic>[].obs;
  List<dynamic> get pesananMenungguPembayaranList =>
      _pesananMenungguPembayaranList;

  List<dynamic> _detailPesananList = [].obs;
  List<dynamic> get detailPesananList => _detailPesananList;

  List<dynamic> _detailPesanan = [].obs;
  List<dynamic> get detailPesanan => _detailPesanan;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void initState() {
    getPesanan();
  }

  Future<void> getPesanan() async {
    if (Get.find<AuthController>().userLoggedIn()) {
      var controller = Get.find<UserController>().usersList[0];
      Response response = await pesananRepo.getPesananList(controller.id!);
      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.body;
        _pesananList.value = [].obs;
        for (dynamic item in responseBody) {
          PurchaseModel purchase = PurchaseModel.fromJson(item);
          _pesananList.add(purchase);
        }
        _isLoading = false;
      }
      update();
    }
  }

  Future<void> getPesananMenungguBayaranList() async {
    if (Get.find<AuthController>().userLoggedIn()) {
      var controller = Get.find<UserController>().usersList[0];
      Response response =
          await pesananRepo.getPesananMenungguBayaranList(controller.id!);
      late ResponseModel responseModel;
      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.body;
        _pesananMenungguPembayaranList.value = [].obs;
        for (dynamic item in responseBody) {
          PurchaseModel purchase = PurchaseModel.fromJson(item);
          _pesananMenungguPembayaranList.add(purchase);
        }
        responseModel = ResponseModel(true, "successfully");
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
      _isLoading = false;
    }

    update();
  }

  Future<ResponseModel> getDetailPesananList(int purchaseId) async {
    var controller = Get.find<UserController>().usersList[0];
    Response response =
        await pesananRepo.getDetailPesananList(controller.id!, purchaseId);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      List<dynamic> responseBody = response.body["purchasesdetail"];
      _detailPesanan.clear();

      for (dynamic item in responseBody) {
        PurchaseModel purchase = PurchaseModel.fromJson(item);
        _detailPesanan.add(purchase);
      }

      List<dynamic> responseBodyPurchases = response.body["purchases"];
      _detailPesananList.clear();
      for (dynamic item in responseBodyPurchases) {
        PurchaseModel purchase = PurchaseModel.fromJson(item);
        _detailPesananList.add(purchase);
      }
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;

  String? _imagePath;
  String? get imagePath => _imagePath;

  final _picker = ImagePicker();
  Future<void> pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    update();
  }

  Future<bool> postBuktiPembayaran(int purchaseId) async {
    _isLoading = true;
    update();
    bool success = false;

    Map<String, dynamic> requestPayload = {
      'purchase_id': purchaseId,
    };
    // Send the request
    http.StreamedResponse? response =
        (await updateProfile(purchaseId, _pickedFile))
            as http.StreamedResponse?;
    if (response?.statusCode == 200) {
      success = true;
      dynamic decodedData = jsonDecode(await response!.stream.bytesToString());

      if (decodedData is Map) {
        Map map = decodedData;
        // Your code here
        String message = map["message"] ?? "";
        _imagePath = message;
      } else {
        // Handle error
        print('Error: Response was not a map');
      }
      Get.find<PesananController>().pesananMenungguPembayaranList.toList();
      _pickedFile = null;
    } else {
      print(response);
    }

    update();
    return success;
  }

  Future<List<http.StreamedResponse>> updateProfile(
      int purchaseId, PickedFile? data) async {
    List<http.StreamedResponse> responses = [];

    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse(AppConstants.BASE_URL + AppConstants.BUKTI_PEMBAYARAN));
    if (GetPlatform.isMobile && data != null) {
      File _file = File(data.path);
      request.files.add(http.MultipartFile('proof_of_payment_image',
          _file.readAsBytes().asStream(), _file.lengthSync(),
          filename: _file.path.split('/').last));
    }
    request.fields['purchase_id'] = purchaseId.toString();
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Get.to(PesananPage());
      print("Uploaded!");
    }
    responses.add(response);

    return responses;
  }

  Future<void> hapusPesanan(String kode_pembelian) async {
    Response response = await pesananRepo.hapusPesanan(kode_pembelian);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Pesanan berhasil dihapus", ContentType.success);
      getPesananMenungguBayaranList();
    } else {
      AwesomeSnackbarButton("Gagal", response.statusText!, ContentType.failure);
    }
    getPesananMenungguBayaranList();
    _isLoading = false;
    update();
  }
}
