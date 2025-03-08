import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';

class CustomContainerSelectToViewDoc extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const CustomContainerSelectToViewDoc({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 7),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 2.1,
              spreadRadius: 2.1,
              offset: const Offset(1.0, 2.0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(
                "assets/images/documentStatus.png",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextForWeather(title: title),
                customTextForWeather(
                  title:
                      DateFormat("MMM d, yyyy, h:mm a").format(DateTime.now()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
