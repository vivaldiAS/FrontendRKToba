import 'package:flutter/material.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/colors.dart';

class HubungiKamiPage extends StatelessWidget {
  const HubungiKamiPage({Key? key}) : super(key: key);

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
              onTap: () {
                // Aksi ketika tombol ditekan, bisa diarahkan ke email atau form
              },
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
