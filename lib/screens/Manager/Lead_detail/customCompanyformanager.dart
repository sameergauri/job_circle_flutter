// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/job_title_model.dart';
import 'package:job_circle/themes/colors.dart';

class CustomCompanyForManagerLeadForm extends StatefulWidget {
  final TextEditingController? controller;

  BuildContext contextIn;
  final String title;
  final String? firstText;
  final Function(String)? getSuggestions;
  final Function(bool) onChanged;
  final Function(int) onSubmit;
  final Function(int)? getEmpID;
  final Function(int)? getSalary;
  final Function(int)? getGender;
  final Function(String)? onGetResumeId;

  CustomCompanyForManagerLeadForm({
    super.key,
    this.controller,
    required this.onSubmit,
    this.onGetResumeId,
    required this.contextIn,
    required this.title,
    this.getSuggestions,
    this.getSalary,
    this.getEmpID,
    this.getGender,
    required this.onChanged,
    this.firstText,
  });

  @override
  _CustomCompanyForManagerLeadFormState createState() =>
      _CustomCompanyForManagerLeadFormState();
}

class _CustomCompanyForManagerLeadFormState
    extends State<CustomCompanyForManagerLeadForm> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<JobTitleModel> suggestions = [];

  late TextEditingController? controller = widget.controller;

  late String selectedID;

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  void handleOnSubmit(int newValue) {
    widget.onSubmit(newValue);
  }

  void handleOngetEmpid(int newValue) {
    widget.getEmpID!(newValue);
  }

  void handleOngetResumeId(String newValue) {
    widget.onGetResumeId!(newValue);
  }

  void handleOnSalary(int newValue) {
    widget.getSalary!(newValue);
  }

  void handleOnGender(int newValue) {
    widget.getGender!(newValue);
  }

  Future<List<JobTitleModel>> getSuggestions(String pattern) async {
    // 2 min wait
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/company/v1/allClientCompany?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<JobTitleModel> suggestions = [];
      Set<String> uniqueNames = {};

      List<dynamic> content = data['resultData']['content'];

      for (var entry in content) {
        String name = entry['name'].toString();
        String code = entry['short_code'].toString();
        if ((name.toLowerCase().startsWith(pattern.toLowerCase()) &&
                !uniqueNames.contains(name)) ||
            (code.toLowerCase().startsWith(pattern.toLowerCase()) &&
                !uniqueNames.contains(name))) {
          uniqueNames.add(name);
          JobTitleModel jobTitle = JobTitleModel.fromJson(entry);
          suggestions.add(jobTitle);
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  int suggestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Client Name",
            style: GoogleFonts.varela(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 25.h,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TypeAheadFormField<dynamic>(
              enabled: false,
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                onChanged: (value) {
                  suggestion = null;
                },
                autofocus: true,

                // focusNode: focusNode,
                textCapitalization: TextCapitalization.sentences,
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Aditya birla Health Insurance",
                  hintStyle: GoogleFonts.varela(
                    color: Constants.subtitleclr,
                    fontSize: 15.sp,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 122, 113, 111),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      // ignore: use_full_hex_values_for_flutter_colors
                      color: Color(0xffff0eceb),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.only(left: 15),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.isNotEmpty) {
                  suggestion = await getSuggestions(pattern);

                  return suggestion!;
                } else {
                  return <dynamic>[];
                }
              },
              itemBuilder: (context, suggestion) {
                final isOdd = suggestionIndex % 2 == 0;
                final backgroundColor =
                    isOdd ? Colors.grey.shade200 : Colors.white;

                // Increment the suggestion index counter
                suggestionIndex++;
                return Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      suggestion.name.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  controller!.text = suggestion.name.toString();
                  handleBoolChange(true);
                  int selectedId = int.tryParse(suggestion.id)!.toInt();
                  handleOnSubmit(selectedId);
                  handleOngetEmpid(suggestion.active);
                  handleOnGender(suggestion.isgender);
                  handleOnSalary(suggestion.isSalary);
                  handleOngetResumeId(suggestion.isResumeId);
                });
              },
              noItemsFoundBuilder: (value) {
                final message = suggestion != null && suggestion!.isEmpty
                    ? 'No result found. Search again and select from suggestion.'
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
