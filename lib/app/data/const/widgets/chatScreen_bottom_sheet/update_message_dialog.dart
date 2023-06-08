import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../models/massage_model.dart';

class UpdateMessageDialog extends StatelessWidget {
  const UpdateMessageDialog({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {

    String updatedMessage = '';

    return AlertDialog(
      title: Row(children: [
        const Icon(Icons.message, color: Colors.blue,),

        SizedBox(width: mq.width* .04,),
        
        const Text('Update Message', style: TextStyle(fontSize: 16),),
      ],),

      content: TextFormField(
        initialValue: message.msg,
        maxLines: null,
        onChanged: (value) => updatedMessage = value,
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ),

      actions: [
        MaterialButton(onPressed: (){
          //hide dialig
          Get.back();
        },
          child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16),),
        ),

        MaterialButton(onPressed: (){
          //hide dialog
          Get.back();
          FirebaseFunction.updateMessage(message: message, updatedMessage: updatedMessage);
        },
          child: const Text('Update', style: TextStyle(color: Colors.blue, fontSize: 16),),
        )
      ],
    );
  }
}
