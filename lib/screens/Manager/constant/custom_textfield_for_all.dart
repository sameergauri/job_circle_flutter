import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomTextFieldforAll extends StatelessWidget {
  final String hint;
  final FocusNode focusNode;
  final bool? isGmail;
  final bool isPrimaryNumber;
  final int? maxLength;
  final bool isNumber;
  final bool? keyboardType;
  final bool isDisabled;
  final int? maxline;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final Function(PointerDownEvent)? onTabOutside;
  final Function(String)? onFieldSubmitted;
  final TextEditingController controller;

  const CustomTextFieldforAll({
    super.key,
    required this.controller,
    required this.hint,
    required this.focusNode,
    this.isGmail,
    this.isPrimaryNumber = false,
    this.maxLength,
    this.isNumber = false,
    this.keyboardType,
    this.isDisabled = true,
    this.maxline,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTabOutside,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxline == null ? MediaQuery.of(context).size.height / 24 : null,
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        onTapOutside: onTabOutside,
        maxLines: maxline,
        enabled: isDisabled,
        focusNode: focusNode,
        inputFormatters: isNumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : (isGmail != null && isGmail!)
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter
                  ]
                : <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                  ],
        maxLength: maxLength,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
        textCapitalization: keyboardType == true
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        controller: controller,
        style: GoogleFonts.montserrat(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefix: isDisabled == false
              ? const customTextForMonst(
                  title: "+91 ",
                  fontSize: 14,
                  color: Constants.black,
                  fontWeight: FontWeight.w500)
              : null,
          filled: isPrimaryNumber,
          fillColor:
              isPrimaryNumber ? Colors.grey.shade200 : Colors.transparent,
          contentPadding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffff0eceb)),
          ),
          focusColor: const Color(0x0ff0eceb),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
              color: Constants.subtitleclr, fontSize: 14),
        ),
      ),
    );
  }
}
