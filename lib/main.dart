import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'app/firebase_options.dart';
import 'app/routes/app_pages.dart';

late Size mq;

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'foe showing message notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log(result, name: 'notification result');
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((value) {

runApp(
  GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Application",
    theme: ThemeData(
      primaryColor: Colors.lightBlueAccent,
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle:  TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 19,
          ),
          // centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          shadowColor: Color(0xffeeb5f5)
      ),
    ),

    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ),
);
}
