import 'package:flutter/material.dart';

class CreditCard {
  String tableName = "creditcard";
  Icon icon = Icon(Icons.payment);
  String name;
  String cardHolderName;
  String cardNumber;
  String cvvCode;
  String expiryDate;
  int id;
  int userid;
  CreditCard(
      {this.name,
      this.cardHolderName,
      this.cardNumber,
      this.cvvCode,
      this.expiryDate,
      this.userid});
  CreditCard.withId(this.name, this.cardHolderName, this.cardNumber,
      this.cvvCode, this.expiryDate, this.id);

  CreditCard.fromObject(dynamic o) {
    id = int.tryParse(o["id"].toString());

    name = o["name"];
    cardHolderName = o["cardHolderName"];
    cardNumber = o["cardNumber"];
    cvvCode = o["cvvCode"];
    expiryDate = o["expiryDate"];
    userid = o["userid"];
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["cardHolderName"] = cardHolderName;
    map["cardNumber"] = cardNumber;
    map["cvvCode"] = cvvCode;
    map["expiryDate"] = expiryDate;
    map["userid"] = userid;

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
