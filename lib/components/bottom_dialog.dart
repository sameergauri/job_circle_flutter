import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomDialog {
  void showBottomDialog(BuildContext context, Widget widget, bool dismissable,
      {bool? enableDrag = false, BottomSheetController? controller}) {
    showModalBottomSheet(
      // barrierLabel: "showGeneralDialog",
      // barrierDismissible: dismissable,
      isDismissible: dismissable,
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      enableDrag: enableDrag ?? false,
      // transitionDuration: const Duration(milliseconds: 400),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
             SystemNavigator.pop();

            // Return true to allow dismissal, false to prevent it
            return false;
          },
          child: StatefulBuilder(builder: (BuildContext context, setState) {
            if (controller != null) controller.setState = setState;
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(child: widget),
            );
          }),
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

class BottomSheetController {
  late void Function(void Function()) setState;
}
