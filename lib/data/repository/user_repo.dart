import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/data/api/api_client.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_URL);
  }

  Future<Response> ubahProfil(int user_id, String name, String no_hp, String birthday, String gender) async {
    return await apiClient.postData(AppConstants.UBAH_PROFIL_URL, {"user_id": user_id, "name":name, "no_hp":no_hp, "birthday": birthday, "gender" : gender});
  }

  Future<Response> ubahPassword(int user_id, String password, String password_baru) async {
    return await apiClient.postData(AppConstants.UBAH_PASSWORD_URL, {"user_id": user_id, "password":password, "password_baru":password_baru});
  }

  Future<Response> hapusAkun(int id) async {
    return await apiClient.postData(AppConstants.HAPUS_AKUN_URL, {"id": id});
  }
}
