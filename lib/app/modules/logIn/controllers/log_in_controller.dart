import 'dart:developer';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../data/firebase_google/firebase_google_auth.dart';
import '../../../routes/app_pages.dart';

class LogInController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement LogInController

  late AnimationController animationController;
  late Animation animation;
  final FirebaseGoogleAuth _googleFunctions = FirebaseGoogleAuth();

  @override
  void onInit() {
    animationInitialization();
    super.onInit();
  }

  void animationInitialization() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: -mq.width * .7, end: mq.width * .24)
        .animate(animationController);
    animationController.forward();
    animationController.addListener(
      () => update(),
    );
  }

  //handle google button click
  Future handleGoogleBtnClick() async {
    await _googleFunctions.signInWithGoogle().then((user) async {
      if (user != null) {
        print('\nUser: ${user.user}');
        log('\nAdditionalUserInfo: ${user.additionalUserInfo}');

        if (await FirebaseFunction.userExists()) {
          Get.offAllNamed(Routes.HOME);
        } else {
          await FirebaseFunction.createUserCredential()
              .then((value) => Get.offAllNamed(Routes.HOME));
        }
      }
    });
  }
}
