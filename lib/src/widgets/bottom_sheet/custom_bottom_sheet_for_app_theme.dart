// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/app_theme_provider.dart/app_theme_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet {
  /// **🔥 Show Bottom Sheet**
  static Future<dynamic> showCustomBottomSheetForAppTheme({
    required BuildContext context,
  }) {
    final themeProvider = context.read<ThemeProvider>();
    final colors = context.appColors;
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: colors.appbarColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                future: null, // Ek baar hi load hoga
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: customText(
                          title: "Select Theme Type",
                          fontSize: 16,
                          color: Constants.darkBlue,
                        ),
                      ),
                      SizedBox(height: 10),
                      Material(
                        color: Colors.transparent,
                        child: RadioListTile<ThemeMode>(
                          title: const Text("Light Mode"),
                          value: ThemeMode.light,
                          groupValue: themeProvider.themeMode,
                          onChanged: (mode) => themeProvider.setTheme(mode!),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: RadioListTile<ThemeMode>(
                          title: const Text("Dark Mode"),
                          value: ThemeMode.dark,
                          groupValue: themeProvider.themeMode,
                          onChanged: (mode) => themeProvider.setTheme(mode!),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: RadioListTile<ThemeMode>(
                          title: const Text("System Default"),
                          value: ThemeMode.system,
                          groupValue: themeProvider.themeMode,
                          onChanged: (mode) => themeProvider.setTheme(mode!),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
