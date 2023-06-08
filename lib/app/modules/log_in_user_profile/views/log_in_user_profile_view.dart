import 'dart:io';
import 'package:chat_firstdemo_app/app/data/const/loading_spinner.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../main.dart';
import '../../../data/const/widgets/userProfileScreen_bottom_sheet.dart';
import '../../../routes/app_pages.dart';
import '../controllers/log_in_user_profile_controller.dart';

class LogInUserProfileView extends GetView<LogInUserProfileController> {
  const LogInUserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //AppBar
        appBar: AppBar(
          title: const Text("User Profile",),
        ),

        //body
        body: Form(
          key: controller.formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //SizedBox
                  SizedBox(
                    height: mq.height * .03,
                    width: mq.width,
                  ),

                  Stack(
                    children: [
                      //User's Profile Photo
                      Obx(
                        () => ClipRRect(
                            borderRadius: BorderRadius.circular(mq.width * .3),
                            child: controller.isImagePicked.value
                                ? Image.file(
                                    File(controller.pickedImage!.path
                                        .toString()),
                                    height: mq.height * .15,
                                    width: mq.width * .30,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    FirebaseFunction.me.image,
                                    height: mq.height * .15,
                                    width: mq.width * .30,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        CupertinoIcons.person,
                                        size: 100,
                                        color: Colors.black45,
                                      );
                                    },
                                  )),
                      ),

                      //Edit profile photo button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          minWidth: 0,
                          onPressed: () {
                            UserProfileScreenBottomSheet().getBottomSheet();
                          },
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: mq.height * .03,
                    width: mq.width,
                  ),

                  //User's Email Id
                  Text(
                    FirebaseFunction.me.email,
                    style: const TextStyle(color: Colors.black45, fontSize: 16),
                  ),

                  SizedBox(
                    height: mq.height * .03,
                    width: mq.width,
                  ),

                  //User name field
                  TextFormField(
                    initialValue: FirebaseFunction.me.name,
                    onSaved: (newValue) =>
                    FirebaseFunction.me.name = newValue ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'eg. Payal Patel',
                    ),
                  ),

                  SizedBox(
                    height: mq.height * .03,
                    width: mq.width,
                  ),

                  //info about user
                  TextFormField(
                    initialValue: FirebaseFunction.me.about,
                    onSaved: (newValue) =>
                    FirebaseFunction.me.about = newValue ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'about',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'eg. Feeling Happy',
                    ),
                  ),

                  SizedBox(
                    height: mq.height * .03,
                    width: mq.width,
                  ),

                  //Update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(mq.width * .4, mq.height * .06),
                    ),
                    onPressed: () {
                      if(controller.formKey.currentState!.validate()){
                        controller.formKey.currentState!.save();
                        FirebaseFunction.updateUserInfo();
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 25,
                    ),
                    label: const Text(
                      'Update',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        //Floating button for logOut
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: Material(
            child: FloatingActionButton.extended(
              elevation: 10,
              backgroundColor: Colors.blue,
              onPressed: () async {
                LoadingSpinner.showSpinner(context);
                FirebaseFunction.updateStatus(false);
                await FirebaseFunction.auth.signOut();
                await GoogleSignIn().signOut();
                LoadingSpinner.hideLoading();
                Get.offAllNamed(Routes.LOG_IN);
                FirebaseFunction.auth = FirebaseAuth.instance;
              },
              label: const Text(
                'LogOut',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(
                Icons.logout_outlined,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
