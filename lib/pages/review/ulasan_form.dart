import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rumah_kreatif_toba/controllers/auth_controller.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';  // Import AppConstant

class UlasanForm extends StatefulWidget {
  final int productId;

  const UlasanForm({Key? key, required this.productId}) : super(key: key);

  @override
  State<UlasanForm> createState() => _UlasanFormState();
}

class _UlasanFormState extends State<UlasanForm> {
  final AuthController authController = Get.find<AuthController>();

  int rating = 0;
  final TextEditingController reviewController = TextEditingController();
  bool isLoading = false;

  Future<void> submitReview() async {
    setState(() {
      isLoading = true;
    });

    bool isLoggedIn = authController.userLoggedIn();
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Silakan login terlebih dahulu.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final token = await authController.authRepo.getUserToken();

    final response = await http.post(
      Uri.parse(AppConstants.REVIEWS_URL),  // Gunakan AppConstant.REVIEWS_URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "product_id": widget.productId,
        "nilai_review": rating,
        "isi_review": reviewController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ulasan berhasil dikirim")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim ulasan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BigText(text: "Beri Ulasan", size: 18, fontWeight: FontWeight.bold),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final i = index + 1;
              return IconButton(
                icon: Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    rating = i;
                  });
                },
              );
            }),
          ),
          TextField(
            controller: reviewController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Tulis ulasanmu di sini...",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: isLoading ? null : submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redColor,
            ),
            child: Text(isLoading ? "Mengirim..." : "Kirim Ulasan"),
          )
        ],
      ),
    );
  }
}
