import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pratik/data/dbHelper.dart';
import 'package:pratik/models/secureNote.dart';

class SecureNoteForm extends StatefulWidget {
  var noteTextController = TextEditingController();
  var nameController = TextEditingController();
  int edit = 0;
  int userid = 0;
  SecureNote tempSecureNote;
  SecureNoteForm(this.edit, this.userid);
  SecureNoteForm.withData(this.edit, this.tempSecureNote);
  SecureNoteForm.edit(edit, tempSecureNote) {
    this.edit = edit;
    this.tempSecureNote = tempSecureNote;
    nameController.text = tempSecureNote.name;
    noteTextController.text = tempSecureNote.noteText;
  }

  @override
  State<StatefulWidget> createState() {
    return SecureNoteFormState();
  }
}

class SecureNoteFormState extends State<SecureNoteForm> {
  var dbHelper = DbHelper();

  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    if (widget.edit == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add Note"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              child: Text("Save"),
              onPressed: () {
                saveNoteForm();
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
              noteTextArea(widget.edit),
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
              noteTextArea(widget.edit),
            ],
          ),
        ),
      );
    }
    if (widget.edit == 2) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Edit "),
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  saveEditData();
                })
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(12.0),
          child: Column(
            children: [
              nameArea(widget.edit),
              SizedBox(height: 10),
              noteTextArea(widget.edit),
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
            hintText: "Note Name:"),
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
            labelText: widget.tempSecureNote.name),
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

  noteTextArea(int edit) {
    if (edit == 0) {
      return TextField(
        minLines: 6,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: widget.noteTextController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: "Note:"),
      );
    }
    if (edit == 1) {
      return TextField(
        minLines: 6,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        enabled: false,
        controller: TextEditingController(text: widget.tempSecureNote.noteText),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      );
    }
    if (edit == 2) {
      return TextField(
        minLines: 6,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: widget.noteTextController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            labelText: "Note:"),
      );
    }
  }

  void saveNoteForm() async {
    var result = await dbHelper.insertData("securenote",
        secureNote: SecureNote(
            userid: widget.userid,
            name: widget.nameController.text,
            noteText: widget.noteTextController.text));
    Navigator.pop(context, true);
  }

  saveEditData() async {
    var result = await dbHelper.updateData("securenote",
        secureNote: SecureNote.withId(
            id: widget.tempSecureNote.id,
            name: widget.nameController.text,
            noteText: widget.noteTextController.text));
    Navigator.pop(context, true);
  }

  void goEditForm() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SecureNoteForm.edit(2, widget.tempSecureNote)));
    if (result != null) {
      if (result) {
        Navigator.pop(context, true);
      }
    }
  }
}
