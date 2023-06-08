import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/firebase_google/firebase_function.dart';


class LogInUserProfileController extends GetxController {

  final formKey = GlobalKey<FormState>();


  RxBool isImagePicked = false.obs;
  XFile? pickedImage;


  //Click event on add images.
  Future getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final image = await picker.pickImage(source: source, imageQuality: 80);

    if (image != null) {
      pickedImage = image;
      isImagePicked.value = !isImagePicked.value;
      log(pickedImage!.path.toString(), name: 'path');
      FirebaseFunction.updateProPicture(File(pickedImage!.path));
      update();
    } else {
      isImagePicked.value = !isImagePicked.value;
    }
    Get.back();
  }

}

