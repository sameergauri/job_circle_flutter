import 'package:flutter/material.dart';

class BottomDialog {
  void showBottomDialog(BuildContext context, Widget widget, bool dismissable) {
    showModalBottomSheet(
      // barrierLabel: "showGeneralDialog",
      // barrierDismissible: dismissable,
      isDismissible: dismissable,
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      enableDrag: false,
      // transitionDuration: const Duration(milliseconds: 400),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(child: widget),
        );
      },
      // tra: (_, animation1, __, child) {
      //   return SlideTransition(
      //     position: Tween(
      //       begin: const Offset(0, 1),
      //       end: const Offset(0, 0),
      //     ).animate(animation1),
      //     child: child,
      //   );
      // },
    );
  }
}
