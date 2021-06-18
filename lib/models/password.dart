import 'package:flutter/material.dart';

class Password {
  final String tableName = "passwords";
  Icon icon = Icon(Icons.enhanced_encryption);
  String name;
  String username;
  String password;
  int id;
  int userid;
  Password({this.name, this.username, this.password, this.userid});
  Password.withId({this.id, this.name, this.username, this.password});

  Password.fromObject(dynamic o) {
    id = int.tryParse(o["id"].toString());

    name = o["name"];
    username = o["username"];
    password = o["password"];
    userid = o["userid"];
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["username"] = username;
    map["password"] = password;
    map["userid"] = userid;

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
