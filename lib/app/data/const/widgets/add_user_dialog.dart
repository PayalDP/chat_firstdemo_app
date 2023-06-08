import 'package:chat_firstdemo_app/app/data/const/custom_snackbar.dart';
import 'package:chat_firstdemo_app/app/data/firebase_google/firebase_function.dart';
import 'package:chat_firstdemo_app/app/modules/home/controllers/home_controller.dart';
import 'package:chat_firstdemo_app/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({required this.controller,Key? key}) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {

    String email = '';

    return AlertDialog(
      title: Row(children: [
        const Icon(Icons.person_add, color: Colors.blue,),

        SizedBox(width: mq.width* .02,),

        const Text('Add User', style: TextStyle(fontSize: 16),),
      ],),

      content: TextFormField(
        maxLines: null,
        onChanged: (value) => email = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: 'Email Id',
          prefixIcon: const Icon(Icons.email, color: Colors.blue,),
        ),
      ),

      actions: [

        //Cancel button
        MaterialButton(onPressed: (){
          //hide dialig
          Get.back();
        },
          child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16),),
        ),

        //Add Button
        MaterialButton(onPressed: () async {
          //hide dialog
          Get.back();

          if(email.isNotEmpty) {
            await FirebaseFunction.addFriend(email).then((value) async {

              controller.getFriendIdList().then((value) => controller.fList.add(value));

              if(!value){
                CustomSnackBar.showSnackBar(msg: 'User Does Not Exists!');

              }
            });
          }

        },
          child: const Text('Add', style: TextStyle(color: Colors.blue, fontSize: 16),),
        )
      ],
    );
  }
}
