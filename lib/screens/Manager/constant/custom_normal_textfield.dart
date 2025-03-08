import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';


class CustomNormalTextfield extends StatelessWidget {
  final String hint;
  final FocusNode focusNode;
  final bool? isPrimaryNumber;
  final int? maxLength;
  final int? maxline;
  final bool isNumber;
  final bool? keyboardType;
  final bool? isDisabled;
  final bool? isOptional;
  final TextEditingController controller;

  const CustomNormalTextfield({
    super.key,
    required this.hint,
    required this.focusNode,
    this.isPrimaryNumber = false,
    this.maxLength,
    this.maxline,
    this.isNumber = false,
    this.keyboardType,
    this.isDisabled = true,
    this.isOptional = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxline != null
          ? double.maxFinite
          : MediaQuery.of(context).size.height / 30,
      child: TextFormField(
        maxLines: maxline ?? 1,
        enabled: isDisabled!,
        focusNode: focusNode,
        inputFormatters: isNumber
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ]
            : <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
        maxLength: maxLength,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
        textCapitalization: TextCapitalization.sentences,
        controller: controller.text != "0" ? controller : null,
        onTap: () {},
        style: GoogleFonts.varela(color: Constants.black, fontSize: 14.sp),
        decoration: InputDecoration(
          filled: isPrimaryNumber! ? true : false,
          fillColor:
              isPrimaryNumber! ? Constants.lightdull : Colors.transparent,
          contentPadding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xffff0eceb)),
          ),
          focusColor: const Color(0xffff0eceb),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Constants.black,
            ),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.sourceSansPro(
              color: Constants.hintColor, fontSize: 14.sp),
        ),
      ),
    );
  }
}
