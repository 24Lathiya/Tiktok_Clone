import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static showCustomSnack(
    String message, {
    String title = "Error",
    bool isError = true,
  }) {
    Get.snackbar(
      title,
      message,
      // titleText: title.text.white.bold.xl.make(),
      // messageText: message.text.white.make(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
    );
  }
}
