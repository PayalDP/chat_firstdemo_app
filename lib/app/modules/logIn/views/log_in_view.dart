
import 'package:chat_firstdemo_app/app/data/const/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../controllers/log_in_controller.dart';

class LogInView extends GetView<LogInController> {
  const LogInView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Chat App'),
        centerTitle: true,
      ),
      body: Stack(
        children: [

          //App logo
          AnimatedBuilder(
            animation: controller.animation,
            builder: (context, child) {
             return Positioned(
                  top: mq.height * .15,
                  // left: mq.width * .20,
                  bottom: mq.height * .40,
                  width: mq.width * .5,
                  right: controller.animation.value,
                  child: Image.asset('images/icon.png'));
            },
          ),


          //google login button
          Positioned(
            top: mq.height * .70,
            bottom: mq.height * .11,
            left: mq.width * .1,
            right: mq.width * .1,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffeeb5f5),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                LoadingSpinner.showSpinner(context);
                controller.handleGoogleBtnClick();
              },
              icon: Image.asset(
                'images/google.png',
                height: mq.height * .03,
              ),
              label: RichText(
                  text: const TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                    TextSpan(text: 'Login with'),
                    TextSpan(
                      text: ' Goggle',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ])),
            ),
          ),
        ],
      ),
    );
  }
}



