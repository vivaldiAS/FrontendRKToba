import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';

void AwesomeSnackbarButton(String snackbarTitle, String snackbarMessage, ContentType snackbarContentType) {
  Get.snackbar(
    snackbarTitle,
    '', // Set messageText to null
    backgroundColor: Colors.transparent,
    barBlur: 0,
    borderRadius: 0,
    snackPosition: SnackPosition.TOP,
    titleText: Container(
      alignment: Alignment.centerLeft,
      child: AwesomeSnackbarContent(
        title: snackbarTitle,
        message: snackbarMessage,
        contentType: snackbarContentType,
      ),
    ),
    duration: Duration(seconds: 3),
  );
}
