import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum SEARCHTYPES {
  LOCATION,
  MYDESTINATION,
  BOTH
}

extension SnackBar on String {
  static void showSnackBar(String title, String message) {
    Get.snackbar(title, message, colorText: Colors.black, backgroundColor: Colors.grey[200]);
  }
}
