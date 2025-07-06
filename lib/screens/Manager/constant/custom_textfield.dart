import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Manager/constant/customstatus_model.dart';
import 'package:job_circle/themes/colors.dart';

class CustomStatusManager extends StatefulWidget {
  final TextEditingController? controller;
  BuildContext contextIn;
  final Function(bool) onChanged;

  final Function(String) getHrStatusID;
  final void Function(String)? onSubmit;

  CustomStatusManager(
      {super.key,
      required this.controller,
      required this.contextIn,
      required this.getHrStatusID,
      required this.onChanged,
      required this.onSubmit});

  @override
  _CustomStatusManagerState createState() => _CustomStatusManagerState();
}

class _CustomStatusManagerState extends State<CustomStatusManager> {
  @override
  void initStateComp() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Don't forget to dispose of the focus node
    super.dispose();
  }

  List<dynamic>? suggestion;
  bool isEdit = false;
  List<dynamic> suggestions = [];
  bool suggestionSelected = false;

  late TextEditingController? controller = widget.controller;

  Future<List<StatusListModel>> getHrStatus(String pattern) async {
    try {
      final response = await http.get(Uri.parse(
          'http://${GlobalConstants.API_Host_one}/status/v1/getHrStatus?page=1&size=100'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<StatusListModel> suggestions = (data['resultData']['content']
                as List<dynamic>)
            .map((e) => StatusListModel.fromJson(e))
            .where((StatusListModel status) =>
                status.value != null &&
                status.value!.toLowerCase().startsWith(pattern.toLowerCase()))
            .toList();

        return suggestions;
      } else {
        throw Exception('Failed to retrieve suggestions');
      }
    } catch (error) {
      print('Error during JSON: $error');
      return [];
    }
  }

  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 25.h,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: TypeAheadFormField<dynamic>(
          validator: (value) {
            if (value!.isEmpty) {
              return "This Text field Cant be empty";
            }
            return null;
          },
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(8),
            elevation: 4.0,
          ),
          textFieldConfiguration: TextFieldConfiguration(
            /* onTapOutside: (event) {
              setState(() {
                suggestionSelected = true;
              });
            }, */
            onSubmitted: (value) {
              setState(() {
                suggestionSelected = true;
              });
            },
            // enabled: !suggestionSelected,
            onChanged: (value) {
              suggestion = null;
            },
            autofocus: true,

            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            style:
                GoogleFonts.varela(color: Constants.hintColor, fontSize: 14.sp),
            decoration: InputDecoration(
              label: const Text("Status"),
              labelStyle: GoogleFonts.varela(
                  color: Constants.themeBgColor, fontSize: 15.sp),
              prefixIcon: const Icon(
                Icons.badge_outlined,
                color: Constants.themeBgColor,
              ),
              prefixIconColor: Constants.themeBgColor,
              //label: Text("Reside at"),
              hintText: "Application",
              hintStyle: GoogleFonts.varela(
                color: Constants.subtitleclr,
                fontSize: 14.sp,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Constants.themeBgColor),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffff0eceb),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.only(
                left: 15,
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.isNotEmpty) {
              suggestion = await getHrStatus(pattern);

              return suggestion!;
            } else {
              return <dynamic>[];
            }
          },
          itemBuilder: (context, suggestion) {
            final isOdd = suggestionIndex % 2 == 0;
            final backgroundColor = isOdd ? Colors.grey.shade200 : Colors.white;

            // Increment the suggestion index counter
            suggestionIndex++;

            return Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(
                  suggestion.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            // widget.focusNode!.nextFocus();
            widget.onChanged(true);
            setState(() {
              controller!.text = suggestion.value.toString();
              widget.getHrStatusID(suggestion.id.toString());
            });
          },
          noItemsFoundBuilder: (value) {
            final message = suggestion != null && suggestion!.isEmpty
                ? 'No result found. Search again.'
                : 'Searching';

            return Text(message);
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class JobPostingPageAppBarTitle extends StatelessWidget {
  JobPostingPageAppBarTitle({super.key, this.title});
  String? title;
  @override
  Widget build(BuildContext context) {
    return customTextForWeather(
      title: title ?? "Job Posting",
      fontSize: 16.sp,
      color: Constants.black,
      fontWeight: FontWeight.w700,
    );
  }
}

class OnboardingAppBarHeading extends StatelessWidget {
  const OnboardingAppBarHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        customTextForWeather(
          title: "Welcome to ",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        customTextForWeather(
          title: "JOB",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Constants.darkBlue,
        ),
        customTextForWeather(
          title: "CIRCLE",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        )
      ],
    );
  }
}

class OnboardingAppBarSubTitle extends StatelessWidget {
  const OnboardingAppBarSubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const customTextForWeather(
      title: "Start building your professional profile",
    );
  }
}

class OnboardingTitle extends StatelessWidget {
  final String title;
  const OnboardingTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: customTextForWeather(
        title: title,
        fontSize: 18,
        color: Constants.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class customText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const customText(
      {super.key,
      required this.title,
      this.fontSize,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: Text(
        title,
        style: GoogleFonts.varela(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class customTextForAll extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;

  const customTextForAll(
      {super.key,
      required this.title,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softwrap,
      this.textAlign,
      this.maxlines,
      this.fontStyle,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: GoogleFonts.varela(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
        fontStyle: fontStyle,
      ),
    );
  }
}

class customTextForSignika extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;

  const customTextForSignika(
      {super.key,
      required this.title,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softwrap,
      this.textAlign,
      this.maxlines,
      this.fontStyle,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: GoogleFonts.signika(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
        fontStyle: fontStyle,
      ),
    );
  }
}

class customTextForWeather extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final TextDecoration? textDecoration;

  const customTextForWeather(
      {required this.title,
      super.key,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softwrap,
      this.textAlign,
      this.maxlines,
      this.fontStyle,
      this.overflow,
      this.letterSpacing,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: GoogleFonts.merriweather(
          fontSize: fontSize ?? 12,
          color: color ?? Colors.black,
          fontWeight: fontWeight,
          decoration: textDecoration ?? TextDecoration.none,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing),
    );
  }
}

class customTextForMonst extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final double? letterSpacing;

  const customTextForMonst(
      {super.key,
      required this.title,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softwrap,
      this.textAlign,
      this.maxlines,
      this.fontStyle,
      this.overflow,
      this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: GoogleFonts.montserrat(
        fontSize: fontSize ?? 12,
        color: color ?? Constants.black,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

class customTextForHind extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;

  const customTextForHind(
      {super.key,
      required this.title,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softwrap,
      this.textAlign,
      this.maxlines,
      this.fontStyle,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: GoogleFonts.hind(
        fontSize: fontSize ?? 12,
        color: color ?? Constants.black,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
        fontStyle: fontStyle,
      ),
    );
  }
}

class customTextForRoboto extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final double? letterSpacing;

  const customTextForRoboto(
      {required this.title,
      super.key,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softwrap,
      this.textAlign,
      this.maxlines,
      this.fontStyle,
      this.overflow,
      this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: GoogleFonts.roboto(
        fontSize: fontSize ?? 12,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
