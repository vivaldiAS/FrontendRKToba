import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class TokoRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  TokoRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> profilTokoWithToken(String token) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    return await apiClient.getData(
      AppConstants.PROFIL_TOKO_TOKEN_URL,
      headers: headers,
    );
  }



  Future<Response> verifikasiToko(int user_id, String foto_ktp, String ktp_dan_selfie) async {
    return await apiClient.postData(AppConstants.VERIFIKASI_TOKO_URL, {"user_id": user_id, "foto_ktp": foto_ktp, "ktp_dan_selfie": ktp_dan_selfie});
  }

  Future<Response> cekVerifikasi(int user_id) async {
    return await apiClient.postData(AppConstants.CEK_VERIFIKASI_URL, {"user_id": user_id});
  }

  Future<Response> tambahToko(int user_id, String nama_merchant, String deskripsi_toko, String kontak_toko, String foto_merchant) async {
    return await apiClient.postData(AppConstants.TAMBAH_TOKO_URL, {"user_id": user_id, "nama_merchant":nama_merchant, "deskripsi_toko":deskripsi_toko, "kontak_toko": kontak_toko, "foto_merchant" : foto_merchant});
  }

  Future<Response> masukToko(int user_id, String password) async {
    return await apiClient.postData(AppConstants.MASUK_TOKO_URL, {"user_id": user_id, "password":password});
  }

  Future<Response> profilToko(int user_id) async {
    return await apiClient.postData(AppConstants.PROFIL_TOKO_URL, {"user_id": user_id});
  }

  Future<Response> ubahToko(int merchant_id, String nama_merchant, String deskripsi_toko, String kontak_toko, String foto_merchant) async {
    return await apiClient.postData(AppConstants.UBAH_TOKO_URL, {"merchant_id": merchant_id, "nama_merchant":nama_merchant, "deskripsi_toko":deskripsi_toko, "kontak_toko": kontak_toko, "foto_merchant" : foto_merchant});
  }

  Future<Response> homeToko(int user_id) async {
    return await apiClient.postData(AppConstants.HOME_TOKO_URL, {"user_id": user_id});
  }

}
