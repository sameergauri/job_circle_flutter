// ignore_for_file: unused_result

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_circle/models/edit_profile_model/Profile_update_request_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_autosize_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class AddProfileSummary extends ConsumerStatefulWidget {
  const AddProfileSummary(
      {required this.summaryData,
      required this.isEdit,
      required this.userid,
      required this.profileskill,
      super.key});

  final bool isEdit;
  final String summaryData;
  final int userid;
  final List<String> profileskill;

  @override
  ConsumerState<AddProfileSummary> createState() => _AddProfileSummaryState();
}

class _AddProfileSummaryState extends ConsumerState<AddProfileSummary> {
  bool newLine = false;
  TextEditingController profileSumary = TextEditingController();

  FocusNode sumaryFocus = FocusNode();

  @override
  void initState() {
    //notesController.text = widget.healthEvent['text'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Ensure the widget is still mounted
        FocusScope.of(context).requestFocus(sumaryFocus);
      }
    });
    if (widget.isEdit) {
      profileSumary.text = widget.summaryData.toString();
    }
    super.initState();
  }

  bool isLoading = false;

  @override
  void dispose() {
    sumaryFocus.dispose(); // Dispose the FocusNode to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: CustomButtonForSave(
            title: "Save",
            onTap: () async {
              setState(() {
                isLoading = true;
              });

              ProfileUpdateRequestDto profileUpdateRequestDto =
                  ProfileUpdateRequestDto(
                id: widget.userid,
                skills: widget.profileskill,
                bio: profileSumary.text.isEmpty ? " " : profileSumary.text,
              );
              UserUpdateRequestModel userUpdateRequestModel =
                  UserUpdateRequestModel(
                      certificationsRequestDtos: null,
                      educationRequestDtos: null,
                      experienceRequestDtos: null,
                      profileUpdateRequestDto: profileUpdateRequestDto);

              // Create an instance of UserDataService

              // Call the saveUserExperience method on the instance
              await JobPostApiService.PostUserInfo(userUpdateRequestModel);
              ref.refresh(ProfileDataProvider);
              Future.delayed(const Duration(seconds: 10));
              setState(() {
                isLoading = false;
              });

              Navigator.pop(context);
              CustomSnackbar.show(
                  widget.isEdit == false
                      ? "Profile summary added succesfully"
                      : "Profile summary updated succesfully",
                  false);
            },
          ),
          resizeToAvoidBottomInset: true, // Add this line
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Constants.borderColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !widget.isEdit
                    ? const OnboardingTitle(
                        title: "Add Profile Summary",
                      )
                    : const OnboardingTitle(
                        title: "Edit Profile Summary",
                      ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAutoSizeTextField(
                    controller: profileSumary,
                    hintText:
                        "Boost visibility with a compelling career summary.",
                    maxline: 15,
                  )
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Blur Effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.2), // Semi-transparent overlay
                  ),
                ),
                // Circular Progress Indicator
                const CircularProgressIndicator(
                  color: Constants.darkBlue,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /* Widget CustomBody() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTextField(
            controller: profileSumary,
            minFontSize: 14.0,
            maxFontSize: 18,
            stepGranularity: 1.0,
            maxLength: 1500,
            textCapitalization: TextCapitalization.sentences,
            fullwidth: true,
            maxLines: 15, // Allow unlimited lines (expands automatically)
            // expands: true, // Allow expansion in height
            textAlign: TextAlign.start,
            style: GoogleFonts.montserrat(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
            cursorColor: Constants.themeBgColor,
            decoration: InputDecoration(
              counterStyle: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 12,
              ),
              fillColor: Colors.transparent,
              contentPadding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              counterText: '',
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0x0ff0eceb)),
              ),
              focusColor: const Color(0x0ff0eceb),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: "Boost visibility with a compelling career summary.",
              hintStyle: GoogleFonts.merriweather(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: profileSumary,
                builder: (context, value, child) {
                  return customTextForMonst(
                    title: "${value.text.length}/1500",
                    color: Constants.subtitleclr,
                    fontSize: 12,
                  );
                },
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    profileSumary.clear();
                  });
                },
                child: const customTextForWeather(
                  title: "Clear All",
                  color: Constants.themeBgColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  } */
}
