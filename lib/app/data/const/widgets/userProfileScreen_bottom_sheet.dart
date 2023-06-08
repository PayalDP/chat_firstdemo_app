
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../main.dart';
import '../../../modules/log_in_user_profile/controllers/log_in_user_profile_controller.dart';

class UserProfileScreenBottomSheet{

  final LogInUserProfileController controller = LogInUserProfileController();

  //Bottom sheet
  Future getBottomSheet() {
    return Get.bottomSheet(
        isScrollControlled: true,
        Padding(
          padding:
          EdgeInsets.only(top: mq.height * .05, bottom: mq.height * .03),
          child: ListView(shrinkWrap: true, children: [
            //Text on top of bottom sheet
            const Text(
              'Edit Profile Picture',
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: mq.height * .05,
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //button to pic image from gallery
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(mq.width * .25, mq.height * .12),
                      backgroundColor: Colors.white,
                      shape: const CircleBorder()),
                  onPressed: () {
                    controller.getImage(ImageSource.gallery);
                  },
                  child: Image.asset('images/add_profile.png'),
              ),

              SizedBox(
                width: mq.width * .1,
              ),

              //button to take a picture from camera
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(mq.width * .25, mq.height * .12),
                      backgroundColor: Colors.white,
                      shape: const CircleBorder()),
                  onPressed: () {
                    controller.getImage(ImageSource.camera);
                  },
                  child: Image.asset('images/camera.png')),
            ])
          ]),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))));
  }
}