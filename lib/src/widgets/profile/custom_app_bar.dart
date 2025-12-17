import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/Resume_builder/templete_selection_screen.dart';
import 'package:job_circle/src/Resume_builder/ui/resume_builder_screen.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';

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
      titleSpacing: 10,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 4, left: 6),
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
          onPressed: () {
            NavigationService.push(TemplateSelectionScreen(userProfile: data));
          },
          icon: const Icon(Icons.build),
        ),
      ],
    );
  }
}
