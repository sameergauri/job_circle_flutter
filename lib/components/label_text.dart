import 'package:flutter/material.dart';

class CustomComponent {
  static Widget labelText(label, text, color) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: color),
        ),
        SizedBox(
          width: label != "" ? 10 : 0,
        ),
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
