import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/utils.dart';
import '../../components/autolistviewmodal.dart';
import '../../models/autocompleteModel.dart';
import '../../models/card_model.dart';
import '../../service/UserDataService.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key, this.prevPageModel, required this.expirieanceFlag})
      : super(key: key);
  final bool expirieanceFlag;
  final dynamic prevPageModel;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final int _widgetId = 2;
  late Widget previousWidget;
  CardModel model = CardModel();
  //bool expirieanceFlag = false;

  var ddlValues;
  late TextEditingController companyController = TextEditingController();
  late TextEditingController jobTitleController = TextEditingController();
  late TextEditingController totalOfExpController = TextEditingController();
  late TextEditingController currentSalaryController = TextEditingController();
  late List<AutoCompleteModel> jobTitleList = [];
  late List<AutoCompleteModel> totalExperienceList = [];
  late List<AutoCompleteModel> currentSalaryList = [];
  AutoCompleteModel selectedJobTitle = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedtotalExperience = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedcurrentSalary = AutoCompleteModel("", "", {});

  @override
  void initState() {
    bindJobTitle();
    bindTotalExperiance();
    bindCurrentSalary();
    if (widget.prevPageModel != null) {
      companyController.text = widget.prevPageModel.companyName ?? '';
      selectedJobTitle = AutoCompleteModel(
          widget.prevPageModel.job_title_id.toString(),
          widget.prevPageModel.job_title ?? '', {});
      jobTitleController.text = widget.prevPageModel.job_title ?? '';
      selectedtotalExperience = AutoCompleteModel(
          widget.prevPageModel.work_experience_id.toString(),
          widget.prevPageModel.work_experience ?? '', {});
      totalOfExpController.text = widget.prevPageModel.work_experience ?? '';
      selectedcurrentSalary = AutoCompleteModel(
          widget.prevPageModel.salaryid.toString(),
          widget.prevPageModel.salary ?? '', {});
      currentSalaryController.text = widget.prevPageModel.salary ?? '';
      /*  widget.expirieanceFlag =
          widget.prevPageModel.has_experience == 1 ? true : false; */
    }
    super.initState();
  }

  bindJobTitle() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'job_role', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      jobTitleList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedJobTitle = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindTotalExperiance() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'total_exp', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      totalExperienceList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedtotalExperience = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindCurrentSalary() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'current_salary', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      currentSalaryList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedcurrentSalary = AutoCompleteModel("0", "", {});
      });
    }
  }

  bool isPresent = false;
  bool month = false,
      year = false,
      skill1 = false,
      skill2 = false,
      skill3 = false,
      onsite = false,
      hybrid = false,
      wfh = false,
      offerletter = false,
      salrysleep = false,
      bankstmt = false,
      experienceletter = false,
      apportunities = false,
      onNoticePeriod = false,
      day15 = false,
      day30 = false,
      day60 = false,
      day90 = false;

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.prevPageModel == null
                    ? Text(
                        "Add Experience",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        "Edit Experience",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                Text(
                  "Introduce your experience to the recruiters",
                  style: GoogleFonts.varela(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: InkWell(
            onTap: () {
              save();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: Constants.themeBgColor,
                  borderRadius: BorderRadius.circular(15)),
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Save",
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          /* Container(
            color: Constants.bgPanelColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ThemeButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xffffffff),
                  size: 25,
                ),
                radious: 0,
                onPressed: () {
                  save();
                },
                text: widget.prevPageModel == null ? "NEXT" : "Save",
                themeButtonSize: ThemeButtonSize.medium,
              ),
            ),
          ), */
          //  backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [
                _education(),
              ]),
            ),
          )),
    );
  }

  Widget _education() {
    return Container(
      key: const Key('second'),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*  SizedBox(
              width: double.infinity,
              child: Text(
                "Do you have any work experience?",
                textAlign: TextAlign.center,
                style: GoogleFonts.varela(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThemeButton(
                    width: 100,
                    onPressed: () {
                      setState(() {
                        expirieanceFlag = true;
                      });
                    },
                    themeButtonSize: ThemeButtonSize.xsmall,
                    radious: 0,
                    text: "YES",
                    isText: expirieanceFlag == true ? false : true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThemeButton(
                    width: 100,
                    onPressed: () {
                      setState(() {
                        expirieanceFlag = false;
                      });
                    },
                    themeButtonSize: ThemeButtonSize.xsmall,
                    radious: 0,
                    isText: expirieanceFlag == false ? false : true,
                    text: "NO",
                  ),
                ),
              ],
            ), */
            // SizedBox(height: 20),
            Visibility(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.expirieanceFlag == true
                      ? SizedBox(
                          width: double.maxFinite,
                          height: 45.h,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select any job title';
                              }
                              return null;
                            },
                            controller: jobTitleController,
                            enabled: true,
                            onTap: (() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogList(
                                      tile: null,
                                      dialogTitle: "Job title",
                                      onSelected: (AutoCompleteModel model) => {
                                        jobTitleController.text = model.label,
                                        selectedJobTitle = model,
                                        Navigator.pop(context)
                                      },
                                      itemsData: jobTitleList,
                                    );
                                  });
                            }),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              // Icons.workspace_premium
                              label: const Text("Job title"),
                              //border: OutlineInputBorder(),
                              // border: InputBorder.none,
                              hintText: "Sales Manager",
                              // prefixIcon: Icon(Icons.admin_panel_settings_outlined)
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.maxFinite,
                          height: 45.h,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select any job title';
                              }
                              return null;
                            },
                            // controller: jobTitleController,
                            enabled: true,
                            /*  onTap: (() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogList(
                                      tile: null,
                                      dialogTitle: "Job title",
                                      onSelected: (AutoCompleteModel model) => {
                                        jobTitleController.text = model.label,
                                        selectedJobTitle = model,
                                        Navigator.pop(context)
                                      },
                                      itemsData: jobTitleList,
                                    );
                                  });
                            }), */
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15)),
                              // Icons.workspace_premium
                              label: const Text("Job title"),
                              //border: OutlineInputBorder(),
                              // border: InputBorder.none,
                              hintText: "Sales Manager",
                              // prefixIcon: Icon(Icons.admin_panel_settings_outlined)
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 45.h,
                    child: TextField(
                      controller: companyController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        //  suffixIcon: const Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                        //border: InputBorder.none,
                        //  icon: Icon(Icons.apartment_outlined),
                        label: const Text("Company Name"),

                        // border: OutlineInputBorder(),
                        hintText: 'Enter company name',
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.1.w,
                        height: 45.h,
                        child: TextField(
                          // controller: companyController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            //  suffixIcon: const Icon(Icons.arrow_drop_down),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            //border: InputBorder.none,
                            //  icon: Icon(Icons.apartment_outlined),
                            label: const Text("Company Location"),
                            // border: OutlineInputBorder(),
                            hintText: 'Mumbai',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.1.w,
                        height: 45.h,
                        child: TextField(
                          // controller: companyController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            //  suffixIcon: const Icon(Icons.arrow_drop_down),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            //border: InputBorder.none,
                            //  icon: Icon(Icons.apartment_outlined),
                            label: const Text("Company Website"),
                            // border: OutlineInputBorder(),
                            hintText: 'www.jobcircle.co.in',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Working Type",
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            // gender = value.toString();
                            onsite = true;
                            hybrid = false;
                            wfh = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                onsite ? Constants.borderColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          margin: const EdgeInsets.only(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              onsite
                                  ? Text(
                                      "On-site",
                                      style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "On-site",
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade400,
                                          fontSize: 13.sp),
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(
                                width: 4.w,
                              ),
                              onsite
                                  ? Image.asset(
                                      "assets/images/check.png",
                                      height: 13.h,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            // gender = value.toString();
                            hybrid = true;
                            onsite = false;
                            wfh = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                hybrid ? Constants.borderColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          margin: const EdgeInsets.only(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              hybrid
                                  ? Text(
                                      "Hybrid",
                                      style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Hybrid",
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade400,
                                          fontSize: 13.sp),
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(
                                width: 4.w,
                              ),
                              hybrid
                                  ? Image.asset(
                                      "assets/images/check.png",
                                      height: 13.h,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            // gender = value.toString();
                            wfh = true;
                            onsite = false;
                            hybrid = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: wfh ? Constants.borderColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          margin: const EdgeInsets.only(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              wfh
                                  ? Text(
                                      "WFH",
                                      style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "WFH",
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade400,
                                          fontSize: 13.sp),
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(
                                width: 4.w,
                              ),
                              wfh
                                  ? Image.asset(
                                      "assets/images/check.png",
                                      height: 13.h,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Divider(),
                  Text(
                    "Skill's",
                    style: GoogleFonts.varela(
                        fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 35.h,
                    child: TextField(
                      decoration: InputDecoration(
                          hintStyle: GoogleFonts.varela(fontSize: 12.sp),
                          contentPadding: const EdgeInsets.all(5),
                          hintText: "Matching skills for this role"),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            // gender = value.toString();
                            skill1 = true;
                            skill2 = false;
                            skill3 = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                skill1 ? Constants.borderColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          margin: EdgeInsets.only(right: 5.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              skill1
                                  ? Text(
                                      "Skill 1",
                                      style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Skill 1",
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade400,
                                          fontSize: 13.sp),
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(
                                width: 4.w,
                              ),
                              skill1
                                  ? Image.asset(
                                      "assets/images/check.png",
                                      height: 13.h,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 13.h,
                                      color: Colors.grey.shade400,
                                    )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            // gender = value.toString();
                            skill2 = true;
                            skill1 = false;
                            skill3 = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                skill2 ? Constants.borderColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          margin: EdgeInsets.only(right: 5.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              skill2
                                  ? Text(
                                      "Skill 2",
                                      style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Skill 2",
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade400,
                                          fontSize: 13.sp),
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(
                                width: 4.w,
                              ),
                              skill2
                                  ? Image.asset(
                                      "assets/images/check.png",
                                      height: 13.h,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 13.h,
                                      color: Colors.grey.shade400,
                                    )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            // gender = value.toString();
                            skill3 = true;
                            skill1 = false;
                            skill2 = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                skill3 ? Constants.borderColor : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          margin: EdgeInsets.only(right: 5.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              skill3
                                  ? Text(
                                      "Skill 3",
                                      style: GoogleFonts.varela(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Skill 3",
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade400,
                                          fontSize: 13.sp),
                                      textAlign: TextAlign.center,
                                    ),
                              SizedBox(
                                width: 4.w,
                              ),
                              skill3
                                  ? Image.asset(
                                      "assets/images/check.png",
                                      height: 13.h,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 13.h,
                                      color: Colors.grey.shade400,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(),
                  // CustomControls.AutoCompleteCustom(
                  //     context,
                  //     "Job title",
                  //     "Enter Job title",
                  //     ((AutoCompleteModel item) => {
                  //           setState(() {
                  //             selectedJobTitle = item;
                  //           }),
                  //           // print(selectedEducation.label),
                  //         }),
                  //     selectedJobTitle,
                  //     jobTitleList,
                  //     Icons.admin_panel_settings_outlined),

                  // CustomControls.AutoCompleteCustom(
                  //     context,
                  //     "Total Years Of Experience",
                  //     "Enter total experience",
                  //     ((AutoCompleteModel item) => {
                  //           setState(() {
                  //             selectedtotalExperience = item;
                  //           }),
                  //           // print(selectedEducation.label),
                  //         }),
                  //     selectedtotalExperience,
                  //     totalExperienceList,
                  //     Icons.event_repeat_outlined),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 45.h,
                        width: MediaQuery.of(context).size.width / 2.2.w,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select any salary';
                            }
                            return null;
                          },
                          controller: currentSalaryController,
                          enabled: true,
                          onTap: (() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogList(
                                    tile: null,
                                    dialogTitle: "Current Salary",
                                    onSelected: (AutoCompleteModel model) => {
                                      currentSalaryController.text =
                                          model.label,
                                      selectedcurrentSalary = model,
                                      Navigator.pop(context)
                                    },
                                    itemsData: currentSalaryList,
                                  );
                                });
                          }),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            prefixIcon:
                                const Icon(Icons.currency_rupee_outlined),
                            // suffixIcon: const Icon(Icons.arrow_drop_down),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            // suffixIcon: const Icon(Icons.arrow_drop_down),
                            // Icons.workspace_premium
                            label: const Text("Current Salary"),
                            //border: OutlineInputBorder(),
                            // border: InputBorder.none,
                            hintText: "Select job salary",
                            //   prefixIcon: Icon(Icons.money)
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      currentSalaryController.text.isNotEmpty
                          ? Container(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        // gender = value.toString();
                                        month = true;
                                        year = false;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: month
                                            ? Constants.borderColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 4),
                                      margin: const EdgeInsets.only(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          month
                                              ? Text(
                                                  "Monthly",
                                                  style: GoogleFonts.varela(
                                                      fontSize: 13.sp,
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  "Monthly",
                                                  style: GoogleFonts.varela(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 13.sp),
                                                  textAlign: TextAlign.center,
                                                ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          month
                                              ? Image.asset(
                                                  "assets/images/check.png",
                                                  height: 13.h,
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    "/",
                                    style: GoogleFonts.varela(fontSize: 20.sp),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        // gender = value.toString();
                                        month = false;
                                        year = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: year
                                            ? Constants.borderColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 4),
                                      margin: const EdgeInsets.only(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          year
                                              ? Text(
                                                  "Yearly",
                                                  style: GoogleFonts.varela(
                                                      fontSize: 13.sp,
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  "Yearly",
                                                  style: GoogleFonts.varela(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 13.sp),
                                                  textAlign: TextAlign.center,
                                                ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          year
                                              ? Image.asset(
                                                  "assets/images/check.png",
                                                  height: 13.h,
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2.w,
                    height: 45.h,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select any job experience';
                        }
                        return null;
                      },
                      controller: totalOfExpController,
                      enabled: true,
                      onTap: () {
                        handleReadOnlyInputClick();
                      },
                      /* onTap: (() {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogList(
                                tile: null,
                                dialogTitle: "Total Years Of Experience",
                                onSelected: (AutoCompleteModel model) => {
                                  totalOfExpController.text = model.label,
                                  selectedtotalExperience = model,
                                  Navigator.pop(context)
                                },
                                itemsData: totalExperienceList,
                              );
                            });
                      }), */
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        // suffixIcon: const Icon(Icons.arrow_drop_down),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                        // suffixIcon: Icon(Icons.arrow_drop_down),
                        // Icons.workspace_premium
                        label: const Text("Joining date"),
                        //border: OutlineInputBorder(),
                        //border: InputBorder.none,
                        hintText: "Joining Date",
                        //prefixIcon: Icon(Icons.event_repeat_outlined)
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2.w,
                        height: 45.h,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select any job experience';
                            }
                            return null;
                          },
                          //  controller: totalOfExpController,
                          enabled: true,
                          /* onTap: (() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogList(
                                    tile: null,
                                    dialogTitle: "Total Years Of Experience",
                                    onSelected: (AutoCompleteModel model) => {
                                      totalOfExpController.text = model.label,
                                      selectedtotalExperience = model,
                                      Navigator.pop(context)
                                    },
                                    itemsData: totalExperienceList,
                                  );
                                });
                          }), */
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            // suffixIcon: const Icon(Icons.arrow_drop_down),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            // suffixIcon: Icon(Icons.arrow_drop_down),
                            // Icons.workspace_premium
                            label: const Text("Last working date"),
                            //border: OutlineInputBorder(),
                            //border: InputBorder.none,
                            hintText: "Last Working Date",
                            //prefixIcon: Icon(Icons.event_repeat_outlined)
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2.w,
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isPresent = !isPresent;
                                  });
                                },
                                child: isPresent
                                    ? Image.asset(
                                        "assets/images/currentworking.png",
                                        height: 16.h,
                                      )
                                    : Icon(
                                        Icons.circle_outlined,
                                        color: Colors.grey,
                                        size: 16.h,
                                      )),
                            SizedBox(
                              width: 5.w,
                            ),
                            isPresent
                                ? Text(
                                    "I am currently working. ",
                                    style: GoogleFonts.varela(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                : Text(
                                    "I am currently working. ",
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade400),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                  //const SizedBox(height: 20),
                  // CustomControls.AutoCompleteCustom(
                  //     context,
                  //     "Current Salary",
                  //     "Enter current salary",
                  //     ((AutoCompleteModel item) => {
                  //           setState(() {
                  //             selectedcurrentSalary = item;
                  //           }),
                  //           // print(selectedEducation.label),
                  //         }),
                  //     selectedcurrentSalary,
                  //     currentSalaryList,
                  //     Icons.money),

                  isPresent
                      ? Container(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            apportunities = !apportunities;
                                          });
                                        },
                                        child: apportunities
                                            ? Image.asset(
                                                "assets/images/currentworking.png",
                                                height: 15.h,
                                              )
                                            : Icon(
                                                Icons.circle_outlined,
                                                color: Colors.grey,
                                                size: 16.h,
                                              )),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    apportunities
                                        ? Text(
                                            "Looking for better opportunities.",
                                            style: GoogleFonts.varela(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Text(
                                            "Looking for better opportunities?",
                                            style: GoogleFonts.varela(
                                                color: Colors.grey.shade400),
                                          )
                                  ],
                                ),
                              ),
                              apportunities
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          "Availability to join?",
                                          style: GoogleFonts.varela(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Wrap(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // gender = value.toString();
                                                  day15 = true;
                                                  day30 = false;
                                                  day60 = false;
                                                  day90 = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: day15
                                                      ? Constants.borderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 4),
                                                margin: EdgeInsets.only(
                                                    top: 10.h, right: 10.w),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    day15
                                                        ? Text(
                                                            "15 Days or less",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 13.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            "15 Days or less",
                                                            style: GoogleFonts
                                                                .varela(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize:
                                                                        13.sp),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    day15
                                                        ? Image.asset(
                                                            "assets/images/check.png",
                                                            height: 13.h,
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // gender = value.toString();
                                                  day15 = false;
                                                  day30 = true;
                                                  day60 = false;
                                                  day90 = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: day30
                                                      ? Constants.borderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 4),
                                                margin: EdgeInsets.only(
                                                    top: 10.h, right: 10.w),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    day30
                                                        ? Text(
                                                            "1 Month",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 13.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            "1 Month",
                                                            style: GoogleFonts
                                                                .varela(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize:
                                                                        13.sp),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    day30
                                                        ? Image.asset(
                                                            "assets/images/check.png",
                                                            height: 13.h,
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // gender = value.toString();
                                                  day15 = false;
                                                  day30 = false;
                                                  day60 = true;
                                                  day90 = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: day60
                                                      ? Constants.borderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 4),
                                                margin: EdgeInsets.only(
                                                    top: 10.h, right: 10.w),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    day60
                                                        ? Text(
                                                            "2 Months",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 13.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            "2 Months",
                                                            style: GoogleFonts
                                                                .varela(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize:
                                                                        13.sp),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    day60
                                                        ? Image.asset(
                                                            "assets/images/check.png",
                                                            height: 13.h,
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // gender = value.toString();
                                                  day15 = false;
                                                  day30 = false;
                                                  day60 = false;
                                                  day90 = true;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: day90
                                                      ? Constants.borderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 4),
                                                margin: EdgeInsets.only(
                                                    top: 10.h, right: 10.w),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    day90
                                                        ? Text(
                                                            "3 Months",
                                                            style: GoogleFonts.varela(
                                                                fontSize: 13.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            "3 Months",
                                                            style: GoogleFonts
                                                                .varela(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    fontSize:
                                                                        13.sp),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    day90
                                                        ? Image.asset(
                                                            "assets/images/check.png",
                                                            height: 13.h,
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      : SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Documnets related to work experience",
                                style: GoogleFonts.varela(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              customDocumnet(
                                "Offer / Appointment letter.",
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              customDocumnet1("6 months Salary Slip. "),
                              SizedBox(
                                height: 5.h,
                              ),
                              customDocumnet2("6 months Bank statement. "),
                              SizedBox(
                                height: 5.h,
                              ),
                              customDocumnet3("Experience / Relieving letter."),
                            ],
                          ),
                        )
                  // const SizedBox(height: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row customDocumnet(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      offerletter = !offerletter;
                    });
                  },
                  child: offerletter
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              offerletter
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        offerletter
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  Row customDocumnet1(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      salrysleep = !salrysleep;
                    });
                  },
                  child: salrysleep
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              salrysleep
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        salrysleep
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  Row customDocumnet2(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      bankstmt = !bankstmt;
                    });
                  },
                  child: bankstmt
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              bankstmt
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        bankstmt
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  Row customDocumnet3(
    String title,
  ) {
    // bool offerletter = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      experienceletter = !experienceletter;
                    });
                  },
                  child: experienceletter
                      ? Image.asset(
                          "assets/images/currentworking.png",
                          height: 15.h,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey,
                          size: 16.h,
                        )),
              SizedBox(
                width: 5.w,
              ),
              experienceletter
                  ? Text(
                      title,
                      style: GoogleFonts.varela(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.varela(color: Colors.grey.shade400),
                    )
            ],
          ),
        ),
        experienceletter
            ? Image.asset(
                "assets/images/file_upload.png",
                height: 16.h,
              )
            : const SizedBox(),
      ],
    );
  }

  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var payload = {
      "id": await Utils.getPreferencesValue(
          prefs, ESharedPreferences.user_id.name),
      "experience": selectedtotalExperience.value == ""
          ? "0"
          : selectedtotalExperience.value,
      "experience_flag": 1,
      "job_title": selectedJobTitle.value == "" ? "0" : selectedJobTitle.value,
      "work_experience": selectedtotalExperience.value == ""
          ? "0"
          : selectedtotalExperience.value,
      "company_name": companyController.text,
      "has_experience": widget.expirieanceFlag ? 1 : 0,
      "ctc":
          selectedcurrentSalary.value == "" ? "0" : selectedcurrentSalary.value
    };
    print(payload);
    var result = await UserDataService()
        .saveUserStages({"stage": "experiene", "data": payload});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (widget.prevPageModel == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, ERoute.home.name, (Route<dynamic> route) => false);
      } else {
        widget.prevPageModel.experience = selectedtotalExperience.label;
        widget.prevPageModel.has_experience = widget.expirieanceFlag ? 1 : 0;

        Navigator.pop(context, widget.prevPageModel);
      }
      Utils.setCacheData('experience', 1);
    }
    setState(() {});
  }

  handleReadOnlyInputClick() async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate;
        return AlertDialog(
          content: SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: CupertinoDatePicker(
                      maximumYear: 2023,
                      //  maximumDate: DateTime.now(),
                      //minimumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime dateTime) {
                        tempPickedDate = dateTime;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        totalOfExpController.text = pickedDate.toString();
      });
    }
  }
}
