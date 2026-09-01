import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/button/custom_call_sms_button.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruiterDetailsCard extends StatelessWidget {
  final String title;
  final String recruiterName;
  final String designation;
  final String location;
  final String email;
  final String profilepic;
  final int contactNumber;
  final String jobTitle;

  const RecruiterDetailsCard({
    super.key,
    required this.title,
    required this.recruiterName,
    required this.designation,
    required this.location,
    required this.contactNumber,
    required this.email,
    required this.profilepic,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
              color: colors.recruiterCardBgColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow:  [
                BoxShadow(
                  color: colors.shadowColor!,
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
                        color: colors.headingColor,
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
                        color: colors.jobdetailGreyColor,
                      ),
                      if (location.isNotEmpty && location != "null")
                        customText(
                          title: location,
                          color: colors.jobdetailGreyColor,
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomcallsmsButton(
                      color: colors.mailCallIconColor!,
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
                      color: colors.mailCallIconColor!,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/128/9821/9821767.png",
                      label: "Call",
                      onTap: () => _handleCallPermission(context),
                    ),
                    const SizedBox(width: 15),
                    CustomcallsmsButton(
                      color: colors.chatIconColor!,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/128/9821/9821763.png",
                      label: "Chat",
                      onTap: () async {
                         final whatsappUrl =
                            "whatsapp://send?phone=91$contactNumber";
                        await launchUrl(Uri.parse(whatsappUrl));
                       /*  ChatUtils.startChatWithRecruiter(
                          context: context,
                          recruiterId: contactNumber
                              .toString()
                              .toString(), // Ensure String
                          recruiterName: recruiterName,
                          jobTitle: jobTitle, // Optional
                        ); */
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

  Future<void> _handleCallPermission(BuildContext context) async {
    final status = await Permission.phone.status;

    if (status.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(contactNumber.toString());
      return;
    }

    if (status.isPermanentlyDenied) {
      // System dialog won't appear — show our dialog with settings option
      if (context.mounted) _showCallPermissionDialog(context);
      return;
    }

    // Status is denied/undetermined — show system dialog only, never our custom dialog here
    final result = await Permission.phone.request();
    if (!context.mounted) return;

    if (result.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(contactNumber.toString());
    }
    // Any denial from system dialog → do nothing; next tap will show our custom dialog
  }

  void _showCallPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E1E2E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Constants.darkBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_rounded,
                      color: Constants.darkBlue,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Phone Permission Required",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Constants.darkBlue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Constants.darkBlue.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Phone permission has been permanently denied. Please enable it from app settings to make direct calls.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey.shade700,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            await openAppSettings();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.darkBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Open Settings",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
