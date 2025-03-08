// ignore_for_file: unused_result, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/screens/Manager/constant/custom_snackbar.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationSelectionDialog extends ConsumerStatefulWidget {
  final int id;
  final String text;
  final String type;
  final int? explegth;
  const EducationSelectionDialog(
      {super.key,
      required this.id,
      required this.text,
      required this.type,
      this.explegth});

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      contentPadding:
          const EdgeInsets.only(top: 20, left: 14, right: 14, bottom: 20),
      content: SizedBox(
        // width: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextForWeather(
                title: "Delete ${widget.text} Permanently?",
                fontSize: 16,
                softwrap: true,
                fontWeight: FontWeight.bold),
            SizedBox(
              height: 10.h,
            ),
            customTextForHind(
                title:
                    "If you delete this ${widget.text}, you won't be able to recover it. Do you want to delete it?",
                fontSize: 12,
                softwrap: true,
                color: Constants.subtitleclr,
                fontWeight: FontWeight.normal),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    _handleDeleteAction();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.darkBlue),
                      color: Constants.darkBlue,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8),
                    child: Text(
                      "Yes",
                      style: GoogleFonts.varela(
                        fontWeight: isUnderGraduate
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.subtitleclr),
                      color: isGraduate ? Constants.darkBlue : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8),
                    child: Text(
                      "No",
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
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteAction() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    String message;
    if (widget.type == "exp") {
      if (widget.explegth != null && widget.explegth == 1) {
        /*  ProfileUpdateRequestDto profileUpdateRequestDto =   //TODO:: uncomment when experience field added to api..
            ProfileUpdateRequestDto(
                id: await Utils.getPreferencesValue(
                    prefs, ESharedPreferences.user_id.name),
                experience: 0);

        UserUpdateRequestModel userUpdateRequestModel = UserUpdateRequestModel(
            certificationsRequestDtos: null,
            educationRequestDtos: null,
            experienceRequestDtos: null,
            profileUpdateRequestDto: profileUpdateRequestDto);
        await JobPostApiService.PostUserInfo(
          userUpdateRequestModel,
        ); */
        await JobPostApiService.DeletExperience(
            widget.id, context, "deleteExpById");
      } else {
        await JobPostApiService.DeletExperience(
            widget.id, context, "deleteExpById");
      }

      message = "Experience Deleted Successfully.";
    } else if (widget.type == "edu") {
      await JobPostApiService.DeletEducaton(widget.id, context);
      message = "Qualification Deleted Successfully.";
    } else {
      await JobPostApiService.DeletExperience(
          widget.id, context, "deleteCertById");
      message = "Certificate Deleted Successfully.";
    }

    CustomSnackbar.show(message, true);
    ref.refresh(ProfileDataProvider);
    Navigator.pop(context);
    if (widget.explegth != null && widget.explegth != 1) {
      Navigator.pop(context);
    }
  }
}
