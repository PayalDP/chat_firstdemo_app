// To parse this JSON data, do
//
//     final massage = massageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String massageToJson(Message data) => json.encode(data.toJson());

class Message {
  String msg;
  String read;
  String told;
  String sent;
  String fromid;
  Type type;

  Message({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.sent,
    required this.fromid,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    msg: json["msg"].toString(),
    read: json["read"].toString(),
    told: json["told"].toString(),
    type: json["type"].toString() == Type.image.name ? Type.image : Type.text,
    sent: json["sent"].toString(),
    fromid: json["fromid"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "read": read,
    "told": told,
    "type": type.name,
    "sent": sent,
    "fromid": fromid,
  };
}

enum Type {text, image}
