import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:developer';

import 'package:chat_firstdemo_app/app/models/massage_model.dart';
import 'package:chat_firstdemo_app/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class FirebaseFunction {
  //initialize firebaseAuth
  static FirebaseAuth auth = FirebaseAuth.instance;

  //initialize firebaseFirestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //initialize firebaseStorage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for accessing firebase messaging (push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  //for storing self info
  static late UserModel me;

  //Get current user
  static User get currentUser => auth.currentUser!;

  //whether user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(currentUser.uid).get())
        .exists;
  }

  //Add User in friend list
  static Future<bool> addFriend(String email) async {
    final data = await firestore.collection('users')
        .where('email', isEqualTo: email)
        .get();

    if(data.docs.isNotEmpty && data.docs.first.id != currentUser.uid){

      firestore.collection('users')
          .doc(currentUser.uid).collection('My_Friends')
          .doc(data.docs.first.id).set({});

      return true;
    }else {
      return false;
    }
  }

  //for getting firebase messaging token
  static getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log(me.pushToken.toString(), name: 'token');
      }
    });
  }

  //get all users's snapshots list
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers (List<String> friendIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: friendIds.isEmpty ? [''] : friendIds)
        .snapshots();
  }

  //get friend's snapshots List
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFriendList () {
    return firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('My_Friends')
        .snapshots();
  }

  //Pass current user info to the profile view
  static Future<void> getCurrentUserInfo() async {
    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //update user active status
        updateStatus(true);
      } else {
        await createUserCredential().then((value) => getCurrentUserInfo());
      }
    });
  }

  //Create user at firestore when user signIn
  static Future createUserCredential() async {
    var time = DateTime.now().millisecondsSinceEpoch.toString();

    final user = UserModel(
        image: currentUser.photoURL.toString(),
        about: 'android developer',
        name: currentUser.displayName.toString(),
        createdAt: time,
        isOnline: false,
        id: currentUser.uid,
        lastActive: time,
        pushToken: '',
        email: currentUser.email.toString());

    return await firestore
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toJson());
  }

  //Update user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(currentUser.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //Update Profile Picture
  static Future<void> updateProPicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //store file ref with path
    final ref = storage.ref().child('Profile_picture/${currentUser.uid}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    //update image in firestore
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({'image': me.image});
  }

  //get selected User information
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSelectedUserInfo(
      UserModel user) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  //update active status
  static Future<void> updateStatus(bool isOnline) async {
    firestore.collection('users').doc(currentUser.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  //for sending push notification
  static sendPushNotification(UserModel user, String msg) async {
    try {
      final body = {
        "to": user.pushToken,
        "notification": {
          "title": user.name,
          "body": msg,
          "android_channel_id": 'chats',
        },
        "data": {"some data": 'User Id: ${me.id}'}
      };

      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA2CpszvU:APA91bFjfqB865RE7kptCvJcaNokuOR1lLaC4Ni6GivqbTGzETjMPrU5NgBcNFoLbG616Mp6xKCOWA1_rUU2vVUeq6y9h4cAZPGtzLGQkNTl-MRF3e6KZ0Rkc49x71PtQFOadSLxqx3r'
              },
              body: jsonEncode(body));
      print('\nResponse status: ${response.statusCode}');
      print('\nResponse body: ${response.body}');
    } catch (e) {
      print('sendnotificationE $e');
    }
  }


  ///***************  chat screen related functions  *********************

  //to get conversation id
  static String getConversationId(String sendTOBeId) =>
      auth.currentUser!.uid.hashCode <= sendTOBeId.hashCode
          ? '${auth.currentUser!.uid}_$sendTOBeId'
          : '${sendTOBeId}_${auth.currentUser!.uid}';

  //send First Message
  Future<void> sendFirstMessage (UserModel user, String msg, Type type) async {

    await firestore.collection('users')
        .doc(user.id)
        .collection('My_Friends')
        .doc(currentUser.uid)
        .set({}).then((value) => sendMessage(user, msg, type));

  }

  //to send message
  Future<void> sendMessage(UserModel user, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        read: '',
        told: user.id,
        type: type,
        sent: time,
        fromid: FirebaseFunction.auth.currentUser!.uid.toString());

    final ref = FirebaseFunction.firestore.collection(
        'chats/${FirebaseFunction.getConversationId(user.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(user, type == Type.text ? msg : 'image'));
  }

  //to get all messages of particulate conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //to update read status
  static Future<void> updateReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of specific chats
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat images
  Future<void> sendImage(UserModel user, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //store file ref with path
    final ref = storage.ref().child(
        'images/${getConversationId(currentUser.uid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    //update image in firestore
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(user, imageUrl, Type.image);
  }

  //Delete message
  static Future<void> deleteMessage({required Message message}) async {

     await firestore
        .collection('chats/${getConversationId(message.told)}/messages/')
        .doc(message.sent)
        .delete();

    if(message.type == Type.image){
      await storage.refFromURL(message.msg).delete();
    }
  }

  //Update Message
  static Future<void> updateMessage({required Message message, required String updatedMessage}) async {

    await firestore
        .collection('chats/${getConversationId(message.told)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMessage});

    
  }
}
