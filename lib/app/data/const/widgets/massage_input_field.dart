import 'dart:developer';
import 'package:chat_firstdemo_app/main.dart';
import 'package:flutter/material.dart';
import '../../../models/massage_model.dart';

import '../../../modules/chatScreen/controllers/chat_screen_controller.dart';

class MessageInputField extends StatelessWidget {

  const MessageInputField({Key? key, required this.controller}) : super(key: key);

  final ChatScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                //emoji button
                IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    controller.showEmoji.value = !controller.showEmoji.value;
                  },
                ),

                //message field
                Expanded(
                  child: TextField(
                    controller: controller.msg,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    onTap: () => controller.showEmoji.value=false,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type here....',
                        hintStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),

                //pick image from gallery
                IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    controller.sendMultipleImage();
                  },
                ),

                //click image from camera
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    controller.sendCameraImage();
                  },
                ),

                SizedBox(width: mq.width* .01,)
              ],
            ),
        ),
          ),

        //Enter button
          MaterialButton(
            shape: const CircleBorder(),
            minWidth: 0,
            onPressed: () {
              if(controller.msg.text.isNotEmpty){
                controller.sendTextMessage(Type.text);
                log(controller.selectedUser.toString(), name: 'selected user');
                controller.msg.clear();
              }

            },
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 16),
          )
      ]
      ),
    );
  }
}
