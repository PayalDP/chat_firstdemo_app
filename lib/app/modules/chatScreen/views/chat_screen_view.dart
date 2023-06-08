import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_firstdemo_app/app/data/const/widgets/chat_appbar.dart';
import 'package:chat_firstdemo_app/app/data/const/widgets/massage_input_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../data/const/widgets/message_card.dart';
import '../../../models/massage_model.dart';
import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  const ChatScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.massageList.value = [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      //if emoji is on and back button pressed then hide emoji
      //or else simple close current screen on back button
      child: WillPopScope(
        onWillPop: () {
          if (controller.showEmoji.value) {
            controller.showEmoji.value = !controller.showEmoji.value;
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            flexibleSpace: ChatAppBar(user: Get.arguments),
          ),
          body: Column(
            children: [
              //Chat stream
              Expanded(
                child: StreamBuilder(
                  stream: controller.snapshots.stream,
                  builder: (context, snapshot) {
                    controller.messageList.value = [];

                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      //if data is loaded
                      case ConnectionState.active:
                      case ConnectionState.done:
                        var massages = snapshot.data?.docs;
                        // var data = jsonEncode(messages[0].data());
                        // log(data.toString(), name: 'message');

                        for (var m in massages) {
                          var jsonString = jsonEncode(m.data());
                          log(jsonString.toString(), name: 'massage');
                          final message = messageFromJson(jsonString);
                          controller.messageList.add(message);
                        }

                        if (controller.messageList.isNotEmpty) {
                          return Obx(() => ListView.builder(
                              reverse: true,
                              itemCount: controller.messageList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                    message: controller.messageList[index]);
                              }));
                        } else {
                          return const Center(
                            child: Text(
                              'Say hi..👋',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),

              Obx(
                () => Offstage(
                  offstage: controller.isImageUploading.value,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: CircularProgressIndicator(
                          strokeWidth: mq.width * .005),
                    ),
                  ),
                ),
              ),

              //message input field
              MessageInputField(controller: controller),

              Obx(() => Offstage(
                    offstage: !controller.showEmoji.value,
                    child: SizedBox(
                        height: mq.height * .35,
                        child: EmojiPicker(
                          textEditingController: controller.msg,
                          config: Config(
                            columns: 7,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            bgColor: Colors.blue.shade50,
                          ),
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
