import 'package:rumah_kreatif_toba/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../api/api_client.dart';

class CartRepo{
    final ApiClient apiClient;
    final SharedPreferences sharedPreferences;
    CartRepo({  required this.apiClient,required this.sharedPreferences});

    List<String> cart = [];

    Future<Response> tambahKeranjang(int user_id, int product_id, int jumlah_masuk_keranjang) async {
        return await apiClient.postData(AppConstants.TAMBAH_KERANJANG_URL, {"user_id": user_id, "product_id": product_id, "jumlah_masuk_keranjang": jumlah_masuk_keranjang});
    }

    Future<Response> getKeranjangList(int user_id) async{
        return await apiClient.postData(AppConstants.KERANJANG_URL, {"user_id": user_id});
    }

    Future<Response> hapusKeranjang(int cart_id) async{
        return await apiClient.postData(AppConstants.HAPUS_KERANJANG_URL, {"cart_id": cart_id});
    }

    Future<Response> kurangKeranjang(int cart_id) async{
        return await apiClient.postData(AppConstants.KURANG_KERANJANG_URL, {"cart_id": cart_id});
    }

    Future<Response> jumlahKeranjang(int cart_id) async{
        return await apiClient.postData(AppConstants.JUMLAH_KERANJANG_URL, {"cart_id": cart_id});
    }

    // void removeCart(){
    //     cart = [];
    //     sharedPreferences.remove(AppConstants.CART_LIST);
    // }
    //
    // void clearCartHistory(){
    //     removeCart();
    //     sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    // }
}