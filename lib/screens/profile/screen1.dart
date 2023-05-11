import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/autocompleteCheckBoxModel.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/masterService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/autolistviewmodal.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key, this.prevPageModel}) : super(key: key);
  final dynamic prevPageModel;

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late Widget previousWidget;

  // Veriable Declaration
  // DropdownModel ddlModel;
  List locationList = [];
  CardModel model = CardModel();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController joblocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  DateTime dataOfBirthValue = DateTime.now();
  TextEditingController jobLocationController = TextEditingController();
  var dt;

  int locationid = 0;

  String gender = "";
  var ddlValues;

  late List list;

  final basicForm = GlobalKey<FormState>();

  late List<AutoCompleteModel> stateList = [];
  late List<AutoCompleteModel> cityList = [];
  late List languageList = [];
  late List<AutoCompleteCheckBoxModel> languageAutoList = [];

  AutoCompleteModel selectedLocation = AutoCompleteModel("", "", {});

  double? age;

  @override
  void initState() {
    super.initState();
    bindLocation();
    dateOfBirth.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    dt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    if (widget.prevPageModel != null) {
      firstName.text = widget.prevPageModel.first_name;
      lastName.text = widget.prevPageModel.last_name;
      selectedLocation = widget.prevPageModel.job_location_city == null
          ? AutoCompleteModel("", "", {})
          : AutoCompleteModel(widget.prevPageModel.job_location_id.toString(),
              widget.prevPageModel.job_location_city, {});
      jobLocationController.text =
          widget.prevPageModel.job_location_city == null
              ? ''
              : widget.prevPageModel.job_location_city.toString();

      emailadr.text = widget.prevPageModel.email.toString();
      gender = widget.prevPageModel.gender.toString();
      dataOfBirthValue = DateTime.parse(widget.prevPageModel.dateofbirth);
      dateOfBirth.text = DateFormat("dd-MM-yyyy").format(dataOfBirthValue);
    }
  }

  bindLocation() async {
    var result = await MasterService().masterGetByGroups(
        {'groupName': 'state,language', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      for (var e in (ddlValues["content"] as List)) {
        if (e['group_name'] == 'state') {
          stateList.add(AutoCompleteModel(e['id'].toString(), e['value'], e));
        } else if (e['group_name'] == 'language') {
          e['checked'] = false;
          if (widget.prevPageModel?.languages != null) {
            if (widget.prevPageModel.languages.indexOf(e['value']) > -1) {
              e['checked'] = true;
            }
          }

          languageList.add(e);
          languageAutoList.add(AutoCompleteCheckBoxModel(
              e['value'], e['value'], e, e['checked']));
        }
      }
      // try {
      //   languageList.sort((a, b) => a['order'].compareTo(b['order']));
      // } catch (e) {}

      setState(() {});
      // jobLocationList =
      //     .map<AutoCompleteModel>(
      //         (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
      //     .toList();
      // final productId = ModalRoute.of(context)!.settings.arguments;

      // 07/06/2022
      // print(productId);
      // setState(() {
      //   selectedLocation = AutoCompleteModel("0", "", {});
      // });
    }
  }

  bool ismale = false,
      isfemale = false,
      istranse = false,
      single = false,
      married = false,
      divorced = false,
      separated = false,
      widowed = false;
  bool language = false;
  String year = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Entro",
                  style: GoogleFonts.varela(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Introduce yourself to the recruiters",
                  style: GoogleFonts.varela(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              if (basicForm.currentState!.validate()) {
                save();
              }
            },
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: Constants.themeBgColor,
                  borderRadius: BorderRadius.circular(15)),
              width: double.maxFinite,
              padding: const EdgeInsets.only(bottom: 7, top: 7),
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
                color: Constants.borderColor,
                /* icon: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xffffffff),
                  size: 25,
                ), */
                radious: 15,
                isText: true,
                onPressed: () {
                  if (basicForm.currentState!.validate()) {
                    save();
                  }
                },
                text: widget.prevPageModel == null ? "Next" : "Save",
                themeButtonSize: ThemeButtonSize.medium,
              ),
            ),
          ), */
          // backgroundColor: ,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(children: [
                basicInfo(),
              ]),
            ),
          )),
    );
  }

  Widget basicInfo() {
    age = ((DateTime.now().difference(dataOfBirthValue)).inDays / 365.floor());
    return Container(
      margin: const EdgeInsets.only(top: 10),
      key: const Key('second'),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
          child: Form(
            key: basicForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      height: 45.h,
                      child: TextFormField(
                        autofocus: true,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                        // ],
                        controller: firstName,
                        onChanged: ((value) => {
                              model.cardName = value.toTitleCase() +
                                  " " +
                                  lastName.text.toLowerCase(),

                              // username.text = model.cardName!,
                              updateCard(model),
                            }),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          //icon: Icon(Icons.person),
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          label: Text(
                            "First Name",
                            style: GoogleFonts.varela(),
                          ),
                          //border: OutlineInputBorder(),
                          //  border: InputBorder.none,
                          hintText: 'Please enter first name',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2.w,
                      height: 45.h,
                      child: TextFormField(
                        autofocus: true,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                        // ],
                        // controller: firstName,
                        onChanged: ((value) => {
                              /*  model.cardName = value.toTitleCase() +
                                  " " +
                                  lastName.text.toLowerCase(), */

                              // username.text = model.cardName!,
                              // updateCard(model),
                            }),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter middle name';
                          }
                          return null;
                        },

                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          // icon: Icon(Icons.person),
                          label: Text(
                            "Middle Name",
                            style: GoogleFonts.varela(),
                          ),
                          //border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Please enter middle name',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2.w,
                  // height: 45.h,
                  child: TextFormField(
                    autofocus: true,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("^[a-zA-Z0-9_ ]*$"))
                    // ],
                    controller: lastName,
                    onChanged: ((value) => {
                          model.cardName = firstName.text.toLowerCase() +
                              " " +
                              value.toTitleCase(),
                          // username.text = model.cardName!,
                          updateCard(model),
                        }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter surname';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        height: 0,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),

                      // icon: Icon(Icons.person),
                      label: Text(
                        "Surname",
                        style: GoogleFonts.varela(),
                      ),
                      //border: OutlineInputBorder(),
                      //   border: InputBorder.none,
                      hintText: 'Please enter surname',
                    ),
                  ),
                ),

                // const SizedBox(height: 10),
                // TextFormField(
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter Job city';
                //     }
                //     return null;
                //   },
                //   decoration: const InputDecoration(
                //     border: InputBorder.none,
                //     icon: Icon(Icons.location_city),
                //     label: Text("Job City"),
                //     // border: OutlineInputBorder(),
                //     hintText: 'Enter Job city',
                //   ),
                // ),
                //const SizedBox(height: 10),
                // CustomControls.AutoCompleteCustom(
                //   context,
                //   "Job Location",
                //   "Enter Job Location",
                //   ((AutoCompleteModel item) => {
                //         setState(() {
                //           selectedLocation = item;
                //         }),
                //         print(selectedLocation.label),
                //       }),
                //   selectedLocation,
                //   jobLocationList,
                //   Icons.location_city,
                //   validator: (value) {
                //     if (value == null ||
                //         value.isEmpty && !value.contains(' ')) {
                //       return 'Please enter valid job location';
                //     }
                //     return null;
                //   },
                // ),
                const Divider(
                  thickness: 1.5,
                  // height: 15,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Gender",
                  style: GoogleFonts.varela(
                      fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),

                Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        // color: Colors.green,
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              // gender = value.toString();
                              isfemale = false;
                              istranse = false;
                              ismale = true;
                              model.gender = "male";
                              updateCard(model);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  ismale ? Constants.borderColor : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ismale
                                    ? Text(
                                        "Male",
                                        style: GoogleFonts.varela(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        "Male",
                                        style:
                                            GoogleFonts.varela(fontSize: 13.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                ismale
                                    ? Image.asset(
                                        "assets/images/check.png",
                                        height: 13.h,
                                      )
                                    : Icon(
                                        Icons.add,
                                        size: 15.h,
                                      )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // gender = value.toString();
                              isfemale = true;
                              ismale = false;
                              istranse = false;
                              model.gender = "female";
                              updateCard(model);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isfemale
                                  ? Constants.borderColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isfemale
                                    ? Text(
                                        "Female",
                                        style: GoogleFonts.varela(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        "Female",
                                        style:
                                            GoogleFonts.varela(fontSize: 13.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                isfemale
                                    ? Image.asset(
                                        "assets/images/check.png",
                                        height: 13.h,
                                      )
                                    : Icon(
                                        Icons.add,
                                        size: 15.h,
                                      )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // gender = value.toString();
                              istranse = true;
                              ismale = false;
                              isfemale = false;
                              model.gender = "trans";
                              updateCard(model);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: istranse
                                  ? Constants.borderColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                istranse
                                    ? Text(
                                        "Transgender",
                                        style: GoogleFonts.varela(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        "Transgender",
                                        style:
                                            GoogleFonts.varela(fontSize: 13.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                istranse
                                    ? Image.asset(
                                        "assets/images/check.png",
                                        height: 13.h,
                                      )
                                    : Icon(
                                        Icons.add,
                                        size: 15.h,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),

                SizedBox(
                  height: 6.h,
                ),
                const Divider(
                  thickness: 1.5,
                  // height: 15,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Email ID",
                  style: GoogleFonts.varela(
                      fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 35,
                  width: 260.w,
                  child: TextFormField(
                    // initialValue: "+9004390874",
                    // enabled: false,
                    controller: emailadr,
                    onChanged: ((value) => {
                          model.email = value,
                          updateCard(model),
                        }),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      // icon: Icon(Icons.email),
                      //label: Text("Add Email ID"),
                      //border: OutlineInputBorder(),
                      hintText: 'test@gmail.com',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty && !value.contains(' ')) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                const Divider(
                  thickness: 1.5,
                  // height: 15,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Marital Status",
                  style: GoogleFonts.varela(
                      fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Wrap(
                  children: [
                    // mareital_status(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          single = true;
                          married = false;
                          divorced = false;
                          widowed = false;
                          separated = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: single ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: const EdgeInsets.only(right: 10, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            single
                                ? Text(
                                    "Single",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Single",
                                    style: GoogleFonts.varela(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            single
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 15.h,
                                  )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          single = false;
                          married = true;
                          divorced = false;
                          widowed = false;
                          separated = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: married ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: const EdgeInsets.only(right: 10, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            married
                                ? Text(
                                    "Married",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Married",
                                    style: GoogleFonts.varela(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            married
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 15.h,
                                  )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          single = false;
                          married = false;
                          divorced = true;
                          widowed = false;
                          separated = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              divorced ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: const EdgeInsets.only(right: 10, bottom: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            divorced
                                ? Text(
                                    "Divorced",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Divorced",
                                    style: GoogleFonts.varela(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            divorced
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 15.h,
                                  )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          single = false;
                          married = false;
                          divorced = false;
                          widowed = true;
                          separated = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widowed ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widowed
                                ? Text(
                                    "Widowed",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Widowed",
                                    style: GoogleFonts.varela(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            widowed
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 15.h,
                                  )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // gender = value.toString();
                          single = false;
                          married = false;
                          divorced = false;
                          widowed = false;
                          separated = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              separated ? Constants.borderColor : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            separated
                                ? Text(
                                    "Separated",
                                    style: GoogleFonts.varela(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Separated",
                                    style: GoogleFonts.varela(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                            SizedBox(
                              width: 4.w,
                            ),
                            separated
                                ? Image.asset(
                                    "assets/images/check.png",
                                    height: 13.h,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 15.h,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 6.h,
                ),
                const Divider(
                  thickness: 1.5,
                  // height: 15,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Date of Birth",
                  style: GoogleFonts.varela(
                      fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35,
                      width: 110.w,
                      child: TextFormField(
                        controller: dateOfBirth,
                        // validator: (value) {
                        //   if (value == null ||
                        //       value.isEmpty && !value.contains(' ')) {
                        //     return 'Please enter valid first and last name';
                        //   }
                        //   return null;
                        // },

                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          //  icon: Icon(Icons.calendar_month),
                          // label: Text("Date Of Birth"),
                          //border: OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.only(top: 10, left: 10),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(color: Constants.borderColor)),
                          hintText: 'Please enter date of birth',
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dataOfBirthValue,
                              firstDate: DateTime.now()
                                  .add(const Duration(days: -(365 * 50))),
                              lastDate: DateTime.now(),
                              currentDate: dataOfBirthValue);

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            dataOfBirthValue = pickedDate;
                            setState(() {
                              dateOfBirth.text = formattedDate;
                              dt = DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(pickedDate);
                              // year = ("$formattedDate-${DateTime.now()}");
                              dt = DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(pickedDate);
                              year = (dt - DateTime.now());
                              dateOfBirth = dt;
                              //set output date to TextField value.
                            });
                          } else {
                            // ignore: avoid_print
                            print("Date is not selected");
                          }
                        },
                      ),
                    ),
                    Text("Age : ${calculateAge(dataOfBirthValue).toString()}"),
                  ],
                ),
                SizedBox(
                  height: 6.h,
                ),
                const Divider(
                  thickness: 1.5,
                  // height: 15,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Reside at",
                  style: GoogleFonts.varela(
                      fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),

                SizedBox(
                  height: 35,
                  width: 110.w,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select any job location';
                      }
                      return null;
                    },
                    controller: jobLocationController,
                    enabled: true,
                    onTap: (() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogList(
                              tile: null,
                              dialogTitle: "Select State",
                              onSelected: (AutoCompleteModel model) async {
                                await selectCity(model.value);
                              },
                              itemsData: stateList,
                            );
                          });
                    }),
                    decoration: InputDecoration(
                      //icon: Icon(Icons.location_city),
                      contentPadding: const EdgeInsets.only(top: 10, left: 10),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      //label: Text("Job City"),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      hintText: 'Select Job City',
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                const Divider(
                  thickness: 1.5,
                  // height: 15,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Language Known",
                  style: GoogleFonts.varela(
                      fontSize: 13.sp, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(children: [customLanguage("English")]),

                /* GestureDetector(
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.7),
                        borderRadius: BorderRadius.circular(60)),
                    child: const Text(
                      "Select Language",
                      style: GoogleFonts.varela(
                          fontSize: 16, color: Color.fromARGB(255, 163, 0, 0)),
                    ),
                  ),
                  onTap: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogCheckBoxList(
                            tile: null,
                            dialogTitle: "Languages",
                            onSelected:
                                (List<AutoCompleteCheckBoxModel> model) => {
                              setState(() {
                                languageAutoList = model;
                              }),
                              // jobLocationController.text = model.label,
                              Navigator.pop(context)
                            },
                            itemsData: languageAutoList,
                          );
                        })
                  },
                ), */
                /* ResponsiveGridRow(children: [            // old language selected container code
                  for (var s in languageAutoList)
                    if (s.checked == true)
                      ResponsiveGridCol(
                        xs: 4,
                        sm: 2,
                        md: 4,
                        child: Container(
                          height: 32.h,
                          //width: 120.w,
                          // alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          padding: const EdgeInsets.only(
                              left: 12, right: 10, bottom: 5, top: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                s.label,
                                style: GoogleFonts.varela(
                                    fontSize: 13.sp, color: Colors.black),
                              ),
                              Icon(
                                Icons.add,
                                size: 15.h,
                                color: Colors.grey.shade300,
                              )
                            ],
                          ),
                        ),
                      )
                ]), */
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Widget mareital_status(String title,bool _single,bool _married,bool _divorced,bool _widowed,bool _separated) {
    return InkWell(
                    onTap: () {
                      setState(() {
                        // gender = value.toString();
                        single = _single;
                        married = _married;
                        divorced = _divorced;
                        widowed = _widowed;
                        separated = _separated;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: single ? Constants.borderColor : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          single
                              ? Text(
                                  title,
                                  style: GoogleFonts.varela(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  title,
                                  style: GoogleFonts.varela(fontSize: 13.sp),
                                  textAlign: TextAlign.center,
                                ),
                          SizedBox(
                            width: 4.w,
                          ),
                          single
                              ? Image.asset(
                                  "assets/images/check.png",
                                  height: 13.h,
                                )
                              : Icon(
                                  Icons.add,
                                  size: 15.h,
                                )
                        ],
                      ),
                    ),
                  );
  } */

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  InkWell customLanguage(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          language = !language;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
        decoration: BoxDecoration(
            color: language ? Constants.borderColor : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            language
                ? Text(
                    title,
                    style: GoogleFonts.varela(
                        fontSize: 13.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    title,
                    style: GoogleFonts.varela(fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              width: 4.w,
            ),
            language
                ? Image.asset(
                    "assets/images/check.png",
                    height: 13.h,
                  )
                : Icon(
                    Icons.add,
                    size: 15.h,
                  )
          ],
        ),
      ),
    );
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    model.email = items.email;
    model.gender = items.gender;

    // model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    setState(() {});
  }

  selectCity(stateId) async {
    cityList.clear();
    var result = await MasterService().getByGroupParentId({
      'groupName': 'city',
      'parentId': stateId,
      'pageNumber': '1',
      'pageSize': '2000'
    });
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      ddlValues = Utils.parseResponse(result).resultData;
      // list=ddlValues["content"];

      for (var e in (ddlValues as List)) {
        cityList.add(AutoCompleteModel(e['id'].toString(), e['value'], e));
      }
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogList(
              tile: null,
              dialogTitle: "Select Location",
              onSelected: (AutoCompleteModel model) async {
                jobLocationController.text = model.label;
                selectedLocation = model;
                Navigator.pop(context);
              },
              itemsData: cityList,
            );
          });
      setState(() {});
    }
  }

  save() async {
    // var result = await UserDataService().masterGetByGroup(
    //     {'groupName': 'location', 'pageNumber': '1', 'pageSize': '10'});
    // print(Utils.parseResponse(result).resultData);
    // return;
    SharedPreferences prefs = await Utils.getSharedPreferences();
    // prefs.setString('username', username.text);

    // String userName = firstName.text;
    // if (userName.isNotEmpty) {
    //   // if (!GlobalConstants.spaceMatch
    //   //     .hasMatch(firstName.text.trim().toTitleCase())) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text("Please enter valid name"),
    //   ));
    //   return;
    //   // }
    // }

    // var firstName = username.text.trim().split(' ')[0];
    // var lastName = username.text.trim().split(' ')[1];
    var mobilenumber = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_mobile.name);
    var selectedLanguages = languageAutoList
        .where((element) => element.checked == true)
        .map((e) => e.value)
        .toList();

    var params = {
      "stage": "basic_info",
      "data": {
        "id": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name),
        "mobile": mobilenumber,
        "first_name": firstName.text.trim(),
        "last_name": lastName.text.trim(),
        "languages": selectedLanguages,
        "job_location_id": selectedLocation.value,
        "email": emailadr.text,
        "gender": gender,
        "dateofbirth": DateFormat("yyyy-MM-dd").format(dataOfBirthValue),
        "usertype": await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_type.name),
      }
    };

    CardModel model = CardModel();
    model.mobile = mobilenumber;
    model.cardName = (firstName.text + " " + lastName.text).toTitleCase();
    model.email = emailadr.text;
    model.gender = gender;
    print(params);
    var result = await UserDataService().saveUserStages(params);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      await Utils.setPreference(
          prefs, ESharedPreferences.user_data.name, jsonEncode(model));
      if (widget.prevPageModel == null) {
        Navigator.pushNamed(context, ERoute.screen2.name);
      } else {
        widget.prevPageModel.first_name = firstName.text;
        widget.prevPageModel.last_name = lastName.text;
        widget.prevPageModel.job_location_city = selectedLocation.label;
        widget.prevPageModel.job_location_id =
            int.parse(selectedLocation.value);
        widget.prevPageModel.gender = gender;
        widget.prevPageModel.languages = selectedLanguages;
        widget.prevPageModel.dateofbirth =
            DateFormat("yyyy-MM-dd").format(dataOfBirthValue);

        Navigator.pop(context, widget.prevPageModel);
      }
      Utils.setCacheData('firstName', firstName.text);
    }
    setState(() {});
  }
}
