
import 'dart:ui';

import 'package:get/get.dart';

class CustomSnackBar{

  static void showSnackBar ({required String msg}) {
      Get.snackbar('', msg,
        backgroundColor: const Color(0xff4ed1f2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
}



// class Dialog {
//
//   static void showSnackBar (String msg) {
//
//     SnackBar(content: Text(msg),
//     behavior: SnackBarBehavior.floating,
//     backgroundColor: const Color(0xff4ed1f2),);
//   }
//
// }