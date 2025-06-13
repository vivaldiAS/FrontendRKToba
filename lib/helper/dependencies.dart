import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/alamat_controller.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/controllers/bank_controller.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/pembelian_controller.dart';
import 'package:rumah_kreatif_toba/controllers/pengiriman_controller.dart';
import 'package:rumah_kreatif_toba/controllers/pesanan_controller.dart';
import 'package:rumah_kreatif_toba/controllers/produk_controller.dart';
import 'package:rumah_kreatif_toba/controllers/toko_controller.dart';
import 'package:rumah_kreatif_toba/controllers/wishlist_controller.dart';
import 'package:rumah_kreatif_toba/data/api/api_client.dart';
import 'package:rumah_kreatif_toba/data/repository/auth_repo.dart';
import 'package:rumah_kreatif_toba/data/repository/cart_repo.dart';
import 'package:rumah_kreatif_toba/data/repository/categories_repo.dart';
import 'package:rumah_kreatif_toba/data/repository/produk_repo.dart';
import 'package:rumah_kreatif_toba/data/repository/toko_repo.dart';
import 'package:rumah_kreatif_toba/data/repository/user_repo.dart';
import 'package:rumah_kreatif_toba/data/repository/wishlist_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rumah_kreatif_toba/controllers/review_controller.dart'; // pastikan impor ini

import '../controllers/categories_controller.dart';
import '../controllers/popular_produk_controller.dart';
import '../controllers/user_controller.dart';
import '../data/repository/alamat_repo.dart';
import '../data/repository/bank_repo.dart';
import '../data/repository/pembelian_repo.dart';
import '../data/repository/pengiriman_repo.dart';
import '../data/repository/pesanan_repo.dart';
import '../utils/app_constants.dart';

Future init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.addKey(GlobalKey<NavigatorState>());

  Get.put(sharedPreferences);

  // api client
  Get.put(ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repositories
  Get.put(AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(UserRepo(apiClient: Get.find()));
  Get.put(AlamatRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(BankRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(CartRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(CategoriesRepo(apiClient: Get.find()));
  Get.put(PembelianRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(PengirimanRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(PesananRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(PopularProdukRepo(apiClient: Get.find()));
  Get.put(TokoRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(WishlistRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controllers
  Get.put(ReviewController());  // Changed from lazyPut to put to ensure immediate registration
  Get.put(AuthController(authRepo: Get.find()));
  Get.put(UserController(userRepo: Get.find()));
  Get.put(PopularProdukController(popularProdukRepo: Get.find()));
  Get.put(CartController(cartRepo: Get.find()));
  Get.put(PengirimanController(pengirimanRepo: Get.find()));
  Get.put(PesananController(pesananRepo: Get.find()));
  Get.put(AlamatController(alamatRepo: Get.find()));
  Get.put(WishlistController(wishlistRepo: Get.find()));
  Get.put(TokoController(tokoRepo: Get.find()));
  Get.put(BankController(bankRepo: Get.find()));
  Get.put(CategoriesController(categoriesRepo: Get.find()));
  Get.put(ProdukController(produkRepo: Get.find()));
  Get.put(PembelianController(pembelianRepo: Get.find()));

  return Future.delayed(Duration(seconds: 1), () {});
}
