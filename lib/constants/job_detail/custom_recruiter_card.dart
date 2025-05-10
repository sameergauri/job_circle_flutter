import 'package:flutter/material.dart';
import 'package:job_circle/components/custom_call_sms_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecruiterDetailsCard extends StatelessWidget {
  final String title;
  final String recruiterName;
  final String designation;
  final String location;
  final String email;
  final int contactNumber;

  const RecruiterDetailsCard({
    super.key,
    required this.title,
    required this.recruiterName,
    required this.designation,
    required this.location,
    required this.contactNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextForWeather(
            title: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.bgColorWhite,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Constants.lightdull,
                  blurRadius: 8,
                  spreadRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Constants.borderColor,
                    child: Icon(
                      Icons.person,
                      color: Constants.darkBlue,
                      size: 30,
                    ),
                  ),
                  title: Row(
                    children: [
                      customTextForWeather(
                        title: recruiterName,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.verified,
                        color: Constants.darkBlue,
                        size: 14,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextForWeather(
                        title: designation,
                        color: Constants.subtitleclr,
                      ),
                      customTextForWeather(
                        title: location,
                        color: Constants.subtitleclr,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomcallsmsButton(
                      color: Constants.darkBlue,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/128/16866/16866136.png",
                      label: "Email",
                      onTap: () async {
                        final whatsappUrl = "mailto:$contactNumber";
                        await launchUrl(Uri.parse(whatsappUrl));
                      },
                    ),
                    const SizedBox(width: 15),
                    CustomcallsmsButton(
                      color: Constants.darkBlue,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/128/9821/9821767.png",
                      label: "Call",
                      onTap: () async {
                        launchUrlString("tel://$contactNumber");
                      },
                    ),
                    const SizedBox(width: 15),
                    CustomcallsmsButton(
                      color: Constants.darkgreen,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/128/6422/6422213.png",
                      label: "Whatsapp",
                      onTap: () async {
                        final whatsappUrl =
                            "whatsapp://send?phone=$contactNumber";
                        await launchUrl(Uri.parse(whatsappUrl));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
