import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class CustomButtonForJobPosting extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const CustomButtonForJobPosting({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: Constants.themeBgColor, // Replace with your Constants.blue
          borderRadius: BorderRadius.circular(8.r),
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: GoogleFonts.varela(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomToggleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelect;

  const CustomToggleButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelect = false, // Default value for isSelect
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
        margin: EdgeInsets.only(top: 5, bottom: 5, right: 10.w),
        decoration: BoxDecoration(
          color: isSelect ? Constants.borderColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelect
                ? Constants.borderColor
                : const Color.fromARGB(255, 200, 194, 193),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.sourceSansPro(
              fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
              color: Constants.black,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
