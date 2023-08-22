// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/screens/profile/screen4.dart';

import '../../constants/gobal.dart';
import '../../models/autocompleteCheckBoxModel.dart';
import '../../models/profileSummary.dart';
import '../../themes/colors.dart';

class LanguageMulti extends StatefulWidget {
  final ProfileSummaryModel? prevPageModel;

  // final bool? expirieanceFlag;
  // final List<Experience> experienceList;

  const LanguageMulti({
    Key? key,
    required this.prevPageModel,
  }) : super(key: key);
  @override
  State<LanguageMulti> createState() => _LanguageMultiState();
}

class _LanguageMultiState extends State<LanguageMulti> {
  late Widget previousWidget;

  late TextEditingController LanguageController = TextEditingController();
  List<dynamic> fetchApiLanguages = [];
  List<dynamic> selectedValuesList = [];
  List<String> selectedValues = [];
  late List languageList = [];
  late List<AutoCompleteCheckBoxModel> languageAutoList = [];

  int? expID;

  @override
  void initState() {
    super.initState();
    LanguageController = TextEditingController();
    if (widget.prevPageModel != null) {
      fetchApiLanguages = widget.prevPageModel!.languages ?? [];
      selectedValuesList = widget.prevPageModel!.skills ?? [];
      expID = widget.prevPageModel!.id;
    }
  }

  @override
  void dispose() {
    LanguageController.dispose();
    super.dispose();
  }

  void updateSelectedValues(String value) {
    setState(() {
      selectedValues.add(value);
    });
  }

  static Future<void> updateLanguages(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/users/v1/$id/languges';

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        // Successful request
        // print('Data posted successfully');
      } else {
        // Request failed
        // print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
  }

  void save() async {
    List<dynamic> languages = fetchApiLanguages;

    ProfileSummaryModel model = ProfileSummaryModel(
      id: expID,
      languages: languages,
    );
    Map<String, dynamic> jsonData = model.toJson();
    await updateLanguages(jsonData, expID!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('language saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.themeBgColorLight,
      appBar: AppBar(
        backgroundColor: Constants.themeBgColorLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Languages",
              style: GoogleFonts.varela(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Let recruiter know your value as a potential candidate",
              style: GoogleFonts.varela(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkillSelection(
                name: "language",
                isSkill: true,
                fetchApiskill: fetchApiLanguages,
                title: "Add Language",
                controller: LanguageController,
                selectedValuesList: selectedValuesList,
                callback: updateSelectedValues,
                contextIn: context,
                hintText: "English",
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: save,
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                      color: Constants.themeBgColor,
                      borderRadius: BorderRadius.circular(15)),
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Save",
                        style: GoogleFonts.varela(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
