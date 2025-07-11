import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/data/repository/wishlist_repo.dart';
import 'package:rumah_kreatif_toba/models/wishlist_models.dart';

import '../base/show_custom_message.dart';
import '../base/snackbar_message.dart';
import '../models/response_model.dart';
import '../utils/app_constants.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../routes/route_helper.dart';

import 'auth_controller.dart';
class WishlistController extends GetxController{
  final WishlistRepo wishlistRepo;
  WishlistController({required this.wishlistRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RxBool isProdukExist = false.obs;


  RxMap<int, bool> checkedtypeWishlist = <int, bool>{}.obs;

  Map<int, bool> get getcheckedtypeWishlist => checkedtypeWishlist;

  RxList _wishlistList= <dynamic>[].obs;
  List<dynamic> get wishlistList => _wishlistList;

  Future<ResponseModel> tambahWishlist(int? user_id, int product_id) async {
    _isLoading = true;
    update();
    Response response = await wishlistRepo.tambahWishlist(user_id!, product_id);
    late ResponseModel responseModel;
    if(response.statusCode == 200){
      AwesomeSnackbarButton("Berhasil",response.body["message"],ContentType.success);
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getWishlistList() async {
    _isLoading = true;
    update();

    if (Get.find<AuthController>().userLoggedIn()) {
      var controller = Get.find<UserController>().usersList[0];
      Response response = await wishlistRepo.getWishlistList(controller.id!);

      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.body;
        _wishlistList.value = [];
        for (dynamic item in responseBody) {
          WishlistModel wishlist = WishlistModel.fromJson(item);
          _wishlistList.add(wishlist);
        }
      } else {
        _wishlistList.value = [];
      }

      _isLoading = false;
      update();
    } else {
      _wishlistList.value = [];
      _isLoading = false;
      update();
    }
  }

  Future<ResponseModel> hapusWishlist(int wishlist_id) async {
    Response response = await wishlistRepo.hapusWishlist(wishlist_id);
    late ResponseModel responseModel;
    if(response.statusCode == 200){
      AwesomeSnackbarButton("Berhasil","Produk berhasil dihapus",ContentType.success);
      getWishlistList();
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // void setTypeWishlist(int index,bool title) {
  //   checkedtypePengiriman.value = {index :title };
  //   update();
  // }

  void setTypeWishlist(int index, bool title) {
    checkedtypeWishlist[index] = title;
    update();
  }

  /// Fungsi baru hapus wishlist berdasarkan product_id
  Future<ResponseModel> hapusWishlistByProductId(int product_id) async {
    // Cari item wishlist berdasarkan product_id
    var item = wishlistList.firstWhereOrNull((element) => element.productId == product_id);
    if (item == null) {
      return ResponseModel(false, "Wishlist item tidak ditemukan");
    }

    // Panggil hapusWishlist lama dengan wishlistId
    return await hapusWishlist(item.wishlistId!);
  }

  /// Metode toggle wishlist, gunakan fungsi baru hapusWishlistByProductId
  Future<void> toggleWishlist(int product_id) async {
    bool isFavorit = checkedtypeWishlist[product_id] ?? false;

    if (!isFavorit) {
      int? userId = Get.find<AuthController>().getUserId();
      if (userId == null) {
        Get.toNamed(RouteHelper.getMasukPage());
        return;
      }
      ResponseModel res = await tambahWishlist(userId, product_id);
      if (res.isSuccess) {
        checkedtypeWishlist[product_id] = true;
      }
    } else {
      ResponseModel res = await hapusWishlistByProductId(product_id);
      if (res.isSuccess) {
        checkedtypeWishlist[product_id] = false;
      }
    }
    update();
  }
}