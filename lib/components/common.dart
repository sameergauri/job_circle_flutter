import 'package:flutter/material.dart';

class UserTextFormField {
  static Widget textBox(TextEditingController _controller, String label,
      String _hintText, IconData icons, String validationText, bool validate) {
    return TextFormField(
      validator: (value) {
        return ((value!.isEmpty && validate) ? validationText : null);
      },
      decoration: InputDecoration(
        icon: Icon(icons),
        label: Text(label),
        //border: OutlineInputBorder(),
        border: InputBorder.none,
        hintText: _hintText,
      ),
      controller: _controller,
    );
  }
}
