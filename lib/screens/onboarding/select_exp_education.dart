import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/models/user_data_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_button_for_save.dart';
import 'package:job_circle/screens/Manager/constant/custom_container_for_gender.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/onboarding/add_education.dart';
import 'package:job_circle/screens/onboarding/add_experience.dart';
import 'package:job_circle/themes/colors.dart';

class SelectExpEducation extends StatefulWidget {
  const SelectExpEducation(
      {required this.userID, required this.introData, super.key});

  final int userID;
  final UserRequest introData;

  @override
  State<SelectExpEducation> createState() => _SelectExpEducationState();
}

class _SelectExpEducationState extends State<SelectExpEducation> {
  //TODO:: Variable

  bool fresher = false;
  bool experience = false;

  bool undergraduate = false;
  bool graduateandabove = false;

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForSave(
        title: "Next",
        onTap: () {
          if (!fresher && !experience) {
            CustomSnackbar.show("Select Professional Career Level", true);
          } else if (!graduateandabove && !undergraduate) {
            CustomSnackbar.show("Select Qualification Level", true);
          } else {
            save();
          }
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.borderColor,
        automaticallyImplyLeading: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Constants.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [OnboardingAppBarHeading(), OnboardingAppBarSubTitle()],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: 10.sp, left: 10.sp, right: 10.sp),
              child: LinearProgressIndicator(
                value: 0.167,
                // value: _calculateProgress(, // Set progress value
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 9.9.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.sp, top: 10.sp, bottom: 10.sp),
              child: const OnboardingTitle(
                title: "Professional Career Level",
              ),
            ),
            selectEducationAndExp()
          ]),
        ),
      ),
    );
  }

//TODO:: Custom function....

  Widget selectEducationAndExp() {
    // ignore: avoid_unnecessary_containers
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  experience == false
                      ? setState(() {
                          fresher = true;
                        })
                      : setState(() {
                          experience = false;
                          fresher = true;
                        });
                },
                child: fresher
                    ? Icon(
                        Icons.radio_button_checked_sharp,
                        color: Constants.blue,
                        size: 22.sp,
                      )
                    : Icon(Icons.circle_outlined,
                        color: Colors.grey.shade400, size: 22.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                        title: "Fresher",
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    SizedBox(
                      height: 5.h,
                    ),
                    customTextForWeather(
                      title:
                          "I am new to the workforce, with no prior professional experience.",
                      softwrap: true,
                      fontStyle: FontStyle.italic,
                      // wordSpacing: 2.0,
                      fontSize: 12.sp,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  fresher == false
                      ? setState(() {
                          experience = true;
                        })
                      : setState(() {
                          fresher = false;
                          experience = true;
                        });
                },
                child: experience
                    ? Icon(
                        Icons.radio_button_checked_sharp,
                        color: Constants.blue,
                        size: 22.sp,
                      )
                    : Icon(Icons.circle_outlined,
                        color: Colors.grey.shade400, size: 22.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                        title: "Experience",
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    SizedBox(
                      height: 5.h,
                    ),
                    customTextForWeather(
                      title:
                          "I have previous professional experience in one or more roles.",
                      softwrap: true,
                      fontStyle: FontStyle.italic,
                      fontSize: 12.sp,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          const Divider(
            thickness: 1.0,
          ),
          SizedBox(
            height: 20.h,
          ),
          const OnboardingTitle(
            title: "Highest Qualification",
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainerForGender(
                  onPressed: () {
                    setState(() {
                      undergraduate = true;
                      graduateandabove = false;
                    });
                  },
                  title: "Under - Graduate",
                  isSelect: undergraduate),
              CustomContainerForGender(
                  onPressed: () {
                    setState(() {
                      undergraduate = false;
                      graduateandabove = true;
                    });
                  },
                  title: "Graduate or above",
                  isSelect: graduateandabove)
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          const customTextForWeather(
              title:
                  "This information helps recruiter tailor the application process based on your career background.",
              textAlign: TextAlign.center,
              fontSize: 12),
        ],
      ),
    );
  }

  /*  Widget selectEducationButton(String title, bool ischeck) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: BoxDecoration(
          color: ischeck ? Constants.borderColor : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: ischeck ? Constants.borderColor : Colors.grey.shade400)),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.varela(
              fontSize: 12.sp,
              color: ischeck ? Colors.black : Colors.grey.shade400,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  } */

  void save() async {
    bool isExperience = false;
    bool isUndergraduate = false;
    if (undergraduate) {
      setState(() {
        isUndergraduate = true;
      });
    } else if (graduateandabove) {
      setState(() {
        isUndergraduate = false;
      });
    }
    if (fresher) {
      setState(() {
        isExperience = false;
      });
    } else if (experience) {
      setState(() {
        isExperience = true;
      });
    }
    ProfileSummaryModel model = ProfileSummaryModel(
      id: widget.userID,
    );
    Map<String, dynamic> jsonData = model.toJson();
    /*  await updateLanguages(jsonData, widget.userID);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('language saved successfully')),
    ); */

    UserRequest updatedIntro = widget.introData.copyWith(
      experience: isExperience ? 1 : 0,
      education: isUndergraduate ? 0 : 1,
    );

    if (fresher) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddEducation(
                    isexperience: isExperience,
                    isUnderGraduate: isUndergraduate,
                    introData: updatedIntro,
                    userID: widget.userID,
                  )));
    } else if (experience) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExperience(
                    isExperience: isExperience,
                    isUndergraduate: isUndergraduate,
                    introData: updatedIntro,
                    userID: widget.userID,
                  )));
    }
  }
}
