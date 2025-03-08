import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

import '../models/job_title_model.dart';

class CustomTextfieldForJobLocation extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final FocusNode? focusNode;
  final String name;
  Function(String) onSubmit;

  // final Function(FocusNode) onFocusNodeRequested;

  CustomTextfieldForJobLocation(
      {super.key,
      this.controller,
      required this.hintText,
      this.focusNode,
      required this.onSubmit,
      required this.name});

  @override
  _CustomTextfieldForJobLocationState createState() =>
      _CustomTextfieldForJobLocationState();
}

class _CustomTextfieldForJobLocationState
    extends State<CustomTextfieldForJobLocation> {
  List<dynamic>? suggestion;

  String? SelectedValue;

  Future<List<String>> GetLocation() async {
    //old Working code of job title
    final response = await http.post(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByLocation?pageNumber=1&pageSize=10000' //TODO:: Old url
        'http://${GlobalConstants.API_Host_one}/api/master/v1/getMasterDataByGroupValue?groupName=${widget.name}&pageNumber=1&pageSize=10000'));

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

      JobTitleModel1? roleResponseModel;
      try {
        roleResponseModel = JobTitleModel1.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }
      List<dynamic> content = data['resultData']['masterData']['content'];
      for (var entry in content) {
        String? value = formatLocality(entry['formateData']!.toString());
        if (!uniqueValues.contains(value)) {
          uniqueValues.add(value);
          suggestions.add(value);
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  String formatLocality(String locality) {
    // Split the string by comma
    List<String> parts = locality.split(',');

    if (parts.length >= 2) {
      // Trim any leading or trailing spaces/tabs from both parts
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();

      // Combine the parts with a single space after the comma
      return '$part1, $part2';
    }

    // If there's no comma, return the original string
    return locality;
  }

  late final Function(String) onIDSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Constants.subtitleclr)),
        // ignore: unnecessary_null_comparison
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectedValue != null
                ? customTextForMonst(
                    title: SelectedValue.toString(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
                : customTextForMonst(
                    title: widget.controller != null
                        ? widget.controller!.text
                        : widget.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    List<String> allSuggestions = []; // Stores all data initially
    List<String> filteredSuggestions = []; // Stores filtered data

    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // TextEditingController controller = TextEditingController();

            // ✅ Function to fetch all job titles initially
            Future<void> fetchAllJobTitles() async {
              allSuggestions = await GetLocation();
              if (widget.controller!.text.isNotEmpty) {
                filteredSuggestions = allSuggestions
                    .where((job) => job
                        .toLowerCase()
                        .contains(widget.controller!.text.toLowerCase()))
                    .toList(); // Show all initially
                setState(() {});
              } else {
                filteredSuggestions =
                    List.from(allSuggestions); // Show all initially
                setState(() {});
              } // Fetch all
              // Update UI
            }

            // ✅ Function to filter job titles based on input
            void filterJobTitles(String query) async {
              List<String> allSuggestions = await GetLocation();
              if (query.isEmpty) {
                filteredSuggestions =
                    List.from(allSuggestions); // Reset to all data
              } else {
                filteredSuggestions = allSuggestions
                    .where((job) =>
                        job.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              }
              setState(() {}); // Update UI
            }

            // ✅ Fetch all job titles when the bottom sheet opens
            if (allSuggestions.isEmpty) {
              fetchAllJobTitles();
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              height: MediaQuery.of(context).size.height / 1.16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      const customTextForWeather(
                        title: "Reside At",
                        color: Constants.themeBgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  TextField(
                    style: GoogleFonts.montserrat(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    controller: widget.controller,
                    onChanged: (value) {
                      filterJobTitles(value); // ✅ Filter the list dynamically
                    },
                    decoration: InputDecoration(
                      hintText: "Type to search",
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Constants.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Constants.subtitleclr),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: filteredSuggestions.isEmpty
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // ✅ Loading state
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredSuggestions.length,
                            itemBuilder: (context, index) {
                              final backgroundColor = index % 2 == 0
                                  ? Colors.grey.shade200
                                  : Colors.white;
                              return Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: customTextForWeather(
                                    title: widget.name == "city"
                                        ? filteredSuggestions[index].toString()
                                        : formatLocality(
                                            filteredSuggestions[index]),
                                    fontSize: 14,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      SelectedValue = widget.name == "city"
                                          ? filteredSuggestions[index]
                                          : formatLocality(
                                              filteredSuggestions[index]);
                                      widget.onSubmit(widget.name == "city"
                                          ? filteredSuggestions[index]
                                              .toString()
                                          : formatLocality(
                                              filteredSuggestions[index]));
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
