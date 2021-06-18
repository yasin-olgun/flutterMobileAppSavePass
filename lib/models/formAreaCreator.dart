import 'package:flutter/material.dart';

class FormAreaCreator {
  createNameArea(
      {int edit,
      String hintText,
      TextEditingController controller,
      String labelText,
      int maxLines,
      int minLines}) {
    if (edit == 0) {
      return TextField(
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: hintText),
      );
    }
  }
}
