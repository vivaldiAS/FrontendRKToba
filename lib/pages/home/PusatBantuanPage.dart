import 'package:flutter/material.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/dimensions.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/widgets/small_text.dart';

class PusatBantuanPage extends StatelessWidget {
  const PusatBantuanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pusat Bantuan'),
        backgroundColor: AppColors.redColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.height20),
        child: ListView(
          children: [
            BigText(
              text: 'Selamat datang di Pusat Bantuan!',
              fontWeight: FontWeight.bold,
              size: 20,
            ),
            SizedBox(height: 20),
            SmallText(
              text:
              'Jika Anda memiliki pertanyaan atau masalah, mungkin ada bisa mendapatkan solusinya disini.',
              size: 16,
            ),
            SizedBox(height: 20),
            BigText(
              text: 'Frequently Asked Questions (FAQ)',
              fontWeight: FontWeight.bold,
              size: 18,
            ),
            SizedBox(height: 10),
            SmallText(
              text: 'Punya pertanyaan? Cek FAQ kami untuk menemukan jawaban.',
              size: 16,
            ),
            SizedBox(height: 20),

            // FAQ 1
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(text: 'Bagaimana cara menggunakan kode promo?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Masukkan kode promo saat checkout di kolom Gunakan Kode Promo. Pastikan kode masih berlaku dan sesuai dengan ketentuan.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ 2
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Saya lupa kata sandi. Apa yang harus saya lakukan?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Klik Lupa Kata Sandi di halaman masuk. Masukkan email Anda, lalu ikuti instruksi yang dikirim melalui email untuk mengatur ulang kata sandi Anda.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ3
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(text: 'Bagaimana cara melacak pesanan saya?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Masuk ke akun Anda, lalu buka menu Pesanan Saya. Pilih pesanan yang ingin Anda lacak untuk melihat status pengiriman secara real-time.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ4
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text:
                  'Apakah saya bisa mengubah alamat pengiriman setelah memesan?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Anda hanya bisa mengubah alamat jika pesanan belum diproses oleh penjual. Silakan hubungi layanan pelanggan secepatnya untuk bantuan.',
                    size: 13,
                  ),
                ),
              ],
            ),
            // FAQ5
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Apakah saya bisa menyimpan produk sebagai favorit?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Ya, cukup klik ikon hati (❤) di halaman produk untuk menambahkannya ke Favorit. Anda bisa melihat daftar favorit di menu akun Anda.',
                    size: 13,
                  ),
                ),
              ],
            ),
            // FAQ6
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title:
              SmallText(text: 'Bagaimana cara memberikan ulasan produk?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Klik Lupa Kata Sandi di halaman masuk. Masukkan email Anda, lalu ikuti instruksi yang dikirim melalui email untuk mengatur ulang kata sandi Anda.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ6
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Saya tidak bisa login, apa yang harus dilakukan?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Pastikan email dan kata sandi yang Anda masukkan benar. Jika masih gagal, coba reset kata sandi dan ubah kata sandi anda menggunakan kata sandi yang mudah anda ingat, coba login kembali menggunakan kata sandi baru.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ7
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text:
                  'Apakah saya bisa menggunakan lebih dari satu kode promo?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'KTidak. Hanya satu kode promo yang bisa digunakan per transaksi, kecuali ada promo gabungan yang ditentukan.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ8
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Bagaimana cara melihat riwayat transaksi saya?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Masuk ke akun Anda, lalu buka menu Riwayat Transaksi untuk melihat semua pembelian yang pernah Anda lakukan.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ9
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Apakah saya bisa membeli tanpa membuat akun?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Tidak. Untuk alasan keamanan dan kenyamanan transaksi, semua pembeli diwajibkan memiliki akun.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ 10
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Bagaimana cara menonaktifkan notifikasi aplikasi?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Buka pengaturan di aplikasi Anda, masuk ke Pengaturan Notifikasi, lalu sesuaikan jenis notifikasi yang ingin Anda terima.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ 11
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Apakah saya bisa menjual produk di aplikasi ini?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Ya, silakan daftar sebagai penjual melalui menu Gabung Jadi Penjual di aplikasi. Isi data yang diperlukan untuk memulai berjualan.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ 12
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text:
                  'Saya belum menerima barang, padahal statusnya sudah terkirim.'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Cek kembali alamat pengiriman dan lacak paket menggunakan nomor resi. Jika masalah berlanjut, segera hubungi layanan pelanggan.',
                    size: 13,
                  ),
                ),
              ],
            ),

            // FAQ 13
            ExpansionTile(
              leading: Icon(Icons.question_answer, color: AppColors.redColor),
              title: SmallText(
                  text: 'Bagaimana cara mengubah informasi profil saya?'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SmallText(
                    text:
                    'Masuk ke akun Anda, buka menu Profil Saya, lalu pilih Edit Profil untuk mengubah nama, foto, alamat, atau informasi lainnya.',
                    size: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}