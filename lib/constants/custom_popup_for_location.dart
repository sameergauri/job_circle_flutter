import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

import '../models/job_title_model.dart';

class CustomPopUpForLocation extends StatefulWidget {
  final String hintText;
  final bool isSelect;
  final String name;
  Function(String) onSubmit;
  final String title;
  final String? pageHeading;

  // final Function(FocusNode) onFocusNodeRequested;

  CustomPopUpForLocation(
      {super.key,
      required this.hintText,
      required this.onSubmit,
      required this.isSelect,
      required this.title,
      required this.name,
      this.pageHeading,
      });

  @override
  _CustomPopUpForLocationState createState() => _CustomPopUpForLocationState();
}

class _CustomPopUpForLocationState extends State<CustomPopUpForLocation> {
  List<dynamic>? suggestion;

  TextEditingController controller = TextEditingController();

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

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: EdgeInsets.only(bottom: 6.h, top: 2.h, right: 15.sp),
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
            decoration: BoxDecoration(
                color: widget.isSelect
                    ? Constants.borderColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: widget.isSelect
                        ? Constants.borderColor
                        : Colors.grey.shade400)),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: customTextForWeather(
                title: widget.title,
                color: widget.isSelect ? Constants.black : Colors.grey.shade400,
                fontWeight:
                    widget.isSelect ? FontWeight.bold : FontWeight.normal,
                fontSize: 12)));
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
              allSuggestions = await GetLocation(); // Fetch all
              filteredSuggestions =
                  List.from(allSuggestions); // Show all initially
              setState(() {}); // Update UI
            }

            // ✅ Function to filter job titles based on input
            void filterJobTitles(String query) async {
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
                       customTextForWeather(
                        title: widget.pageHeading?? "Reside At",
                        color: Constants.themeBgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  TextField(
                    controller: controller,
                    onChanged: (value) {
                      filterJobTitles(value); // ✅ Filter the list dynamically
                    },
                    style: GoogleFonts.merriweather(
                        fontSize: 14, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Type to search",
                      hintStyle: GoogleFonts.montserrat(
                        color: Constants.subtitleclr,
                        fontSize: 14,
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
                                      fontSize: 12,
                                      title: widget.name == "city"
                                          ? filteredSuggestions[index]
                                              .toString()
                                          : formatLocality(
                                              filteredSuggestions[index])),
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
