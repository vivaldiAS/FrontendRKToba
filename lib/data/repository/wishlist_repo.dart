import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class WishlistRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  WishlistRepo({ required this.apiClient, required this.sharedPreferences});

  Future<Response> tambahWishlist(int user_id, int product_id) async {
    return await apiClient.postData(
        AppConstants.TAMBAH_WISHLIST_URL, {"user_id": user_id, "product_id": product_id});
  }

  Future<Response> getWishlistList(int user_id) async{
    return await apiClient.postData(AppConstants.DAFTAR_WISHLIST_URL, {"user_id": user_id});
  }

  Future<Response> hapusWishlist(int wishlist_id) async{
    return await apiClient.postData(AppConstants.HAPUS_WISHLIST_URL, {"wishlist_id": wishlist_id});
  }
}