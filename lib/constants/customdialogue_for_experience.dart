// ignore_for_file: unused_local_variable, unused_result, library_private_types_in_public_api, deprecated_member_use, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';

class MyCustomDialogForExperience extends ConsumerStatefulWidget {
  final Experience e;
  final Function(bool) onYes;
  final Function(bool) onNo;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const MyCustomDialogForExperience(
      {super.key,
      required this.e,
      required this.onYes,
      required this.onNo,
      required this.selectedDate,
      required this.onDateSelected});

  @override
  _MyCustomDialogForExperienceState createState() =>
      _MyCustomDialogForExperienceState();
}

class _MyCustomDialogForExperienceState
    extends ConsumerState<MyCustomDialogForExperience> {
  DateTime? selectedDate;

  /*  void _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Store the selected date
      });
    }
  } */

  void _openDatePicker(Experience e) async {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    // DateTime initialDate = e.joiningDate ?? DateTime.now();
    // DateTime firstDate = e.joiningDate ?? DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime initialDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate; // Store the selected date
      });
    }
  }

  SnackBar customSnackbar(String title, bool error) {
    return SnackBar(
      elevation: 1.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: Constants.themeBgColorLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 8), // Remove shadow
      content: Expanded(
        child: Row(
          children: [
            error
                ? Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                    size: 15.h,
                  )
                : Image.asset(
                    "assets/images/check.png",
                    color: Constants.themeBgColor,
                    height: 15.h,
                  ),
            /* Icon(
                    Icons.check,
                    color: Constants.themeBgColor,
                    size: 15.h,
                  ),  */ // Add an icon if needed
            const SizedBox(width: 8.0), // Add spacing between icon and text
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 14.0,
                  // Text size
                ),
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      // duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Define your custom logic here to determine whether the dialog should close or not.
        // Return true to allow the dialog to close or false to prevent it from closing.
        return false; // Change this as needed.
      },
      child: AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 10.h, left: 14, right: 14, bottom: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Add",
                  style: GoogleFonts.varela(),
                ),
                Text(
                  " End Date",
                  style: GoogleFonts.varela(color: Colors.blue),
                ),
                Text(
                  " of previous company",
                  style: GoogleFonts.varela(),
                )
              ],
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
              // ignore: sized_box_for_whitespace
              leading: Container(
                width: 70.w,
                height: 70.h,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(15),
                //   border: Border.all(
                //     color: Colors.transparent,
                //   ),
                // ),
                child: Image.network(
                  widget.e.companyLogo == null || widget.e == ""
                      ? "https://cdn-icons-png.flaticon.com/128/2098/2098316.png"
                      : "https://s3.ap-south-1.amazonaws.com/job-circle-2/${widget.e.companyLogo}",
                  //  "https://cdn-icons-png.flaticon.com/128/10693/10693407.png",
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                widget.e.jobTitle.toString(),
                // experience.job_title.toString(),
                style: GoogleFonts.varela(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                         widget.e.companyLogo.toString(),
                        // experience.company_name.toString(),
                        style: GoogleFonts.varela(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(" · "),
                      Text(
                        widget.e.empType.toString(),
                        style: GoogleFonts.varela(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        widget.e.joiningDate != null?widget.e.joiningDate.toString():"",
                           /*  ? DateFormat('MMM-yyyy')
                                .format(widget.e.joiningDate!).to
                            : "", */
                        /*  experienceList[index].joining_date != null
                                                                ? experienceList[index].joining_date.toString()
                                                                : "", */
                        // '$formattedJoiningDate - $formattedLastWorkingDate ($experience)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (widget.e.last_working_date != null)
                        SizedBox(
                          child: Row(
                            children: [
                              const Text(" - "),
                              Text(
                                DateFormat('MMM-yyyy')
                                    .format(widget.e.last_working_date!),

                                /*  experienceList[index].joining_date != null
                                                                      ? experienceList[index].joining_date.toString()
                                                                      : "", */
                                // '$formattedJoiningDate - $formattedLastWorkingDate ($experience)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.e.last_working_date == null)
                        SizedBox(
                          child: Row(
                            children: [
                              const Text(" - "),
                              InkWell(
                                onTap: () {
                                  _openDatePicker(widget.e);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 6, right: 6, top: 4, bottom: 4),
                                  child: Text(
                                    selectedDate == null
                                        ? 'End Date'
                                        : DateFormat('MMM-yyyy')
                                            .format(selectedDate!),
                                    style: GoogleFonts.varela(
                                      color: Colors.blue,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      /* if (experienceList[index].joining_date != null &&
                                                              experienceList[index].last_working_date != null)
                                                            Text(
                                                              " (${monthsDifference.toString()}m)",
                                                              style: GoogleFonts.varela(
                                                                fontSize: 12.sp,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ) */
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.e.jobLocation.toString(),
                        // experience.company_location.toString(),
                        style: GoogleFonts.varela(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(" · "),
                      Text(
                        widget.e.workType.toString(),
                        // experience.company_location.toString(),
                        style: GoogleFonts.varela(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(
                            () {
                              widget.onNo(true);
                              widget.onYes(false);
                              // selectedLastDateofPrevious = null;
                            },
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 10.w),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.varela(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          // Retrieve the form data

                          // Create a new instance of the model and assign the values
                          Experience experience = Experience(
                              id: widget.e.id,
                             /*  userId: widget.e.userId,
                              job_title: widget.e.job_title,
                              company_name: widget.e.company_name,
                              isCurrent: 0,
                              description: widget.e.description,
                              skills_exp: widget.e.skills_exp,
                              work_type: widget.e.work_type,
                              company_location: widget.e.company_location,
                              emptype: widget.e.emptype,
                              joining_date: widget.e.joining_date,
                              last_working_date: selectedDate,
                              salary: widget.e.salary,
                              ismonthly: widget.e.ismonthly,
                              offer_letter: widget.e.offer_letter,
                              appointment_letter: widget.e.appointment_letter,
                              salary_slip: widget.e.salary_slip,
                              increment_letter: widget.e.increment_letter,
                              experience_lettter: widget.e.experience_lettter,
                              icon: widget.e.icon,
                              availability: widget.e.availability,
                              companyid: widget.e.companyid */
                              // working: working,
                              );

                          // Create an instance of UserDataService
                          UserDataService userDataService = UserDataService();
                          //  selectedLastDateofPrevious,
                          if (selectedDate != null) {
                            await userDataService
                                .saveUserExperience(experience.toJson());
                            ref.refresh(userDataProvider);

                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar(
                                    " last working date for your previous job has been updated.",
                                    false));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar("Add End Date.", true));
                          }
                          // Call the saveUserExperience method on the instance
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 10.w),
                          child: Text(
                            "Submit",
                            style:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              /* trailing: InkWell(
                                                      onTap: () {
                                                        sendToExperience(experienceList[index]
                                                            // experience
                                                            ); // Pass the selected experience object
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.only(left: 10, right: 4, bottom: 10),
                                                        child: Icon(Icons.edit_outlined, size: 18.h),
                                                      )), */
            ),
          ],
        ),
      ),
    );
  }
}
