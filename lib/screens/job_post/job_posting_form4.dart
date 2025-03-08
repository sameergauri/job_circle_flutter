import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/customchechbox.dart';
import 'package:job_circle/screens/Manager/constant/custom_normal_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/job_post/job_post_form5_keyrespo.dart';
import 'package:job_circle/themes/colors.dart';

class JobPostingForm4 extends StatefulWidget {
  const JobPostingForm4({super.key});

  @override
  State<JobPostingForm4> createState() => _JobPostingForm4State();
}

class _JobPostingForm4State extends State<JobPostingForm4> {
  bool excelent = false,
      verygood = false,
      avrage = false,
      noEnglish = false,
      fresher = false,
      sixmonthandabove = false,
      andabove = false,
      other = false,
      male = false,
      female = false,
      releventbackground = false,
      showandabove = true,
      femaleprefered = false,
      languagemandate = false;

  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();
  TextEditingController minYear = TextEditingController();
  TextEditingController maxYear = TextEditingController();

  FocusNode minFocus = FocusNode();
  FocusNode maxFocus = FocusNode();
  FocusNode minyearFocus = FocusNode();
  FocusNode maxyearFocus = FocusNode();

  List<String> suggestions = ["English", "Hindi", "Marathi"];
  List<String> selectedlist = [];

  @override
  void initState() {
    super.initState();
    maxYear.addListener(() {
      if (maxYear.text.isNotEmpty) {
        setState(() {
          showandabove = false;
        });
      } else {
        setState(() {
          showandabove = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForJobPosting(
        buttonText: "Save & Continue",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const JobPostForm5KeyRespo()));
        },
      ),
      resizeToAvoidBottomInset: true, // Add this line
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Constants.borderColor,
          elevation: 0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: JobPostingPageAppBarTitle()),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.sp, left: 20.sp, right: 10.sp),
              child: LinearProgressIndicator(
                value: 0.500,
                // value: _calculateProgress(, // Set progress value
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 9.9.sp,
              ),
            ),
            CustomBody()
          ],
        ),
      ),
    );
  }

  Widget CustomBody() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingTitle(
            title: "Language Required*",
          ),
          Wrap(
            children: suggestions.map((suggestion) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (!selectedlist.contains(suggestion)) {
                      selectedlist.add(suggestion);
                    } else {
                      selectedlist.remove(suggestion);
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 6.h, top: 2.h, right: 15.sp),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedlist.contains(suggestion)
                              ? Colors.transparent
                              : Colors.grey.shade400),
                      color: !selectedlist.contains(suggestion)
                          ? Colors.transparent
                          : Constants.borderColor,
                      borderRadius: BorderRadius.circular(8.r)),
                  padding:
                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                  child: Text(
                    suggestion.toString(),
                    style: GoogleFonts.varela(
                        fontSize: 12.sp,
                        fontWeight: selectedlist.contains(suggestion)
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
              );
            }).toList(),
          ),
          CustomCheckboxRow(
            onChanged: (newValue) {
              setState(() {
                languagemandate = !languagemandate;
              }); // Notify Flutter that the state has changed
            },
            title: 'Any one lingual language is mandate',
            value: languagemandate,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "English Communication Rating*",
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Excelent",
                  onTap: () {
                    setState(() {
                      excelent = true;
                      verygood = false;
                      avrage = false;
                      noEnglish = false;
                    });
                  },
                  isSelect: excelent,
                ),
                CustomToggleButton(
                  title: "Very Good",
                  onTap: () {
                    setState(() {
                      excelent = false;
                      verygood = true;
                      avrage = false;
                      noEnglish = false;
                    });
                  },
                  isSelect: verygood,
                ),
                CustomToggleButton(
                  title: "Average",
                  onTap: () {
                    setState(() {
                      excelent = false;
                      verygood = false;
                      avrage = true;
                      noEnglish = false;
                    });
                  },
                  isSelect: avrage,
                ),
                CustomToggleButton(
                  title: "No English",
                  onTap: () {
                    setState(() {
                      excelent = false;
                      verygood = false;
                      avrage = false;
                      noEnglish = true;
                    });
                  },
                  isSelect: noEnglish,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Any gender Preferrence",
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Only Male",
                  onTap: () {
                    setState(() {
                      male = true;
                      female = false;
                      femaleprefered = false;
                    });
                  },
                  isSelect: male,
                ),
                CustomToggleButton(
                  title: "Only Female",
                  onTap: () {
                    setState(() {
                      male = false;
                      female = true;
                      femaleprefered = false;
                    });
                  },
                  isSelect: female,
                ),
                CustomToggleButton(
                  title: "Female Preferred",
                  onTap: () {
                    setState(() {
                      male = false;
                      female = false;
                      femaleprefered = true;
                    });
                  },
                  isSelect: femaleprefered,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Age Limit",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: CustomNormalTextfield(
                  maxLength: 2,
                  isNumber: true,
                  hint: "Min Age",
                  controller: minAge,
                  focusNode: minFocus,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.4,
                child: CustomNormalTextfield(
                  maxLength: 2,
                  isNumber: true,
                  hint: "Max Age",
                  controller: maxAge,
                  focusNode: maxFocus,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Experience Required*",
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Fresher",
                  onTap: () {
                    setState(() {
                      fresher = true;
                      sixmonthandabove = false;
                      other = false;
                      minYear.clear();
                      maxYear.clear();
                    });
                  },
                  isSelect: fresher,
                ),
                CustomToggleButton(
                  title: "6 month or above",
                  onTap: () {
                    setState(() {
                      fresher = false;
                      sixmonthandabove = true;
                      other = false;
                      minYear.clear();
                      maxYear.clear();
                    });
                  },
                  isSelect: sixmonthandabove,
                ),
                CustomToggleButton(
                  title: "other",
                  onTap: () {
                    setState(() {
                      fresher = false;
                      sixmonthandabove = false;
                      other = true;
                    });
                  },
                  isSelect: other,
                ),
              ],
            ),
          ),
          if (other)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: CustomNormalTextfield(
                    maxLength: 2,
                    isNumber: true,
                    hint: "Min Year",
                    controller: minYear,
                    focusNode: minyearFocus,
                  ),
                ),
                const OnboardingTitle(
                  title: " - ",
                ),
                if (!andabove)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: CustomNormalTextfield(
                      maxLength: 2,
                      isNumber: true,
                      hint: "Max Year",
                      controller: maxYear,
                      focusNode: maxyearFocus,
                    ),
                  ),
                if (!andabove && maxYear.text.isEmpty)
                  const OnboardingTitle(
                    title: " / ",
                  ),
                if (showandabove)
                  CustomToggleButton(
                    title: "& above",
                    onTap: () {
                      setState(() {
                        andabove = !andabove;
                        showandabove = true;
                        if (andabove) {
                          maxYear
                              .clear(); // Clear the maxYear text if "& above" is selected
                        }
                      });
                    },
                    isSelect: andabove,
                  ),
              ],
            ),
          SizedBox(
            height: 5.h,
          ),
          CustomCheckboxRow(
            title: 'Candidate should be from relevant experience background',
            value: releventbackground,
            onChanged: (value) {
              setState(() {
                releventbackground = !releventbackground;
              });
            },
          ),
        ],
      ),
    );
  }
}
