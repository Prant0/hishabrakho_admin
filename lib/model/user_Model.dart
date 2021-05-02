// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.isAdmin,
  });

  int id;
  String name;
  String email;
  String image;
  int isAdmin;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    image: json["image"] == null ? null : json["image"],
    isAdmin: json["is_admin"] == null ? null : json["is_admin"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "image": image == null ? null : image,
    "is_admin": isAdmin == null ? null : isAdmin,
  };
}
