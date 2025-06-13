import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class PengirimanRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PengirimanRepo({required this.apiClient, required this.sharedPreferences});

  /// Kirim data checkout multi-merchant
  Future<Response> beliProdukMultiMerchant(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.BELI_PRODUK_MULTI_MERCHANT, body);
  }

  /// Checkout 1 merchant
  Future<Response> beliProduk(
      int user_id,
      List cart_id,
      int merchant_id,
      int metode_pembelian,
      int harga_pembelian,
      String potongan_pembelian,
      int alamat_purchase,
      String courier_code,
      String service,
      int ongkir,
      ) async {
    return await apiClient.postData(AppConstants.BELI_LANGSUNG, {
      "user_id": user_id,
      "cart_id": cart_id,
      "merchant_id": merchant_id,
      "metode_pembelian": metode_pembelian,
      "harga_pembelian": harga_pembelian,
      "potongan_pembelian": potongan_pembelian,
      "alamat_purchase": alamat_purchase,
      "courier_code": courier_code,
      "service": service,
      "ongkir": ongkir,
    });
  }

  /// Checkout beli langsung 1 produk
  Future<Response> beliLangsung(
      int user_id,
      int product_id,
      int metode_pembelian,
      int jumlah_masuk_keranjang,
      int harga_pembelian,
      String potongan_pembelian,
      int alamat_purchase,
      String courier_code,
      String service,
      int ongkir,
      ) async {
    return await apiClient.postData(AppConstants.BELI_LANGSUNG, {
      "user_id": user_id,
      "product_id": product_id,
      "metode_pembelian": metode_pembelian,
      "jumlah_masuk_keranjang": jumlah_masuk_keranjang,
      "harga_pembelian": harga_pembelian,
      "potongan_pembelian": potongan_pembelian,
      "alamat_purchase": alamat_purchase,
      "courier_code": courier_code,
      "service": service,
      "ongkir": ongkir,
    });
  }
}
