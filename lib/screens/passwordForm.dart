import 'package:flutter/material.dart';
import 'package:pratik/data/dbHelper.dart';
import 'package:pratik/models/password.dart';

class PasswordForm extends StatefulWidget {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();

  int edit = 0;
  int userid = 0;
  Password tempPassword = Password();
  PasswordForm(this.edit, this.userid);
  PasswordForm.withData(this.edit, this.tempPassword);
  PasswordForm.edit(edit, tempPassword) {
    this.edit = edit;
    this.tempPassword = tempPassword;
    usernameController.text = tempPassword.username;
    nameController.text = tempPassword.name;
    passwordController.text = tempPassword.password;
  }
  @override
  State<StatefulWidget> createState() {
    return PasswordFormState();
  }
}

class PasswordFormState extends State<PasswordForm> {
  var dbHelper = DbHelper();

  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    if (widget.edit == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add Password"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              child: Text("Save"),
              onPressed: () {
                addPassword();
              },
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(12.0),
          child: Column(
            children: [
              nameArea(widget.edit),
              SizedBox(height: 10),
              usernameArea(widget.edit),
              SizedBox(height: 10),
              passwordArea(widget.edit),
            ],
          ),
        ),
      );
    }
    if (widget.edit == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text("View Form"),
          actions: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  goEditForm();
                })
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(12.0),
          child: Column(
            children: [
              nameArea(widget.edit),
              SizedBox(height: 10),
              usernameArea(widget.edit),
              SizedBox(height: 10),
              passwordArea(widget.edit),
            ],
          ),
        ),
      );
    }
    if (widget.edit == 2) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Edit "),
        ),
        body: Container(
          margin: EdgeInsets.all(12.0),
          child: Column(
            children: [
              nameArea(widget.edit),
              SizedBox(height: 10),
              usernameArea(widget.edit),
              SizedBox(height: 10),
              passwordArea(widget.edit),
              editButton()
            ],
          ),
        ),
      );
    }
  }

  nameArea(int edit) {
    if (edit == 0) {
      return TextField(
        controller: widget.nameController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: "Enter Name"),
      );
    }
    if (edit == 1) {
      return TextField(
        enabled: false,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: widget.tempPassword.name),
      );
    }
    if (edit == 2) {
      return TextField(
        controller: widget.nameController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: "Name"),
      );
    }
  }

  passwordArea(int edit) {
    if (edit == 0) {
      return TextField(
          obscureText: hidePassword,
          controller: widget.passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: "Enter password",
            suffix: InkWell(
              onTap: () {
                _togglePasswordView();
              },
              child: Icon(Icons.remove_red_eye_outlined),
            ),
          ));
    }
    if (edit == 1) {
      return TextField(
        enabled: false,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: widget.tempPassword.password),
      );
    }
    if (edit == 2) {
      return TextField(
        controller: widget.passwordController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: "Password"),
      );
    }
  }

  usernameArea(int edit) {
    if (edit == 0) {
      return TextField(
        controller: widget.usernameController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: "Enter username"),
      );
    }
    if (edit == 1) {
      return TextField(
        enabled: false,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: widget.tempPassword.username),
      );
    }
    if (edit == 2) {
      return TextField(
        controller: widget.usernameController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: "Username"),
      );
    }
  }

  _togglePasswordView() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  addPassword() async {
    var result = await dbHelper.insertData("passwords",
        password: Password(
            userid: widget.userid,
            name: widget.nameController.text,
            username: widget.usernameController.text,
            password: widget.passwordController.text));
    Navigator.pop(context, true);
  }

  saveButton() {
    return TextButton(
      child: Text("Save"),
      onPressed: () {
        addPassword();
      },
    );
  }

  void goEditForm() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordForm.edit(2, widget.tempPassword)));
    if (result != null) {
      if (result) {
        Navigator.pop(context, true);
      }
    }
  }

  editButton() {
    return TextButton(
      child: Text("Edit"),
      onPressed: () {
        saveEditData();
      },
    );
  }

  void saveEditData() async {
    var result1 = await dbHelper.updateData("passwords",
        password: Password.withId(
            id: widget.tempPassword.id,
            name: widget.nameController.text,
            username: widget.usernameController.text,
            password: widget.passwordController.text));
    Navigator.pop(context, true);
  }
}
