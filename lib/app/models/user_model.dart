// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String image;
  String about;
  String name;
  String createdAt;
  bool isOnline;
  String id;
  String lastActive;
  String pushToken;
  String email;

  UserModel({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.pushToken,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    image: json["image"],
    about: json["about"],
    name: json["name"],
    createdAt: json["created_at"],
    isOnline: json["is_online"],
    id: json["id"],
    lastActive: json["last_active"],
    pushToken: json["push_token"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "about": about,
    "name": name,
    "created_at": createdAt,
    "is_online": isOnline,
    "id": id,
    "last_active": lastActive,
    "push_token": pushToken,
    "email": email,
  };
}
