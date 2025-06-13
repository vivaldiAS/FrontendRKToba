import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';
class BankRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  BankRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> getBankList() async {
    return await apiClient.getData(AppConstants.DAFTAR_BANK_URL);
  }

  Future<Response> tambahRekening(int user_id, String nama_bank, String nomor_rekening, String atas_nama) async {
    return await apiClient.postData(AppConstants.TAMBAH_REKENING_URL, {"user_id": user_id, "nama_bank": nama_bank, "nomor_rekening": nomor_rekening, "atas_nama": atas_nama});
  }

  Future<Response> getRekeningList(int user_id) async {
    return await apiClient.postData(AppConstants.DAFTAR_REKENING_URL, {"user_id": user_id});
  }

  Future<Response> hapusRekening(int rekening_id) async {
    return await apiClient.postData(AppConstants.HAPUS_REKENING_URL, {"rekening_id": rekening_id});
  }
}