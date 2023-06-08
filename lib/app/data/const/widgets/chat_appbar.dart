import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_firstdemo_app/app/data/const/my_date_util.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:chat_firstdemo_app/app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({required this.user, Key? key}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {Get.toNamed(Routes.PROFILE_SCREEN, arguments: user);},
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding:
                EdgeInsets.only(bottom: mq.height * .01, left: mq.width * .12),
            child: StreamBuilder(
              stream: FirebaseFunction.getSelectedUserInfo(user),
              builder: (context, snapshot) {
                var data = snapshot.data?.docs;
                final list = data?.map((e) => UserModel.fromJson(e.data()))
                        .toList() ?? [];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //User profile picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        height: mq.height * .06,
                        width: mq.width * .11,
                        imageUrl: list.isNotEmpty ? list[0].image : user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),

                    SizedBox(width: mq.width * .03),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: mq.height * .04),
                          child: Text(
                            list.isNotEmpty ? list[0].name : user.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: mq.height * .005,
                        ),
                        Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                              ? 'OnLine'
                              : MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(context: context, lastActive: user.lastActive),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        )
                      ],
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
