import 'dart:developer';

import 'package:chat_firstdemo_app/app/data/const/my_date_util.dart';
import 'package:chat_firstdemo_app/app/data/const/widgets/chatScreen_bottom_sheet/sheet_options.dart';
import 'package:chat_firstdemo_app/app/data/const/widgets/chatScreen_bottom_sheet/update_message_dialog.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:chat_firstdemo_app/app/models/massage_model.dart';
import 'package:chat_firstdemo_app/app/modules/chatScreen/controllers/chat_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../../../../main.dart';
import '../../custom_snackbar.dart';

class ChatScreenBottomSheet {

  ChatScreenController controller = ChatScreenController();

  Future getBottomSheet(
      {required Message message,
      required bool isMe,
      required BuildContext context,}) {
    return Get.bottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        ListView(shrinkWrap: true, children: [
          Container(
            height: 4,
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .4,
              vertical: mq.height * .015,
            ),
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(8)),
          ),
          message.type == Type.text
              ? SheetOptions(
                  icon: const Icon(
                    Icons.copy_all_rounded,
                    color: Colors.blueAccent,
                  ),
                  name: 'Copy',
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: message.msg))
                        .then((value) {
                      //hide bottom sheet
                      Get.back();

                      CustomSnackBar.showSnackBar(msg: 'Text Copied!');
                    });
                  })
              : SheetOptions(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.blueAccent,
                  ),
                  name: 'Image',
                  onTap: () async {
                    try{
                      await GallerySaver.saveImage(message.msg, albumName: 'Chat App').then((success) {
                        Get.back();
                        if(success != null && success){
                          CustomSnackBar.showSnackBar(msg: 'Image successfully saved!');
                        }
                      });
                    }catch (e) {
                      log(e.toString(), name: 'Error in saving images');
                    }
                  }),

          if (isMe) Divider(color: Colors.grey[350], height: 2),

          if (message.type == Type.text && isMe)
            SheetOptions(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
                name: 'Edit Message',
                onTap: () {
                  //hide bottom sheet
                  Get.back();

                  //show dialog to edit message
                  Get.dialog(UpdateMessageDialog(message: message,));

                }),


          if (isMe)
            SheetOptions(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                name: 'Delete Message',
                onTap: () async {
                  await FirebaseFunction.deleteMessage(message: message)
                      .then((value) {
                    Get.back();
                  });
                }),
          const Divider(color: Colors.grey, height: 2),
          SheetOptions(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.blueAccent,
              ),
              name:
                  'Sent At: ${MyDateUtil.getMessageTime(context, message.sent)}',
              onTap: () {}),
          SheetOptions(
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.red,
              ),
              name: message.read.isEmpty
                  ? 'Read At : not seen yet'
                  : 'Read At: ${MyDateUtil.getMessageTime(context, message.sent)}',
              onTap: () {})
        ]));
  }
}
