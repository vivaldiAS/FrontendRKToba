import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher
import '../../../utils/dimensions.dart';
import '../../../utils/colors.dart';

class HubungiKamiPage extends StatelessWidget {
  const HubungiKamiPage({Key? key}) : super(key: key);

  // Fungsi untuk membuka Gmail di browser dengan subjek dan body otomatis terisi
  Future<void> _sendEmail() async {
    final String emailUrl = Uri.encodeFull(
        'https://mail.google.com/mail/?view=cm&fs=1&to=kreatiftoba@gmail.com&su=Tanya+tentang+Produk+UMKM+TOBA&body=Tulis+pesan+Anda+di+sini...');

    try {
      // Memeriksa apakah URL dapat dibuka
      if (await canLaunch(emailUrl)) {
        await launch(emailUrl);  // Membuka Gmail di browser dengan subjek dan body yang sudah terisi
      } else {
        debugPrint('Tidak dapat membuka URL: $emailUrl');
      }
    } catch (e) {
      debugPrint('Error membuka Gmail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: const Text(
          'Hubungi Kami',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kami ingin mendengar dari Anda! Jika Anda memiliki pertanyaan, '
                  'saran, atau umpan balik, jangan ragu untuk menghubungi kami. '
                  'Tim kami siap membantu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.font16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _sendEmail,  // Panggil fungsi untuk membuka Gmail
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.redColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'Hubungi Kami melalui Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
