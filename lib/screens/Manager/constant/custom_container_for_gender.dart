import 'package:flutter/material.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomContainerForGender extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelect;
  final String title;

  const CustomContainerForGender({
    super.key,
    required this.onPressed,
    required this.isSelect,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        height: MediaQuery.of(context).size.height / 22,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelect ? Constants.borderColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelect ? Constants.borderColor : Constants.subtitleclr,
          ),
        ),
        child: Center(
          child: customTextForWeather(
            title: title,
            fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
            color: isSelect ? Constants.black : Colors.black,
          ),
        ),
      ),
    );
  }
}
