import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_firstdemo_app/app/models/user_model.dart';
import 'package:chat_firstdemo_app/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: mq.height* .35,
        width: mq.width* .6,
        child: Stack(
          children: [

            //user profile picture
            Positioned(
              top: mq.height* .07,
              left: mq.width* .15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.width * .3),
                child: CachedNetworkImage(
                  width: mq.width* .45,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
            ),
            
            //user name
            Positioned(
                top: mq.height* .02,
                left: mq.width* .04,
                width: mq.width* .55,
                child: Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)),
            
            //userinfo icon
            Positioned(
              right: mq.width* .02,
                child: MaterialButton(onPressed: () { Get.toNamed(Routes.PROFILE_SCREEN, arguments: user); },
                    shape: const CircleBorder(),
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                child: const Icon(Icons.info_outline, color: Colors.blueAccent,size: 30,))),
          ],
        ),
      ),
    );
  }
}
