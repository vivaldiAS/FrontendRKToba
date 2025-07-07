import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/data/repository/auth_repo.dart';
import 'package:rumah_kreatif_toba/models/response_model.dart';
import '../base/snackbar_message.dart';
import '../models/users_models.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  Future<String> getToken() async {
    return await authRepo.getUserToken();
  }

  List<dynamic> _userList = [];
  List<dynamic> get userList => _userList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  Future<ResponseModel> registrasi(Users users) async {
    update();
    Response response = await authRepo.registrasi(users);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      // Simpan token
      authRepo.saveUserToken(response.body["token"]);

      int? userId;
      if (response.body["user"] != null) {
        userId = response.body["user"]["id"];
        authRepo.saveUserId(userId!);
      }

      // ✅ Kirim userId ke ResponseModel
      responseModel = ResponseModel(true, response.body["token"], userId);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    _isLoading = true;
    update();
    return responseModel;
  }

    Future<ResponseModel?> login(String username, String password) async {
    Response response = await authRepo.login(username, password);
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      if (response.body["token"] != null) {
        authRepo.saveUserToken(response.body["token"]);

        if (response.body["user"] != null) {
          authRepo.saveUserId(response.body["user"]["id"]);
        }

        responseModel = ResponseModel(true, response.body["token"]);
      }  else {
      responseModel = ResponseModel(false, response.body["message"] ?? "Gagal login");
    }
  } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String no_hp, String password) {
    authRepo.saveUserNumberAndPassword(no_hp, password);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    isLoading = false;
    update(); // penting untuk beri tahu UI
    return authRepo.clearSharedData();
  }


  int? getUserId() {
    return authRepo.getUserId();
  }
}
