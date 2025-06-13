import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rumah_kreatif_toba/data/api/api_client.dart';
import 'package:rumah_kreatif_toba/models/users_models.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> registrasi(Users users) async {
    return await apiClient.postData(AppConstants.REGISTRASI_URL, users.toJson());
  }

Future<Response> login(String username, String password) async {
  Response response = await apiClient.postData(
    AppConstants.LOGIN_URL,
    {"username": username, "password": password},
  );

  if (response.statusCode == 200 && response.body['token'] != null) {
    String token = response.body['token'];
    apiClient.updateHeader(token); // update header dan simpan token
  }

  return response;
}


  Future<String> getUserToken() async {
    return await sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<bool> saveUserId(int userId) async {
    return await sharedPreferences.setInt(AppConstants.USER_ID, userId);
  }

  int? getUserId() {
    return sharedPreferences.getInt(AppConstants.USER_ID);
  }

  Future<void> saveUserNumberAndPassword(String no_hp, String password) async {
    await sharedPreferences.setString(AppConstants.PHONE, no_hp);
    await sharedPreferences.setString(AppConstants.PASSWORD, password);
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PASSWORD);
    sharedPreferences.remove(AppConstants.PHONE);
    sharedPreferences.remove(AppConstants.USER_ID);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }
}
