import 'package:flutter/material.dart';

class SecureNote {
  final String tableName = "securenote";
  Icon icon = Icon(Icons.notes_rounded);

  String name;
  String noteText;
  int id;
  int userid;
  SecureNote({this.name, this.noteText, this.userid});
  SecureNote.withId({
    this.id,
    this.name,
    this.noteText,
  });

  SecureNote.fromObject(dynamic o) {
    id = int.tryParse(o["id"].toString());

    name = o["name"];
    noteText = o["noteText"];
    userid = o["userid"];
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["noteText"] = noteText;
    map["userid"] = userid;

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
