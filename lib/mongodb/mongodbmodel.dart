//THIS IS TO CONVERT THE DATA INPUT TO JASON FORMAT TO  BE ENTERED INTO THE DATABASE

import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    Welcome({
      required this.id,
      required this.email,
      required this.password,
      required this.username,
      required this.name,
      required this.phone,
    });

    ObjectId id;
    String email;
    String password;
    String username;
    String name;
    String phone;

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["_id"],
        email: json["email"],
        password: json["password"],
        username: json["username"],
        name: json["name"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "password": password,
        "username": username,
        "name": name,
        "phone": phone,
    };
}