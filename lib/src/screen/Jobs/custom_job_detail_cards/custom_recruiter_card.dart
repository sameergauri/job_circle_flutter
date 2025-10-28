import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/button/custom_call_sms_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruiterDetailsCard extends StatelessWidget {
  final String title;
  final String recruiterName;
  final String designation;
  final String location;
  final String email;
  final String profilepic;
  final int contactNumber;

  const RecruiterDetailsCard({
    super.key,
    required this.title,
    required this.recruiterName,
    required this.designation,
    required this.location,
    required this.contactNumber,
    required this.email,
    required this.profilepic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(title: title, fontSize: 14, fontWeight: FontWeight.w700),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.white,
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
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.white,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Constants.lightdull,
                      backgroundImage: profilepic != " "
                          ? NetworkImage(
                              "${GlobalConstants.Image_url}$profilepic",
                            )
                          : const NetworkImage(CustomIconUrl.usericon)
                                as ImageProvider,
                    ),
                  ),
                  title: Row(
                    children: [
                      customText(
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
                      customText(
                        title: designation,
                        color: Constants.subtitleclr,
                      ),
                      if (location.isNotEmpty && location != "null")
                        customText(
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
                        final whatsappUrl = "mailto:$email";
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
                        FlutterPhoneDirectCaller.callNumber(
                          contactNumber.toString(),
                        );
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
                            "whatsapp://send?phone=91$contactNumber";
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
