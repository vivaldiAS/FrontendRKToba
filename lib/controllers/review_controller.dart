import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart'; // Import AppConstants


class ReviewController extends GetxController {
  List<int> reviewedProductIds = [];

  Future<void> getUserReviews() async {
    final token = await Get.find<AuthController>().authRepo.getUserToken();
    final userController = Get.find<UserController>();

    if (userController.usersList.isEmpty) {
      await userController.getUser();
    }

    final userId = userController.usersList[0].id;

    final response = await http.get(
      Uri.parse(AppConstants.REVIEWS_URL),  // Gunakan AppConstant.REVIEWS_URL
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      reviewedProductIds = data
          .where((review) => review['user_id'] == userId)
          .map<int>((review) => review['product_id'] as int)
          .toList();
      update();
    }
  }
}
