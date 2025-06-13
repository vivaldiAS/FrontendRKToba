import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_kreatif_toba/utils/colors.dart';
import 'package:rumah_kreatif_toba/widgets/big_text.dart';

void showCustomSnackBar(String message, {bool isError = true, String title="Error"}){
  Get.snackbar(title, message,
  titleText: BigText(text: title, color: Colors.white,),
    messageText: Text(message, style: const TextStyle(
      color: Colors.white,
    ),),
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    backgroundColor: AppColors.notification_success
  );
}