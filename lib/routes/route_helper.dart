import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/pages/account/profil/profil_page.dart';
import 'package:rumah_kreatif_toba/pages/alamat/daftaralamat.dart';
import 'package:rumah_kreatif_toba/pages/alamat/tambahalamat.dart';
import 'package:rumah_kreatif_toba/pages/auth/masuk.dart';
import 'package:rumah_kreatif_toba/pages/home/home_page.dart';
import 'package:rumah_kreatif_toba/pages/home/main_home_page.dart';
import 'package:rumah_kreatif_toba/pages/home/pakaian_diminati_page.dart';
import 'package:rumah_kreatif_toba/pages/home/produk_terbaru_page.dart';
import 'package:rumah_kreatif_toba/pages/home/produk_unggulan_page.dart';
import 'package:rumah_kreatif_toba/pages/kategori/kategori_produk.dart';
import 'package:rumah_kreatif_toba/pages/kategori/kategori_produk_detail.dart';
import 'package:rumah_kreatif_toba/pages/keranjang/keranjang_page.dart';
import 'package:rumah_kreatif_toba/pages/pembayaran/pembayaran_page.dart';
import 'package:rumah_kreatif_toba/pages/pembelian/pembelian_page.dart';
import 'package:rumah_kreatif_toba/pages/pesanan/detail_pesanan_page.dart';
import 'package:rumah_kreatif_toba/pages/pesanan/menunggu_pembayaran_page.dart';
import 'package:rumah_kreatif_toba/pages/splash/splash_page.dart';
import 'package:rumah_kreatif_toba/pages/toko/AlamatToko/tambah_alamat_toko.dart';
import 'package:rumah_kreatif_toba/pages/toko/databank.dart';
import 'package:rumah_kreatif_toba/pages/toko/menungguverifikasitoko.dart';
import 'package:rumah_kreatif_toba/pages/toko/toko.dart';
import 'package:rumah_kreatif_toba/pages/alamat/editalamat.dart';


import '../controllers/popular_produk_controller.dart';
import '../pages/pesanan/pesanan_page.dart';
import '../pages/produk/produk_detail.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String editalamat = "/edit-alamat";
  static const String produkDetail = "/produkjson";
  static const String keranjangPage = "/keranjang";
  static const String kategoriProdukDetail = "/kategoriProdukDetail";
  static const String masuk = "/login";
  static const String toko = "/toko";
  static const String bank = "/bank";
  static const String pembelian = "/pembelian";
  static const String pembayaran = "/pembayaran";
  static const String pesanan = "/pesanan";
  static const String menungguPembayaran = "/menunggu_pembayaran";
  static const String detailPesanan = "/detail_pesanan";
  static const String profil = "/profil";
  static const String menungguVerifikasiToko = "/menunggu_verifikasi_toko";

  static const String daftaralamat = "/daftar_alamat";
  static const String tambahalamat = "/tambah_alamat";
  static const String ubahproduk = "/ubahproduk";

  static const String daftaralamat_toko = "/daftar_alamat_toko";

  static const String makananminumanfavorit = "/makananminumanfavorit";
  static const String pakaiandiminati = "/pakaiandiminati";
  static const String produkterbaru = "/produkterbaru";


  static String getSplashPage() => '$splashPage';

  static String getPusatBantuanPage() => "/pusat_bantuan";
  static String getInitial() => '$initial';
  static String getProdukDetail(int produkId) => '$produkDetail/$produkId';
  static String getKeranjangPage() => '$keranjangPage';
  static String getKategoriProdukDetail() => '$kategoriProdukDetail';
  static String getMasukPage() => '$masuk';
  static String getTokoPage() => '$toko';
  static String getBankPage() => '$bank';
  static String getPembelianPage() => '$pembelian';
  static String getPembayaranPage() => '$pembayaran';
  static String getPesananPage() => '$pesanan';
  static String getMenungguPembayaranPage() => '$menungguPembayaran';
  static String getDetailPesananPage() => '$detailPesanan';
  static String getProfilPage() => '$profil';
  static String getMenungguVerifikasiTokoPage() => '$menungguVerifikasiToko';

  static String getUbahProduk(int produkId) => '$ubahproduk/$produkId';
  static String getDaftarAlamatPage() => '$daftaralamat';
  static String getTambahAlamatPage() => '$tambahalamat';

  static String getDaftarAlamatTokoPage() => '$daftaralamat_toko';

  static String getMakananMinumanFavoritPage() => '$makananminumanfavorit';
  static String getPakaianDiminatiPage() => '$pakaiandiminati';
  static String getProdukTerbaruPage() => '$produkterbaru';

  static String getEditAlamatPage({
    required int alamatId,
    required int provinceId,
    required int cityId,
    required int subdistrictId,
    required String provinceName,
    required String cityName,
    required String subdistrictName,
    required String userStreetAddress,
  }) {
    return '$editalamat?alamat_id=$alamatId'
        '&province_id=$provinceId&city_id=$cityId&subdistrict_id=$subdistrictId'
        '&province_name=$provinceName&city_name=$cityName&subdistrict_name=$subdistrictName'
        '&user_street_address=$userStreetAddress';
  }

  static List<GetPage> routes = [
    GetPage(
      name: produkDetail + '/:produkId', // Pastikan path menerima produkId sebagai parameter
      page: () {
        return ProdukDetail();
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: editalamat,
      page: () {
        final params = Get.parameters;
        return EditAlamatPage(
          alamatId: int.parse(params['alamat_id']!),
          province_id: int.parse(params['province_id'] ?? '0'),
          city_id: int.parse(params['city_id'] ?? '0'),
          subdistrict_id: int.parse(params['subdistrict_id'] ?? '0'),
          province_name: params['province_name'] ?? '',
          city_name: params['city_name'] ?? '',
          subdistrict_name: params['subdistrict_name'] ?? '',
          user_street_address: params['user_street_address'] ?? '',
        );
      },
    ),

    GetPage(name: splashPage, page: () => SplashScreen()),
    GetPage(name: initial, page: () => HomePage(initialIndex: 0)),
    GetPage(
        name: masuk,
        page: () {
          return Masuk();
        },
        transition: Transition.fade),
    GetPage(
        name: masuk,
        page: () {
          return Masuk();
        },
        transition: Transition.fade),
    GetPage(name: pembelian, page: () => PembelianPageState()),
    GetPage(name: pembayaran, page: () => PembayaranPage()),
    GetPage(name: pesanan, page: () => PesananPage()),
    GetPage(name: menungguPembayaran, page: () => MenungguPembayaranPage()),
    GetPage(name: detailPesanan, page: () => DetailPesananPage()),
    GetPage(name: profil, page: () => ProfilPage()),
    GetPage(name: menungguVerifikasiToko, page: () => MenungguVerifikasiToko()),
    GetPage(
      name: produkDetail + '/:produkId', // Add named parameter ":produkId"
      page: () {
        return ProdukDetail();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
        name: keranjangPage,
        page: () {
          return KeranjangPage();
        },
        transition: Transition.fadeIn),
    GetPage(
        name: kategoriProdukDetail,
        page: () => KategoriProdukDetail(),
        transition: Transition.fadeIn),
    GetPage(name: toko, page: () => TokoPage()),
    GetPage(name: bank, page: () => DataBankPage()),
    GetPage(name: daftaralamat, page: () => DaftarAlamatPage()),
    GetPage(name: tambahalamat, page: () => TambahAlamatPage()),

    GetPage(name: makananminumanfavorit, page: () => ProdukUnggulanPage()),
    GetPage(name: pakaiandiminati, page: () => PakaianDiminatiPage()),
    GetPage(name: produkterbaru, page: () => ProdukTerbaruPage()),
  ];
}
