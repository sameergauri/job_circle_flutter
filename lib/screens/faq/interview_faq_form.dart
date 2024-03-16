import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customSnackBar.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/custom_suggestion_textfield.dart';
import 'package:job_circle/constants/custom_textfield_for_profile.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/interview_faq_post_model.dart';
import 'package:job_circle/models/interviewbay_faq_model.dart';
import 'package:job_circle/screens/faq/interview_bay_faq_detail.dart';
import 'package:job_circle/themes/colors.dart';

class InterviewFaqForm extends ConsumerStatefulWidget {
  int? id;
  int? crpfid;
  String? icon;
  String? roleName;
  String? now;
  String? process;
  InterviewFaqForm(
      {super.key,
      this.id,
      this.icon,
      this.roleName,
      this.process,
      this.now,
      this.crpfid});

  @override
  ConsumerState<InterviewFaqForm> createState() => _InterviewFaqFormState();
}

class _InterviewFaqFormState extends ConsumerState<InterviewFaqForm> {
  TextEditingController companyName = TextEditingController();
  TextEditingController process = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController now = TextEditingController();
  TextEditingController postedBy = TextEditingController();
  TextEditingController quesController = TextEditingController();
  TextEditingController answer = TextEditingController();

  FocusNode companyNameFocusNode = FocusNode();
  FocusNode processFocusNode = FocusNode();
  FocusNode roleFocusNode = FocusNode();
  FocusNode nowFocusNode = FocusNode();

  bool isCompany = false;
  bool isProcess = false;
  bool isRole = false;
  bool isNow = false;
  bool isEdit4 = false;
  bool isEdit1 = false;
  bool isEdit2 = false;
  bool isEdit3 = false;
  bool isComp = false;
  bool isValue = false;
  bool isDropOpen = false;

  String? parentID, question, pId;
  String? jobId;
  String? companyId;
  String? shortCode;
  String? roleCode;
  String? icon;
  String? firstName;
  String? lastName;
  String selectValue = '';
  String? parentId, processId, isEmp;
  String? roleId;
  String? roleName;

  int? natureOfWorkID;
  int? userId;
  int? id;

  var spocName = [];
  List<QuestionAnswersController> qA = [];
  InterviewFaqGetModel? item;

  void onTextField1Tap1(TextEditingController tappedController) {
    process.clear();
    role.clear();
    now.clear();
    setState(() {
      isEdit4 = false;
      isEdit2 = false;
      isEdit1 = false;
    });
  }

  void onTextField1Tap2(TextEditingController tappedController) {
    role.clear();
    now.clear();
    setState(() {
      isEdit2 = false;
      isEdit1 = false;
    });
  }

  void onTextField1Tap3(TextEditingController tappedController) {
    now.clear();
    setState(() {
      isEdit2 = false;
    });
  }

  void onTextField1Tap4(TextEditingController tappedController) {}

  @override
  void initState() {
    super.initState();
    fetchData();
    loadUserByRole();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${GlobalConstants.API_Host_one}/interviewfaqs/{id}?id=${widget.id}'));

      if (response.statusCode == 200) {
        // final jsonData = json.decode(response.body)['resultData']['content'];

        // List<Map<String, dynamic>> questionAnswersData =
        //     List<Map<String, dynamic>>.from(jsonData);

        dynamic responseData = json.decode(response.body)['resultData'];
        if (responseData != null) {
          item = InterviewFaqGetModel.fromJson(responseData);
          setState(() {
            if (item != null) {
              jobId = item?.crpfid.toString();
              id = item?.id!.toInt();
              userId = item?.userId!.toInt();
              process.text = item!.process.toString();
              role.text = item!.roleName.toString();
              now.text = item!.natureOfWork.toString();
              companyName.text = item!.name.toString();
              // roleCode = item!.roleCode.toString();
              shortCode = item!.shortCode.toString();
              icon = item!.icon;
              postedBy.text =
                  "${item!.firstName.toString()} ${item!.lastName.toString()}";
              quesController.text = item!.question.toString();
              answer.text = item!.answer!.toString();

              // for (int i = 0; i < questionAnswersData.length; i++) {
              //   Map<String, dynamic> data = questionAnswersData[i];
              //   qA.add(QuestionAnswersController(
              //       question: TextEditingController(text: data['question']),
              //       answer: TextEditingController(text: data['answer']),
              //       id: data['id']));
              //   jobId = data['crpfid'].toString();
              //   userId = data['user_id'];
              //   companyName.text = data['name'].toString();
              //   process.text = data['process'].toString();
              //   role.text = data['rolename'].toString();
              //   now.text = data['naturofwork'].toString();
              //   icon = data['icon'].toString();
              //   roleCode = data['role_code'].toString();
              //   shortCode = data['short_code'].toString();
              //   firstName = data['first_name'].toString();
              //   lastName = data['last_name'].toString();
              //   postedBy.text =
              //       "${data['first_name'].toString()} ${data['last_name'].toString()}";
              // }
            }
          });
        } else {
          throw Exception('No data found in the response');
        }

        // setState(() {});
      } else {
        throw Exception('Failed to fetch data from the API');
      }
    } catch (error) {
      throw Exception('Error occurred while fetching data: $error');
    }
  }

  void getCompanyId(String id) {
    setState(() {
      companyId = id;
      if (isEdit4 == false) {
        isEdit1 = false;
        isEdit2 = false;
        isEdit3 = false;
        process.clear();
      }
      if (role.text.isEmpty) {
        FocusScope.of(context).requestFocus(roleFocusNode);
      } else if (role.text.isNotEmpty && process.text.isEmpty) {
        FocusScope.of(context).requestFocus(processFocusNode);
      } else if (process.text.isNotEmpty && now.text.isEmpty) {
        FocusScope.of(context).requestFocus(nowFocusNode);
      }
    });
  }

  void getValueOfJobtitle(String getJobTitle) async {
    setState(() {
      question = getJobTitle;
      if (companyName.text.isEmpty) {
        FocusScope.of(context).requestFocus(companyNameFocusNode);
      } else if (process.text.isEmpty) {
        FocusScope.of(context).requestFocus(processFocusNode);
      } else if (process.text.isNotEmpty && now.text.isEmpty) {
        FocusScope.of(context).requestFocus(nowFocusNode);
      }
    });
  }

  String? pro;
  void getValuOfProcess(String gteProcess) {
    setState(() {
      pro = gteProcess;
      if (companyName.text.isEmpty) {
        FocusScope.of(context).requestFocus(companyNameFocusNode);
      } else if (role.text.isEmpty) {
        FocusScope.of(context).requestFocus(roleFocusNode);
      } else {
        FocusScope.of(context).requestFocus(nowFocusNode);
      }
    });
  }

  void getNatureOfWorkId(String ids) {
    setState(() {
      natureOfWorkID = int.parse(ids);
      if (companyName.text.isEmpty) {
        FocusScope.of(context).requestFocus(companyNameFocusNode);
      } else if (role.text.isEmpty) {
        FocusScope.of(context).requestFocus(roleFocusNode);
      } else if (process.text.isEmpty) {
        FocusScope.of(context).requestFocus(processFocusNode);
      }
    });
  }

  void getFunctionalAreaIdCust(int id) {
    setState(() {
      jobId = id.toString();
    });
  }

  void loadUserByRole() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/users/v1/UserByRole?page=1&size=100';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var dataResult = Utils.parseResponse(response).resultData;
        spocName = dataResult['content'] as List<dynamic>;

        setState(() {});
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.id != null || widget.process != null
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              titleTextStyle: GoogleFonts.varela(color: Constants.themeBgColor),
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.text.isNotEmpty
                        ? role.text
                        : widget.roleName.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.varela(
                      fontSize: 16.h,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        process.text.isNotEmpty
                            ? process.text
                            : widget.process.toString(),
                        style: GoogleFonts.varela(
                          fontSize: 12.h,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        " ||",
                        style: GoogleFonts.varela(
                          fontSize: 12.h,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        now.text.isNotEmpty ? now.text : widget.now.toString(),
                        style: GoogleFonts.varela(
                          fontSize: 12.h,
                        ),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                  icon != "" || widget.icon != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 30.h,
                          width: 60.w,
                          child: CustomImage(
                            imageUrl:
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${icon ?? widget.icon}",
                            defaultImageUrl: "assets/images/logo.png",
                          ))
                      : const SizedBox()
                ])
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              titleTextStyle: GoogleFonts.varela(color: Constants.themeBgColor),
              automaticallyImplyLeading: false,
              title: Center(
                child: Text(
                  "Add Interview QA",
                  style: GoogleFonts.varela(
                    fontSize: 16.h,
                  ),
                ),
              ),
            ),
      bottomNavigationBar: InkWell(
        onTap: () {
          save();
        },
        child: Container(
          margin:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
              color: Constants.themeBgColor,
              borderRadius: BorderRadius.circular(8.r)),
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
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.id == null && widget.process == null)
              Column(
                children: [
                  isComp
                      ? customCompanyforExperience(
                          onTapCallback: onTextField1Tap1,
                          focusNode: companyNameFocusNode,
                          isCompany: true,
                          name: "company",
                          title: "Client Name",
                          controller: companyName,
                          onChanged: (p0) {
                            isEdit4 = p0;
                            role.clear();
                            process.clear();
                            now.clear();
                            isComp = false;
                          },
                          contextIn: context,
                          onSubmit: getCompanyId,
                          hintText: "Aditya birla Health Insurance",
                          //getSuggestions:(){},
                          onIDSelected: () {},
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 24,
                              child: TextFormField(
                                onTap: () {
                                  setState(() {
                                    isComp = true;
                                    isEdit4 = false;
                                    isEdit1 = false;
                                    isEdit2 = false;
                                    isEdit3 = false;
                                    isProcess = true;
                                    isRole = true;
                                    isNow = true;
                                    companyName.clear();
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This Text field Cant be empty";
                                  }
                                  return null;
                                },
                                textCapitalization: TextCapitalization.words,
                                controller: companyName,
                                style: GoogleFonts.varela(
                                    color: Constants.subtitleclr,
                                    fontSize: 14.sp),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.holiday_village_outlined,
                                    color: Constants.themeBgColor,
                                  ),
                                  prefixIconColor: Constants.themeBgColor,
                                  contentPadding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    left: 10,
                                    right: 10,
                                  ),
                                  counterText: '',
                                  labelText: 'Client Name',
                                  labelStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.themeBgColor,
                                    fontSize: 14.sp,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: Color(0xffff0eceb),
                                    ),
                                  ),
                                  focusColor: const Color(0xffff0eceb),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: Constants.themeBgColor,
                                    ),
                                  ),
                                  hintText: 'Aditya Birla Health Insurance',
                                  hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.hintColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isEdit4
                      ? SuggestionTextField(
                          onTapCallback: onTextField1Tap2,
                          companyID: companyId,
                          controller: process,
                          textfieldNumber: 1,
                          process: process.text,
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
                              now.clear();
                            });
                          },
                        )
                      : const SizedBox(),
                  if (isProcess == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 24,
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              isProcess = true;
                              // isEdit4 = truep
                              isRole = true;
                              isNow = true;
                              isEdit1 = false;
                              isEdit4 = true;
                              process.clear();
                              // process.clear();
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This Text field Cant be empty";
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          controller: process,
                          style: GoogleFonts.varela(
                              color: Constants.subtitleclr, fontSize: 14.sp),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.propane_outlined,
                              color: Constants.themeBgColor,
                            ),
                            prefixIconColor: Constants.themeBgColor,
                            contentPadding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 10,
                              right: 10,
                            ),
                            counterText: '',
                            labelText: 'Process',
                            labelStyle: GoogleFonts.sourceSansPro(
                              color: Constants.themeBgColor,
                              fontSize: 14.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: Color(0xffff0eceb),
                              ),
                            ),
                            focusColor: const Color(0xffff0eceb),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: const BorderSide(
                                color: Constants.themeBgColor,
                              ),
                            ),
                            hintText: 'Health Insurance',
                            hintStyle: GoogleFonts.sourceSansPro(
                              color: Constants.hintColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isRole == true)
                    isEdit1 && isEdit4
                        ? SuggestionTextField(
                            onTapCallback: onTextField1Tap3,
                            companyID: companyId,
                            controller: role,
                            textfieldNumber: 2,
                            process: process.text,
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

                                now.clear();
                              });
                            },
                            /*    getSpoc: (int id) {},
                            getInterviewRounds: (List<String> id) {},
                            getJobId: (String id) {}, */
                          )
                        : const SizedBox(),
                  if (isRole == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        //   margin: EdgeInsets.only(top: 4.h),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 24,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                isRole = true;
                                isEdit3 = true;
                                isEdit1 = true;
                                isEdit4 = true;
                                isEdit2 = false;
                                isNow = true;
                                // role.clear();
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This Text field Cant be empty";
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            controller: role,
                            style: GoogleFonts.varela(
                                color: Constants.subtitleclr, fontSize: 14.sp),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.engineering_outlined,
                                color: Constants.themeBgColor,
                              ),
                              prefixIconColor: Constants.themeBgColor,
                              contentPadding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 10,
                                right: 10,
                              ),
                              counterText: '',
                              labelText: 'Role',
                              labelStyle: GoogleFonts.sourceSansPro(
                                color: Constants.themeBgColor,
                                fontSize: 14.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: Color(0xffff0eceb),
                                ),
                              ),
                              focusColor: const Color(0xffff0eceb),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: Constants.themeBgColor,
                                ),
                              ),
                              hintText: 'Job Title / Role',
                              hintStyle: GoogleFonts.sourceSansPro(
                                color: Constants.hintColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isNow == true)
                    isEdit2 && isEdit1 && isEdit4
                        ? SuggestionTextField(
                            onTapCallback: onTextField1Tap4,
                            companyID: companyId,
                            controller: now,
                            textfieldNumber: 3,
                            process: process.text,
                            role: role.text,
                            // icon: Icons.outbond,
                            hint: "Sales",
                            title: "Functional Area",
                            getFunctionalAreaId: getFunctionalAreaIdCust,
                            // getSpoc: ((p0) {}),
                            // getInterviewRounds: (p0) {},
                            // getJobId: (p0) {},
                            onChanged: (p0) {
                              setState(() {
                                isEdit3 = p0;
                              });
                            },
                          )
                        : const SizedBox(),
                  if (isNow == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        //: EdgeInsets.only(top: 4.h),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 24,
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                isNow = true;
                                isEdit2 = true;
                                isEdit1 = true;
                                isEdit4 = true;
                                // now.clear();
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This Text field Cant be empty";
                              }
                              return null;
                            },
                            textCapitalization: TextCapitalization.words,
                            controller: now,
                            style: GoogleFonts.varela(
                              color: Constants.subtitleclr,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.outbond,
                                color: Constants.themeBgColor,
                              ),
                              prefixIconColor: Constants.themeBgColor,
                              contentPadding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 10,
                                right: 10,
                              ),
                              counterText: '',
                              labelText: 'Functional Area',
                              labelStyle: GoogleFonts.sourceSansPro(
                                color: Constants.themeBgColor,
                                fontSize: 14.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: Color(0xffff0eceb),
                                ),
                              ),
                              focusColor: const Color(0xffff0eceb),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                  color: Constants.themeBgColor,
                                ),
                              ),
                              hintText: 'Job Title / Role',
                              hintStyle: GoogleFonts.sourceSansPro(
                                color: Constants.hintColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            // Text(
            //   'Question',
            //   style: GoogleFonts.varela(fontWeight: FontWeight.bold),
            // ),
            TextField(
              controller: quesController,
              decoration: const InputDecoration(
                hintText: 'Type your question here...',
                border: UnderlineInputBorder(),
              ),
              style: GoogleFonts.varela(fontWeight: FontWeight.bold),
              maxLines: null, // Allow multiline input
            ),
            const SizedBox(height: 20.0),
            // Text('Answer',
            //     style: GoogleFonts.varela(fontWeight: FontWeight.bold)),
            TextField(
              controller: answer,
              decoration: const InputDecoration(
                hintText: 'Type your answer here...',
                border: UnderlineInputBorder(),
              ),
              maxLines: null, // Allow multiline input
            ),
            // CustomJobTitleForExperience(
            //   isCity: false,
            //   stateId: int.tryParse(jobId.toString()),
            //   onIDSelected: () {},
            //   role: "",
            //   isCompany: false,
            //   isIndustry: false,
            //   name: "question",
            //   title: "Question",
            //   controller: quesController,
            //   onTap: () {
            //     // qA[index].designation.clear();
            //   },
            //   onChanged: (p0) {
            //     setState(() {});
            //   },
            //   onSubmit: (p0) {
            //     setState(() {
            //       //    qA[index].roleId = int.tryParse(p0 ?? '') ?? 0;
            //     });
            //   },
            //   contextIn: context,
            //   hintText: "",
            //   icon: Icons.roller_shades,
            //   companyID: '',
            //   isCode: false,
            //   process: '',
            //   textfieldNumber: 0,
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // CustomJobTitleForExperience(
            //   isCity: false,
            //   stateId: int.tryParse(jobId.toString()),
            //   onIDSelected: () {},
            //   role: "",
            //   isCompany: false,
            //   isIndustry: false,
            //   name: "answer",
            //   title: "Answer",
            //   controller: answer,
            //   onTap: () {
            //     // qA[index].designation.clear();
            //   },
            //   onChanged: (p0) {
            //     setState(() {});
            //   },
            //   onSubmit: (p0) {
            //     setState(() {
            //       //    qA[index].roleId = int.tryParse(p0 ?? '') ?? 0;
            //     });
            //   },
            //   contextIn: context,
            //   hintText: "",
            //   icon: Icons.roller_shades,
            //   companyID: '',
            //   isCode: false,
            //   process: '',
            //   textfieldNumber: 0,
            // ),
            const SizedBox(
              height: 350,
            ),
            if (id != null)
              Center(
                child: IconButton(
                  icon: Image.asset(
                    "assets/images/bin.gif",
                    height: 40.h,
                  ),
                  onPressed: () {
                    String apiUrl =
                        'http://${GlobalConstants.API_Host}/interviewfaqs/$id';

                    http.delete(Uri.parse(apiUrl)).then((response) {
                      if (response.statusCode == 200 ||
                          response.statusCode == 204) {
                        ref.refresh(interviewFaqByjobProvider(
                            int.parse(jobId.toString())));

                        Navigator.pop(context);
                      } else {}
                    }).catchError((error) {});
                  },
                ),
              )

            // Column(
            //   children: [
            //     Container(
            //       height: MediaQuery.of(context).size.height / 24,
            //       child: TextFormField(
            //         textCapitalization: TextCapitalization.words,
            //         controller: postedBy.text.isNotEmpty
            //             ? postedBy
            //             : TextEditingController(text: selectValue),
            //         onTap: () {
            //           setState(() {
            //             if (selectValue.isNotEmpty) {
            //               selectValue = '';
            //               postedBy.text = '';
            //               isValue = false;
            //               isDropOpen = !isDropOpen;
            //             } else {
            //               isDropOpen = !isDropOpen;
            //             }
            //           });
            //         },
            //         style: GoogleFonts.varela(
            //             color: Constants.subtitleclr, fontSize: 14.sp),
            //         decoration: InputDecoration(
            //           prefixIcon: const Icon(Icons.person),
            //           prefixIconColor: Constants.themeBgColor,
            //           contentPadding: const EdgeInsets.only(
            //               top: 8, bottom: 8, left: 10, right: 10),
            //           counterText: '',
            //           labelText: "Posted By",
            //           labelStyle: GoogleFonts.sourceSansPro(
            //             color: Constants.themeBgColor,
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide:
            //                 const BorderSide(color: Constants.themeBgColor),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           border: OutlineInputBorder(
            //             borderSide: const BorderSide(
            //               color: Color(0xffff0eceb),
            //             ),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //         ),
            //       ),
            //     ),
            //     if (isDropOpen)
            //       Column(
            //         children: spocName.map(
            //           (userData) {
            //             UserRole userModel = UserRole.fromJson(userData);

            //             return Container(
            //               margin: const EdgeInsets.symmetric(vertical: 4),
            //               height: 32,
            //               width: MediaQuery.of(context).size.width * .9,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(8),
            //                 color: spocName.indexOf(userData) % 2 == 1
            //                     ? Colors.grey.shade100
            //                     : Colors.grey,
            //               ),
            //               child: GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     selectValue =
            //                         "${userModel.firstName} ${userModel.lastName}";
            //                     postedBy.text = selectValue;
            //                     userId = userModel.id;
            //                     isValue = true;
            //                     isDropOpen = false;
            //                   });
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                       vertical: 6, horizontal: 20),
            //                   child: Row(
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             userModel.firstName,
            //                             style: GoogleFonts.sourceSansPro(
            //                               color: Colors.black,
            //                               fontSize: 14.sp,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const Text(" "),
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             userModel.lastName,
            //                             style: GoogleFonts.sourceSansPro(
            //                               color: Colors.black,
            //                               fontSize: 14.sp,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const Text("  -  "),
            //                       Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             userModel.role,
            //                             style: GoogleFonts.sourceSansPro(
            //                               color: Colors.black,
            //                               fontSize: 14.sp,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             );
            //           },
            //         ).toList(),
            //       )
            //   ],
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // ListView.builder(
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: qA.length,
            //   itemBuilder: (context, index) {
            //     bool isLast = index == qA.length - 1;
            //     bool isFirst = index == 0;

            //     return Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         _buildQAInputFields(index),
            //         const SizedBox(height: 10),
            //         if (isLast)
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               if (!isFirst && isLast)
            //                 Align(
            //                     alignment: Alignment.centerLeft,
            //                     child: IconButton(
            //                       icon: Icon(Icons.delete,
            //                           color: Colors.redAccent),
            //                       onPressed: () {
            //                         setState(() {
            //                           if (qA[index].id != null) {
            //                             int intId = qA[index].id!.toInt();
            //                             if (intId != 0 &&
            //                                 intId == qA[index].id!.toInt()) {
            //                               String apiUrl =
            //                                   'http://${GlobalConstants.API_Host}/interviewfaqs/{crpfid}/$intId';

            //                               http
            //                                   .delete(Uri.parse(apiUrl))
            //                                   .then((response) {})
            //                                   .catchError((error) {});
            //                             }
            //                           }

            //                           clearQuestionControllers(index);
            //                           qA.removeAt(index);
            //                         });
            //                       },
            //                     )),
            //               Align(
            //                 alignment: Alignment.centerRight,
            //                 child: InkWell(
            //                   onTap: () {
            //                     if (qA[index].answer.text.isEmpty) {
            //                       ScaffoldMessenger.of(context)
            //                           .showSnackBar(SnackBar(
            //                         backgroundColor:
            //                             Constants.themeBgColorLight,
            //                         content: Text(
            //                           'Please add the Answer for current Question.',
            //                           style: GoogleFonts.varela(),
            //                         ),
            //                       ));
            //                     } else {
            //                       setState(() {
            //                         qA.add(QuestionAnswersController(
            //                           question: TextEditingController(),
            //                           answer: TextEditingController(),
            //                         ));
            //                         // qA[index].isCurrent = 0;
            //                       });
            //                     }
            //                   },
            //                   child: Container(
            //                     margin: const EdgeInsets.only(left: 10),
            //                     padding: EdgeInsets.symmetric(
            //                         vertical: 4.h, horizontal: 10.w),
            //                     decoration: BoxDecoration(
            //                       border: Border.all(color: Colors.blueAccent),
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                     child: Text(
            //                       "Add Question",
            //                       style: GoogleFonts.varela(
            //                         color: Colors.blueAccent,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //       ],
            //     );
            //   },
            // ),
          ],
        ),
      )),
    );
  }

  Widget _buildQAInputFields(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.themeBgColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomJobTitleForExperience(
                
                  onIDSelected: () {},
                  role: "",
                  isCompany: false,
                  isIndustry: false,
                  name: "question",
                  title: "Question ${index + 1}",
                  controller: qA[index].question,
                  getid: (p0) {
                    
                  },
                 
                  onChanged: (p0) {
                    setState(() {});
                  },
                  onSubmit: (p0) {
                    setState(() {
                      //    qA[index].roleId = int.tryParse(p0 ?? '') ?? 0;
                    });
                  },
                  contextIn: context,
                  hintText: "",
                /*   icon: Icons.roller_shades,
                  companyID: '',
                  isCode: false,
                  process: '',
                  textfieldNumber: 0, */
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomJobTitleForExperience(
                 /*  isCity: false,
                  stateId: int.tryParse(jobId.toString()), */
                  onIDSelected: () {},
                  role: "",
                  isCompany: false,
                  isIndustry: false,
                  name: "answer",
                  title: "Answer ${index + 1}",
                  controller: qA[index].answer,
                  getid: (p0) {
                    
                  },
                  onChanged: (p0) {
                    setState(() {});
                  },
                  onSubmit: (p0) {
                    setState(() {
                      //    qA[index].roleId = int.tryParse(p0 ?? '') ?? 0;
                    });
                  },
                  contextIn: context,
                  hintText: "",
                /*   icon: Icons.roller_shades,
                  companyID: '',
                  isCode: false,
                  process: '',
                  textfieldNumber: 0, */
                ),
              ],
            )),
      ],
    );
  }

  void save() async {
    InterviewFaqPost qusAns = InterviewFaqPost(
        id: id ?? 0,
        crpfid: jobId != null
            ? int.parse(jobId.toString())
            : widget.crpfid!.toInt(),
        userId: userId != null
            ? userId!.toInt()
            : await Utils.getPreferencesValue(
                null, ESharedPreferences.user_id.name),
        question: quesController.text,
        answer: answer.text);

    Map<String, dynamic> qAJson = qusAns.toJson();

    try {
      final response = await http.post(
        Uri.parse('http://${GlobalConstants.API_Host}/interviewfaqs'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(qAJson),
      );

      if (response.statusCode == 200) {
        ref.refresh(interviewFaqByjobProvider(
            int.parse(jobId?.toString() ?? widget.crpfid?.toString() ?? "0")));
       

        Navigator.pop(context);
       
      } else {
    
      }
    } catch (e) {
     
    }
  }
}

class QuestionAnswersController {
  TextEditingController question;
  TextEditingController answer;
  int? id;
  QuestionAnswersController(
      {required this.question, required this.answer, this.id});
}
