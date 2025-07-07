import 'package:flutter/material.dart';

class InstruksiKTP extends StatelessWidget {
  const InstruksiKTP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna latar AppBar putih
        foregroundColor: Colors.black, // Warna teks judul
        iconTheme: const IconThemeData(color: Colors.black), // Warna ikon
        title: const Text(
          "Intruksi",
          style: TextStyle(color: Colors.black), // Warna teks eksplisit
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1, // Sedikit bayangan agar tidak terlalu datar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/ktp.png",
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Foto Bagian Depan KTP",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Pastikan Foto KTP Anda dengan ketentuan dibawah.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const BulletPoint(text: "Foto harus landscape."),
            const BulletPoint(text: "Pastikan seluruh KTP tidak terpotong."),
            const BulletPoint(text: "Foto harus terlihat jelas, tidak buram, atau terdapat pantulan cahaya."),
            const BulletPoint(text: "Foto harus asli, bukan potokopi, dan tidak diedit."),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(fontSize: 14)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
