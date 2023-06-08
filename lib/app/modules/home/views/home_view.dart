import 'dart:developer';

import 'package:chat_firstdemo_app/app/data/const/widgets/add_user_dialog.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../data/const/widgets/users_stream_builder.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if(controller.isSearching.value){
            controller.isSearching.value = !controller.isSearching.value;
            return Future.value(false);
          }else {
            return Future.value(true);
          }},
          child: Scaffold(
            //AppBar
            appBar: AppBar(

              title: Obx(() {
                return
                  controller.isSearching.value
                    ?  TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ....',),
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  onChanged: (value) {
                    controller.searchList.clear();
                    controller.searchUser(value);
                  },
                )
                    : const Text("Chat App");
              }),

              actions: [
                //search user button
                Obx(() => IconButton(
                  icon: Icon(controller.isSearching.value
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search),
                  onPressed: () {
                    controller.isSearching.value = !controller.isSearching.value;
                    log(controller.isSearching.value.toString(), name: 'isSearching');
                    controller.searchList.clear();
                  },
                ),),

                //more feature button
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOG_IN_PROFILE,);
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),

            //Floating button to add new user
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10),
              child: Material(
                shape: CircleBorder(
                    side: BorderSide(color: Colors.blueGrey.shade50, width: 1)),
                child: FloatingActionButton(
                  elevation: 10,
                  backgroundColor: Colors.grey[400],
                  onPressed: () {
                    Get.dialog(AddUserDialog(controller: controller));
                  },
                  child: const Icon(
                    Icons.add_comment,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            //users list
            body: UserStreamBuilder(controller: controller),
          ),
        ),
      );
  }
}
