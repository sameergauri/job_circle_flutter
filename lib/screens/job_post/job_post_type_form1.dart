import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/custom_bottom_sheet.dart';
import 'package:job_circle/screens/Manager/constant/custom_document_upload_button.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/job_post/job_post_form2.dart';
import 'package:job_circle/themes/colors.dart';

class JobPostOneType extends StatefulWidget {
  const JobPostOneType({super.key});

  @override
  State<JobPostOneType> createState() => _JobPostOneTypeState();
}

class _JobPostOneTypeState extends State<JobPostOneType> {
  bool classic = false,
      premium = false,
      banner = false,
      private = false,
      meAndMyTeam = false,
      allmember = false;

  List<String> MyTeamMember = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForJobPosting(
        buttonText: "Save & Continue",
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const JobPostForm2()));
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
                value: 0.005,
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
            title: "Job Post type",
          ),
          Row(
            children: [
              CustomToggleButton(
                title: "Classic",
                onTap: () {
                  setState(() {
                    classic = true;
                    premium = false;
                    banner = false;
                  });
                },
                isSelect: classic,
              ),
              CustomToggleButton(
                title: "Premium",
                onTap: () {
                  setState(() {
                    classic = false;
                    premium = true;
                    banner = false;
                  });
                },
                isSelect: premium,
              ),
              CustomToggleButton(
                title: "Banner",
                onTap: () {
                  setState(() {
                    classic = false;
                    premium = false;
                    banner = true;
                  });
                },
                isSelect: banner,
              )
            ],
          ),
          if (banner)
            SizedBox(
              height: 4.h,
            ),
          if (banner)
            CustomDocumentUploadButton(
              onTab: () {},
              title: "Add Banner",
              subTitle: "Supported formate : PNG, JPG",
            ),
          const OnboardingTitle(
            title: "Post Visibility",
          ),
          customText(
            title:
                "If you choose to make the project private, You 'll still be able to invite more people later.",
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      private = true;
                      meAndMyTeam = false;
                      allmember = false;
                      MyTeamMember.clear();
                    });
                  },
                  icon: Icon(
                    private
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_off,
                    color: private
                        ? Constants.themeBgColor
                        : Constants.subtitleclr,
                  )),
              customText(
                title: "Private / Only me.",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Constants.subtitleclr,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      private = false;
                      meAndMyTeam = true;
                      allmember = false;
                    });
                    CustomBottomSheet(
                      context: context,
                      items: [
                        "Member1",
                        "Member2",
                        "Member3",
                        "Member4",
                        "Member5"
                      ],
                      title: "My Team Member",
                      initiallySelectedItems: MyTeamMember,
                      onSelectionComplete: (selectedItems) {
                        setState(() {
                          MyTeamMember = selectedItems;
                        });
                      },
                    ).show();
                  },
                  icon: Icon(
                    meAndMyTeam
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_off,
                    color: meAndMyTeam
                        ? Constants.themeBgColor
                        : Constants.subtitleclr,
                  )),
              customText(
                title: "Me And My Team Member.",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Constants.subtitleclr,
              ),
            ],
          ),
          if (MyTeamMember.isNotEmpty)
            Wrap(
              spacing: 8.0,
              children: MyTeamMember.map((item) => Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: Constants.borderColor,
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item),
                        SizedBox(
                          width: 4.w,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              MyTeamMember.remove(item);
                            });
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 16.h,
                          ),
                        )
                      ],
                    ),
                  )).toList(),
            ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      private = false;
                      meAndMyTeam = false;
                      allmember = true;
                      MyTeamMember.clear();
                    });
                  },
                  icon: Icon(
                    allmember
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_off,
                    color: allmember
                        ? Constants.themeBgColor
                        : Constants.subtitleclr,
                  )),
              customText(
                title: "All member of Job Circle.",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Constants.subtitleclr,
              ),
            ],
          )
        ],
      ),
    );
  }
}
