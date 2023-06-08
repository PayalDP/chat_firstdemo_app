import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingSpinner {
  static void showSpinner(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  static hideLoading() {
    Get.back();
  }
}
