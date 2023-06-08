import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_firstdemo_app/app/data/const/my_date_util.dart';
import 'package:chat_firstdemo_app/app/data/const/widgets/profile_dialog.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:chat_firstdemo_app/app/models/massage_model.dart';
import 'package:chat_firstdemo_app/app/models/user_model.dart';
import 'package:chat_firstdemo_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_firstdemo_app/main.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class UserCard extends StatelessWidget {

  final UserModel user;

  const UserCard({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Message? message;

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * .01, vertical: mq.height * .0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: InkWell(
          onTap: () {
            Get.toNamed(Routes.CHAT_SCREEN, arguments: user);
          },
          child: StreamBuilder(
            stream: FirebaseFunction.getLastMessage(user),
            builder: (context, snapshot) {

              var messages = snapshot.data?.docs;

              log(messages.toString(), name: 'data');

              for (var m in messages ?? []) {
                var temp = messageFromJson(jsonEncode(m.data()));
                message = temp;
              }

              return ListTile(
                  leading: InkWell(
                    onTap: () {
                      Get.dialog(ProfileDialog(user: user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        height: mq.height * .06,
                        width: mq.width * .11,
                        imageUrl: user.image,
                        errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),

                  //user Name
                  title: Text(user.name),

                  //User last message
                  subtitle: Text(
                    message != null
                        ?
                    message!.type == Type.image
                    ? 'image'
                    : message!.msg
                        : user.about,
                    maxLines: 1,
                  ),

                  //last message time
                  trailing: message == null
                      ? null
                      : message!.read.isEmpty && message!.told == FirebaseFunction.currentUser.uid
                          ? Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: message!.sent),
                              style: const TextStyle(color: Colors.black54),
                            ));
            },
          )),
    );
  }
}
