import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

// ignore: must_be_immutable
class CustomDocumentUploadButton extends StatefulWidget {
  final Function onTab;
  final String title;
  final String? subTitle;
  const CustomDocumentUploadButton(
      {super.key, required this.onTab, required this.title, this.subTitle});

  @override
  State<CustomDocumentUploadButton> createState() =>
      _CustomDocumentUploadButtonState();
}

class _CustomDocumentUploadButtonState
    extends State<CustomDocumentUploadButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTab();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DottedBorder(
            options: RectDottedBorderOptions(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              strokeWidth: 1,
              dashPattern: const [4, 4],
              color: Constants.subtitleclr,
            ),
            child: Center(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(1, 1),
                            blurStyle: BlurStyle.outer,
                            color: Colors.grey.shade400,
                            blurRadius: 2.1)
                      ]),
                  child: customTextForWeather(
                    title: widget.title,
                    color: Constants.darkBlue,
                  ),
                ),
                customTextForWeather(
                  title: widget.subTitle ?? "Supported formate : PDF",
                  fontSize: 10.sp,
                  color: Constants.subtitleclr,
                  fontStyle: FontStyle.italic,
                ),
                SizedBox(
                  height: 6.h,
                )
              ],
            ))),
      ),
    );
  }
}
