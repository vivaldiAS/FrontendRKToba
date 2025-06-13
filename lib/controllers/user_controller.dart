import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/data/repository/auth_repo.dart';
import 'package:rumah_kreatif_toba/models/response_model.dart';
import '../base/show_custom_message.dart';
import '../base/snackbar_message.dart';
import '../data/repository/user_repo.dart';
import '../models/users_models.dart';
import '../pages/account/profil/profil_page.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../pages/home/home_page.dart';
import '../routes/route_helper.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({
    required this.userRepo,
  });

  @override
  void initState() {
    getUser();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RxList<Users> _usersList = <Users>[].obs;
  List<dynamic> get usersList => _usersList;

  late AuthController _auth;

  void clearUser() {
    usersList.clear(); // Clear the user data
    update(); // Ensure that the UI updates when user data is cleared
  }

  Future<void> getUser() async {
    ResponseModel responseModel;

    if (Get.find<AuthController>().userLoggedIn()) {
      Response response = await userRepo.getUserInfo();
      // print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.body;
        _usersList.value = [];
        for (dynamic item in responseBody) {
          Users users = Users.fromJson(item);
          _usersList.add(users);
        }
        _isLoading = true;
        update();
        responseModel = ResponseModel(true, "successfully");
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    }
  }

  Future<ResponseModel> ubahProfil(int? user_id, String name, String no_hp,
      String birthday, String gender) async {
    _isLoading = true;
    update();
    Response response =
    await userRepo.ubahProfil(user_id!, name, no_hp, birthday, gender);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", "Berhasil mengubah profil", ContentType.success);
      Get.to(ProfilPage());
      getUser();
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> ubahPassword(
      int? user_id, String password, String password_baru) async {
    _isLoading = true;
    update();
    Response response =
    await userRepo.ubahPassword(user_id!, password, password_baru);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      AwesomeSnackbarButton(
          "Berhasil", response.body["message"], ContentType.success);
      Get.to(ProfilPage());
      getUser();
    } else {
      AwesomeSnackbarButton(
          "Gagal", response.body["message"], ContentType.failure);
    }
    _isLoading = false;
    update();
  }

  Future<void> hapusAkun() async {
    _isLoading = false;
    update();

    var controller = Get.find<UserController>().usersList[0];
    Response response = await userRepo.hapusAkun(controller.id!);

    _isLoading = true;
    update();

    Get.back();
    if (response.statusCode == 200) {
      print("berhasil");
      if (Get.find<AuthController>().userLoggedIn()) {
        if(Get.find<AuthController>().clearSharedData()){
          if(Get.to(() => HomePage(initialIndex: 0)) != null){
          }
        }
      }
    } else {
      print("gagal");
    }


  }

}