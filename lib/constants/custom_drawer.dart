// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/themes/colors.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose;
  // Callback to close drawer

  const CustomDrawer({
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Set width of the drawer
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 10),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 150,
            color: Constants.borderColor,
            padding: const EdgeInsets.only(
                top: kTextTabBarHeight,
                left: kTextTabBarHeight / 2,
                bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserProfile()));
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.bgColorWhite,
                    child: Icon(Icons.person_outline_rounded,
                        size: 40, color: Constants.darkBlue),
                  ),
                ),
                const SizedBox(height: 10),
                customTextForWeather(
                  title: "Name",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                customTextForWeather(title: "Location", fontSize: 14),
              ],
            ),
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: const Icon(Icons.home_outlined),
            title: const customText(
                title: 'Home', fontSize: 12, fontWeight: FontWeight.normal),
            onTap: () {
              onClose();
            },
          ),
          ListTile(
            dense: true,
            minLeadingWidth: 0.0,
            minVerticalPadding: 5.1,
            leading: const Icon(Icons.logout_outlined),
            title: const customText(
                title: 'LogOut', fontSize: 12, fontWeight: FontWeight.normal),
            onTap: () {
              onClose();
            },
          ),
        ],
      ),
    );
  }
}
