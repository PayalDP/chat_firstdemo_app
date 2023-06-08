import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chat_firstdemo_app/app/data/const/widgets/chatScreen_bottom_sheet/update_message_dialog.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:chat_firstdemo_app/app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/massage_model.dart';

class ChatScreenController extends GetxController {
  final FirebaseFunction function = FirebaseFunction();
  final StreamController snapshots = StreamController.broadcast();
  final TextEditingController msg = TextEditingController();
  RxList<Message> messageList = <Message>[].obs;
  UserModel selectedUser = Get.arguments;
  RxBool showEmoji = false.obs;
  RxBool isImageUploading = true.obs;

  @override
  void onInit() async {
    await snapshots.addStream(FirebaseFunction.getAllMessage(selectedUser));

    super.onInit();
  }

  //to send message
  sendTextMessage(Type type) {
    if(messageList.isEmpty){
      function.sendFirstMessage(selectedUser, msg.text, type);
      log('msg sent', name: 'status');
    }else{
      function.sendMessage(selectedUser, msg.text, type);
    }
  }

  //pick picture to send image
  Future sendMultipleImage() async {
    final ImagePicker picker = ImagePicker();

    List<XFile>images = await picker.pickMultiImage(imageQuality: 70);

    isImageUploading.value = !isImageUploading.value;

    for (var i in images) {
      function.sendImage(selectedUser, File(i.path));
    }
    isImageUploading.value = !isImageUploading.value;
  }

  //to send image using camera
  Future sendCameraImage() async {
    final ImagePicker picker = ImagePicker();

    var image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 70);

    isImageUploading.value = !isImageUploading.value;

    if (image != null) {
      function.sendImage(selectedUser, File(image.path)).then((value) =>
      isImageUploading.value = !isImageUploading.value);
    }
  }

}
