import 'package:flutter/material.dart';

class CustomComponent {
  static Widget labelText(icon, text, color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        // Text(
        //   label,
        //   style: TextStyle(color: color),
        // ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
