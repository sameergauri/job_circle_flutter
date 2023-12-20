import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/service/job_post_api_service.dart';

import '../models/add_resume_model.dart';
import '../models/fetch_applied_job_model.dart';
import '../themes/colors.dart';
import 'custom_suggestion_textfield_for_new.dart';

class CustomDialogueForNew extends StatefulWidget {
  //final ValueSetter<String>? get;

  final String title, company_name, process, role, nature_of_work, title2;
  final int companyId;
  final Applicant item;
  final Function refreshCallback;

  const CustomDialogueForNew(
      {super.key,
      required this.title,
      required this.company_name,
      required this.nature_of_work,
      required this.process,
      required this.role,
      required this.companyId,
      required this.title2,
      required this.refreshCallback,
      //required this.company_resumeId,

      required this.item});

  @override
  State<CustomDialogueForNew> createState() => _CustomDialogueForNewState();
}

class _CustomDialogueForNewState extends State<CustomDialogueForNew> {
  @override
  TextEditingController shorListController = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController proces = TextEditingController();
  TextEditingController natureOfWork = TextEditingController();
  bool isEdit4 = false, isEdit1 = false, isEdit2 = false, isEdit3 = false;

  String? CompanyID, parentID, jobTitle, pId;

  bool? name;

  String? same;
  List<dynamic> suggestions = [];

  //String? companyId;
  int? processId, roleId;
  int newJobID = 0;

  void handleSelectedID(String id) {
    // Process the selected ID as needed
    print('Selected ID: $id');
    setState(() {
      parentID = id;
    });
    // Perform any other actions with the ID
  }

  bool resumeidfilled = false;

  String? resumeID;

  TextEditingController ResumeId = TextEditingController();

  void getResumeID(String id) {
    setState(() {
      resumeID = id;
    });
  }

  void someFunction() {
    // Perform some action...

    // Trigger the refresh callback
    widget.refreshCallback();
  }

  void getCompanyId(String id) {
    setState(() {
      CompanyID = id;
      if (isEdit4 == false) {
        isEdit1 = false;
        isEdit2 = false;
        isEdit3 = false;
        proces.clear();
      }
      if (role.text.isEmpty) {
        FocusScope.of(context).requestFocus(roleFocusNode);
      } else if (role.text.isNotEmpty && proces.text.isEmpty) {
        FocusScope.of(context).requestFocus(processFocusNode);
      } else if (proces.text.isNotEmpty && natureOfWork.text.isEmpty) {
        FocusScope.of(context).requestFocus(functionalAreaFocusNode);
      }
    });
  }

  void getValueOfJobtitle(String getJobTitle) async {
    setState(() {
      jobTitle = getJobTitle;
      if (shorListController.text.isEmpty) {
        FocusScope.of(context).requestFocus(cmpnyFocusNode);
      } else if (proces.text.isEmpty) {
        FocusScope.of(context).requestFocus(processFocusNode);
      } else if (proces.text.isNotEmpty && natureOfWork.text.isEmpty) {
        FocusScope.of(context).requestFocus(functionalAreaFocusNode);
      }
    });
  }

  String? pro;
  void getValuOfProcess(String gteProcess) {
    setState(() {
      pro = gteProcess;
      if (shorListController.text.isEmpty) {
        FocusScope.of(context).requestFocus(cmpnyFocusNode);
      } else if (role.text.isEmpty) {
        FocusScope.of(context).requestFocus(roleFocusNode);
      } else {
        FocusScope.of(context).requestFocus(functionalAreaFocusNode);
      }
    });
  }

  void getNatureOfWorkId(String ids) {
    setState(() {
      NatureOfWorkID = int.parse(ids);
      if (shorListController.text.isEmpty) {
        FocusScope.of(context).requestFocus(cmpnyFocusNode);
      } else if (role.text.isEmpty) {
        FocusScope.of(context).requestFocus(roleFocusNode);
      } else if (proces.text.isEmpty) {
        FocusScope.of(context).requestFocus(processFocusNode);
      }
    });
  }

  int? NatureOfWorkID;
  List<String> checkboxData = [];
  List<String> checkboxDataState = [];

  // List<String> data = [];

  List<int> uniqueValues = [];

// To fetch Process.........

  FocusNode cmpnyFocusNode = FocusNode();
  FocusNode roleFocusNode = FocusNode();
  FocusNode processFocusNode = FocusNode();
  FocusNode functionalAreaFocusNode = FocusNode();
  bool isEdit = false;
  //bool isEdit2 = false;

  void onTextField1Tap1(TextEditingController tappedController) {
    proces.clear();
    role.clear();
    natureOfWork.clear();
    setState(() {
      isEdit4 = false;
      isEdit2 = false;
      isEdit1 = false;
    });
  }

  void onTextField1Tap2(TextEditingController tappedController) {
    role.clear();
    natureOfWork.clear();
    setState(() {
      isEdit2 = false;
      isEdit1 = false;
    });
  }

  void onTextField1Tap3(TextEditingController tappedController) {
    natureOfWork.clear();
    setState(() {
      isEdit2 = false;
    });
  }

  void onTextField1Tap4(TextEditingController tappedController) {}

  void getFunctionalAreaIdCust(int id) {
    setState(() {
      newJobID = id;
    });
  }

  String? spocLastName, spocFirsName;
  int? spoc;
  String? firstInterviewRound;

  void getSpocLastName(String lname) {
    setState(() {
      spocLastName = lname;
    });
    print(lname);
  }

  void getSpocFirstName(String fname) {
    setState(() {
      spocFirsName = fname;
    });
    print(fname);
  }

  void getSpoc(int spc) {
    setState(() {
      spoc = spc;
    });
    print(spoc);
  }

  void getInterviewRounds(String spc) {
    setState(() {
      firstInterviewRound = spc;
    });
    print(spoc);
  }

  bool f2f = false, virtual = false;

  bool isComp = false, isprocess = false, isRole = false, isNof = false;

  void closeCustomDialogue() {
    setState(() {
      isComp = false;
      isprocess = false;
      isRole = false;
      isNof = false;
      resumeidfilled = false;
      isEdit1 = false;
      isEdit2 = false;
      isEdit3 = false;
      isEdit4 = false;
      ResumeId.clear();
      // Additional reset logic if needed
    });
  }

  // String? title,Desc;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,

      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.only(
                top: 10.0, left: 20, right: 20, bottom: 10),
            child: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add your custom dialog content here
                Wrap(
                  alignment: WrapAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.varela(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.item.applicantName.toString()} ${widget.item.last_name.toString()}",
                      style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      widget.title2,
                      style: GoogleFonts.varela(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Mode of Interview",
                      style: GoogleFonts.varela(
                        fontSize: 14.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          virtual = true;
                          f2f = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 1, right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: virtual ? Colors.grey.shade500 : Colors.white,
                          border: Border.all(
                            color: virtual == false
                                ? Colors.grey.shade500
                                : Colors.white,
                          ),
                        ),
                        child: Text(
                          "Virtual",
                          style: GoogleFonts.varela(
                              fontWeight: FontWeight.bold,
                              color:
                                  virtual ? Colors.white : Colors.grey.shade500,
                              fontSize: 14.sp),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          f2f = true;
                          virtual = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 1, right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: f2f ? Colors.grey.shade500 : Colors.white,
                          border: Border.all(
                            color: f2f == false
                                ? Colors.grey.shade500
                                : Colors.white,
                          ),
                        ),
                        child: Text(
                          "Face2Face",
                          style: GoogleFonts.varela(
                            fontWeight: FontWeight.bold,
                            color: f2f ? Colors.white : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.h,
                ),
                isComp
                    ? CustomJobFormForUpdateCRPF(
                        onTapCallback: onTextField1Tap1,
                        focusNode: cmpnyFocusNode,
                        isCompany: true,
                        name: "company",
                        /* onFocusNodeRequested: (p0) {
                            focusNode.requestFocus();
                          }, */
                        title: "Company Name",
                        controller: shorListController,
                        // isEdit: isEdit,
                        //  focusNode: focusNode,
                        onChanged: (p0) {
                          isEdit4 = p0;
                          role.clear();
                          proces.clear();
                          natureOfWork.clear();
                          ResumeId.clear();
                          resumeidfilled = false;
                        },
                        contextIn: context,
                        onSubmit: getCompanyId,
                        onGetResumeId: getResumeID,
                        hintText: "Aditya birla Health Insurance",
                        //getSuggestions:(){},
                        onIDSelected: handleSelectedID,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Name",
                            style: GoogleFonts.varela(
                              fontSize: 14.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                resumeidfilled = false;
                                ResumeId.clear();
                                isComp = true;
                                isEdit4 = false;
                                isEdit1 = false;
                                isEdit2 = false;
                                isEdit3 = false;
                                isprocess = true;
                                isRole = true;
                                isNof = true;
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 6.w),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade500,
                                    borderRadius: BorderRadius.circular(8.r)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.company_name),
                                    Icon(
                                      Icons.edit,
                                      size: 15.h,
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                if ((resumeID == "1" &&
                        resumeID != null &&
                        isprocess &&
                        isEdit4) ||
                    widget.item.company_resumeId == "1" && isComp == false)
                  resumeidfilled == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Resume ID",
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 14.sp,
                                //color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25.h,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {},
                                      decoration: InputDecoration(
                                        filled: true,
                                        //icon: const Icon(Icons.arrow_forward_ios),
                                        fillColor: Colors.white,
                                        hintText: "R1546464",
                                        hintStyle: GoogleFonts.sourceSansPro(
                                          color: Constants.subtitleclr,
                                          fontSize: 15.sp,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 122, 113, 111),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffff0eceb),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                      ),
                                      controller: ResumeId,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        resumeidfilled = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 15.w),
                                      child: Text("Next",
                                          style: GoogleFonts.varela(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                          ],
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 4.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Resume ID",
                                style: GoogleFonts.varela(
                                  fontSize: 14.0,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    resumeidfilled = false;
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 6.w),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade500,
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ResumeId.text),
                                        Icon(
                                          Icons.edit,
                                          size: 15.h,
                                          color: Colors.white,
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                if (resumeID == "1" ? resumeidfilled : resumeidfilled == false)
                  isEdit4
                      ? SuggestionTextFieldForNew(
                          onTapCallback: onTextField1Tap2,
                          companyID: isprocess && isComp
                              ? CompanyID
                              : widget.companyId.toString(),
                          controller: proces,
                          textfieldNumber: 1,
                          process: proces.text,
                          role: role.text,
                          hint: "Health Insurance",
                          title: "Process",
                          getFunctionalAreaId: (p0) {
                            setState(() {
                              processId = p0;
                            });
                          },
                          onChanged: (p0) {
                            setState(() {
                              isEdit1 = p0;
                              role.clear();

                              natureOfWork.clear();
                            });
                          },
                        )
                      : const SizedBox(),
                if (isprocess == false)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Process",
                          style: GoogleFonts.varela(
                            fontSize: 14.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isprocess = true;
                              // isEdit4 = true;
                              isRole = true;
                              isNof = true;
                              isEdit1 = false;
                              isEdit4 = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 6.w),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.process),
                                  Icon(
                                    Icons.edit,
                                    size: 15.h,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),

                if (isRole == true)
                  isEdit1 && isEdit4
                      ? SuggestionTextFieldForNew(
                          onTapCallback: onTextField1Tap3,
                          companyID: isRole && isprocess && isComp
                              ? CompanyID
                              : widget.companyId.toString(),
                          controller: role,
                          textfieldNumber: 2,
                          process: isRole && isprocess && isComp
                              ? proces.text
                              : widget.process,
                          role: role.text,
                          hint: "Sr. Executive",
                          title: "Job Title / Role",
                          getFunctionalAreaId: (p0) {
                            setState(() {
                              roleId = p0;
                            });
                          },
                          onChanged: (p0) {
                            setState(() {
                              isEdit2 = p0;

                              natureOfWork.clear();
                            });
                          },
                        )
                      : const SizedBox(),
                if (isRole == false)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Role",
                          style: GoogleFonts.varela(
                            fontSize: 14.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isRole = true;
                              isEdit3 = true;
                              isEdit1 = true;
                              isEdit4 = true;
                              isEdit2 = false;
                              isNof = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 6.w),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.role),
                                  Icon(
                                    Icons.edit,
                                    size: 15.h,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),

                if (isNof == true)
                  isEdit2 && isEdit1 && isEdit4
                      ? SuggestionTextFieldForNew(
                          onTapCallback: onTextField1Tap4,
                          companyID: isNof && isRole && isprocess && isComp
                              ? CompanyID
                              : widget.companyId.toString(),
                          controller: natureOfWork,
                          textfieldNumber: 3,
                          process: isNof && isRole && isprocess && isComp
                              ? proces.text
                              : widget.process,
                          role: isNof && isRole && isprocess && isComp
                              ? role.text
                              : widget.role,
                          hint: "Sales",
                          title: "Functional Area",
                          getFunctionalAreaId: getFunctionalAreaIdCust,
                          onChanged: (p0) {
                            setState(() {
                              isEdit3 = p0;
                            });
                          },
                          getSpocfName: getSpocFirstName,
                          getSpoclName: getSpocLastName,
                          getspoc: getSpoc,
                          getInterviewRounds: getInterviewRounds,
                        )
                      : const SizedBox(),
                if (isNof == false)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Functional Area",
                          style: GoogleFonts.varela(
                            fontSize: 14.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isNof = true;

                              isEdit2 = true;
                              isEdit1 = true;
                              isEdit4 = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 6.w),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.nature_of_work),
                                  Icon(
                                    Icons.edit,
                                    size: 15.h,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),

                Container(
                  margin: const EdgeInsets.only(top: 5),
                  //   color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          closeCustomDialogue();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5, right: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (isEdit1 &&
                                isEdit2 &&
                                isEdit3 &&
                                isEdit4 &&
                                resumeidfilled &&
                                (virtual || f2f)) ||
                            (!isComp &&
                                !isprocess &&
                                !isRole &&
                                !isNof &&
                                resumeidfilled == false &&
                                (virtual || f2f)) ||
                            ((isEdit1 &&
                                isEdit2 &&
                                isEdit3 &&
                                isEdit4 &&
                                resumeidfilled == false &&
                                (virtual || f2f))),
                        child: InkWell(
                          onTap: () async {
                            final addResumeModel = JobApplicationModel(
                              resume: widget.item.resume,
                              isRef: widget.item.is_ref,
                              rid: widget.item.rid,
                              sub_source: widget.item.sub_source,
                              uid: widget.item.uid,
                              id: widget.item.id,
                              applicantName: widget.item.applicantName,
                              lastName: widget.item.last_name,
                              contactNo: widget.item.contactNo,
                              qualification: widget.item.qualification,
                              isExperienced:
                                  widget.item.isExperienced == 1 ? 1 : 0,
                              companyName: isComp == false
                                  ? widget.company_name
                                  : shorListController.text,
                              process: isprocess == false
                                  ? widget.process
                                  : proces.text,
                              level: isRole == false ? widget.role : role.text,
                              naturofwork: isNof == false
                                  ? widget.nature_of_work
                                  : natureOfWork.text,
                              shortListFor: isComp == false
                                  ? widget.companyId
                                  : int.parse(CompanyID.toString()),
                              status: "IB5",

                              // subStatus: "Shortlist",
                              sourceId: widget.item.sourceId,
                              sourceName: widget.item.source_name,
                              jobid: isComp == false
                                  ? widget.item.jobId
                                  : newJobID,
                              spoc: spoc ?? widget.item.spoc,
                              interview_rounds: isComp == false
                                  ? widget.item.inteviewrounds!.first
                                      .toString()
                                      .replaceAll('"', '')
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                  : firstInterviewRound,
                              client_resume_id: ResumeId.text.isNotEmpty
                                  ? ResumeId.text
                                  : null,
                              subStatus: virtual
                                  ? "Virtual Interview"
                                  : f2f
                                      ? "On-Site Interview"
                                      : "",
                              dol: widget.item.dol,
                              alternateNo: widget.item.alternateNo,

                              //dos: widget.item.dos
                              // ... fill in other properties as needed
                            );
                            final jsonData = addResumeModel.toJson();
                            await JobPostApiService.addResume(
                                jsonData, context, true);
                            closeCustomDialogue();
                            someFunction();

                            Navigator.pop(context);

                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget customContainer({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.sourceSansPro(
              fontSize: 18.sp,
              // color: Colors.grey.shade500,
              fontWeight: FontWeight.w600),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 25.h,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8))),
          ),
        ),
      ],
    );
  }
}
