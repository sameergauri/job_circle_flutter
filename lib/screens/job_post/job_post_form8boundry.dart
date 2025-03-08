import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/custom_bullet_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class JobPostForm8boundry extends StatefulWidget {
  const JobPostForm8boundry({super.key});

  @override
  State<JobPostForm8boundry> createState() => _JobPostForm8boundryState();
}

class _JobPostForm8boundryState extends State<JobPostForm8boundry> {
  bool newLine = false;
  @override
  TextEditingController boundry = TextEditingController();
  TextEditingController additional = TextEditingController();

  FocusNode boundryfocus = FocusNode();
  FocusNode additionalfocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForJobPosting(
        buttonText: "Save & Continue",
        onTap: () {},
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
                value: 0.725,
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
            title: "Boundry Limit",
          ),
          BulletPointTextField(
              maxlength: 1200,
              controller: boundry,
              hintText: "Any Boundry Limit")
        ],
      ),
    );
  }

  // Ensure every line starts with a bullet point
}
