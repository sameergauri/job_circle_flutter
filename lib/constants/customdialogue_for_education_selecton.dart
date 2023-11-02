import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/profile/profile_summary.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';

class EducationSelectionDialog extends ConsumerStatefulWidget {
  final int id;
  const EducationSelectionDialog({super.key, required this.id});

  @override
  _EducationSelectionDialogState createState() =>
      _EducationSelectionDialogState();
}

class _EducationSelectionDialogState
    extends ConsumerState<EducationSelectionDialog> {
  bool isUnderGraduate = false;
  bool isGraduate = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          EdgeInsets.only(top: 10.h, left: 14, right: 14, bottom: 8),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Level of ",
                  style: GoogleFonts.varela(
                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Education",
                  style: GoogleFonts.varela(
                      color: Colors.blue,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isUnderGraduate = true;
                      isGraduate = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.themeBgColor),
                      color: isUnderGraduate
                          ? Constants.themeBgColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8),
                    child: Text(
                      "H.S.C",
                      style: GoogleFonts.varela(
                        fontWeight: isUnderGraduate
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isUnderGraduate ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isGraduate = true;
                      isUnderGraduate = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.themeBgColor),
                      color: isGraduate ? Constants.themeBgColor : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8),
                    child: Text(
                      "Graduate or above",
                      style: GoogleFonts.varela(
                        fontWeight:
                            isGraduate ? FontWeight.bold : FontWeight.normal,
                        color: isGraduate ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isGraduate || isUnderGraduate)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () async {
                        var payload = {
                          "stage": "education",
                          "data": {
                            "id": await Utils.getPreferencesValue(
                                null, ESharedPreferences.user_id.name),
                            "education": isGraduate ? 1 : 0,
                          }
                        };

                        await saveEducation(payload);
                        await JobPostApiService.DeletExperience(
                            widget.id, context, "edu");
                        ref.refresh(userDataProvider);
                        Navigator.pop(context);
                       
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(),
                        child: Text("Submit",
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.bold,
                                color: Constants.subtitleclr)),
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }

  saveEducation(data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      print("done");
    }
    setState(() {});
  }
}
