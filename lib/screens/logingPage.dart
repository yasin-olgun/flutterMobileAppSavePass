import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pratik/data/dbHelper.dart';
import 'package:pratik/main.dart';
import 'package:pratik/models/user.dart';
import 'package:pratik/screens/registerPage.dart';

class LoginPage extends StatefulWidget {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  User tempUser = User("", "", -1);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  var dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            "SavePass...",
            style: GoogleFonts.architectsDaughter(fontSize: 55),
          ),
        ),
        toolbarHeight: 250,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: [
              userNameArea(),
              SizedBox(
                height: 10,
              ),
              passwordArea(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                  ),
                  loginButton(),
                  registerButton()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  userNameArea() {
    return TextField(
      controller: widget.userNameController,
      decoration: InputDecoration(
          filled: false,
          fillColor: Colors.red.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Username"),
    );
  }

  passwordArea() {
    return TextField(
      controller: widget.passwordController,
      obscureText: true,
      decoration: InputDecoration(
          filled: false,
          fillColor: Colors.red.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Password"),
    );
  }

  loginButton() {
    return TextButton(
        onPressed: () async {
          var username = widget.userNameController.text;
          var password = widget.passwordController.text;
          var result = await dbHelper.login(username, password);
          if (result.length == 1) {
            widget.tempUser.id = result[0]['id'];
            widget.tempUser.username = result[0]['username'];
            widget.tempUser.password = result[0]['password'];

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateHome(
                          state: 0,
                          tempUser: widget.tempUser,
                        )));
          } else {}
        },
        child: Text("Login"));
  }

  registerButton() {
    return TextButton(
        onPressed: () async {
          bool result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        child: Text("Register"));
  }
}
