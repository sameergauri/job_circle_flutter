// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables, unused_element, unrelated_type_equality_checks
// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/model/business_ats/update_ats_model.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';
import 'package:job_circle/src/provider/business_ats/business_ats_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/utils/date_picker/custom_date_picker.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_call_sms_new_button.dart';
import 'package:job_circle/src/widgets/dialogue/custom_diaogue_for_non_contactable.dart';
import 'package:job_circle/src/widgets/list_tile/custom_list_tile_faq.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBottomShheetForAts {
  static Future<dynamic> show({
    required BuildContext context,
    required AtsApplicant applicantData,
  }) {
    bool isTodayOrPast(String doj) {
      DateTime dojDate;
      try {
        dojDate = DateFormat("dd MMM yyyy").parse(doj.trim());
      } catch (e) {
        // Fallback in case the string is empty, null, or invalid
        dojDate = DateTime.now();
      }

      // Current date without time part
      DateTime today = DateTime.now();
      DateTime todayOnlyDate = DateTime(today.year, today.month, today.day);

      // DOJ without time part
      DateTime dojOnlyDate = DateTime(dojDate.year, dojDate.month, dojDate.day);

      return dojOnlyDate.isBefore(todayOnlyDate) ||
          dojOnlyDate.isAtSameMomentAs(todayOnlyDate);
    }

    bool isYesterday(int dojMilliseconds) {
      DateTime dojDate = DateTime.fromMillisecondsSinceEpoch(dojMilliseconds);
      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

      return dojDate.year == yesterday.year &&
          dojDate.month == yesterday.month &&
          dojDate.day == yesterday.day;
    }

    final colors = context.appColors;

    final jobprovider = context.read<JobProvider>();

    return showModalBottomSheet(
      barrierColor: colors.headingColor!.withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      context: context,
      builder: (context) {
        final atsprovider = Provider.of<AtsProvider>(context, listen: false);
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: colors.bottomsheetbgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      title: "Available Action",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.darkBlue,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: colors.headingColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomcallsmsButton(
                      imageUrl: CustomIconUrl.callicon,
                      label: "Call",
                      onTap: () async {
                        FlutterPhoneDirectCaller.callNumber(
                          applicantData.contactNo.toString(),
                        );
                      },
                    ),
                    if (applicantData.alternateNo != null &&
                        applicantData.alternateNo != 0)
                      CustomcallsmsButton(
                        imageUrl: CustomIconUrl.callicon,
                        label: "Call",
                        onTap: () async {
                          FlutterPhoneDirectCaller.callNumber(
                            applicantData.alternateNo.toString(),
                          );
                        },
                      ),
                    CustomcallsmsButton(
                      imageUrl: CustomIconUrl.whatsappicon,
                      label: "Whatsapp",
                      onTap: () async {
                        int phone = applicantData.contactNo!;
                        var whatsappUrl = "whatsapp://send?phone=91$phone";
                        await launchUrl(Uri.parse(whatsappUrl));
                      },
                    ),
                    if (applicantData.alternateNo != null &&
                        applicantData.alternateNo != 0)
                      CustomcallsmsButton(
                        imageUrl: CustomIconUrl.whatsappicon,
                        label: "Whatsapp",
                        onTap: () async {
                          int phone = applicantData.alternateNo!;
                          var whatsappUrl = "whatsapp://send?phone=91$phone";
                          await launchUrl(Uri.parse(whatsappUrl));
                        },
                      ),
                  ],
                ),
                // TODO:: Application...
                if (applicantData.statusId == 1 ||
                    applicantData.statusId == 2 ||
                    applicantData.statusId == 4 ||
                    applicantData.statusId == 15) // For Application....
                  Column(
                    children: [
                      CustomListTileForBottomSheet(
                        subtitle: applicantData.statusId == 3
                            ? "Move candidate back into consideration."
                            : 'Proceed to schedule interview for this candidate.',
                        title: applicantData.statusId == 3
                            ? "Reschedule / Reconsider"
                            : "Schedule Interview",
                        imgurl: applicantData.statusId == 3
                            ? CustomIconUrl.rescheduleicon
                            : CustomIconUrl.scheduleicon,
                        onTap: () async {
                          Navigator.pop(context);
                          DateTime? date = await CustomDatePicker.selectDate(
                            context: context,
                            startDate: DateTime.now(),
                            isAddResume: false,
                            title: "Select Date Of Interview",
                          );
                          if (date != null) {
                            UpdateAtsModel updateAtsModel = UpdateAtsModel(
                              dateOfInterview: date,
                              statusId: 5,
                              status: "Lineup",
                              subStatus: "Blank",
                            );
                            await atsprovider.updateLead(
                              context,
                              updateAtsModel,
                              applicantData.leadId!,
                            );
                          }
                        },
                      ),
                      if (applicantData.statusId != 2 &&
                          applicantData.statusId !=
                              3) //Not display when substatus is non contactable.and screening reject
                        CustomListTileForBottomSheet(
                          subtitle:
                              'Candidate didn’t respond – mark as not contactable.',
                          title: "Not Contactable / Ringing",
                          imgurl: CustomIconUrl.notcontactableicon,
                          onTap: () {
                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return CustomDialogueForNotContactable(
                                  notcontact: true,
                                  hint: "Type to add",
                                  title: 'Not Contactable',
                                  onYes: () async {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: 2,
                                          status: "Application",
                                          subStatus: "Not Contacted",
                                          remark: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      if (applicantData.statusId !=
                          3) //Not display when substatus is Screening reject.
                        CustomListTileForBottomSheet(
                          subtitle:
                              'Candidate does not fulfill the initial screening criteria.',
                          title: "Not Eligible",
                          imgurl: CustomIconUrl.notelegibleicon,
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CustomDialogueForRemark(
                                  hint: "Reson of Not shortlist",
                                  title: 'Screening Reject',
                                  onYes: () async {
                                    if (atsprovider.remark.text.isNotEmpty) {
                                      Navigator.pop(context);
                                      UpdateAtsModel updateAtsModel =
                                          UpdateAtsModel(
                                            statusId: 3,
                                            status: "Application",
                                            subStatus: "Non Shortlisted",
                                            remark: atsprovider.remark.text,
                                          );
                                      await atsprovider.updateLead(
                                        context,
                                        updateAtsModel,
                                        applicantData.leadId!,
                                      );
                                    } else {
                                      CustomSnackbar.show(
                                        "Enter Remark to submit",
                                        true,
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      CustomListTileForBottomSheet(
                        subtitle: 'Candidate requested a call back.',
                        title: "Schedule Call Back",
                        imgurl: CustomIconUrl.callicon,
                        onTap: () async {
                          Navigator.pop(context);
                          DateTime? date = await CustomDatePicker.selectDate(
                            context: context,
                            startDate: DateTime.now(),
                            isAddResume: false,
                            title: "Select Date Of Interview",
                          );
                          if (date != null) {
                            UpdateAtsModel updateAtsModel = UpdateAtsModel(
                              callBackDateTime: date,
                              statusId: 15,
                              status: "Application",
                              subStatus: "Call Back",
                            );
                            await atsprovider.updateLead(
                              context,
                              updateAtsModel,
                              applicantData.leadId!,
                            );
                          }
                        },
                      ),
                      CustomListTileForBottomSheet(
                        subtitle:
                            'Remove this candidate from the current hiring process.',
                        title: "Remove from the hiring process",
                        imgurl: CustomIconUrl.revokdropicon,
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "feedback.",
                                title: 'Revoke / Drop / Hold',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: 6,
                                          status: "Lineup",
                                          subStatus: "Revoke/Drop",
                                          remark: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Remark to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      if (applicantData.statusId != 6 ||
                          applicantData.statusId != 2)
                        CustomListTileForBottomSheet(
                          subtitle:
                              'Move the candidate to another suitable apportunity.',
                          title: "Switch / Change Role",
                          imgurl: CustomIconUrl.callicon,
                          onTap: () {
                            Navigator.pop(context);
                            _showJobSelectionBottomSheet(
                              context,
                              atsprovider,
                              applicantData,
                              jobprovider.jobs,
                            );
                          },
                        ),
                      CustomListTileForBottomSheet(
                        subtitle: "Add a note or comment about this candidate",
                        title: "Add note",
                        imgurl: CustomIconUrl.addnotecon,
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "Type here to add note.",
                                title: 'Add Note',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: applicantData.statusId,
                                          notes: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Note to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                if (applicantData.statusId == 5) //For LineUp
                  Column(
                    children: [
                      CustomListTileForBottomSheet(
                        subtitle: "Candidate is selected.",
                        title: "Select",
                        imgurl: CustomIconUrl.calenderFiltericon,
                        onTap: () async {
                          Navigator.pop(context);
                          DateTime? date = await CustomDatePicker.selectDate(
                            context: context,
                            startDate: DateTime.now(),
                            isAddResume: false,
                            title: "Select Date Of Joining",
                          );
                          if (date != null || date == null) {
                            UpdateAtsModel updateAtsModel = UpdateAtsModel(
                              dateOfInterview: date,
                              statusId: 12,
                              status: "Select / Hired",
                              subStatus: "Blank / Offer",
                            );
                            await atsprovider.updateLead(
                              context,
                              updateAtsModel,
                              applicantData.leadId!,
                            );
                          }
                        },
                      ),
                      CustomListTileForBottomSheet(
                        subtitle: 'Candidate not selected.',
                        title: "Reject",
                        imgurl: CustomIconUrl.revokdropicon,
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "Feedback.",
                                title: 'Candidate has beed rejected',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: 9,
                                          status: "Interview bey",
                                          subStatus: "Reject",
                                          remark: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Remark to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      CustomListTileForBottomSheet(
                        subtitle: "Postponed or rescheduled the interview.",
                        title: "Reschedule Interview",
                        imgurl: CustomIconUrl.calenderFiltericon,
                        onTap: () async {
                          Navigator.pop(context);
                          DateTime? date = await CustomDatePicker.selectDate(
                            context: context,
                            startDate: DateTime.now(),
                            isAddResume: false,
                            title: "Select Date Of Interview",
                          );
                          if (date != null) {
                            UpdateAtsModel updateAtsModel = UpdateAtsModel(
                              dateOfInterview: date,
                              statusId: 5,
                              status: "Lineup",
                              subStatus: "Blank",
                            );
                            await atsprovider.updateLead(
                              context,
                              updateAtsModel,
                              applicantData.leadId!,
                            );
                          }
                        },
                      ),
                      CustomListTileForBottomSheet(
                        subtitle:
                            'Candiidate did not attend schedule interview.',
                        title: "Mark as No-Show",
                        imgurl: CustomIconUrl.revokdropicon,
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "Feedback.",
                                title: 'Mark as No-Show',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: 8,
                                          status: "Interview bey",
                                          subStatus: "Revoke/Drop/Hold",
                                          remark: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Remark to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      if (applicantData.statusId != 9)
                        CustomListTileForBottomSheet(
                          subtitle:
                              'Move the candidate to another suitable apportunity.',
                          title: "Switch / Change Role",
                          imgurl: CustomIconUrl.callicon,
                          onTap: () {
                            Navigator.pop(context);
                            _showJobSelectionBottomSheet(
                              context,
                              atsprovider,
                              applicantData,
                              jobprovider.jobs,
                            );
                          },
                        ),
                      CustomListTileForBottomSheet(
                        subtitle: "Add a note or comment about this candidate.",
                        title: "Add note",
                        imgurl: CustomIconUrl.addnotecon,
                        onTap: () {
                          Navigator.pop(context);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "Type here to add note.",
                                title: 'Add Note',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: applicantData.statusId,
                                          notes: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Note to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                if (applicantData.statusId == 3 ||
                    applicantData.statusId == 6 ||
                    applicantData.statusId == 8 ||
                    applicantData.statusId == 9) // Not Shortlisted
                  Column(
                    children: [
                      if (applicantData.statusId != 9)
                        CustomListTileForBottomSheet(
                          subtitle: "Postponed or rescheduled the interview.",
                          title: "Reschedule Interview",
                          imgurl: CustomIconUrl.calenderFiltericon,
                          onTap: () async {
                            Navigator.pop(context);
                            DateTime? date = await CustomDatePicker.selectDate(
                              context: context,
                              startDate: DateTime.now(),
                              isAddResume: false,
                              title: "Select Date Of Interview",
                            );
                            if (date != null) {
                              UpdateAtsModel updateAtsModel = UpdateAtsModel(
                                dateOfInterview: date,
                                statusId: 5,
                                status: "Lineup",
                                subStatus: "Blank",
                              );
                              await atsprovider.updateLead(
                                context,
                                updateAtsModel,
                                applicantData.leadId!,
                              );
                            }
                          },
                        ),
                      CustomListTileForBottomSheet(
                        subtitle:
                            'Move the candidate to another suitable apportunity.',
                        title: "Switch / Change Role",
                        imgurl: CustomIconUrl.callicon,
                        onTap: () {
                          Navigator.pop(context);
                          _showJobSelectionBottomSheet(
                            context,
                            atsprovider,
                            applicantData,
                            jobprovider.jobs,
                          );
                        },
                      ),
                      CustomListTileForBottomSheet(
                        subtitle: "Add a note or comment about this candidate.",
                        title: "Add note",
                        imgurl: CustomIconUrl.addnotecon,
                        onTap: () {
                          Navigator.pop(context);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "Type here to add note.",
                                title: 'Add Note',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: applicantData.statusId,
                                          notes: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Note to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                if (applicantData.statusId == 10 ||
                    applicantData.statusId == 11 ||
                    applicantData.statusId == 12 ||
                    applicantData.statusId == 13 ||
                    applicantData.statusId == 14) //For Onboarding
                  Column(
                    children: [
                      if (applicantData.statusId ==
                          12) //TODO:: Special join, notjoin and offerdecline visibile only for offer
                        Column(
                          children: [
                            if (applicantData.dojFormatted != null &&
                                isTodayOrPast(applicantData.dojFormatted!))
                              CustomListTileForBottomSheet(
                                subtitle:
                                    'Candidate has joined the organization.',
                                title: "Join",
                                imgurl: CustomIconUrl.joinicon,
                                onTap: () async {
                                  Navigator.pop(context);
                                  UpdateAtsModel updateAtsModel =
                                      UpdateAtsModel(
                                        statusId: 13,
                                        status: "Select / Hired",
                                        subStatus: "Join",
                                      );
                                  await atsprovider.updateLead(
                                    context,
                                    updateAtsModel,
                                    applicantData.leadId!,
                                  );
                                },
                              ),
                            if ((applicantData.dojFormatted != null &&
                                isTodayOrPast(applicantData.dojFormatted!)))
                              CustomListTileForBottomSheet(
                                subtitle:
                                    'Candidate did not report on joining date.',
                                title: "Not Join",
                                imgurl: CustomIconUrl.notjoinicon,
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CustomDialogueForRemark(
                                        hint: "Reason of not join.",
                                        title: 'Not Join',
                                        onYes: () async {
                                          if (atsprovider
                                              .remark
                                              .text
                                              .isNotEmpty) {
                                            Navigator.pop(context);
                                            UpdateAtsModel updateAtsModel =
                                                UpdateAtsModel(
                                                  statusId: 10,
                                                  status: "Select / Hired",
                                                  subStatus: "Not Join",
                                                  remark:
                                                      atsprovider.remark.text,
                                                );
                                            await atsprovider.updateLead(
                                              context,
                                              updateAtsModel,
                                              applicantData.leadId!,
                                            );
                                          } else {
                                            CustomSnackbar.show(
                                              "Enter Remark to submit",
                                              true,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            if (applicantData.dojFormatted == null ||
                                !isTodayOrPast(applicantData.dojFormatted!))
                              CustomListTileForBottomSheet(
                                subtitle:
                                    'Candidate backed out before joining.',
                                title: "Offer Decline",
                                imgurl: CustomIconUrl.offerdeclineicon,
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CustomDialogueForRemark(
                                        hint: "Reason of offer decline",
                                        title: 'Offer Decline',
                                        onYes: () async {
                                          if (atsprovider
                                              .remark
                                              .text
                                              .isNotEmpty) {
                                            Navigator.pop(context);
                                            UpdateAtsModel
                                            updateAtsModel = UpdateAtsModel(
                                              doj:
                                                  applicantData.dojFormatted ==
                                                      null
                                                  ? DateTime.now()
                                                  : applicantData.dojFormatted
                                                        as DateTime?,
                                              statusId: 11,
                                              status: "Select / Hired",
                                              subStatus: "Offer Decline",
                                              remark: atsprovider.remark.text,
                                            );
                                            await atsprovider.updateLead(
                                              context,
                                              updateAtsModel,
                                              applicantData.leadId!,
                                            );
                                          } else {
                                            CustomSnackbar.show(
                                              "Enter Remark to submit",
                                              true,
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      if (applicantData.statusId != 12 &&
                          applicantData.statusId != 13) // not offer and join
                        CustomListTileForBottomSheet(
                          subtitle:
                              "Postponed or rescheduled the candidate's interview",
                          title: "Reconsider / Ready to join",
                          imgurl: CustomIconUrl.rescheduleicon,
                          onTap: () async {
                            DateTime? date = await CustomDatePicker.selectDate(
                              context: context,
                              startDate: DateTime.now(),
                              isAddResume: false,
                              title: "Select Date of Joining",
                            );

                            if (date != null) {
                              Navigator.pop(context);
                              UpdateAtsModel updateAtsModel = UpdateAtsModel(
                                statusId: 12,
                                status: "Select / Hired",
                                subStatus: "Blank / Offer",
                                doj: date,
                              );
                              await atsprovider.updateLead(
                                context,
                                updateAtsModel,
                                applicantData.leadId!,
                              );
                            }
                          },
                        ),
                      if (applicantData.statusId == 12 &&
                          applicantData.dojFormatted ==
                              null) //only for offer substatus
                        CustomListTileForBottomSheet(
                          subtitle: "Add the candidate's joining date.",
                          title: "Date of Joining",
                          imgurl: CustomIconUrl.calenderFiltericon,
                          onTap: () async {
                            DateTime? date = await CustomDatePicker.selectDate(
                              context: context,
                              startDate: DateTime.now(),
                              isAddResume: false,
                              title: "Select Date of Joining",
                            );

                            if (date != null) {
                              Navigator.pop(context);
                              UpdateAtsModel updateAtsModel = UpdateAtsModel(
                                doj: date,
                                statusId: applicantData.statusId,
                              );
                              await atsprovider.updateLead(
                                context,
                                updateAtsModel,
                                applicantData.leadId!,
                              );
                            }
                          },
                        ),
                      if (applicantData.statusId == 13) //only for join.
                        CustomListTileForBottomSheet(
                          subtitle: 'Left the job after successful joining.',
                          title: "Dropout",
                          imgurl: CustomIconUrl.dropouticon,
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CustomDialogueForNotContactable(
                                  notcontact: false,
                                  hint: "Reason of dropout.",
                                  title: 'Trainig Dropout',
                                  onYes: () async {
                                    if (atsprovider.remark.text.isNotEmpty) {
                                      Navigator.pop(context);
                                      UpdateAtsModel updateAtsModel =
                                          UpdateAtsModel(
                                            statusId: 14,
                                            status: "Select / Hired",
                                            subStatus: "Dropout",
                                            remark: atsprovider.remark.text,
                                          );
                                      await atsprovider.updateLead(
                                        context,
                                        updateAtsModel,
                                        applicantData.leadId!,
                                      );
                                    } else {
                                      CustomSnackbar.show(
                                        "Enter Remark to submit",
                                        true,
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      if (applicantData.statusId == 12 &&
                          applicantData.dojFormatted != null &&
                          applicantData.dojFormatted != "")
                        CustomListTileForBottomSheet(
                          subtitle: 'Modify the date of joining.',
                          title: "Batch Postpond",
                          imgurl: CustomIconUrl.changedojicon,
                          onTap: () async {
                            DateTime? date = await CustomDatePicker.selectDate(
                              context: context,
                              startDate: DateTime.now(),
                              isAddResume: false,
                              title: "Select Date of Joining",
                            );
                            if (date != null) {
                              Navigator.pop(context);
                              UpdateAtsModel updateAtsModel = UpdateAtsModel(
                                doj: date,
                                statusId: applicantData.statusId,
                              );
                              await atsprovider.updateLead(
                                context,
                                updateAtsModel,
                                applicantData.leadId!,
                              );
                            }
                          },
                        ),
                      CustomListTileForBottomSheet(
                        subtitle: "Add a note or comment about this candidate",
                        title: "Add note",
                        imgurl: CustomIconUrl.addnotecon,
                        onTap: () {
                          Navigator.pop(context);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CustomDialogueForRemark(
                                hint: "Type here to add note",
                                title: 'Add Note',
                                onYes: () async {
                                  if (atsprovider.remark.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    UpdateAtsModel updateAtsModel =
                                        UpdateAtsModel(
                                          statusId: applicantData.statusId,
                                          notes: atsprovider.remark.text,
                                        );
                                    await atsprovider.updateLead(
                                      context,
                                      updateAtsModel,
                                      applicantData.leadId!,
                                    );
                                  } else {
                                    CustomSnackbar.show(
                                      "Enter Note to submit",
                                      true,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Second bottom sheet for "Switch / Change Role": pick which of the
  /// candidate-user's own jobseeker-posted jobs to move this lead to.
  static void _showJobSelectionBottomSheet(
    BuildContext context,
    AtsProvider atsprovider,
    AtsApplicant applicantData,
    List<JobContent> allJobs,
  ) {
    final colors = context.appColors;
    final int currentUserId = SharedPrefsHelper.getInt(
      ESharedPreferences.user_id,
    );
    final jobs = allJobs
        .where(
          (job) =>
              job.spoc == currentUserId &&
              job.postedByType != null &&
              job.postedByType == "JOBSEEKER",
        )
        .toList();

    int? selectedJobId;

    showModalBottomSheet(
      barrierColor: colors.headingColor!.withValues(alpha: 0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: colors.bottomsheetbgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        title: "Select Job",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.darkBlue,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: colors.headingColor,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: jobs.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: customText(
                              title: "No jobs found",
                              color: colors.subTitleColor,
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: jobs.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              final isSelected = selectedJobId == job.id;
                              return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: customText(
                                    title:
                                        job.jobHeadline != null &&
                                            job.jobHeadline!.isNotEmpty
                                        ? job.jobHeadline!
                                        : (job.roleForBusinessHiring ?? 'Job'),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colors.headingColor,
                                  ),
                                  trailing: Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? Constants.darkgreen
                                        : colors.subTitleColor,
                                  ),
                                  onTap: () {
                                    setModalState(() {
                                      selectedJobId = job.id;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  if (selectedJobId != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          UpdateAtsModel updateAtsModel = UpdateAtsModel(
                            jobid: selectedJobId,
                          );
                          await atsprovider.updateLead(
                            context,
                            updateAtsModel,
                            applicantData.leadId!,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.darkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CustomListTileForBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgurl;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool? asseticon;
  final int? index;
  final bool? addcompany;
  const CustomListTileForBottomSheet({
    super.key,
    required this.subtitle,
    required this.title,
    required this.imgurl,
    required this.onTap,
    this.iconColor,
    this.addcompany,
    this.asseticon,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: CustomListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          children: [
            asseticon != null && asseticon == true
                ? Container(
                    padding: const EdgeInsets.all(4),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: iconColor != null
                        ? Image.asset(imgurl, fit: BoxFit.cover)
                        : Image.asset(
                            imgurl,
                            fit: BoxFit.cover,
                            color: colors.subTitleColor,
                          ),
                  )
                : Container(
                    padding: const EdgeInsets.all(4),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: iconColor != null
                        ? Image.network(imgurl, fit: BoxFit.cover)
                        : Image.network(
                            imgurl,
                            fit: BoxFit.cover,
                            color: colors.subTitleColor,
                          ),
                  ),
            if (addcompany != null && addcompany == true)
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.add_circle_outlined,
                  color: Constants.darkgreen,
                ),
              ),
            if (index != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: index == 0
                    ? const Icon(Icons.cancel, color: Constants.red)
                    : const Icon(
                        Icons.check_circle,
                        color: Constants.darkgreen,
                      ),
              ),
          ],
        ),
        title: customText(
          title: title,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.headingColor,
        ),
        subtitle: customText(
          title: subtitle,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.subTitleColor,
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }
}
