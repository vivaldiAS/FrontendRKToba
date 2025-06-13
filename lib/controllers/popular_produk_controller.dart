import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/controllers/cart_controller.dart';
import 'package:rumah_kreatif_toba/controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/models/produk_models.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../base/show_custom_message.dart';
import '../base/snackbar_message.dart';
import '../data/repository/produk_repo.dart';
import '../models/cart_models.dart';
import '../models/response_model.dart';
import '../pages/produk/produk_detail.dart';
import '../routes/route_helper.dart';


class PopularProdukController extends GetxController{
  final PopularProdukRepo popularProdukRepo;
  PopularProdukController({required this.popularProdukRepo});
  RxList<dynamic> _popularProdukList=[].obs;
  List<dynamic> get popularProdukList => _popularProdukList;

  List<dynamic> _produkmakananminumanList=[].obs;
  List<dynamic> get produkMakananMinumanList => _produkmakananminumanList;

  List<dynamic> _produkPakaianList=[].obs;
  List<dynamic> get produkPakaianList => _produkPakaianList;

  List<dynamic> _produkTerbaruList=[].obs;
  List<dynamic> get produkTerbaruList => _produkTerbaruList;

  RxList<dynamic> _detailProdukList=<dynamic>[].obs;
  List<dynamic> get detailProdukList => _detailProdukList;

  List<dynamic> _imageProdukList=[].obs;
  List<dynamic> get imageProdukList => _imageProdukList;

  RxList<dynamic> _kategoriProdukList=[].obs;
  List<dynamic> get kategoriProdukList => _kategoriProdukList;
  late CartController _cart;

  RxBool isLoading = false.obs;

  bool get getLoading => isLoading.value;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getPopularProdukList() async{
    Response response = await popularProdukRepo.getPopularProdukList();

    // print("STATUS CODE ${response.statusCode}");
    if(response.statusCode == 200){

      List<dynamic> responseBodyproduk = response.body["products"];
      _popularProdukList = [].obs;
      for (dynamic item in responseBodyproduk) {
        Produk produk = Produk.fromJson(item);
        _popularProdukList.add(produk);
      }



      late ResponseModel responseModel;
      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.body["produk_makanan_minuman_terlaris"];
        _produkmakananminumanList = [].obs;
        for (dynamic item in responseBody) {
          Produk produk = Produk.fromJson(item);
          _produkmakananminumanList.add(produk);
        }

        List<dynamic> responseBodyTerlaris= response.body["produk_pakaian_terlaris"];
        _produkPakaianList = [].obs;
        for (dynamic item in responseBodyTerlaris) {
          Produk produk = Produk.fromJson(item);
          _produkPakaianList.add(produk);
        }

        List<dynamic> responseBodyTerbaru= response.body["new_products"];
        _produkTerbaruList = [].obs;
        for (dynamic item in responseBodyTerbaru) {
          Produk produk = Produk.fromJson(item);
          _produkTerbaruList.add(produk);
        }

        List<dynamic> responseBodyImage= response.body["product_images"];
        _imageProdukList.clear();
        for (dynamic item in responseBodyImage) {
          Produk produk = Produk.fromJson(item);
          _imageProdukList.add(produk);
        }
        _isLoaded = true;
        responseModel = ResponseModel(true, "successfully");
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
      isLoading.value = true;

      update();
    }else{

    }
  }

  Future<void> getKategoriProdukList(String namaKategori) async{
    Response response = await popularProdukRepo.getKategoriProdukList(namaKategori);
    if(response.statusCode == 200){
      List<dynamic> responseBody = response.body;
      _kategoriProdukList = [].obs;
      for (dynamic item in responseBody) {
        Produk produk = Produk.fromJson(item);
        _kategoriProdukList.add(produk);
      }
      _isLoaded = true;
      isLoading = true.obs;
      update();
    }else{

    }
  }


  //Daftar Produk sesuai merchant
  List<dynamic> _daftarProdukList=[].obs;
  List<dynamic> get daftarProdukList => _daftarProdukList;

  Future<void> getProdukList() async{
    var controller = Get.find<UserController>().usersList[0];
    Response response = await popularProdukRepo.getProdukList(controller.id!);
    if(response.statusCode == 200){
      List<dynamic> responseBody = response.body;
      _daftarProdukList = [].obs;
      for (dynamic item in responseBody) {
        Produk produk = Produk.fromJson(item);
        _daftarProdukList.add(produk);
      }
      _isLoaded = true;
      update();
    }else{

    }
  }

  Future<void> getProdukListToken() async {
    Response response = await popularProdukRepo.getProdukListToken();
    if(response.statusCode == 200){
      List<dynamic> responseBody = response.body;
      _daftarProdukList = [].obs;
      for (dynamic item in responseBody) {
        Produk produk = Produk.fromJson(item);
        _daftarProdukList.add(produk);
      }
      _isLoaded = true;
      update();
    } else {
      // Tangani error jika perlu
    }
  }


  Future<ResponseModel> hapusProduk(int product_id) async {
    Response response = await popularProdukRepo.hapusProduk(product_id);
    late ResponseModel responseModel;
    if(response.statusCode == 200){
      AwesomeSnackbarButton("Berhasil","Produk berhasil dihapus",ContentType.success);
      getProdukList();
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoaded = true;
    update();
    return responseModel;
  }



  Future<ResponseModel> detailProduk(int product_id) async {
    Response response = await popularProdukRepo.detailProduk(product_id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      List<dynamic> responseBody= response.body;
      _detailProdukList.clear();
      for (dynamic item in responseBody) {
        Produk produk = Produk.fromJson(item);
        _detailProdukList.add(produk);
      }
      Get.to(ProdukDetail());
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoaded = false;
    update();
    return responseModel;
  }

}