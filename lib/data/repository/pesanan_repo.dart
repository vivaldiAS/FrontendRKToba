import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class PesananRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PesananRepo({  required this.apiClient,required this.sharedPreferences});

  Future<Response> getPesananList(int user_id) async{
    return await apiClient.postData(AppConstants.PESANAN_URL, {"user_id": user_id});
  }

  Future<Response> getPesananMenungguBayaranList(int user_id) async{
    return await apiClient.postData(AppConstants.MENUNGGU_PEMBAYARAN_URL, {"user_id": user_id});
  }

  Future<Response> getDetailPesananList(int user_id, int purchase_id) async{
    return await apiClient.postData(AppConstants.DETAIL_PESANAN_URL, {"user_id": user_id, "purchase_id" : purchase_id});
  }

  Future<Response> postBuktiPembayaran(List purchase_id, String proof_of_payment_image ) async {
    return await apiClient.postData(AppConstants.BUKTI_PEMBAYARAN, {"purchase_id": purchase_id, "proof_of_payment_image" : proof_of_payment_image });
  }

  Future<Response> hapusPesanan(String kode_pembelian) async{
    return await apiClient.postData(AppConstants.HAPUS_PESANAN_URL, {"kode_pembelian": kode_pembelian});
  }
}