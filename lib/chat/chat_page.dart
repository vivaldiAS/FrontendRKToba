import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'chat_detail_page.dart'; // Import halaman chat detail
import 'package:rumah_kreatif_toba/pages/auth/masuk.dart'; // Import halaman MasukPage
import 'package:rumah_kreatif_toba/pages/account/main_account_page.dart'; // Import halaman MainAccountPage
import 'package:rumah_kreatif_toba/utils/app_constants.dart'; // Import AppConstants

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> chatList = [];
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Menambahkan pengecekan autentikasi
  Future<void> _checkAuthentication() async {
    bool _userLoggedIn = await authController.userLoggedIn();

    if (!_userLoggedIn) {
      // Jika pengguna belum login, arahkan ke halaman MasukPage
      Get.off(() => Masuk());
    } else {
      fetchChats(); // Jika sudah login, ambil data chat
    }
  }

  Future<void> fetchChats() async {
    String authToken = await authController.authRepo.getUserToken();

    try {
      final response = await http.get(
        Uri.parse(AppConstants.BASE_URL + 'chats'), // Ganti dengan konstanta BASE_URL
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            chatList = data['ready_chat'] ?? [];
          });
        }
      } else {
        print('Failed to load chats');
      }
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesan"),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(); // Navigasi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: chatList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return _buildChatItem(
            chat['nama_merchant'] ?? 'Merchant Tidak Diketahui',
            chat['latest_message'] ?? 'Waktu Tidak Diketahui',
            chat['latest_message_text'] ?? 'Pesan Tidak Diketahui',
            chat['merchant_id'],
            chat['foto_merchant'] ?? '', // Ambil foto_merchant
          );
        },
      ),
    );
  }

  Widget _buildChatItem(String toko, String tanggal, String pesanTerbaru, int merchantId, String fotoMerchant) {
    return ListTile(
      leading: fotoMerchant.isNotEmpty
          ? CircleAvatar(
        backgroundImage: NetworkImage(AppConstants.BASE_URL_IMAGE + '/u_file/foto_merchant/' + fotoMerchant),
      )
          : CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.store, color: Colors.white),
      ),
      title: Text(toko, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(pesanTerbaru),
      trailing: Text(tanggal, style: TextStyle(color: Colors.grey)),
      onTap: () {
        Get.to(() => ChatDetailPage(merchantId: merchantId, namaMerchant: toko));
      },
    );
  }
}
