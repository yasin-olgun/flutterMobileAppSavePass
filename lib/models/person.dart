class Person {
  String username;
  String password;
  int id;
  Person({this.username, this.password});
  Person.withId(this.id, this.username, this.password);

  Person.fromObject(dynamic o) {
    //id = int.tryParse(o["id"]);
    id = int.tryParse(o["id"].toString());

    username = o["username"];
    password = o["password"];
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
