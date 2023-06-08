import 'dart:convert';
import 'dart:developer';

import 'package:chat_firstdemo_app/app/data/const/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../modules/home/controllers/home_controller.dart';

class UserStreamBuilder extends StatelessWidget {
  const UserStreamBuilder({Key? key, required this.controller})
      : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    // controller.isSearching.value
    //     ? controller.searchList.value = []
    //     : controller.usersList.value = [];

    return Obx(() {
      if (controller.isSearching.value) {
        return StreamBuilder(
          stream: controller.snapshots.stream,
          builder: (context, snapshot) {

            controller.searchList.value = [];

            switch (snapshot.connectionState) {
            // If data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );

            // If data is loaded
              case ConnectionState.active:
              case ConnectionState.done:
                var users = snapshot.data?.docs.reversed;

                for (var u in users!) {
                  log(jsonEncode(u.data()).toString(), name: 'user');
                  var jsonString = jsonEncode(u.data());
                  final user = userFromJson(jsonString);

                  controller.searchList.add(user);
                }

                if (controller.searchList.isNotEmpty) {
                  return Obx(() => ListView.builder(
                    itemCount: controller.searchList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return UserCard(
                        user: controller.searchList[index],
                      );
                    },
                  ));
                } else {
                  return const Center(
                    child: Text(
                      'Add User',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
          },
        );
      } else {
        return StreamBuilder(
          stream: controller.fsnapshots.stream,
          builder: (context, snapshot) {
            controller.usersList.value = [];

            switch (snapshot.connectionState) {
            // If data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  // child:
                  // Text( 'no data'),
                  // CircularProgressIndicator(),
                );

            // If data is loaded
              case ConnectionState.active:
              case ConnectionState.done:
                var users = snapshot.data.docs ?? [];

                log(users.toString(), name: 'users');

                for (var u in users) {
                  log(jsonEncode(u.data()).toString(), name: 'user');
                  var jsonString = jsonEncode(u.data());
                  final user = userFromJson(jsonString);
                  controller.usersList.add(user);
                }

                if (controller.usersList.isNotEmpty) {
                  return Obx(() =>
                      ListView.builder(
                        itemCount: controller.usersList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return UserCard(
                            user: controller.usersList[index],
                          );
                        },
                      ));
                } else {
                  return const Center(
                    child: Text(
                      'Add User',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
          },
        );
      }
    });
  }
}

