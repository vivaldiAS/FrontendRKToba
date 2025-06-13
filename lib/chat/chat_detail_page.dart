import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/pages/auth/masuk.dart'; // Import halaman MasukPage
import 'package:rumah_kreatif_toba/utils/app_constants.dart'; // Import AppConstants
import 'package:rumah_kreatif_toba/pages/home/detail_toko.dart'; // Import halaman detail toko

class ChatDetailPage extends StatefulWidget {
  final int merchantId;
  final String namaMerchant;

  ChatDetailPage({required this.merchantId, required this.namaMerchant});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<dynamic> chatMessages = [];
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = true;
  String? fotoMerchant;

  DateTime? previousDate;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool _userLoggedIn = await authController.userLoggedIn();
    if (!_userLoggedIn) {
      Get.off(() => Masuk());
    } else {
      fetchChatDetail();
    }
  }

  Future<void> fetchChatDetail() async {
    String authToken = await authController.authRepo.getUserToken();
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}chat/${widget.merchantId}'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chatMessages = data['chatting'] ?? [];
          fotoMerchant = data['merchant']['foto_merchant'];
          isLoading = false;
        });

        _scrollToBottom();
      } else {
        print('❌ Failed to load chat detail. Status: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ Error fetching chat detail: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> sendMessage() async {
    String authToken = await authController.authRepo.getUserToken();
    String message = _messageController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      chatMessages.add({
        'message': message,
        'isSending': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    });

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}chat/${widget.merchantId}'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'isi_chat': message}),
      );

      if (response.statusCode == 200) {
        _messageController.clear();
        fetchChatDetail();
      } else {
        print('❌ Failed to send message. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error sending message: $e');
    }
  }

  Future<void> deleteChat(int chatId, int index) async {
    String authToken = await authController.authRepo.getUserToken();

    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.BASE_URL}chat/$chatId'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          chatMessages.removeAt(index);
        });
      } else {
        print('❌ Failed to delete message. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting message: $e');
    }
  }

  String formatTime(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    if (previousDate == null || !isSameDay(previousDate!, dateTime)) {
      previousDate = dateTime;
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
    return '';
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            if (fotoMerchant != null)
              GestureDetector(
                onTap: () {
                  Get.to(() => StorePage(merchantId: widget.merchantId));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage('${AppConstants.BASE_URL_IMAGE}/u_file/foto_merchant/$fotoMerchant'),
                  radius: 20,
                ),
              ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Get.to(() => StorePage(merchantId: widget.merchantId));
              },
              child: Expanded(
                child: Text(
                  widget.namaMerchant,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : chatMessages.isEmpty
                ? Center(child: Text("Belum ada pesan"))
                : ListView.builder(
              controller: _scrollController,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final chat = chatMessages[index];
                bool isMe = chat['pengirim'] == 'user';
                String message = chat['message'] ?? chat['isi_chat'];
                String time = formatTime(chat['created_at']);
                String date = formatDate(chat['created_at']);

                return Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (date.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: Text(
                            date,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5, // Membatasi lebar balon pesan
                      ),
                      decoration: BoxDecoration(
                        color: chat['isSending'] ?? false ? Colors.blue[300] : (isMe ? Colors.blue[300] : Colors.grey[300]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: TextStyle(color: chat['isSending'] ?? false ? Colors.white : (isMe ? Colors.white : Colors.black)),
                              overflow: TextOverflow.visible, // Menampilkan pesan secara vertikal jika melebihi batas
                              softWrap: true, // Membungkus teks jika lebih panjang
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            time,
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          if (chat['isSending'] ?? false)
                            SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
