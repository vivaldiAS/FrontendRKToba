import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/data/api/api_client.dart';

import '../../utils/app_constants.dart';

class PopularProdukRepo extends GetxService {
  final ApiClient apiClient;
  PopularProdukRepo({required this.apiClient});

  Future<Response> getPopularProdukList() async {
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URL);
  }

  Future<Response> getKategoriProdukList(String namaKategori) async {
    return await apiClient.postData(
        AppConstants.KATEGORI_PRODUCT_URL, {"nama_kategori": namaKategori});
  }

  Future<Response> getProdukList(int user_id) async {
    return await apiClient.postData(
        AppConstants.DAFTAR_PRODUK_URL, {"user_id": user_id});
  }

  Future<Response> tambahProduk(int user_id, String product_name, List product_image, String product_description, int price, int heavy, String kategori, int stok) async {
    return await apiClient.postData(AppConstants.TAMBAH_PRODUK_URL, {"user_id": user_id, "product_name" : product_name, "product_image" : product_image, "product_description" : product_description, "price" : price, "heavy" : heavy, "kategori" : kategori, "stok":stok});
  }

  Future<Response> hapusProduk(int product_id) async {
    return await apiClient.postData(AppConstants.HAPUS_PRODUK_URL, {"product_id": product_id});
  }

  Future<Response> detailProduk(int product_id) async {
    return await apiClient.postData(AppConstants.DETAIL_PRODUK_URL, {"product_id": product_id});
  }

  Future<Response> getProdukListToken() async {
    return await apiClient.getDataWithToken(AppConstants.DAFTAR_PRODUK_TOKEN);
  }

}
