import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/customchechbox.dart';
import 'package:job_circle/screens/Manager/constant/custom_normal_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/job_post/job_posting_form4.dart';
import 'package:job_circle/themes/colors.dart';

class JobPostForm3 extends StatefulWidget {
  const JobPostForm3({super.key});

  @override
  State<JobPostForm3> createState() => _JobPostForm3State();
}

class _JobPostForm3State extends State<JobPostForm3> {
  bool pffund = false,
      healthInsurance = false,
      payroll = false,
      joiningBonus = false,
      Incentive = false,
      dayrotational = false,
      rotationalall = false,
      rotationalone = false,
      rotationaltwo = false,
      altsatsun = false,
      perMonth = false,
      perYear = false,
      undergraduate = false,
      graduateandabove = false,
      undergraduatewithreventExp = false,
      hybrid = false,
      remote = false,
      onsite = false;

  TextEditingController controller = TextEditingController();
  FocusNode focusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomButtonForJobPosting(
        buttonText: "Save & Continue",
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const JobPostingForm4()));
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
                value: 0.250,
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
            title: "Job Benefits*",
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Provident Fund",
                  onTap: () {
                    setState(() {
                      pffund = true;
                    });
                  },
                  isSelect: pffund,
                ),
                CustomToggleButton(
                  title: "Health Insurance",
                  onTap: () {
                    setState(() {
                      healthInsurance = true;
                    });
                  },
                  isSelect: healthInsurance,
                ),
                CustomToggleButton(
                  title: "Payroll",
                  onTap: () {
                    setState(() {
                      payroll = true;
                    });
                  },
                  isSelect: payroll,
                ),
                CustomToggleButton(
                  title: "Joining Bonus",
                  onTap: () {
                    setState(() {
                      joiningBonus = true;
                    });
                  },
                  isSelect: joiningBonus,
                ),
                CustomToggleButton(
                  title: "Incentive",
                  onTap: () {
                    setState(() {
                      Incentive = true;
                    });
                  },
                  isSelect: Incentive,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Work Mode*",
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Onsite",
                  onTap: () {
                    setState(() {
                      onsite = true;
                      hybrid = false;
                      remote = false;
                    });
                  },
                  isSelect: onsite,
                ),
                CustomToggleButton(
                  title: "Hybrid",
                  onTap: () {
                    setState(() {
                      hybrid = true;
                      onsite = false;
                      remote = false;
                    });
                  },
                  isSelect: hybrid,
                ),
                CustomToggleButton(
                  title: "Remote",
                  onTap: () {
                    setState(() {
                      remote = true;
                      onsite = false;
                      hybrid = false;
                    });
                  },
                  isSelect: remote,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Job Location*",
          ),
          CustomNormalTextfield(
            hint: "Job Location",
            controller: controller,
            focusNode: focusnode,
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Shift Timing*",
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Day Rotational",
                  onTap: () {
                    setState(() {
                      dayrotational = true;
                      rotationalall = false;
                    });
                  },
                  isSelect: dayrotational,
                ),
                CustomToggleButton(
                  title: "Hybrid",
                  onTap: () {
                    setState(() {
                      rotationalall = true;
                      dayrotational = false;
                    });
                  },
                  isSelect: rotationalall,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Week - Off*",
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CustomToggleButton(
                  title: "Rotational 1",
                  onTap: () {
                    setState(() {
                      rotationalone = true;
                      rotationaltwo = false;
                      altsatsun = false;
                    });
                  },
                  isSelect: rotationalone,
                ),
                CustomToggleButton(
                  title: "Rotational 2",
                  onTap: () {
                    setState(() {
                      rotationaltwo = true;
                      rotationalone = false;
                      altsatsun = false;
                    });
                  },
                  isSelect: rotationaltwo,
                ),
                CustomToggleButton(
                  title: "Alternat Sat & Sun",
                  onTap: () {
                    setState(() {
                      altsatsun = true;
                      rotationalone = false;
                      rotationaltwo = false;
                    });
                  },
                  isSelect: altsatsun,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const OnboardingTitle(
            title: "Salary*",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: CustomNormalTextfield(
                      hint: "From",
                      controller: controller,
                      focusNode: focusnode,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              perMonth = true;
                              perYear = false;
                            });
                          },
                          icon: Icon(
                            perMonth
                                ? Icons.radio_button_checked_outlined
                                : Icons.radio_button_off,
                            color: perMonth
                                ? Constants.themeBgColor
                                : Constants.subtitleclr,
                          )),
                      customText(
                        title: "Per Month",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Constants.subtitleclr,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: CustomNormalTextfield(
                      hint: "upto",
                      controller: controller,
                      focusNode: focusnode,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              perMonth = false;
                              perYear = true;
                            });
                          },
                          icon: Icon(
                            perYear
                                ? Icons.radio_button_checked_outlined
                                : Icons.radio_button_off,
                            color: perYear
                                ? Constants.themeBgColor
                                : Constants.subtitleclr,
                          )),
                      customText(
                        title: "Per Year",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Constants.subtitleclr,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          const OnboardingTitle(
            title: "Qualification*",
          ),
          Row(
            children: [
              CustomToggleButton(
                title: "Under - Graduate",
                onTap: () {
                  setState(() {
                    undergraduate = true;
                    graduateandabove = false;
                  });
                },
                isSelect: undergraduate,
              ),
              CustomToggleButton(
                title: "Graduate or above",
                onTap: () {
                  setState(() {
                    graduateandabove = true;
                    undergraduate = false;
                  });
                },
                isSelect: graduateandabove,
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          CustomCheckboxRow(
            onChanged: (newValue) {
              setState(() {
                undergraduatewithreventExp = !undergraduatewithreventExp;
              }); // Notify Flutter that the state has changed
            },
            title: "Under Graduate with relevent experience can apply",
            value: undergraduatewithreventExp,
          )
          /*  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        // selectedKeyResponsible.contains(item)
                        Colors.grey,
                    width: 1.5,
                  ),
                ),
                height: 16,
                width: 20,
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    side: const BorderSide(color: Colors.white),
                    activeColor: Colors.white,
                    checkColor: Constants.blue,
                    visualDensity: VisualDensity.compact,
                    value: undergraduatewithreventExp,
                    onChanged: (newValue) {
                      setState(() {
                        undergraduatewithreventExp =
                            !undergraduatewithreventExp;
                      }); // Notify Flutter that the state has changed
                    },
                  ),
                ),
              ),
              customText(
                title: "Under Graduate with relevent experience can apply",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Constants.subtitleclr,
              ),
            ],
          ), */
        ],
      ),
    );
  }
}
