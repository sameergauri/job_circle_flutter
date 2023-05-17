import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../themes/colors.dart';

class CustomJobFormTextField extends StatefulWidget {
  final TextEditingController controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  BuildContext contextIn;
  final String title;
  final Function(String) getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  // final Function(FocusNode) onFocusNodeRequested;

   CustomJobFormTextField({
    Key? key,
    required this.controller,
    // required this.isEdit,
    // required this.focusNode,
    required this.contextIn,
    required this.title,
    required this.hintText,
    required this.getSuggestions,
    required this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  }) : super(key: key);

  void initState() {
    FocusScope.of(contextIn).nextFocus();
  }

  @override
  _CustomJobFormTextFieldState createState() => _CustomJobFormTextFieldState();
}

class _CustomJobFormTextFieldState extends State<CustomJobFormTextField> {
  List<dynamic>? suggestion;
  bool isEdit = false;

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          focusNode.requestFocus();

          setState(() {
            controller.clear();
            handleBoolChange(false);
            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(right: 5, bottom: 10, top: 10),
            decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: isSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller.text,
                          style: GoogleFonts.sourceSansPro(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "assets/images/cross.png",
                        height: 12,
                      )
                    ],
                  )
                : Text(widget.controller.text,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr, fontSize: 14.sp))));
  }

  List<dynamic> suggestions = [];

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://ec2-13-232-140-47.ap-south-1.compute.amazonaws.com:9090/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */

  FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isEdit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customContainerSelect(true),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 26.h,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,
                      focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: GoogleFonts.sourceSansPro(
                          color: Constants.subtitleclr,
                          fontSize: 14.sp,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 122, 113, 111),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffff0eceb),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.only(left: 15),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        suggestion = await getSuggestions(pattern) ?? [];
                        return suggestion!;
                      } else {
                        return <dynamic>[];
                      }
                    },
                    itemBuilder: (context, suggestion) {
                      final index = suggestions.indexOf(suggestion);
                      final isOdd = index % 2 == 0;
                      final backgroundColor =
                          isOdd ? Colors.grey.shade200 : Colors.white;

                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        controller.text = suggestion.toString();
                        firstText = controller.text;
                        handleBoolChange(true);
                        FocusScope.of(context).nextFocus();
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      final message = suggestion != null && suggestion!.isEmpty
                          ? 'No items found'
                          : 'Searching';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
