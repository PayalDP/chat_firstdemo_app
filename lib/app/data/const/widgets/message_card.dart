import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:chat_firstdemo_app/app/models/massage_model.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../my_date_util.dart';
import 'chatScreen_bottom_sheet/chat_screen_bottom_sheet.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    bool isMe = FirebaseFunction.currentUser.uid == message.fromid;
    return InkWell(onLongPress: () {
      ChatScreenBottomSheet().getBottomSheet(message: message, isMe: isMe, context: context);
    },
    child: isMe ? _greenMessage(context) : _blueMessage(context),);
  }

  Widget _greenMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: mq.width * .04),
          child: Row(
            children: [
              if (message.read.isNotEmpty)
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.green,
                  size: 20,
                ),
              SizedBox(
                width: mq.width * .01,
              ),
              Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: message.sent),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                message.type == Type.image ? mq.width * .02 : mq.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .02),
            decoration: BoxDecoration(
                color: Colors.green[100],
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: message.type == Type.text

                //show text msg
                ? Text(message.msg,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.normal))

                //show image msg
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .01),
                    child: CachedNetworkImage(
                      imageUrl: message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image),
                    )),
          ),
        ),
      ],
    );
  }

  Widget _blueMessage(BuildContext context) {
    //update read time of last message
    if (message.read.isEmpty) {
      FirebaseFunction.updateReadStatus(message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                message.type == Type.image ? mq.width * .02 : mq.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .02),
            decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: message.type == Type.text

                //show text msg
                ? Text(message.msg,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.normal))

                //show image msg
                : ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .01),
                    child: CachedNetworkImage(
                      imageUrl: message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image),
                    )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(context: context, time: message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
