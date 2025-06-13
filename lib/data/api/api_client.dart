import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 10);
    token = sharedPreferences.getString('TOKEN') ?? '';
    _mainHeaders = _buildHeaders(token);
  }

  // Buat header
  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // Memperbarui token dan header
  void updateHeader(String newToken) {
    token = newToken;
    sharedPreferences.setString('TOKEN', token); // simpan token
    _mainHeaders = _buildHeaders(token);
  }

  // Ambil data GET
  Future<Response> getDataWithToken(String uri) async {
    var token = await getUserToken(); // async ambil token misal dari SharedPreferences
    final response = await get(
      '$baseUrl/$uri',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }


  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await get(uri, headers: headers ?? _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // Kirim data POST
  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response = await post(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  // Ambil token (opsional, jika butuh di controller)
  String getUserToken() {
    return token;
  }
}
