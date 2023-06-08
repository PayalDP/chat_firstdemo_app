import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../main.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Stack(
            children: [

              //App logo
              Positioned(
                  top: mq.height * .15,
                  bottom: mq.height * .40,
                  width: mq.width * .5,
                  right: mq.width * .24,
                  child: Image.asset('images/icon.png')),

              //google login button
              Positioned(
                  bottom: mq.height * .11,
                  width: mq.width,
                  child: const Text(
                    'Made in india with ❤️',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        letterSpacing: 0.5),
                  )),
            ],
          );
        },
      ),
    );
  }
}
