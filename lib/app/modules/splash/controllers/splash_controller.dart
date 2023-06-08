import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    getSplash();
    super.onInit();
  }

   Future getSplash(){

    return Future.delayed(const Duration(milliseconds: 1500),() {
      //exit full-screen
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.tran,
      //     statusBarColor: Colors.white));

      if(FirebaseFunction.auth.currentUser != null){

        Get.offAllNamed(Routes.HOME);

      }else{

        //navigate to LogIn screen
        Get.offAllNamed(Routes.LOG_IN);}
    });
  }


}
