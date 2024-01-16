/* import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  Widget listViewItem_new1(
      BuildContext context,
      Applicant item,
      bool isTrue,
      List<String> status,
      int id,
      int index,
      List<DropDownItem> dropDownModel) {
    bool isRejected = false,
        isOfferDrop = false,
        isWalkOut = false,
        isDropOut = false,
        isNotJoin = false;

    // spocController.text =
    // "${userRole.runtimeType} ${userModel.lastName} -  ${userModel.role}";

    List<String> finalinterviewRounds = item.inteviewrounds
            ?.map((round) => round
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', ''))
            .expand((formattedRound) => formattedRound.split(', '))
            .toList() ??
        [];

    /* String? getInitialValue() {
      if (selectedRoundsMap[item.id] != null &&
          selectedRoundsMap[item.id]!.isNotEmpty &&
          finalinterviewRounds.contains(selectedRoundsMap[item.id]!)) {
        return selectedRoundsMap[item.id]!;
      } else if (finalinterviewRounds.isNotEmpty) {
        return finalinterviewRounds[0];
      } else {
        return null;
      }
    } */

    //final isDropOut = selectedoption[item.id] ?? false;

    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime today = DateTime.now();
    DateTime? doj;
    if (item.doj != null) {
      doj = DateTime(item.doj!.year, item.doj!.month, item.doj!.day);
    }
    DateTime today1 = DateTime(today.year, today.month, today.day);

    bool isToday = doj != null && doj.isAtSameMomentAs(today1);

    DateTime yesterday = today1.subtract(const Duration(days: 1));
    bool isYesterday = doj != null && doj.isAtSameMomentAs(yesterday);

    DateTime initialDate = DateTime.now();
    DateTime lastAllowedDate = DateTime.now().add(const Duration(days: 4 * 31));
    DateTime? singleSelect;

    // Replace with your stored date
    const Duration threshold = Duration(days: 6); // 6 days threshold

    bool isWithinThreshold(DateTime currentDate) {
      return doj != null
          ? currentDate.isAfter(doj.subtract(threshold)) &&
              currentDate.isBefore(doj)
          : false;
    }

    bool isDateWithinThreshold = isWithinThreshold(today1);

    Future<void> singleSelectPicker() async {
      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return AwesomeCalendarDialog(
            initialDate: initialDate,
            startDate: initialDate,
            endDate: lastAllowedDate,
            selectionMode: SelectionMode.single,
            cancelBtnText: "",
            confirmBtnText: "Submit",
          );
        },
      );
      if (picked != null) {
        setState(() {
          singleSelect = picked;
        });
        print(picked);
        ChangeStatusModel changeStatusModel = ChangeStatusModel(
          status: "IB7",
          subStatus: "Confirmation Pending",
          doj: picked,
          id: item.id,
          sourceId: item.sourceId,
        );
        Map<String, dynamic> jsonData = changeStatusModel.toJson();
        try {
          await JobPostApiService.changeStatus(jsonData, item.id!.toInt());
          ref.refresh(fetchAllApplicantProvider);
          setState(() {});
          // First pop to close the dialog
        } catch (e) {
          print('Error: $e');
          // Handle error...
        }
      }
    }

    // List<String>? myStrings;
    //  bool stopIteration = false;
    /*  int jobId =
        item.id!.toInt(); // Replace with the actual ID or unique identifier
    if (!jobToggleStates.containsKey(jobId)) {
      jobToggleStates[jobId] = true; // Initialize the toggle state for this job
    } */
    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (item.status_id != 10) {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TalentPoolDetail(
                            applicant: item,
                            Status: status,
                          ))); */
            } else {
              ChangeStatusModel changeStatusModel = ChangeStatusModel(
                  status: "TP2", sourceId: id, subStatus: "View");
              Map<String, dynamic> jsonData = changeStatusModel.toJson();
              try {
                JobPostApiService.changeStatus(jsonData, item.id!.toInt());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Recruitz()));
                setState(() {});
                /* showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      fetchDataFromApi: () {},
                      isFisrt: false,
                      onClose: () {
                        Navigator.pop(context);
                      },
                      title: "Success",
                      subtitle: "Submitted successfully!",
                    );
                  },
                ); */
              } catch (e) {
                print('Error: $e');
              }
            }
            setState(() {});
            setState(() {});
            /*  item.status == "Application"
                ? null
                : Navigator.pushNamed(
                    context,
                    ERoute.jobsdetail.name,
                    arguments: {
                      'id': item.jobId,
                    },
                  ); */
          },
          child: SwipeTo(
            iconOnRightSwipe: Icons.call,
            iconOnLeftSwipe: Icons.sms_outlined,
            /* onRightSwipe: item.alternateNo == 0 || item.alternateNo == null   //TODO siwpe to call
                ? () async {
                    FlutterPhoneDirectCaller.callNumber("+91${item.contactNo}");
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return item.alternateNo != null
                            ? CustomAlertDialog(
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                isCall: true,
                              )
                            : const SizedBox();
                      },
                    );
                  },
            onLeftSwipe: item.alternateNo == 0 || item.alternateNo == null
                ? () async {
                    Uri url =
                        Uri.parse("whatsapp://send?phone=91${item.contactNo}");
                    await canLaunchUrl(url)
                        ? await launchUrl(url)
                        : throw "could not launch $url";
                  }
                : (details) {
                    // handle left swipe with DragUpdateDetails
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          phoneNumber1: int.parse(item.contactNo.toString()),
                          phoneNumber2: int.parse(item.alternateNo.toString()),
                          isCall: false,
                        );
                      },
                    );
                  }, */
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0.5, 2),
                        blurRadius: 2,
                        spreadRadius: 2,
                        color: Colors.grey.shade200)
                  ],
                  borderRadius: BorderRadius.circular(8.r)),
              /*   shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                //set border radius more than 50% of height and width to make circle
              ),
              // shadowColor: Constants.themeBgColor,
              elevation: 4, */

              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (item.gender != null)
                            item.profilePic != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.profilePic}"),
                                    // child: Text(item.applicantName[0].toUpperCase()),
                                    radius: 22,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Constants.bgColorWhite,
                                    backgroundImage: AssetImage(
                                        item.gender == "Male"
                                            ? "assets/images/leadmale.png"
                                            : "assets/images/leadfemal.png"),
                                    // child: Text(item.applicantName[0].toUpperCase()),
                                    radius: 22,
                                  ),
                          if (item.gender == null)
                            item.profilePic != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.profilePic}"),
                                    // child: Text(item.applicantName[0].toUpperCase()),
                                    radius: 22,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Constants.borderColor,
                                    // child: Text(item.applicantName[0].toUpperCase()),
                                    radius: 22,
                                    child: Text(
                                      item.applicantName!.isNotEmpty
                                          ? item.applicantName![0].toUpperCase()
                                          : 'N', // Default to 'N' if the name is empty
                                      style: const TextStyle(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                          /* const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://media.istockphoto.com/id/503040171/photo/middle-eastern-businessman-portrait.jpg?s=612x612&w=0&k=20&c=7t6c_HQHfUZNgrVtR-G1rQpJAMaCbFsuxppDRKBnXDw="),
                            // child: Text(item.applicantName[0].toUpperCase()),
                            radius: 22,
                          ), */
                          const SizedBox(
                            width: 6,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${item.applicantName.toString().toTitleCase()} ${item.last_name.toString().toTitleCase()}",
                                    style: GoogleFonts.varela(
                                      fontStyle: FontStyle.normal,
                                      // color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.status_code != "IB7" &&
                                      item.dateOfBirth != null)
                                    Text(
                                      " (${calculateAge(item.dateOfBirth.toString())} yr's)",
                                      style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          fontSize: 12.sp),
                                    )
                                ],
                              ),
                              if (item.status_id != 17 &&
                                  item.status_id != 24 &&
                                  item.status_code != "IB4")
                                Row(
                                  children: [
                                    item.qualification == null
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/bag.png",
                                                height: 12.h,
                                                //  color: Constants.subtitleclr,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                item.isExperienced.toString(),
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/graduate.png",
                                                height: 15.h,
                                                //  color: Constants.subtitleclr,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "${item.qualification.toString()}  |  ",
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/images/bag.png",
                                                height: 12.h,
                                                //  color: Constants.subtitleclr,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                " ${item.isExperienced}",
                                                style: GoogleFonts.varela(
                                                  color: Colors.black54,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              if (item.status_code == "IB7" ||
                                  item.status_code == "IB5" ||
                                  item.status_code == "IB4")
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Constants.borderColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.role_code != null &&
                                                item.role_code != ""
                                            ? "${item.process} - ${item.role_code}"
                                            : "${item.process} - ${item.lead_level}",
                                        style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if ((item.status_id != 17 &&
                              item.status_code != "IB8" &&
                              item.status_id != 24) &&
                          !isDropOut)
                        Wrap(
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: List.generate(
                                applicationList!
                                    .where((option) =>
                                        option.code!.contains('IB8:3'))
                                    .length,
                                (index) {
                                  final option = applicationList!
                                      .where((option) =>
                                          option.code!.contains('IB8:3'))
                                      .toList()[index];
                                  return InkWell(
                                    onTap: option.code != "IB8:3"
                                        ? () {
                                          
                                          }
                                        : () {
                                            setState(() {
                                              isDropOut = !isDropOut;
                                            });
                                          },
                                    child: Wrap(
                                      children: [
                                        //  if (option.code != "IB8:1")
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, right: 6),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: Colors.grey.shade100,
                                            border: Border.all(
                                                color: Constants.borderColor),
                                          ),
                                          child: Text(
                                            option.code != "IB5:2"
                                                ? option.value.toString()
                                                : "F2F Interview",
                                            style: GoogleFonts.varela(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CustomDialogueForNew(
                                      title: 'Register ',
                                      title2: "for an Interview.",
                                      company_name: item.companyName.toString(),
                                      nature_of_work:
                                          item.natureOfWork.toString(),
                                      process: item.process.toString(),
                                      role: item.lead_level.toString(),
                                      companyId: item.short_list_for!.toInt(),
                                      item: item,
                                      refreshCallback: () {
                                        ref.refresh(fetchAllApplicantProvider);
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 6, right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.grey.shade100,
                                  border:
                                      Border.all(color: Constants.borderColor),
                                ),
                                child: Text(
                                  "Schedule Interview",
                                  style: GoogleFonts.varela(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),


                      if ((item.status_id != 10 && item.status_id != 17) &&
                          item.status_id != 24 &&
                          item.status_code != "IB4")
                        Container(
                          decoration: BoxDecoration(
                              color: Constants.borderColor,
                              /* border: Border.all(color: Constants.borderColor
                      ), */
                              // color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(bottom: 2, top: 6.h),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          // padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.status_id !=
                                          24 && //TODO: id of intterviewBay..
                                      item.status_id !=
                                          17) //TODO: if of select..
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        item.status_id ==
                                                24 //TODO: id of intterviewBay..
                                            ? item.short_name.toString()
                                            : item.companyName.toString(),
                                        style: GoogleFonts.varela(
                                          color: Colors.black54,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (item.status_code != "IB7")
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 4),
                                      decoration: BoxDecoration(
                                          color: Constants.borderColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.role_code != null &&
                                                    item.role_code != ""
                                                ? "${item.process} - ${item.role_code}"
                                                : "${item.process} - ${item.lead_level}",
                                            style: GoogleFonts.varela(
                                              color: Colors.black54,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              
                              ),
                            ],
                          ),
                        ),
                      //TODO: to add document status as per document mode.

                      if (item.status_id == 17 && item.mode_document == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Documentation Status :"),
                            SizedBox(
                              height: 4.h,
                            ),
                            Wrap(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (item.document_status !=
                                            "Under Review" &&
                                        item.document_status != "Submitted" &&
                                        item.document_status !=
                                            "Not Submitted") {
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                        /* status: "IB7",
                                        subStatus: item.sub_code == "IB7-4"
                                            ? "Ready to Join"
                                            : "Confirmation Pending", */
                                        status: item.status_code,
                                        subStatus: item.sub_status,
                                        doj: item.doj,
                                        id: item.id,
                                        sourceId: item.sourceId,
                                        document_status: "Not Submitted",
                                      );
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
                                        setState(() {});

                                        // First pop to close the dialog
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: item.document_status !=
                                              "Under Review" &&
                                          item.document_status != "Submitted"
                                      ? Container(
                                          margin: EdgeInsets.only(right: 6.w),
                                          decoration: BoxDecoration(
                                              color: item.document_status ==
                                                      "Not Submitted"
                                                  ? Colors.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color:
                                                      Constants.borderColor)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Text("Not Submitted",
                                              style: GoogleFonts.varela(
                                                  color: item.document_status ==
                                                          "Not Submitted"
                                                      ? Colors.white
                                                      : Colors.black)),
                                        )
                                      : disableContainer("Not Submitted"),
                                ),
                                InkWell(
                                    onTap: () async {
                                      if (item.document_status != "Submitted" &&
                                          item.document_status !=
                                              "Under Review") {
                                        ChangeStatusModel changeStatusModel =
                                            ChangeStatusModel(
                                                /* status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending", */
                                                status: item.status_code,
                                                subStatus: item.sub_status,
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status:
                                                    "Under Review");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
                                          setState(() {});
                                          // First pop to close the dialog
                                        } catch (e) {
                                          print('Error: $e');
                                          // Handle error...
                                        }
                                      }
                                    },
                                    child: item.document_status != "Submitted"
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            decoration: BoxDecoration(
                                                color: item.document_status ==
                                                        "Under Review"
                                                    ? Colors.orangeAccent
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        Constants.borderColor)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text("Under Review",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        item.document_status ==
                                                                "Under Review"
                                                            ? Colors.white
                                                            : Colors.black)),
                                          )
                                        : disableContainer("Under Review")),
                                InkWell(
                                  onTap: () async {
                                    if (item.document_status ==
                                            "Under Review" ||
                                        item.document_status ==
                                                "Not Submitted" &&
                                            item.mode_document == 1) {
                                      setState(() {
                                        notSubmited = false;
                                        submited = true;
                                        under = false;
                                      });
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                              /* status: "IB7",
                                              subStatus:
                                                  item.sub_code == "IB7-4"
                                                      ? "Ready to Join"
                                                      : "Confirmation Pending", */
                                              status: item.status_code,
                                              subStatus: item.sub_status,
                                              doj: item.doj,
                                              id: item.id,
                                              sourceId: item.sourceId,
                                              document_status: "Submitted");
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());

                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
                                        setState(() {});
                                        // First pop to close the dialog
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 6.w),
                                    decoration: BoxDecoration(
                                        color: item.document_status ==
                                                    "Submitted" &&
                                                item.mode_document == 1
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                            color: Constants.borderColor)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("Submitted",
                                        style: GoogleFonts.varela(
                                            color: item.document_status ==
                                                        "Submitted" &&
                                                    item.mode_document == 1
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            )
                          ],
                        ),

                      if (item.status_code == "IB7" && item.mode_document == 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Documentation Status :"),
                            SizedBox(
                              height: 4.h,
                            ),
                            Wrap(
                              children: [
                                InkWell(
                                    onTap: () async {
                                      if (item.document_status != "Pending" &&
                                          item.document_status != "Submitted" &&
                                          item.document_status !=
                                              "Schedule F2F" &&
                                          item.mode_document == 0) {
                                        ChangeStatusModel changeStatusModel =
                                            ChangeStatusModel(
                                                /*   status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending", */
                                                status: item.status_code,
                                                subStatus: item.sub_status,
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status:
                                                    "Schedule F2F");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
                                          setState(() {});
                                          // First pop to close the dialog
                                        } catch (e) {
                                          print('Error: $e');
                                          // Handle error...
                                        }
                                      }
                                    },
                                    child: item.document_status != "Pending" &&
                                            item.document_status !=
                                                "Submitted" &&
                                            item.mode_document == 0
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            decoration: BoxDecoration(
                                                color: item.document_status ==
                                                        "Schedule F2F"
                                                    ? Colors.amber
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        Constants.borderColor)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text("Schedule F2F",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        item.document_status ==
                                                                "Schedule F2F"
                                                            ? Colors.white
                                                            : Colors.black)),
                                          )
                                        : disableContainer("Schedule F2F")),
                                InkWell(
                                    onTap: () async {
                                      if (item.document_status != "Submitted" &&
                                          item.document_status != "Pending" &&
                                          item.mode_document == 0) {
                                        ChangeStatusModel changeStatusModel =
                                            ChangeStatusModel(
                                                /* status: "IB7",
                                                subStatus: item.sub_code ==
                                                        "IB7-4"
                                                    ? "Ready to Join"
                                                    : "Confirmation Pending", */
                                                status: item.status_code,
                                                subStatus: item.sub_status,
                                                doj: item.doj,
                                                id: item.id,
                                                sourceId: item.sourceId,
                                                document_status: "Pending");
                                        Map<String, dynamic> jsonData =
                                            changeStatusModel.toJson();
                                        try {
                                          await JobPostApiService.changeStatus(
                                              jsonData, item.id!.toInt());

                                          ref.refresh(
                                              fetchAllApplicantProvider);
                                          ref.refresh(fetchAllReferalProvider);
                                          ref.refresh(fetchAllApplyProvider);
                                          setState(() {});
                                          // First pop to close the dialog
                                        } catch (e) {
                                          print('Error: $e');
                                          // Handle error...
                                        }
                                      }
                                    },
                                    child: item.document_status !=
                                                "Submitted" &&
                                            item.mode_document == 0
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            decoration: BoxDecoration(
                                                color: item.document_status ==
                                                        "Pending"
                                                    ? Colors.orangeAccent
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        Constants.borderColor)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text("Pending",
                                                style: GoogleFonts.varela(
                                                    color:
                                                        item.document_status ==
                                                                "Pending"
                                                            ? Colors.white
                                                            : Colors.black)),
                                          )
                                        : disableContainer("Pending")),
                                InkWell(
                                  onTap: () async {
                                    if (item.document_status == "Pending" ||
                                        item.document_status ==
                                                "Schedule F2F" &&
                                            item.mode_document == 0) {
                                      ChangeStatusModel changeStatusModel =
                                          ChangeStatusModel(
                                              /*  status: "IB7",
                                              subStatus:
                                                  item.sub_code == "IB7-4"
                                                      ? "Ready to Join"
                                                      : "Confirmation Pending", */
                                              status: item.status_code,
                                              subStatus: item.sub_status,
                                              doj: item.doj,
                                              id: item.id,
                                              sourceId: item.sourceId,
                                              document_status: "Submitted");
                                      Map<String, dynamic> jsonData =
                                          changeStatusModel.toJson();
                                      try {
                                        await JobPostApiService.changeStatus(
                                            jsonData, item.id!.toInt());
                                        ref.refresh(fetchAllApplicantProvider);
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
                                        setState(() {});
                                        // First pop to close the dialog
                                      } catch (e) {
                                        print('Error: $e');
                                        // Handle error...
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 6.w),
                                    decoration: BoxDecoration(
                                        color: item.document_status ==
                                                    "Submitted" &&
                                                item.mode_document == 0
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        border: Border.all(
                                            color: Constants.borderColor)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    child: Text("Submitted",
                                        style: GoogleFonts.varela(
                                            color: item.document_status ==
                                                        "Submitted" &&
                                                    item.mode_document == 0
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.h,
                            )
                          ],
                        ),
                      //todo to show DOJ and select or update DOJ only for select tab.
                      if (item.status_code == "IB7" &&
                          (item.sub_code == "IB7-5" ||
                              item.sub_code == "IB7-4" ||
                              item.sub_code == "IB7-1"))
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                isToday ||
                                        isYesterday ||
                                        item.sub_code == "IB7-4"
                                    ? null
                                    : singleSelectPicker();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: doj == yesterday
                                          ? Constants.themeBgColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: item.doj != null
                                              ? item.doj?.day == tomorrow.day &&
                                                      item.doj!.month ==
                                                          tomorrow.month &&
                                                      item.doj!.year ==
                                                          tomorrow.year
                                                  ? Colors.blue
                                                  : item.doj!.day ==
                                                              DateTime.now()
                                                                  .day &&
                                                          item.doj!.month ==
                                                              DateTime.now()
                                                                  .month &&
                                                          item.doj!.year ==
                                                              DateTime.now()
                                                                  .year
                                                      ? Colors.green
                                                      : doj == yesterday
                                                          ? Colors.white
                                                          : Colors.brown
                                              : Constants.themeBgColor)),
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 4, bottom: 4, right: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          size: 15.h,
                                          color: item.doj != null
                                              ? item.doj?.day == tomorrow.day &&
                                                      item.doj!.month ==
                                                          tomorrow.month &&
                                                      item.doj!.year ==
                                                          tomorrow.year
                                                  ? Colors.blue
                                                  : item.doj!.day ==
                                                              DateTime.now()
                                                                  .day &&
                                                          item.doj!.month ==
                                                              DateTime.now()
                                                                  .month &&
                                                          item.doj!.year ==
                                                              DateTime.now()
                                                                  .year
                                                      ? Colors.green
                                                      : doj == yesterday
                                                          ? Colors.white
                                                          : Colors.brown
                                              : Constants.themeBgColor),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      item.doj != null
                                          ? item.doj!.day == DateTime.now().day &&
                                                  item.doj!.month ==
                                                      DateTime.now().month &&
                                                  item.doj!.year ==
                                                      DateTime.now().year
                                              ? Text("Today",
                                                  style: GoogleFonts.varela(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600))
                                              : item.doj!.day == tomorrow.day &&
                                                      item.doj!.month ==
                                                          tomorrow.month &&
                                                      item.doj!.year ==
                                                          tomorrow.year
                                                  ? Text("Tomorrow",
                                                      style: GoogleFonts.varela(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                  : doj == yesterday
                                                      ? Text("Yesterday",
                                                          style: GoogleFonts.varela(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                                      : Text(DateFormat('dd MMM yyyy').format(item.doj!),
                                                          style: GoogleFonts.varela(
                                                              color:
                                                                  Colors.brown,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))
                                          : Text("Select DOJ",
                                              style: GoogleFonts.varela(color: Constants.themeBgColor, fontWeight: FontWeight.w600)),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            if (item.doj != null &&
                                !isToday &&
                                item.sub_code != "IB7-4")
                              InkWell(
                                onTap: () async {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                    status: "IB7",
                                    subStatus: "Confirmation Pending",
                                    doj: null,
                                    id: item.id,
                                    sourceId: item.sourceId,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    setState(() {});
                                    // First pop to close the dialog
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                  setState(() {
                                    item.doj == null;
                                  });
                                  ref.refresh(fetchAllApplicantProvider);
                                },
                                child: Image.asset(
                                  "assets/images/close (1).png",
                                  height: 16.h,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            const Spacer(),
                            if (item.sub_code == "IB7-4")
                              Container(
                                margin:
                                    EdgeInsets.only(bottom: 10.h, right: 10.w),
                                child: Image.asset(
                                  "assets/images/readytojoin.png",
                                  height: 40.h,
                                ),
                              ),
                          ],
                        ),
                      if (item.status_code == "IB5" &&
                          !isWalkOut &&
                          !isRejected)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Wrap(
                              children: List.generate(
                                applicationList!
                                    .where(
                                        (option) => option.code!.contains(';'))
                                    .length,
                                (index) {
                                  final option = applicationList!
                                      .where((option) =>
                                          option.code!.contains(';'))
                                      .toList()[index];
                                  return InkWell(
                                    onTap: option.code != "IB8;2"
                                        ? () {
                                            ChangeStatusModel
                                                changeStatusModel =
                                                ChangeStatusModel(
                                              status:
                                                  option.sub_value.toString(),
                                              sourceId: item.sourceId,
                                              subStatus: option.value,
                                            );
                                            Map<String, dynamic> jsonData =
                                                changeStatusModel.toJson();
                                            try {
                                              JobPostApiService.changeStatus(
                                                  jsonData, item.id!.toInt());
                                              setState(() {});
                                            } catch (e) {
                                              print('Error: $e');
                                              // Handle error...
                                            }
                                          }
                                        : () {
                                            setState(() {
                                              isWalkOut = !isWalkOut;
                                            });
                                          },
                                    child: Wrap(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, right: 6),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            color: Colors.grey.shade100,
                                            border: Border.all(
                                                color: Constants.borderColor),
                                          ),
                                          child: Text(
                                            option.value.toString(),
                                            style: GoogleFonts.varela(
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                           
                            const Spacer(),
                            // const (),
                            //if (item.status_code!.contains("IB5"))
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 2),
                                child: Stack(
                                  children: [
                                    // item.sub_code=="IB5:1"?
                                    ToggleButton(
                                      initialValue: item.sub_code == "IB5:1"
                                          ? true
                                          : false,
                                      item: item,
                                      id: item.id!.toInt(),
                                      refreshCallback: () {
                                        ref.refresh(fetchAllApplicantProvider);
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),

                      if (item.status_code == "IB5" &&
                          !isRejected &&
                          !isWalkOut)
                        Row(children: [
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogueForSelect(
                                    item: item,
                                    refreshCallback: () {
                                      ref.refresh(fetchAllApplicantProvider);
                                      ref.refresh(fetchAllReferalProvider);
                                      ref.refresh(fetchAllApplyProvider);
                                    },
                                  );
                                },
                              );
                              ref.refresh(fetchAllApplicantProvider);
                              ref.refresh(fetchAllReferalProvider);
                              ref.refresh(fetchAllApplyProvider);
                              /*    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 3, top: 3.h),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.green[900],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Constants.borderColor, width: 2)),
                              child: Text("Select",
                                  style: GoogleFonts.varela(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          if (!isRejected && !isWalkOut)
                            InkWell(
                              onTap: () {
                                //  selectedJobs[item.id!.toInt()] = !isSelected;

                                setState(() {
                                  isRejected = !isRejected;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Constants.themeBgColor,
                                        width: 2)),
                                child: Text("Reject",
                                    style: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          const Spacer(),
                          if (item.status_code != "IB7" &&
                              item.status_code == "IB5")
                            Container(
                              height: 30.h,
                              padding: const EdgeInsets.only(left: 8),
                              // Adjust the padding as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                border:
                                    Border.all(color: Colors.blue, width: 1.5),
                              ),
                              child: DropdownButton<String>(
                                // menuMaxHeight: 0.1,
                                borderRadius: BorderRadius.circular(8.r),
                                elevation: 4,
                                value: item.interview_rounds ??
                                    finalinterviewRounds.first,
                                onChanged: (newValue) async {
                                  if (newValue != null) {
                                    updateSelectedRoundForJob(
                                        item.id!.toInt(), newValue);
                                  }
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                    status: "IB5",
                                    sourceId: item.sourceId,
                                    interview_rounds: newValue,
                                    subStatus: item.sub_status,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    setState(() {});
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                },
                                items: [
                                  if (item.interview_rounds != null &&
                                      !finalinterviewRounds
                                          .contains(item.interview_rounds))
                                    DropdownMenuItem<String>(
                                      value: item
                                          .interview_rounds, // Use the initial value from the JSON string
                                      child: Text(
                                        item.interview_rounds.toString(),
                                        style: GoogleFonts.varela(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ...finalinterviewRounds.toSet().map((round) {
                                    return DropdownMenuItem<String>(
                                      value: round,
                                      child: Text(
                                        round,
                                        style: GoogleFonts.varela(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                underline:
                                    Container(), // This removes the underline
                                hint: Text(
                                  'Select',
                                  style: GoogleFonts.varela(
                                    fontSize: 12.sp,
                                  ),
                                ), // Display "Select" when item.interview_rounds is empty
                              ),
                            )
                        ]),

                     
                      if (item.status_code == "IB7" &&
                              item.sub_code == "IB7-5" ||
                          item.sub_code == "IB7-4" && !isDropOut)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (item.doj != null && isToday ||
                                item.doj != null && isYesterday)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isNotJoin = !isNotJoin;
                                    notJoin = true;
                                    Drop = false;
                                  });
                                },
                                /* ChangeStatusModel changeStatusModel =
                                        ChangeStatusModel(
                                      status: "IB7",
                                      subStatus: "Not Join",
                                      doj: item.doj,
                                      id: item.id,
                                      sourceId: item.sourceId,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      JobPostApiService.changeStatus(
                                          jsonData, item.id!.toInt());
                                      setState(() {});
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    } */

                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 3, right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Constants.themeBgColor,
                                          width: 2)),
                                  child: Text("Not Join",
                                      style: GoogleFonts.varela(
                                          color: Constants.themeBgColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            if (item.doj != null && isToday ||
                                item.doj != null && isYesterday)
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialogueForJoin(
                                        item: item,
                                      );
                                    },
                                  );
                                  /*  ChangeStatusModel changeStatusModel =
                                        ChangeStatusModel(
                                      status: "IB7",
                                      subStatus: "Join",
                                      doj: item.doj,
                                      id: item.id,
                                      sourceId: item.sourceId,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      JobPostApiService.changeStatus(
                                          jsonData, item.id!.toInt());
                                      setState(() {});
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    } */
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 3, right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.green, width: 2)),
                                  child: Text("Join",
                                      style: GoogleFonts.varela(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            if (((item.doj == null || !isToday) &&
                                    !isYesterday) &&
                                item.sub_code != "IB7-4")
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isOfferDrop = !isOfferDrop;
                                    Drop = true;
                                    notJoin = false;
                                  });
                                  /*  ChangeStatusModel changeStatusModel =
                                        ChangeStatusModel(
                                      status: "IB7",
                                      subStatus: "Offer Drop",
                                      doj: item.doj,
                                      id: item.id,
                                      sourceId: item.sourceId,
                                    );
                                    Map<String, dynamic> jsonData =
                                        changeStatusModel.toJson();
                                    try {
                                      JobPostApiService.changeStatus(
                                          jsonData, item.id!.toInt());
                                      setState(() {});
                                      // First pop to close the dialog
                                    } catch (e) {
                                      print('Error: $e');
                                      // Handle error...
                                    } */
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 3, right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Constants.themeBgColor,
                                          width: 2)),
                                  child: Text("Offer Drop",
                                      style: GoogleFonts.varela(
                                          color: Constants.themeBgColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            if (!isToday &&
                                item.doj != null &&
                                !isYesterday &&
                                item.sub_code != "IB7-4")
                              InkWell(
                                onTap: () async {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                    status: "IB7",
                                    subStatus: "Ready to Join",
                                    doj: item.doj,
                                    id: item.id,
                                    sourceId: item.sourceId,
                                  );
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllReferalProvider);
                                    ref.refresh(fetchAllApplyProvider);
                                    setState(() {});
                                    // First pop to close the dialog
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 3,
                                    right: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.green, width: 2)),
                                  child: Text("Ready to Join",
                                      style: GoogleFonts.varela(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                          ],
                        ),

                      //TODO: Reason remark for offer Drop and not join

                      if (item.status_code == "IB7" && isDropOut ||
                          isOfferDrop ||
                          isNotJoin)
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          height: MediaQuery.of(context).size.height / 26,
                          child: TextField(
                            controller: remarkfordropandNotJoin,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 10.h, left: 6.w),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Constants.borderColor),
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: notJoin
                                  ? "Reason of Not Join"
                                  : Drop
                                      ? "Reason of Offer Drop"
                                      : "",
                              hintStyle: GoogleFonts.varela(
                                  color: Colors.grey.shade400),
                              hintText: notJoin
                                  ? "Reason of not join"
                                  : Drop
                                      ? "Reason of Offer Drop"
                                      : "",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                            ),
                          ),
                        ),

                      if (item.status_code == "IB7" && isDropOut ||
                          isOfferDrop ||
                          isNotJoin) //isOfferDrop
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isOfferDrop) {
                                    isOfferDrop = !isOfferDrop;
                                  } else if (isDropOut) {
                                    isDropOut = !isDropOut;
                                  } else {
                                    isNotJoin = !isNotJoin;
                                  }

                                  remarkfordropandNotJoin.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Cancel",
                                    style: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            /*  ElevatedButton(
                                onPressed: () {selectedoption
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showRejectTextField = true;
                                  });
                                },
                                child: const Text("Cancel"),
                              ), */
                            //    if (showrejectTextFileld.text.isNotEmpty)
                            // if (showrejectTextFileld.text.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                if (remarkfordropandNotJoin.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                          fetchDataFromApi: () {},
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                          isFisrt: false,
                                          title: "Feedback",
                                          subtitle: notJoin
                                              ? "Please give the reason of Not Join"
                                              : Drop
                                                  ? "Please give the reason of Offer Drop"
                                                  : "");
                                    },
                                  );
                                } else {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                          status: "IB7",
                                          subStatus: notJoin
                                              ? "Not Join"
                                              : "Offer Drop",
                                          doj: item.doj,
                                          id: item.id,
                                          sourceId: item.sourceId,
                                          remark: remarkfordropandNotJoin.text);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllReferalProvider);
                                    ref.refresh(fetchAllApplyProvider);
                                    remarkfordropandNotJoin.clear();
                                    setState(() {});
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showremarkfordropandNotJoin = false;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Submit",
                                    style: GoogleFonts.varela(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      if (item.status_code == "IB8" && item.remark != null)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: const Offset(0.5, 2),
                                    blurRadius: 2,
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(8.r)),
                          margin: EdgeInsets.only(top: 4.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Feedback",
                                style: GoogleFonts.varela(
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              if (item.remark != null)
                                Text(
                                  "${item.remark}",
                                  style: GoogleFonts.varela(
                                    color: Colors.black54,
                                    fontSize: 12.sp,
                                  ),
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                            ],
                          ),
                        ),

                      //TODO: Remark End for not join and offer drop......

                      if (item.status_code == "IB5" && isRejected ||
                          isWalkOut ||
                          isDropOut)
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          height: MediaQuery.of(context).size.height / 26,
                          child: TextField(
                            controller: showrejectTextFileld,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 10.h, left: 6.w),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Constants.borderColor),
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: isRejected
                                  ? "Reason of Rejection"
                                  : isDropOut
                                      ? "Reason of Drop-Out"
                                      : "Reason of Walk Out",
                              labelStyle:
                                  GoogleFonts.varela(color: Colors.grey),
                              hintStyle: GoogleFonts.varela(
                                  color: Colors.grey.shade400),
                              hintText: isRejected
                                  ? "Reason of Rejection"
                                  : isDropOut
                                      ? "Reason of Drop-Out"
                                      : "Reason of Walk Out",
                              //labelStyle: GoogleFonts.varela(color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Constants.borderColor),
                              ),
                            ),
                          ),
                        ),
                      if (item.status_code == "IB5" && isRejected ||
                          isWalkOut ||
                          isDropOut)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isRejected
                                      ? isRejected = !isRejected
                                      : isDropOut == true
                                          ? isDropOut = !isDropOut
                                          : isWalkOut = !isWalkOut;
                                  showrejectTextFileld.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Cancel",
                                    style: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),

                            /*  ElevatedButton(
                                onPressed: () {
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showRejectTextField = true;
                                  });
                                },
                                child: const Text("Cancel"),
                              ), */
                            //    if (showrejectTextFileld.text.isNotEmpty)
                            // if (showrejectTextFileld.text.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                if (showrejectTextFileld.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                          fetchDataFromApi: () {},
                                          onClose: () {
                                            Navigator.pop(context);
                                          },
                                          isFisrt: false,
                                          title: "Feedback",
                                          subtitle: isRejected
                                              ? "Please give the reason of Rejection"
                                              : isDropOut
                                                  ? "Provide Reason to drop out first"
                                                  : "Provide Reason to walk out first");
                                    },
                                  );
                                } else {
                                  ChangeStatusModel changeStatusModel =
                                      ChangeStatusModel(
                                          status: isRejected
                                              ? "IB6"
                                              : isDropOut
                                                  ? "IB8"
                                                  : "IB8",
                                          subStatus: isRejected
                                              ? null
                                              : isDropOut
                                                  ? "DropOut"
                                                  : "WalkOut",
                                          sourceId: item.sourceId,
                                          remark: showrejectTextFileld.text);
                                  Map<String, dynamic> jsonData =
                                      changeStatusModel.toJson();
                                  try {
                                    await JobPostApiService.changeStatus(
                                        jsonData, item.id!.toInt());
                                    ref.refresh(fetchAllApplicantProvider);
                                    ref.refresh(fetchAllApplyProvider);
                                    ref.refresh(fetchAllReferalProvider);
                                    showrejectTextFileld.clear();
                                    setState(() {});
                                  } catch (e) {
                                    print('Error: $e');
                                    // Handle error...
                                  }
                                  /*  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => CC(
                                                key: _talentPollKey,
                                              )))); */
                                  // Perform actions on submission
                                  // For example, save the reason and update status
                                  // ...

                                  // Reset _showRejectTextField to hide the text field
                                  setState(() {
                                    _showRejectTextField = false;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: Text("Submit",
                                    style: GoogleFonts.varela(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                }),

                // initialPadding: EdgeInsets.zero,
                // contentPadding: EdgeInsets.only(left: 7.w),
                //key: cardB,
                // trailing: const Icon(null),

                /* children: <Widget>[
                    const Divider(
                      thickness: 1.0,
                      height: 1.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      // padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [Text("${item.process} - ${item.level}")],
                          ),
                          Text(item.companyName)
                        ],
                      ),
                    )
                  ] */
              ),
            ),
          ),
        ),
        if (item.resume != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  /*  if (item.status != "Application")
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerScreen(
                                pdfAssetPath: 'assets/images/cv.pdf',
                                phoneNumber1: item.contactNo!.toInt(),
                                phoneNumber2: item.alternateNo!.toInt(),
                                // Replace with the actual asset path of your PDF file
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 15.h,
                          color: Constants.themeBgColor,
                        )), */
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(
                              pdfAssetPath: item.resume.toString(),
                              phoneNumber1: item.contactNo!.toInt(),
                              isref: false,
                              phoneNumber2: item.alternateNo != null
                                  ? item.alternateNo!.toInt()
                                  : 0,

                              // Replace with the actual asset path of your PDF file
                            ),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/images/cv.png",
                        height: 15.h,
                      )),
                ],
              ),
            ),
          )
      ],
    );
  }

} */