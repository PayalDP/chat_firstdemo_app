import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../data/const/my_date_util.dart';
import '../../../data/firebase_google/firebase_function.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends GetView<ProfileScreenController> {
  const ProfileScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //AppBar
        appBar: AppBar(
          title: Text(controller.user.name),
        ),

        floatingActionButton: //user about
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joined On: ',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
                MyDateUtil.getLastMessageTime(
                    context: context,
                    time: controller.user.createdAt, showYear: true),
                style: const TextStyle(color: Colors.black54, fontSize: 15)),
          ],
        ),


        //body
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //SizedBox
                SizedBox(
                  height: mq.height * .03,
                  width: mq.width,
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: controller.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                // for adding some space
                SizedBox(height: mq.height * .02),

                Text(controller.user.email,
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16)),

                // for adding some space
                SizedBox(height: mq.height * .02),

                //user about
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'About: ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  Text(controller.user.about,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
