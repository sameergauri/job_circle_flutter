import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

class Screen2 extends StatefulWidget {
  const Screen2({Key? key, this.prevPageModel}) : super(key: key);
  final dynamic prevPageModel;
  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final int _widgetId = 2;
  late Widget previousWidget;
  late TextEditingController educationController = TextEditingController();
  late TextEditingController passingYearController = TextEditingController();
  late TextEditingController universityController = TextEditingController();
  late TextEditingController degreeController = TextEditingController();
  CardModel model = CardModel();

  var ddlValues;
  late List<AutoCompleteModel> levelOfEducationList = [];
  late List<AutoCompleteModel> universityInstitueList = [];
  late List<AutoCompleteModel> degreeList = [];
  AutoCompleteModel selectedEducation = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedUniversity = AutoCompleteModel("", "", {});
  AutoCompleteModel selectedDegree = AutoCompleteModel("", "", {});

  @override
  initState() {
    super.initState();

    bindLevelOfEducation();
    bindUniversityEducation();
    bindDegree();
    if (widget.prevPageModel != null) {
      String educationId = "";
      dynamic education = "";
      if (widget.prevPageModel.education_id != null) {
        educationId = widget.prevPageModel.education_id.toString();
      }
      if (widget.prevPageModel.education != null) {
        education = widget.prevPageModel.education;
      }
      selectedEducation = AutoCompleteModel(educationId, education, {});
      educationController.text = education;

      String univercityId = widget.prevPageModel.univercity_id != null
          ? widget.prevPageModel.univercity_id.toString()
          : "";
      dynamic univercity = widget.prevPageModel.univercity != null
          ? widget.prevPageModel.univercity.toString()
          : "";

      selectedUniversity = AutoCompleteModel(univercityId, univercity, {});
      universityController.text = univercity;

      String degreeSpcId = widget.prevPageModel.degree_spc_id != null
          ? widget.prevPageModel.degree_spc_id.toString()
          : "";
      dynamic degreeSpc = widget.prevPageModel.degree_spc != null
          ? widget.prevPageModel.degree_spc.toString()
          : "";
      selectedDegree = AutoCompleteModel(degreeSpcId, degreeSpc, {});
      degreeController.text = degreeSpc;
      passingYearController.text = widget.prevPageModel.passing_year.toString();
    }
  }

  bindLevelOfEducation() async {
    var result = await MasterService().masterGetByGroup({
      'groupName': 'level_education',
      'pageNumber': '1',
      'pageSize': '1000'
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      levelOfEducationList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        //selectedEducation = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindUniversityEducation() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'university', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      universityInstitueList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedUniversity = AutoCompleteModel("0", "", {});
      });
    }
  }

  bindDegree() async {
    var result = await MasterService().masterGetByGroup(
        {'groupName': 'degree', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      degreeList = (ddlValues["content"] as List)
          .map<AutoCompleteModel>(
              (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
          .toList();

      setState(() {
        // selectedDegree = AutoCompleteModel("0", "", {});
      });
    }
  }

  bool graduate = false,
      other = false,
      undergraduate = false,
      hsc = false,
      mba = false,
      sem1 = false,
      sem2 = false,
      sem3 = false,
      sem4 = false,
      sem5 = false,
      sem6 = false;

  FilePickerResult? result;
  void _showFilesinDir({required Directory dir}) {
    dir
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });
  }

  customFilePicker() async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      setState(() {
        ListView.builder(
            shrinkWrap: true,
            itemCount: result?.files.length ?? 0,
            itemBuilder: (context, index) {
              return Text(result?.files[index].name ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold));
            });
      });
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.prevPageModel == null
                    ? Text(
                        "Add Education",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        "Edit Education ",
                        style: GoogleFonts.varela(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                Text(
                  "Let recruiter know your value as a potential candidate",
                  style: GoogleFonts.varela(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: _education(),
            ),
          )),
    );
  }

  Widget _education() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      key: const Key('second'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomControls.AutoCompleteCustom(
          //     context,
          //     "Level Of Education",
          //     "Enter Level Of Education",
          //     ((AutoCompleteModel item) => {
          //           setState(() {
          //             selectedEducation = item;
          //           }),
          //           // print(selectedEducation.label),
          //         }),
          //     selectedEducation,
          //     levelOfEducationList,
          //     Icons.school_outlined),
          /* TextFormField(
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please select any job location';
            //   }
            // },
            controller: educationController,
            enabled: true,
            onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "Level Of Education",
                      onSelected: (AutoCompleteModel model) => {
                        educationController.text = model.label,
                        selectedEducation = model,
                        Navigator.pop(context)
                      },
                      itemsData: levelOfEducationList,
                    );
                  });
            }),
            decoration: const InputDecoration(
                suffixIcon: Icon(Icons.arrow_drop_down),
                // Icons.workspace_premium
                label: Text("Level Of Education"),
                //border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: "Select level of education",
                prefixIcon: Icon(Icons.school_outlined)),
          ), */
          Text(
            "Level of Education",
            style: GoogleFonts.varela(
                fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    // gender = value.toString();
                    graduate = false;
                    undergraduate = false;
                    mba = false;
                    hsc = true;
                    other = false;
                    degreeController.clear;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: hsc ? Constants.borderColor : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  margin: EdgeInsets.only(right: 5.w, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      hsc
                          ? Text(
                              "H.S.C / 10+2",
                              style: GoogleFonts.varela(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "H.S.C / 10+2",
                              style: GoogleFonts.varela(
                                  color: Colors.grey.shade400, fontSize: 13.sp),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(
                        width: 4.w,
                      ),
                      hsc
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
                    graduate = true;
                    undergraduate = false;
                    hsc = false;
                    other = false;
                    mba = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: graduate ? Constants.borderColor : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  margin: EdgeInsets.only(right: 5.w, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      graduate
                          ? Text(
                              "Graduate",
                              style: GoogleFonts.varela(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Graduate",
                              style: GoogleFonts.varela(
                                  color: Colors.grey.shade400, fontSize: 13.sp),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(
                        width: 4.w,
                      ),
                      graduate
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
                    graduate = false;
                    undergraduate = true;
                    mba = false;
                    hsc = false;
                    other = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: undergraduate ? Constants.borderColor : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  margin: EdgeInsets.only(right: 5.w, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      undergraduate
                          ? Text(
                              "Post Graduate",
                              style: GoogleFonts.varela(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Post Graduate",
                              style: GoogleFonts.varela(
                                  color: Colors.grey.shade400, fontSize: 13.sp),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(
                        width: 4.w,
                      ),
                      undergraduate
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
                    graduate = false;
                    undergraduate = false;
                    hsc = false;
                    mba = true;
                    other = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: mba ? Constants.borderColor : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  margin: EdgeInsets.only(right: 5.w, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      mba
                          ? Text(
                              "MBA",
                              style: GoogleFonts.varela(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "MBA",
                              style: GoogleFonts.varela(
                                  color: Colors.grey.shade400, fontSize: 13.sp),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(
                        width: 4.w,
                      ),
                      mba
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
                    graduate = false;
                    undergraduate = false;
                    mba = false;
                    hsc = false;
                    degreeController.clear;
                    other = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: other ? Constants.borderColor : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  margin: EdgeInsets.only(right: 5.w, bottom: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      other
                          ? Text(
                              "Other's",
                              style: GoogleFonts.varela(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Other's",
                              style: GoogleFonts.varela(
                                  color: Colors.grey.shade400, fontSize: 13.sp),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(
                        width: 4.w,
                      ),
                      other
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
          const Divider(
            thickness: 1.5,
          ),
          const SizedBox(
            height: 10,
          ),
          // CustomControls.AutoCompleteCustom(
          //     context,
          //     "University / Institute",
          //     "Enter college name",
          //     ((AutoCompleteModel item) => {
          //           setState(() {
          //             selectedUniversity = item;
          //           }),
          //           // print(selectedEducation.label),
          //         }),
          //     selectedUniversity,
          //     universityInstitueList,
          //     Icons.school_sharp),

          // CustomControls.AutoCompleteCustom(
          //     context,
          //     "Degree / Specialization",
          //     "Enter degree",
          //     ((AutoCompleteModel item) => {
          //           setState(() {
          //             selectedDegree = item;
          //           }),
          //           // print(selectedEducation.label),
          //         }),
          //     selectedDegree,
          //     degreeList,
          //     Icons.cast_for_education),
          if (hsc == true) customWidgetHSC(),
          if (graduate == true) customWidgetGraduation(),
          if (undergraduate == true) customWidgetPost(),
          if (mba == true) customWidgetMBA(),
          if (other == true) customWidgetOther(),
        ],
      ),
    );
  }

  SizedBox customWidgetOther() {
    return SizedBox(
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select any job location';
              }
              return null;
            },
            // controller: universityController,
            // enabled: true,
            /* onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "University / Institute",
                      onSelected: (AutoCompleteModel model) => {
                        universityController.text = model.label,
                        selectedUniversity = model,
                        Navigator.pop(context)
                      },
                      itemsData: universityInstitueList,
                    );
                  });
            }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),

              // suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("University / Institute"),
              //border: OutlineInputBorder(),
              //  border: InputBorder.none,
              hintText: "Mumbai University",
              // prefixIcon: Icon(Icons.school_sharp)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            // controller: degreeController,
            enabled: true,
            /*  onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "Degree / Specialization",
                      onSelected: (AutoCompleteModel model) => {
                        degreeController.text = model.label,
                        selectedDegree = model,
                        Navigator.pop(context)
                      },
                      itemsData: degreeList,
                    );
                  });
            }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Degree / Specialization"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Bachelor Of Commerce",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            //  controller: degreeController,
            //  enabled: true,
            /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Field of Study"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Accounts and Finance",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            //  controller: degreeController,
            //  enabled: true,
            /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("First Year"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Jun-2023",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            //  controller: degreeController,
            //  enabled: true,
            /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Final Year"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "April-2023",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*  customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false), */
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox customWidgetMBA() {
    return SizedBox(
      child: Column(children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select any job location';
            }
            return null;
          },
          // controller: universityController,
          // enabled: true,
          /* onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "University / Institute",
                      onSelected: (AutoCompleteModel model) => {
                        universityController.text = model.label,
                        selectedUniversity = model,
                        Navigator.pop(context)
                      },
                      itemsData: universityInstitueList,
                    );
                  });
            }), */
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),

            // suffixIcon: const Icon(Icons.arrow_drop_down),
            // Icons.workspace_premium
            label: const Text("University / Institute"),
            //border: OutlineInputBorder(),
            //  border: InputBorder.none,
            hintText: "Mumbai University",
            // prefixIcon: Icon(Icons.school_sharp)
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          // controller: degreeController,
          enabled: true,
          /*  onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "Degree / Specialization",
                      onSelected: (AutoCompleteModel model) => {
                        degreeController.text = model.label,
                        selectedDegree = model,
                        Navigator.pop(context)
                      },
                      itemsData: degreeList,
                    );
                  });
            }), */
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            //  suffixIcon: const Icon(Icons.arrow_drop_down),
            // Icons.workspace_premium
            label: const Text("Degree / Specialization"),
            //border: OutlineInputBorder(),
            // border: InputBorder.none,
            hintText: "Bachelor of Commerce ",
            //  prefixIcon: Icon(Icons.cast_for_education)
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          //  controller: degreeController,
          //  enabled: true,
          /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            //  suffixIcon: const Icon(Icons.arrow_drop_down),
            // Icons.workspace_premium
            label: const Text("Field of Study"),
            //border: OutlineInputBorder(),
            // border: InputBorder.none,
            hintText: "Field of study",
            //  prefixIcon: Icon(Icons.cast_for_education)
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          //  controller: degreeController,
          //  enabled: true,
          /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            //  suffixIcon: const Icon(Icons.arrow_drop_down),
            // Icons.workspace_premium
            label: const Text("First Year"),
            //border: OutlineInputBorder(),
            // border: InputBorder.none,
            hintText: "Jun-2023",
            //  prefixIcon: Icon(Icons.cast_for_education)
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          //  controller: degreeController,
          //  enabled: true,
          /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            //  suffixIcon: const Icon(Icons.arrow_drop_down),
            // Icons.workspace_premium
            label: const Text("Final Year"),
            //border: OutlineInputBorder(),
            // border: InputBorder.none,
            hintText: "April-2023",
            //  prefixIcon: Icon(Icons.cast_for_education)
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*     customButton("Digi Locker",
                                  "assets/images/digilocker.png", 70, false), */
                              customButton("Manual",
                                  "assets/images/file_exp.png", 70, false),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: customButton("Upload Marksheet", "", 0, true),
            ),
          ],
        )
      ]),
    );
  }

  SizedBox customWidgetHSC() {
    return SizedBox(
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select any job location';
              }
              return null;
            },
            // controller: universityController,
            // enabled: true,
            /* onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "University / Institute",
                      onSelected: (AutoCompleteModel model) => {
                        universityController.text = model.label,
                        selectedUniversity = model,
                        Navigator.pop(context)
                      },
                      itemsData: universityInstitueList,
                    );
                  });
            }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),

              // suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Board"),
              //border: OutlineInputBorder(),
              //  border: InputBorder.none,
              hintText: "Maharashtra state board",
              // prefixIcon: Icon(Icons.school_sharp)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            // controller: degreeController,
            enabled: true,
            /*  onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "Degree / Specialization",
                      onSelected: (AutoCompleteModel model) => {
                        degreeController.text = model.label,
                        selectedDegree = model,
                        Navigator.pop(context)
                      },
                      itemsData: degreeList,
                    );
                  });
            }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("College Name"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Job Circle College of Science, Commerce & Arts.",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            //  controller: degreeController,
            //  enabled: true,
            /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Passing year"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Mar-23",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false),
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget customButton(String title, String? img, int? conSize, bool dlg) {
    return InkWell(
      onTap: () async {
        customFilePicker();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border:
                Border.all(color: dlg ? Constants.themeBgColor : Colors.white)),
        child: img!.isNotEmpty
            ? Image.asset(
                img,
                height: conSize!.h,
              )
            : Row(
                children: [
                  const Icon(
                    Icons.add,
                    size: 16,
                    color: Constants.themeBgColor,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold,
                        color: Constants.themeBgColor),
                  )
                ],
              ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
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
          child: Text(
            title,
            style: GoogleFonts.varela(
                color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
        Image.asset(
          "assets/images/file_upload.png",
          height: 16.h,
        )
      ],
    );
  }

  SizedBox customWidgetGraduation() {
    return SizedBox(
      child: Column(
        children: [
          TextFormField(
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please select any job location';
            //   }
            // },
            controller: universityController,
            enabled: true,
            onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "University / Institute",
                      onSelected: (AutoCompleteModel model) => {
                        universityController.text = model.label,
                        selectedUniversity = model,
                        Navigator.pop(context)
                      },
                      itemsData: universityInstitueList,
                    );
                  });
            }),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),

              suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("University / Institute"),
              //border: OutlineInputBorder(),
              //  border: InputBorder.none,
              hintText: "Mumbai University",
              // prefixIcon: Icon(Icons.school_sharp)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: degreeController,
            enabled: true,
            onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "Degree / Specialization",
                      onSelected: (AutoCompleteModel model) => {
                        degreeController.text = model.label,
                        selectedDegree = model,
                        Navigator.pop(context)
                      },
                      itemsData: degreeList,
                    );
                  });
            }),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Degree / Specialization"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Bachelor of Commerce",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            //  controller: degreeController,
            //  enabled: true,
            /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Field of study"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Accounts and Finance",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
            // ],
            controller: passingYearController,
            keyboardType: TextInputType.number,
            // maxLength: 4,
            onChanged: ((value) => {}),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid first and last name';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              // icon: Icon(Icons.calendar_month),
              label: const Text("First Year"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: 'Jun-23',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
            // ],
            controller: passingYearController,
            keyboardType: TextInputType.number,
            // maxLength: 4,
            onChanged: ((value) => {}),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid first and last name';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              // icon: Icon(Icons.calendar_month),
              label: const Text("Final date"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: 'April-23',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*  customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false), */
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox customWidgetPost() {
    return SizedBox(
      child: Column(
        children: [
          TextFormField(
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please select any job location';
            //   }
            // },
            controller: universityController,
            enabled: true,
            onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "University / Institute",
                      onSelected: (AutoCompleteModel model) => {
                        universityController.text = model.label,
                        selectedUniversity = model,
                        Navigator.pop(context)
                      },
                      itemsData: universityInstitueList,
                    );
                  });
            }),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),

              suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("University / Institute"),
              //border: OutlineInputBorder(),
              //  border: InputBorder.none,
              hintText: "Mumbai University",
              // prefixIcon: Icon(Icons.school_sharp)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: degreeController,
            enabled: true,
            onTap: (() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(
                      tile: null,
                      dialogTitle: "Degree / Specialization",
                      onSelected: (AutoCompleteModel model) => {
                        degreeController.text = model.label,
                        selectedDegree = model,
                        Navigator.pop(context)
                      },
                      itemsData: degreeList,
                    );
                  });
            }),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Degree / Specialization"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Bachelor of Commerce",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            //  controller: degreeController,
            //  enabled: true,
            /* onTap: (() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogList(
                    tile: null,
                    dialogTitle: "Degree / Specialization",
                    onSelected: (AutoCompleteModel model) => {
                      degreeController.text = model.label,
                      selectedDegree = model,
                      Navigator.pop(context)
                    },
                    itemsData: degreeList,
                  );
                });
          }), */
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              //  suffixIcon: const Icon(Icons.arrow_drop_down),
              // Icons.workspace_premium
              label: const Text("Field of study"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: "Accounts and Finance",
              //  prefixIcon: Icon(Icons.cast_for_education)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
            // ],
            controller: passingYearController,
            keyboardType: TextInputType.number,
            // maxLength: 4,
            onChanged: ((value) => {}),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid first and last name';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              // icon: Icon(Icons.calendar_month),
              label: const Text("First Year"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: 'Jun-23',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
            // ],
            controller: passingYearController,
            keyboardType: TextInputType.number,
            // maxLength: 4,
            onChanged: ((value) => {}),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid first and last name';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              // icon: Icon(Icons.calendar_month),
              label: const Text("Final date"),
              //border: OutlineInputBorder(),
              // border: InputBorder.none,
              hintText: 'April-23',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*    customButton("Digi Locker",
                                    "assets/images/digilocker.png", 70, false), */
                                customButton("Manual",
                                    "assets/images/file_exp.png", 70, false),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: customButton("Upload Marksheet", "", 0, true),
              ),
            ],
          )
        ],
      ),
    );
  }

  save() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().saveUserStages({
      "stage": "education",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "education": selectedEducation.value,
        "degree_spc": selectedDegree.value,
        "university": selectedUniversity.value,
        "passing_year": passingYearController.text,
      }
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (widget.prevPageModel == null) {
        Navigator.pushNamed(context, ERoute.screen3.name);
      } else {
        if (selectedEducation.label.isNotEmpty) {
          widget.prevPageModel.education = selectedEducation.label;
          widget.prevPageModel.education_id =
              int.parse(selectedEducation.value);
        }

        if (selectedUniversity.label.isNotEmpty) {
          widget.prevPageModel.univercity = selectedUniversity.label;
          widget.prevPageModel.univercity_id =
              int.parse(selectedUniversity.value);
        }

        if (selectedDegree.label.isNotEmpty) {
          widget.prevPageModel.degree_spc = selectedDegree.label;
          widget.prevPageModel.degree_spc_id = int.parse(selectedDegree.value);
        }
        if (passingYearController.text != "") {
          widget.prevPageModel.passing_year =
              int.parse(passingYearController.text);
        }

        Navigator.pop(context, widget.prevPageModel);
      }
      Utils.setCacheData('education', int.parse(selectedEducation.value));
    }
    setState(() {});
  }
}
