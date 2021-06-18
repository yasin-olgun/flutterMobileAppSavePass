import 'package:flutter/material.dart';
import 'package:pratik/data/dbHelper.dart';
import 'package:pratik/models/user.dart';
import 'package:pratik/screens/creditCardNewForm.dart';
import 'package:pratik/screens/logingPage.dart';
import 'package:pratik/screens/passwordForm.dart';
import 'package:pratik/screens/secureNoteForm.dart';

import 'models/password.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: CreateHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CreateHome extends StatefulWidget {
  int state = 1;
  User tempUser = User("", "", -1);
  CreateHome({this.state, this.tempUser});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _createHomeState();
  }
}

class _createHomeState extends State<CreateHome> {
  var dbHelper = DbHelper();
  List<Password> passwords = [];
  List allData = [];

  int count = 0;

  @override
  void initState() {
    if (widget.state == 0) {
      getAllData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return createBody();
    if (widget.state == 0) {
      return createBody();
    } else {
      return LoginPage();
    }
  }

  Widget createBody() {
    return Scaffold(
      appBar: AppBar(
        title: Text("SavePass..."),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(allData[index].name),
                      leading: allData[index].icon,
                      //title: Text(    passwords[index].username + passwords[index].id.toString()),
                      onTap: () {
                        miniScreen(index);
                      });
                }),
            //child: createBody()
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFEEAE6),
          foregroundColor: Color(0xFF442B2D),
          child: Icon(Icons.add),
          onPressed: () {
            // goToPasswordAdd();
            formButtons();
          }),
    );
  }

  miniScreen(index) {
    return showModalBottomSheet<void>(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: const Color(0xFF8ecae6),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                Text(
                  allData[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ListTile(
                  title: Text("View Form"),
                  onTap: () {
                    goViewForm(allData[index].tableName, index);
                  },
                  leading: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text("Edit Data"),
                  onTap: () {
                    editItem(allData[index].tableName, allData[index]);
                  },
                  leading: Icon(Icons.edit),
                ),
                ListTile(
                  title: Text("Delete Item"),
                  onTap: () {
                    deleteItem(allData[index].tableName, allData[index].id);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.delete),
                ),
              ],
            ),
          );
        });
  }

  void getAllData() {
    var data = dbHelper.getAllData(widget.tempUser.id);
    data.then((value) {
      this.allData = value;

      setState(() {
        count = value.length;
      });
    });
  }

  void deleteItem(String tableName, int id) {
    print(id);
    dbHelper.delete(id, tableName);
    initState();
  }

  void deleteAll() {
    dbHelper.deleteAll();
  }

  formButtons() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              ListTile(
                title: Text("Password"),
                subtitle: Text("Hide your accounts username and password"),
                leading: Icon(Icons.lock),
                onTap: () {
                  Navigator.pop(context);
                  goToPasswordAdd();
                },
              ),
              ListTile(
                title: Text("Secure Note"),
                subtitle: Text("Keep notes safely"),
                leading: Icon(Icons.note_add),
                onTap: () {
                  Navigator.pop(context);
                  goToSecureNoteAdd();
                },
              ),
              ListTile(
                title: Text("Payment Card"),
                subtitle: Text("Hide card information"),
                leading: Icon(Icons.credit_card),
                onTap: () {
                  Navigator.pop(context);
                  goToCreditCard();
                },
              ),
              ListTile(
                title: Text("Wi-Fi password"),
                subtitle: Text(""),
                leading: Icon(Icons.wifi),
                onTap: () {
                  Navigator.pop(context);
                  goToCreditCard();
                },
              ),
              ListTile(
                title: Text("Adress Information"),
                subtitle: Text(""),
                leading: Icon(Icons.account_balance),
                onTap: () {
                  Navigator.pop(context);
                  goToPasswordAdd();
                },
              ),
            ],
          );
        });
  }

  void goToSecureNoteAdd() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SecureNoteForm(0, widget.tempUser.id)));
    if (result != null) {
      if (result) {
        setState(() {
          getAllData();
        });
      }
    }
  }

  void goToPasswordAdd() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordForm(0, widget.tempUser.id)));
    if (result != null) {
      if (result) {
        setState(() {
          //getPasswords();
          getAllData();
        });
      }
    }
  }

  void goViewForm(String tableName, int index) async {
    if (tableName == "passwords") {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PasswordForm.withData(1, allData[index])));
      if (result != null) {
        if (result) {
          setState(() {
            getAllData();
          });
        }
      }
    }
    if (tableName == "securenote") {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SecureNoteForm.withData(1, allData[index])));
      if (result != null) {
        if (result) {
          setState(() {
            getAllData();
          });
        }
      }
    }
    if (tableName == "creditcard") {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreditCardFormNew.withData(1, allData[index])));
      if (result != null) {
        if (result) {
          setState(() {
            getAllData();
          });
        }
      }
    }
  }

  void editItem(tableName, allData) async {
    if (tableName == "passwords") {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PasswordForm.edit(2, allData)));
      if (result != null) {
        if (result) {
          setState(() {
            getAllData();
          });
        }
      }
    }
    if (tableName == "securenote") {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecureNoteForm.edit(2, allData)));
      if (result != null) {
        if (result) {
          setState(() {
            getAllData();
          });
        }
      }
    }
    if (tableName == "creditcard") {
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreditCardFormNew.edit(2, allData)));
      if (result != null) {
        if (result) {
          setState(() {
            getAllData();
          });
        }
      }
    }
  }

  void goToCreditCard() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreditCardFormNew(0, widget.tempUser.id)));
    if (result != null) {
      if (result) {
        setState(() {
          getAllData();
        });
      }
    }
  }
}
