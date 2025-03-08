import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/screens/Manager/constant/custom_normal_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/job_post/job_post_form3.dart';
import 'package:job_circle/themes/colors.dart';

class JobPostForm2 extends StatefulWidget {
  const JobPostForm2({super.key});

  @override
  State<JobPostForm2> createState() => _JobPostForm2State();
}

class _JobPostForm2State extends State<JobPostForm2> {
  bool entrylevel = false,
      seniorlevel = false,
      leader = false,
      fulltime = false,
      parttime = false,
      internship = false,
      contract = false,
      freelancing = false;

  TextEditingController companyController = TextEditingController();

  FocusNode comapnyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForJobPosting(
        buttonText: "Save & Continue",
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const JobPostForm3()));
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
          title:  JobPostingPageAppBarTitle()),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.sp, left: 20.sp, right: 10.sp),
              child: LinearProgressIndicator(
                value: 0.125,
                // value: _calculateProgress(, // Set progress value
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 9.9.sp,
              ),
            ),
            customBody()
          ],
        ),
      ),
    );
  }

  Widget customBody() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OnboardingTitle(
            title: "Hiring for / Company Name*",
          ),
          CustomNormalTextfield(
            hint: "ICICI Lombard",
            controller: companyController,
            focusNode: comapnyFocusNode,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Job Title*",
          ),
          CustomNormalTextfield(
            hint: "Customer Service Associate",
            controller: companyController,
            focusNode: comapnyFocusNode,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Process*",
          ),
          CustomNormalTextfield(
            hint: "Echannel",
            controller: companyController,
            focusNode: comapnyFocusNode,
          ),
          const SizedBox(
            height: 10,
          ),
          const OnboardingTitle(
            title: "Functional Area*",
          ),
          CustomNormalTextfield(
            hint: "Digital Sales",
            controller: companyController,
            focusNode: comapnyFocusNode,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Industry*",
          ),
          CustomNormalTextfield(
            hint: "Industry Type",
            controller: companyController,
            focusNode: comapnyFocusNode,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Number of vacancies*",
          ),
          CustomNormalTextfield(
            hint: "Type Number of vacancies",
            controller: companyController,
            focusNode: comapnyFocusNode,
            isNumber: true,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Level of Hiring*",
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Entery Level",
                  onTap: () {
                    setState(() {
                      entrylevel = true;
                      seniorlevel = false;
                      leader = false;
                    });
                  },
                  isSelect: entrylevel,
                ),
                CustomToggleButton(
                  title: "Senior Level",
                  onTap: () {
                    setState(() {
                      entrylevel = false;
                      seniorlevel = true;
                      leader = false;
                    });
                  },
                  isSelect: seniorlevel,
                ),
                CustomToggleButton(
                  title: "Leader",
                  onTap: () {
                    setState(() {
                      entrylevel = false;
                      seniorlevel = false;
                      leader = true;
                    });
                  },
                  isSelect: leader,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Employment Type*",
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Full Time",
                  onTap: () {
                    setState(() {
                      fulltime = true;
                      parttime = false;
                      internship = false;
                      contract = false;
                      freelancing = false;
                    });
                  },
                  isSelect: fulltime,
                ),
                CustomToggleButton(
                  title: "Part Time",
                  onTap: () {
                    setState(() {
                      fulltime = false;
                      parttime = true;
                      internship = false;
                      contract = false;
                      freelancing = false;
                    });
                  },
                  isSelect: parttime,
                ),
                CustomToggleButton(
                  title: "InternShip",
                  onTap: () {
                    setState(() {
                      fulltime = false;
                      parttime = false;
                      internship = true;
                      contract = false;
                      freelancing = false;
                    });
                  },
                  isSelect: internship,
                ),
                CustomToggleButton(
                  title: "Contractual",
                  onTap: () {
                    setState(() {
                      fulltime = false;
                      parttime = false;
                      internship = false;
                      contract = true;
                      freelancing = false;
                    });
                  },
                  isSelect: contract,
                ),
                CustomToggleButton(
                  title: "Freelancer",
                  onTap: () {
                    setState(() {
                      fulltime = false;
                      parttime = false;
                      internship = false;
                      contract = false;
                      freelancing = true;
                    });
                  },
                  isSelect: freelancing,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
