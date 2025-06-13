import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class PembelianRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PembelianRepo({  required this.apiClient,required this.sharedPreferences});

  Future<Response> daftarPembelian(int user_id) async {
    return await apiClient.postData(AppConstants.DAFTAR_PEMBELIAN_URL, {"user_id": user_id });
  }

  Future<Response> detailPembelian(int purchase_id) async {
    return await apiClient.postData(AppConstants.DETAIL_PEMBELIAN_URL, {"purchase_id": purchase_id });
  }

  Future<Response> updateStatusPembelian(int purchase_id) async {
    return await apiClient.postData(AppConstants.UPDATE_STATUS_PEMBELIAN_URL, {"purchase_id": purchase_id });
  }

  Future<Response> updateNoResiPembelian(int purchase_id, String no_resi) async {
    return await apiClient.postData(AppConstants.UPDATE_NORESI_PEMBELIAN_URL, {"purchase_id": purchase_id, "no_resi" : no_resi});
  }
}