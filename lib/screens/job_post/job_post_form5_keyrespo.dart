import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/custom_bullet_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/job_post/job_post_form7_elogibility.dart';
import 'package:job_circle/themes/colors.dart';

class JobPostForm5KeyRespo extends StatefulWidget {
  const JobPostForm5KeyRespo({super.key});

  @override
  State<JobPostForm5KeyRespo> createState() => _JobPostForm5KeyRespoState();
}

class _JobPostForm5KeyRespoState extends State<JobPostForm5KeyRespo> {
  bool newLine = false;
  @override
  void initState() {
    //notesController.text = widget.healthEvent['text'];
   /*  keyrsponsibilities.addListener(() {
      print('___${keyrsponsibilities.text}');
      String note = keyrsponsibilities.text;
      if (note.isNotEmpty && note.substring(note.length - 1) == '\u2022') {
        print('newline');
        setState(() {
          newLine = true;
        });
      } else {
        setState(() {
          newLine = false;
        });
      }
    }); */
    super.initState();
  }

  TextEditingController keyrsponsibilities = TextEditingController();

  FocusNode keyrspoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForJobPosting(
        buttonText: "Save & Continue",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const JobPostForm7eligibility()));
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
                value: 0.850,
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
            title: "Key Responsibilities",
          ),
          BulletPointTextField(
             maxlength: 1200,
              controller: keyrsponsibilities, hintText: "Enter your Job Role")
          /*        AutoSizeTextField(
            onChanged: (value) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (newLine) {
                  return;
                }
                String note = keyrsponsibilities.text;
                if (note.isEmpty) {
                  keyrsponsibilities.text = '${keyrsponsibilities.text}\u2022';
                  keyrsponsibilities.selection = TextSelection.fromPosition(
                      TextPosition(offset: keyrsponsibilities.text.length));
                }
                if (note.isNotEmpty &&
                    note.substring(note.length - 1) == '\n') {
                  keyrsponsibilities.text = '${keyrsponsibilities.text}\u2022';
                  keyrsponsibilities.selection = TextSelection.fromPosition(
                      TextPosition(offset: keyrsponsibilities.text.length));
                }
              });
            },

            minFontSize: 16.0, // Use fixed values
            maxFontSize: 24.0, // Avoid sp for min/max font sizes
            stepGranularity: 1.0, // Ensure stepGranularity matches
            fullwidth: true,
            style: GoogleFonts.varela(color: Constants.black, fontSize: 30.sp),
            controller: keyrsponsibilities,
            maxLines: 10,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              contentPadding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xffff0eceb)),
              ),
              focusColor: const Color(0xffff0eceb),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: Constants.black,
                ),
              ),
              hintText: 'Enter your job role',
              hintStyle: GoogleFonts.sourceSansPro(
                color: Constants.hintColor,
                fontSize: 14.sp,
              ),
            ),
          ) */
        ],
      ),
    );
  }

  // Ensure every line starts with a bullet point
}
