import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/themes/colors.dart';

class CustomBottomSheetForPinCode extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final void Function(String)? onSubmit;
  final void Function(String)? onCitySubmit;

  const CustomBottomSheetForPinCode(
      {super.key,
      this.controller,
      this.onSubmit,
      this.onCitySubmit,
      required this.title});

  @override
  _CustomJobFormTextFieldRespoOneProfileState createState() =>
      _CustomJobFormTextFieldRespoOneProfileState();
}

class _CustomJobFormTextFieldRespoOneProfileState
    extends State<CustomBottomSheetForPinCode> {
  List<dynamic>? suggestion;
  List<dynamic> suggestions = [];

  late TextEditingController? controller = widget.controller;
  TextEditingController controllerForbottomsheer = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.requestFocus();

    // getJobIndustry();
  }

  Future<List<String>> getJobIndustry(
    String pattern,
  ) async {
    final response = await http.post(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/api/master/v1/getMasterDataByGroupValue?groupName=pin_code&pageNumber=1&pageSize=10000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      List<String> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      List<dynamic> content = data['resultData']['masterData']['content'];
      for (var entry in content) {
        String? value = "${entry['formateData']?.toString()}";
        if (value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            List<String> parts = value.split(',');
            String result = "${parts[0]}, ${parts[1]}, ${parts[2]}";
            uniqueValues.add(result);
            suggestions.add(result);
          }
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return SizedBox(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.9, // Set max height
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Prevent infinite height issue
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back,
                              color: Constants.themeBgColor),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Pin Code",
                          style: GoogleFonts.varela(
                            color: Constants.themeBgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Expanded(
                      // Prevent infinite height issue
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 24,
                              child: TypeAheadField<dynamic>(
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Allows only numbers
                                    ],
                                    style: GoogleFonts.varela(
                                      color: Constants.black,
                                      fontSize: 12.sp,
                                    ),
                                    onChanged: (value) {
                                      suggestion = null;
                                    },
                                    //autofocus: true,
                                    focusNode: _focusNode,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    controller: controllerForbottomsheer,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      labelStyle: const TextStyle(
                                        color: Constants.themeBgColor,
                                      ),
                                      /*  prefixIcon:
                                        const Icon(Icons.house_outlined),
                                    prefixIconColor: Constants.themeBgColor, */
                                      //label: Text("Reside at"),
                                      hintText: "Type to search",
                                      hintStyle: GoogleFonts.varela(
                                        color: Constants.subtitleclr,
                                        fontSize: 12.sp,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Constants.themeBgColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffff0eceb),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.only(left: 15),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) async {
                                  if (pattern.isNotEmpty) {
                                    return await getJobIndustry(pattern);
                                  }
                                  return [];
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  );
                                },
                                onSelected: (suggestion) {
                                  setState(() {
                                    widget.onSubmit!(suggestion.toString());
                                    controllerForbottomsheer.text =
                                        suggestion.toString();
                                    Navigator.pop(context);
                                  });
                                },
                                emptyBuilder: (context) {
                                  return InkWell(
                                    onTap: () {
                                      if (controllerForbottomsheer
                                          .text.isNotEmpty) {
                                        widget.onSubmit!(
                                            controllerForbottomsheer.text);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2.h, horizontal: 6.w),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.h, horizontal: 8.w),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Add Pin Code",
                                                style: GoogleFonts.varela(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 24,
          child: TextFormField(
            controller: widget.controller,
            enabled: false,
            // autofocus: focusNode.canRequestFocus,
            //focusNode: focusNode,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This Text field Cant be empty";
              }
              return null;
            },

            //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
            textCapitalization: TextCapitalization.words,

            onTap: (() {}),
            style: GoogleFonts.varela(
                color: Constants.subtitleclr, fontSize: 12.sp),
            decoration: InputDecoration(
                prefixIconColor: Constants.themeBgColor,
                // prefixIcon: const Icon(Icons.house_outlined),
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 10, right: 10),
                counterText: '',
                /* labelText: firstText != null
                    ? "$firstText, $cityname"
                    : widget.hintText,
                labelStyle: const TextStyle(
                  color: Constants.subtitleclr,
                ), */
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xffff0eceb)),
                ),
                focusColor: const Color(0xffff0eceb),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: Constants.themeBgColor,
                  ),
                ),
                hintText: "Pin Code",
                hintStyle: GoogleFonts.sourceSansPro(
                    color: Constants.hintColor, fontSize: 12.sp)),
          ),
        ),
      ),
    );
  }
}
