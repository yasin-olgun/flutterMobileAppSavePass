class User {
  int id;
  String username;
  String password;

  User(this.username, this.password, this.id);

  User.fromObject(dynamic o) {
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
