// ignore_for_file: must_be_immutable, unused_local_variable, library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:timelines/timelines.dart';

class CustomTimeline extends StatelessWidget {
  final List<String> keyResponsible;
  double size;

  CustomTimeline({super.key, required this.keyResponsible, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      // margin: const EdgeInsets.only(top: 8),
      child: Timeline.tileBuilder(
        physics: const NeverScrollableScrollPhysics(),
        theme: TimelineTheme.of(context).copyWith(
          direction: Axis.vertical,
          nodeItemOverlap: false,
          nodePosition: 0,
          indicatorTheme: const IndicatorThemeData(size: 10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        builder: TimelineTileBuilder.connected(
          indicatorBuilder: (context, index) => const DotIndicator(),
          connectorBuilder: (_, index, type) => const SolidLineConnector(),
          itemCount: keyResponsible.length,
          contentsBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 2),
              child: Text(
                keyResponsible[index],
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Constants.themeBgColor,
      ),
    );
  }
}

class SolidLineConnector extends StatelessWidget {
  const SolidLineConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 2,
      color: Constants.themeBgColor,
    );
  }
}

class RestrictedButton extends StatefulWidget {
  // String title;
  VoidCallback onTap;
  bool isChat;
  RestrictedButton({super.key, required this.onTap, required this.isChat});

  @override
  _RestrictedButtonState createState() => _RestrictedButtonState();
}

class _RestrictedButtonState extends State<RestrictedButton> {
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Initialize the notification plugin

    // Set the allowed time and day ranges
    const allowedStartTime = TimeOfDay(hour: 9, minute: 0);
    const allowedEndTime = TimeOfDay(hour: 19, minute: 0);
    final allowedDays = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday
    ];

    // Check if the current time and day are within the allowed ranges
    final currentTime = TimeOfDay.now();
    final currentDateTime = DateTime.now();
    final startDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      allowedStartTime.hour,
      allowedStartTime.minute,
    );
    final endDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      allowedEndTime.hour,
      allowedEndTime.minute,
    );
    final isTimeAllowed = currentDateTime.isAfter(startDateTime) &&
        currentDateTime.isBefore(endDateTime);
    final isDayAllowed = allowedDays.contains(currentDateTime.weekday);

    // Determine if the button should be enabled or disabled based on the restrictions
    setState(() {
      isButtonEnabled = isTimeAllowed && isDayAllowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isButtonEnabled
          ? widget.onTap
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    elevation: 1.0,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 5),
                    backgroundColor: Constants.borderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    // margin: const EdgeInsets.all(5),
                    content: customTextForWeather(
                      title:
                          'Recruiter are available on Monday to Saturday between 9:00 AM to 7:00 PM.',
                      color: Constants.subtitleclr,
                    )),
              );
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Constants.subtitleclr)),
        child: widget.isChat
            ? Row(
                children: [
                  Image.asset(
                    "assets/images/whatsapp.png",
                    height: 14.h,
                    color: Colors.greenAccent[400],
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const customTextForWeather(
                    title: "Chat",
                    fontWeight: FontWeight.bold,
                  )
                ],
              )
            : const Row(
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 14,
                    color: Constants.darkBlue,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  customTextForWeather(
                      title: "Call ", fontWeight: FontWeight.bold)
                ],
              ),
      ),
    );
  }

  void _handleButtonPress(BuildContext context) {}

  void _handleButtonPress1(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Allow')),
    );
  }
}
