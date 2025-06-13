import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rumah_kreatif_toba/pages/kategori/kategori_produk.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // Tombol Jelajahi Semua
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
              side: const BorderSide(color: Colors.black12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.arrow_outward),
            label: const Text("Jelajahi Semua"),
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: KategoriProduk(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          ),
          const SizedBox(height: 24),

          // Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo_rkt.png", height: 50),
              const SizedBox(width: 16),
              Image.asset("assets/images/Bangga_Buatan_Indonesia_Logo.png", height: 50),
              const SizedBox(width: 16),
              Image.asset("assets/images/toba.png", height: 50),
            ],
          ),
          const SizedBox(height: 24),

          // Teks deskripsi
          const Text(
            "Tingkatkan pengalaman berbelanja UMKM Toba tanpa harus mengunjungi Kabupaten Toba.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            "Online, Bayar, dan Dapatkan segera.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
