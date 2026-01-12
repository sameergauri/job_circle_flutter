//ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';

import '../../model/user_profile/user_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProfileModel data;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomAppBar({super.key, required this.data});

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 25,
      titleSpacing: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 0, left: 16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 24,
          child: TextField(
            style: GoogleFonts.merriweather(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusColor: Colors.grey.shade400,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              filled: true,
              contentPadding: const EdgeInsets.only(left: 5, top: 10),
              hintText:
                  "${capitalizeFirstLetter(data.firstName)} ${capitalizeFirstLetter(data.lastName)}",
              hintStyle: GoogleFonts.merriweather(
                color: Constants.subtitleclr,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            CustomSnackbar.show(
              "The functionality is not implemented yet",
              true,
            );
          },
          icon: const Icon(Icons.settings, color: Colors.black),
        ),
      ],
      /* actions: [  // TODO:: Resume Builder Integration
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResumeTemplateSelectionScreen(
                  userProfileJson: data.toJson(),
                  geminiApiKey:
                      'AIzaSyAnhaXULIUPpgeewuV7_bFZBhZBPL1PLBc', // null = skip AI polishing
                  onPdfGenerated: (Uint8List pdfBytes) {
                    // Your custom save logic here
                    // e.g., save to gallery, upload to server, share, etc.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Resume saved successfully!'),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.build),
        ),
      ], */
    );
  }
}
