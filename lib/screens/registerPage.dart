import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pratik/data/dbHelper.dart';
import 'package:pratik/main.dart';
import 'package:pratik/models/user.dart';

class RegisterPage extends StatefulWidget {
  var userNameController = TextEditingController();
  var passwordController1 = TextEditingController();
  var passwordController2 = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  var dbHelper = DbHelper();
  User tempUser = User("", "", 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Center(
          child: Text(
            "Register...",
            style: GoogleFonts.architectsDaughter(fontSize: 55),
          ),
        ),
        toolbarHeight: 200,
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
              passwordArea(widget.passwordController1),
              SizedBox(
                height: 10,
              ),
              passwordArea(widget.passwordController2),
              SizedBox(height: 10),
              registerButton(),
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

  passwordArea(TextEditingController controller) {
    return TextField(
      controller: controller,
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

  registerButton() {
    return TextButton(
        onPressed: () async {
          if (widget.passwordController1.text !=
              widget.passwordController2.text) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Password does not match!'),
              duration: const Duration(seconds: 2),
            ));
          } else {
            tempUser.username = widget.userNameController.text;
            tempUser.password = widget.passwordController1.text;
            var result = await dbHelper.register(tempUser);
            if (result.toString() != "0") {
              Navigator.pop(context, true);
            }
          }
        },
        child: Text("Register"));
  }
}
