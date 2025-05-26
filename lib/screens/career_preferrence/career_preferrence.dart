// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:job_circle/components/customTextFieldForAll.dart';
import 'package:job_circle/constants/career_preference/custom_bottomsheet_for_career_preference.dart';
import 'package:job_circle/constants/career_preference/custom_bottomsheet_for_work_modek.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/models/career_preference/career_preference_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/service/career_preference/career_preference_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class CareerPreferrence extends StatefulWidget {
  const CareerPreferrence({super.key});

  @override
  State<CareerPreferrence> createState() => _CareerPreferrenceState();
}

class _CareerPreferrenceState extends State<CareerPreferrence> {
  TextEditingController jobtitle = TextEditingController();
  TextEditingController industry = TextEditingController();
  TextEditingController functionalArea = TextEditingController();
  TextEditingController ExpectedSalary = TextEditingController();

  bool fullTime = false,
      partTime = false,
      internShip = false,
      contract = false,
      day = false,
      night = false,
      flexible = false,
      immediate = false,
      day15 = false,
      month1 = false,
      month2 = false,
      month3 = false;

  List<String> selectedCitiesMap = [];
  String? selectedWorkMode;

  final apiService = CareerPreferenceApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColorWhite,
      bottomNavigationBar:
          CustomButtonForSave(onTap: _handleSave, title: "Save"),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        backgroundColor: Constants.borderColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextForWeather(
              title: "Career Preference",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            customTextForWeather(
              title: "Tell us what kind of opportunity you are looking for.",
            ),
          ],
        ),
      ),
      body: _custombody(),
    );
  }

  Widget _custombody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const customTextForWeather(title: "Job Title*"),
            MultiSelectBottomSheetField(
              controller: jobtitle,
              hint: 'Preferred Job Role (up to 10)',
              fetchSuggestions: apiService.fetchJobRoleSuggestions,
              maxSelections: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Industry"),
            MultiSelectBottomSheetField(
              controller: industry,
              hint: 'Preferred Industry (up to 3)',
              fetchSuggestions: apiService.fetchIndustrySuggestions,
              maxSelections: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Functional Area"),
            MultiSelectBottomSheetField(
              controller: functionalArea,
              hint: 'Preferred Functional Area (up to 5)',
              fetchSuggestions: apiService.fetchFunctionalAreaSuggestions,
              maxSelections: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Imployment Type*"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomToggleButton(
                    title: "Full Time",
                    onTap: () {
                      setState(() {
                        fullTime = true;
                        partTime = false;
                        internShip = false;
                        contract = false;
                      });
                    },
                    isSelect: fullTime,
                  ),
                  CustomToggleButton(
                    title: "Part Time",
                    onTap: () {
                      setState(() {
                        fullTime = false;
                        partTime = true;
                        internShip = false;
                        contract = false;
                      });
                    },
                    isSelect: partTime,
                  ),
                  CustomToggleButton(
                    title: "InternShip",
                    onTap: () {
                      setState(() {
                        fullTime = false;
                        partTime = false;
                        internShip = true;
                        contract = false;
                      });
                    },
                    isSelect: internShip,
                  ),
                  CustomToggleButton(
                    title: "Contractual",
                    onTap: () {
                      setState(() {
                        fullTime = false;
                        partTime = false;
                        internShip = false;
                        contract = true;
                      });
                    },
                    isSelect: contract,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Work Mode*"),
            WorkModeWithCitySelection(
              onCitySelectionChanged: (newSelection) {
                setState(() {
                  selectedCitiesMap = newSelection;
                });
              },
              selectedWorkMode: (p0) {
                setState(() {
                  selectedWorkMode = p0;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Shift Preferred*"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomToggleButton(
                    title: "Day",
                    onTap: () {
                      setState(() {
                        day = true;
                        night = false;
                        flexible = false;
                      });
                    },
                    isSelect: day,
                  ),
                  CustomToggleButton(
                    title: "Night",
                    onTap: () {
                      setState(() {
                        day = false;
                        night = true;
                        flexible = false;
                      });
                    },
                    isSelect: night,
                  ),
                  CustomToggleButton(
                    title: "Flexible",
                    onTap: () {
                      setState(() {
                        day = false;
                        night = false;
                        flexible = true;
                      });
                    },
                    isSelect: flexible,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Expected Annual Salary*"),
            CustomTextFieldforAll(
              controller: ExpectedSalary,
              hint: "Enter annual ctc",
              isNumber: true,
              maxLength: 7,
            ),
            const SizedBox(
              height: 10,
            ),
            const customTextForWeather(title: "Joining Availability*"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomToggleButton(
                    title: "Immediate",
                    onTap: () {
                      setState(() {
                        immediate = true;
                        day15 = false;
                        month1 = false;
                        month2 = false;
                        month3 = false;
                      });
                    },
                    isSelect: immediate,
                  ),
                  CustomToggleButton(
                    title: "15 days or less",
                    onTap: () {
                      setState(() {
                        immediate = false;
                        day15 = true;
                        month1 = false;
                        month2 = false;
                        month3 = false;
                      });
                    },
                    isSelect: day15,
                  ),
                  CustomToggleButton(
                    title: "1 Month",
                    onTap: () {
                      setState(() {
                        immediate = false;
                        day15 = false;
                        month1 = true;
                        month2 = false;
                        month3 = false;
                      });
                    },
                    isSelect: month1,
                  ),
                  CustomToggleButton(
                    title: "2 Month",
                    onTap: () {
                      setState(() {
                        immediate = false;
                        day15 = false;
                        month1 = false;
                        month2 = true;
                        month3 = false;
                      });
                    },
                    isSelect: month2,
                  ),
                  CustomToggleButton(
                    title: "3 Month",
                    onTap: () {
                      setState(() {
                        immediate = false;
                        day15 = false;
                        month1 = false;
                        month2 = false;
                        month3 = true;
                      });
                    },
                    isSelect: month3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSave() async {
    // Validate Job Title
    if (jobtitle.text.isEmpty) {
      CustomSnackbar.show("Job Title is required", true);
      return;
    }

    // Validate Employment Type
    String? employmentType;
    if (fullTime) {
      employmentType = "Full Time";
    } else if (partTime) {
      employmentType = "Part Time";
    } else if (internShip) {
      employmentType = "InternShip";
    } else if (contract) {
      employmentType = "Contractual";
    }
    if (employmentType == null) {
      CustomSnackbar.show("Employment Type is required", true);
      return;
    }

    // Validate Work Mode (Job Location/City)
    if (selectedCitiesMap.isEmpty) {
      CustomSnackbar.show("Work Mode and Job Location/City are required", true);
      return;
    }

    // Validate Shift Preferred
    String? shiftPreferred;
    if (day) {
      shiftPreferred = "Day";
    } else if (night) {
      shiftPreferred = "Night";
    } else if (flexible) {
      shiftPreferred = "Flexible";
    }
    if (shiftPreferred == null) {
      CustomSnackbar.show("Shift Preferred is required", true);
      return;
    }

    // Validate Expected Salary
    if (ExpectedSalary.text.isEmpty) {
      CustomSnackbar.show("Expected Annual Salary is required", true);
      return;
    }

    // Validate Joining Availability
    String? joiningAvailability;
    if (immediate) {
      joiningAvailability = "Immediate";
    } else if (day15) {
      joiningAvailability = "15 days or less";
    } else if (month1) {
      joiningAvailability = "1 Month";
    } else if (month2) {
      joiningAvailability = "2 Month";
    } else if (month3) {
      joiningAvailability = "3 Month";
    }
    if (joiningAvailability == null) {
      CustomSnackbar.show("Joining Availability is required", true);
      return;
    }

    // All validations passed, create the model
    CareerPreferenceModel careerPreference = CareerPreferenceModel(
      jobTitles: jobtitle.text.split(',').map((e) => e.trim()).toList(),
      industries: industry.text.isNotEmpty
          ? industry.text.split(',').map((e) => e.trim()).toList()
          : null,
      functionalAreas: functionalArea.text.isNotEmpty
          ? functionalArea.text.split(',').map((e) => e.trim()).toList()
          : null,
      employmentType: employmentType,
      workMode: selectedWorkMode!,
      workModeCities: selectedCitiesMap,
      shiftPreferred: shiftPreferred,
      expectedSalary: ExpectedSalary.text,
      joiningAvailability: joiningAvailability,
    );

    // Save the data via API

    bool success = await apiService.saveCareerPreference(careerPreference);
    if (success) {
      CustomSnackbar.show("Career Preference saved successfully", false);
      // Optionally, navigate back or clear the form
      Navigator.pop(context);
    } else {
      CustomSnackbar.show("Failed to save Career Preference", true);
    }
  }
}
