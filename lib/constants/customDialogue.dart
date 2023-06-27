import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/matching_job_model.dart';
import 'package:job_circle/screens/jobs/jobs.dart';

class CustomDialog extends StatefulWidget {
  final ValueSetter<TextEditingController>? getCompanyName;
  final ValueSetter<TextEditingController>? getJobtitile;
  final ValueSetter<TextEditingController>? getProcess;
  final ValueSetter<TextEditingController>? getNatureOFWork;
  final ValueSetter<String>? getNatureOfWorkId;
  final ValueSetter<String>? getCompanyId;
  final ValueSetter<String>? getJobtitleValue;
  final Function(JobData?)? onDataReceived;
  final Function? fetchDataFromApi;

  //final ValueSetter<String>? get;

  final VoidCallback onClose;
  final String title, subtitle;
  final bool isFisrt;
  const CustomDialog(
      {super.key,
      this.onDataReceived,
      this.fetchDataFromApi,
      this.getJobtitleValue,
      this.getCompanyId,
      this.getNatureOfWorkId,
      this.getCompanyName,
      this.getJobtitile,
      this.getProcess,
      this.getNatureOFWork,
      required this.onClose,
      required this.isFisrt,
      required this.title,
      required this.subtitle});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

Future<JobData?> fetchMatchingJobs({
  int? companyId,
  String? process,
  String? jobTitle,
  int? natureOfWorkId,
  Function(JobData?)? onDataReceived,
}) async {
  try {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/jobs/v1/matchngjob?companyid=$companyId&process=$process&naturofworkid=$natureOfWorkId&rolename=$jobTitle&page=1&size=100'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      JobDetails jobDetails = JobDetails.fromJson(jsonData);

      if (jobDetails.resultData.isNotEmpty) {
        JobData jobData = jobDetails.resultData[0];
        onDataReceived!(jobData); // ha ab kr
        return jobData;
      }
//Agaian tere wo bade wale model me issue lag raha hai
      // Handle the case when jobDetails.resultData is empty
      print('Job data is empty');
      return null;
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error during JSON decoding: $error'); // nhi hua
  }
  return null;
}

class _CustomDialogState extends State<CustomDialog> {
  TextEditingController shorListController = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController proces = TextEditingController();
  TextEditingController natureOfWork = TextEditingController();
  bool isEdit4 = false, isEdit1 = false, isEdit2 = false, isEdit3 = false;

  String? CompanyID, parentID, jobTitle, pId;

  bool? name;

  String? same;
  List<dynamic> suggestions = [];
  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  //String? companyId;

  void handleSelectedID(String id) {
    // Process the selected ID as needed
    print('Selected ID: $id');
    setState(() {
      parentID = id;
    });
    // Perform any other actions with the ID
  }

  void getCompanyId(String id) {
    setState(() {
      CompanyID = id;
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

  Future<List<String>> fetchData(String id) async {
    // function to fetch nature of work
    setState(() {
      //  NatureOfWorkID = int.parse(id);
    });
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host}/master/v1/getDataByParentNameAndParentIdAndGroupName?groupName=key_responsible&parentname=$jobTitle&parentId=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and extract the desired value from each map
      final content = data['resultData'];
      if (content is! List) {
        print('Invalid data format');
        return []; // or any other appropriate default value
      } else {
        checkboxData = content.map((map) => map['value'].toString()).toList();
        setState(() {
          checkboxDataState = checkboxData; // Update the state variable
        });
        print(checkboxData);
        return checkboxData;
      }
    } else {
      print('Failed to fetch data');
      return []; // or any other appropriate default value
    }
  }

  FocusNode cmpnyFocusNode = FocusNode();
  FocusNode roleFocusNode = FocusNode();
  FocusNode processFocusNode = FocusNode();
  FocusNode functionalAreaFocusNode = FocusNode();

  // String? title,Desc;
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                top: 20.0, left: 20, right: 20, bottom: 10),
            child: SingleChildScrollView(
              child: widget.isFisrt == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WillPopScope(
                          onWillPop: () async {
                            // Disable back button functionality
                            return false;
                          },
                          child: const SizedBox(),
                        ),
                        // Add your custom dialog content here
                        Text(
                          widget.title,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        const SizedBox(height: 15.0),
                        CustomJobFormTextField(
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
                          },
                          contextIn: context,
                          onSubmit: getCompanyId,
                          hintText: "Aditya birla Health Insurance",
                          getSuggestions: getSuggestions,
                          onIDSelected: handleSelectedID,
                        ),
                        CustomJobFormTextFieldRespOne(
                          focusNode: roleFocusNode,
                          isCompany: false,
                          name: "job_role",
                          /* onFocusNodeRequested: (p0) {
                                  focusNode.requestFocus();
                                }, */
                          title: "Job Title / Role",
                          controller: role,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit1 = p0;
                          },
                          onIDSelected: handleSelectedID,
                          contextIn: context,
                          hintText: "Sr. Executive",
                          onSubmit: getValueOfJobtitle,
                          //  getSuggestions: getJobTitle,
                        ),
                        CustomJobFormTextFieldRespOne(
                          focusNode: processFocusNode,
                          isCompany: false,
                          name: "process",
                          /* onFocusNodeRequested: (p0) {
                              focusNode.requestFocus();
                                                }, */
                          title: "Process",
                          controller: proces,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          onChanged: (p0) {
                            isEdit2 = p0;
                          },
                          onSubmit: getValuOfProcess,
                          contextIn: context,
                          hintText: "Health Insurance",
                          //   getSuggestions: getJobTit
                          onIDSelected: handleSelectedID,
                        ),
                        CustomJobFormTextFieldJobRespo(
                          focusNode: functionalAreaFocusNode,
                          isCompany: false,
                          name: "now",
                          /* onFocusNodeRequested: (p0) {
                                  focusNode.requestFocus();
                                }, */
                          title: "Functional Area", // Nature of Work on update
                          controller: natureOfWork,
                          // isEdit: isEdit,
                          //  focusNode: focusNode,
                          pId: pId,
                          onChanged: (p0) {
                            isEdit3 = p0;
                            //fetchData();
                          },
                          contextIn: context,
                          hintText: "Sales",
                          //  onIDSelected: handleSelectedID,
                          onSubmit: getNatureOfWorkId,
                          // getSuggestions: getJobTitle,
                        ),

                        /* Text(
                          widget.subtitle,
                          style: const TextStyle(fontSize: 16.0),
                        ), */

                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          //   color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Jobs(),
                                        ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_outlined,
                                      color: Colors.black,
                                    ),
                                  )),
                              Visibility(
                                  visible:
                                      isEdit1 && isEdit2 && isEdit3 && isEdit4,
                                  child: InkWell(
                                    onTap: () {
                                      widget
                                          .getCompanyName!(shorListController);
                                      // widget.getJobTitle!(role.text);
                                      widget.getProcess!(proces);
                                      widget.getNatureOFWork!(natureOfWork);
                                      widget.getJobtitile!(role);
                                      widget.getNatureOfWorkId!(
                                          NatureOfWorkID.toString());
                                      widget
                                          .getCompanyId!(CompanyID.toString());
                                      fetchMatchingJobs(
                                          companyId: int.parse(CompanyID!),
                                          natureOfWorkId: NatureOfWorkID,
                                          jobTitle: jobTitle,
                                          onDataReceived: widget.onDataReceived,
                                          process: pro);
                                      Navigator.pop(context);
                                      widget.fetchDataFromApi!();

                                      widget.getJobtitleValue!(
                                          jobTitle.toString());
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: const BoxDecoration(),
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add your custom dialog content here
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        Text(
                          widget.subtitle,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: widget.onClose,
                          child: const Text('Close'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
