import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({Key? key}) : super(key: key);

  // Link Instagram
  final String instagramUrl =
      'https://www.instagram.com/kreatiftoba?igsh=MTZ0bjc1MjN2ZHBzcg==' ;

  // Fungsi untuk membuka URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // Mengganti warna AppBar menjadi putih
        backgroundColor: Colors.white, // Warna latar belakang putih
        iconTheme: const IconThemeData(color: Colors.black), // Warna ikon hitam
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              "assets/images/logo_rkt.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),

            // Deskripsi
            const Text(
              'Tingkatkan pengalaman berbelanja Produk UMKM TOBA tanpa harus mengunjungi lokasi.\n\nOnline, Bayar, dan Dapatkan segera.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),

            const Text(
              'TERHUBUNG DENGAN KAMI',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Ikon Media Sosial
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TikTok (kosong)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.tiktok),
                  iconSize: 30,
                  onPressed: () {
                    // Kosong untuk saat ini
                  },
                ),
                const SizedBox(width: 24),

                // Facebook (kosong)
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.facebook),
                  iconSize: 30,
                  onPressed: () {
                    // Kosong untuk saat ini
                  },
                ),
                const SizedBox(width: 24),

                // Instagram
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                  iconSize: 30,
                  onPressed: () {
                    _launchURL(instagramUrl);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
