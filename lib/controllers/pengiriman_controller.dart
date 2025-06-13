import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/alamat_controller.dart';
import 'package:rumah_kreatif_toba/controllers/pesanan_controller.dart';

import '../base/show_custom_message.dart';
import '../base/snackbar_message.dart';
import '../data/repository/pengiriman_repo.dart';
import '../models/response_model.dart';
import '../pages/pembayaran/pembayaran_page.dart';
import '../pages/pesanan/detail_pesanan_page.dart';
import '../pages/pesanan/pesanan_page.dart';
import '../routes/route_helper.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'auth_controller.dart';

class PengirimanController extends GetxController{
  final PengirimanRepo pengirimanRepo;
  PengirimanController({required this.pengirimanRepo});
  RxInt purchaseId = 0.obs;
  // int _paymentIndex = 0;
  // int get paymentIndex => _paymentIndex;

  @override
  void initState() {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<AlamatController>().getAlamatUser();
    }
  }
  String _alamatType = "aa";
  String get alamatType => _alamatType;

  RxInt paymentIndex = RxInt(0);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _typePengiriman = "Pilih Pengiriman";
  String get typePengiriman => _typePengiriman;

  RxString checkedtypePengiriman = RxString("Pilih Pengiriman");


  Future<ResponseModel> beliProduk(int? user_id, List cart_id, int merchant_id, int metode_pembelian, int harga_pembelian, String potongan_pembelian,  int alamat_purchase, String courier_code, String service, int ongkir) async {
    _isLoading = true;
    update();
    Response response = await pengirimanRepo.beliProduk(user_id!, cart_id, merchant_id, metode_pembelian, harga_pembelian, potongan_pembelian, alamat_purchase, courier_code, service, ongkir);
    late ResponseModel responseModel;
    if(response.statusCode == 200){
      AwesomeSnackbarButton("Berhasil","Produk berhasil dibeli",ContentType.success);
      purchaseId.value = response.body;
      await Get.find<PesananController>().getDetailPesananList(purchaseId.value);
      Get.to(PembayaranPage());
    }else{
      responseModel = ResponseModel(false, response.statusText!);
      AwesomeSnackbarButton("Gagal",response.statusText!,ContentType.failure);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> beliLangsung(int? user_id, int product_id, int metode_pembelian, int jumlah_masuk_keranjang, int harga_pembelian, String potongan_pembelian,  int alamat_purchase, String courier_code, String service, int ongkir) async {
    _isLoading = true;
    update();
    Response response = await pengirimanRepo.beliLangsung(user_id!, product_id,  metode_pembelian, jumlah_masuk_keranjang, harga_pembelian, potongan_pembelian, alamat_purchase, courier_code, service, ongkir);
    late ResponseModel responseModel;
    if(response.statusCode == 200){
      AwesomeSnackbarButton("Berhasil","Produk berhasil dibeli",ContentType.success);
      purchaseId.value = response.body;
      await Get.find<PesananController>().getDetailPesananList(purchaseId.value);
      Get.to(PembayaranPage());
    }else{
      responseModel = ResponseModel(false, response.statusText!);

    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> beliProdukMultiMerchant(
      int? user_id,
      List<List<int?>> cart_ids_per_merchant,
      List<int> merchant_ids,
      int metode_pembelian,
      List<int> harga_pembelian_per_merchant,
      String potongan_pembelian,
      String alamat_purchase,
      String courier_code,
      String service,
      int ongkir,
      ) async {
    _isLoading = true;
    update();

    List<Map<String, dynamic>> merchants = [];

    for (int i = 0; i < merchant_ids.length; i++) {
      merchants.add({
        "merchant_id": merchant_ids[i],
        "cart_ids": cart_ids_per_merchant[i],
        "harga_pembelian": harga_pembelian_per_merchant[i],
      });
    }

    Map<String, dynamic> body = {
      "merchants": merchants,
      "catatan": "hushusland", // Bisa diganti input user
      "alamat_purchase": alamat_purchase,
      "potongan_pembelian": int.tryParse(potongan_pembelian) ?? 0,
      "metode_pembelian": metode_pembelian == 1 ? "ambil_ditempat" : "dikirim",
      "courier_code": courier_code,
      "service": service,
      "ongkir": ongkir
    };

    print(">>> Data dikirim ke backend:");
    print(body);

    Response response =
    await pengirimanRepo.beliProdukMultiMerchant(body);

    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton("Berhasil", "Produk berhasil dibeli", ContentType.success);
      purchaseId.value = response.body['purchase_id']; // ← disesuaikan
      await Get.find<PesananController>().getDetailPesananList(purchaseId.value);
      Get.to(PembayaranPage());
      responseModel = ResponseModel(true, "Sukses");
    } else {
      responseModel = ResponseModel(false, response.statusText ?? "Gagal");
      AwesomeSnackbarButton("Gagal", response.statusText ?? "Gagal", ContentType.failure);
    }

    _isLoading = false;
    update();
    return responseModel;
  }



  void setPaymentIndex(int index){
    paymentIndex.value = index;
    update();
  }

  void setTypePengiriman(String title) {
    checkedtypePengiriman.value = title;
    update();
  }

  void setTypeAlamat(String type){
    _alamatType = type;
    update();
  }
}
