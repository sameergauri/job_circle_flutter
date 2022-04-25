import 'package:flutter/material.dart';

class BottomDialog {
  void showBottomDialog(BuildContext context, Widget widget, bool disposable) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: disposable,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: widget,
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
