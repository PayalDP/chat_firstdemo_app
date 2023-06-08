import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/firebase_google/firebase_function.dart';
import '../../../data/firebase_google/firebase_google_auth.dart';

import '../../../routes/app_pages.dart';



class HomeController extends GetxController {
  final FirebaseGoogleAuth _firebaseGoogleAuth = FirebaseGoogleAuth();
  final StreamController snapshots = StreamController.broadcast();
  final StreamController fsnapshots = StreamController.broadcast();
  final StreamController<List> fList = StreamController.broadcast();
  RxList usersList = [].obs;
  RxList searchList = [].obs;
  RxList<String> friendList = <String>[].obs;

  RxBool isSearching = false.obs;

  //fetch snapshots
  @override
  void onInit() {
    //Get information about current user profile
    FirebaseFunction.getCurrentUserInfo();

    //Update user status
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (FirebaseFunction.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          FirebaseFunction.updateStatus(true);
        }
        if (message.toString().contains('pause')) {
          FirebaseFunction.updateStatus(false);
        }
      }

      return Future(() => message);
    });

    //get all Users Stream
    snapshots.addStream(FirebaseFunction.firestore
        .collection('users')
        .where('id', isNotEqualTo: FirebaseFunction.currentUser.uid)
        .snapshots());

    //get friend's stream
    getFriendIdList().then((value) {
     if(value.isNotEmpty){
       fsnapshots.addStream(FirebaseFunction.firestore
           .collection('users')
           .where('id', whereIn: value)
           .snapshots());
     }
    });

    fList.stream.listen((event) {
      fsnapshots.sink.addStream(FirebaseFunction.firestore
          .collection('users')
          .where('id', whereIn: friendList)
          .snapshots());
    });

    //update
    everAll([usersList, searchList, friendList], (callback) => update);

    super.onInit();
  }

  //signOut function
  void onSignOut() {
    _firebaseGoogleAuth.signOut().then((value) => Get.offNamed(Routes.LOG_IN));
  }

  //Logic for searching user
  void searchUser(String value) {
    for (var i in usersList) {
      if (i.email.toLowerCase().contains(value.toLowerCase()) ||
          i.name.toLowerCase().contains(value.toLowerCase())) {
        searchList.add(i);
      }
    }
  }

  Future<List> getFriendIdList () async {

    List<String> list = [];
    friendList.clear();

    var data = await  FirebaseFunction.firestore
        .collection('users')
        .doc(FirebaseFunction.currentUser.uid)
        .collection('My_Friends').get();

          var temp = data.docs.map((e) => e.id).toList();

    friendList.value = temp;

    log(friendList.toString(), name: 'friendsids');
     return friendList;

  }

}


