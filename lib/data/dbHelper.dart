import 'dart:async';

import 'package:pratik/models/CreditCard.dart';
import 'package:pratik/models/password.dart';
import 'package:path/path.dart';
import 'package:pratik/models/secureNote.dart';
import 'package:pratik/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "app15.db");

    var passDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return passDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "Create table user(id integer primary key ,username text unique,password text)");
    await db.execute(
        "Create table passwords(id integer primary key ,name text,username text,password text,userid int)");
    await db.execute(
        "Create table securenote(id integer primary key ,name text,noteText text,userid int)");
    await db.execute(
        "Create table creditcard(id integer primary key ,name text,cardHolderName text,userid int,cardNumber text,cvvCode text,expiryDate text)");
  }

  Future login(String username, String password) async {
    Database db = await this.db;

    var result = await db.rawQuery(
        'SELECT * FROM user WHERE username=? and password=?',
        [username, password]);
    if (result.length != 0) {
      return result;
    } else {
      return result;
    }
  }

  Future register(User user) async {
    Database db = await this.db;
    var result = db.rawInsert(
        'INSERT or IGNORE INTO user(username, password) VALUES(?, ?)',
        [user.username, user.password]);

    return result;
  }

  Future<List> getPasswords(int id) async {
    Database db = await this.db;
    var result =
        await db.rawQuery('SELECT * FROM passwords WHERE userid=?', [id]);
    return result;
  }

  Future<List> getSecureNotes(int id) async {
    Database db = await this.db;

    var result =
        await db.rawQuery('SELECT * FROM securenote WHERE userid=?', [id]);
    return result;
  }

  Future<List> getCreditCards(int id) async {
    Database db = await this.db;

    var result =
        await db.rawQuery('SELECT * FROM creditcard WHERE userid=?', [id]);
    return result;
  }

  Future<List> getAllData(int id) async {
    var result1 = await getSecureNotes(id);
    var result2 = await getPasswords(id);
    var result3 = await getCreditCards(id);
    List data = [];
    for (int i = 0; i < result1.length; i++) {
      data.add(SecureNote.fromObject(result1[i]));
    }
    for (int i = 0; i < result2.length; i++) {
      data.add(Password.fromObject(result2[i]));
    }
    for (int i = 0; i < result3.length; i++) {
      data.add(CreditCard.fromObject(result3[i]));
    }

    return data;
  }

  Future<int> insertData(String tableName,
      {Password password, SecureNote secureNote, CreditCard creditCard}) async {
    if (tableName == "passwords") {
      Database db = await this.db;
      var result = await db.insert("passwords", password.toMap());
    }
    if (tableName == "securenote") {
      Database db = await this.db;
      var result = await db.insert("securenote", secureNote.toMap());
    }
    if (tableName == "creditcard") {
      Database db = await this.db;
      var result = await db.insert("creditcard", creditCard.toMap());
    }
  }

  Future<int> updateData(String tableName,
      {Password password, SecureNote secureNote, CreditCard creditCard}) async {
    Database db = await this.db;
    if (tableName == "passwords") {
      var result = await db.update("passwords", password.toMap(),
          where: "id=?", whereArgs: [password.id]);
      return result;
    }
    if (tableName == "securenote") {
      var result = await db.update("securenote", secureNote.toMap(),
          where: "id=?", whereArgs: [secureNote.id]);
      return result;
    }
    if (tableName == "creditcard") {
      var result = await db.update("creditcard", creditCard.toMap(),
          where: "id=?", whereArgs: [creditCard.id]);
      return result;
    }
  }

  Future<int> updatePassword(Password password) async {
    Database db = await this.db;
    print("update pass alani");
    print(password.id);
    var result = await db.update("passwords", password.toMap(),
        where: "id=?", whereArgs: [password.id]);
    return result;
  }

  Future<int> updateSecureNote(SecureNote secureNote) async {
    Database db = await this.db;
    var result = await db.update("securenote", secureNote.toMap(),
        where: "id=?", whereArgs: [secureNote.id]);
    return result;
  }

  Future<int> delete(int id, String tableName) async {
    Database db = await this.db;
    var result = await db.rawDelete(
      "delete from " + tableName + " where id= $id",
    );
    return result;
  }

  Future<int> deleteAll() async {
    Database db = await this.db;
    await db.execute("DELETE  FROM passwords");
  }
}
