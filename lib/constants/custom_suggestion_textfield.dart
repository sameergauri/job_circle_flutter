// ignore_for_file: must_be_immutable, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers, use_full_hex_values_for_flutter_colors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/job_title_model.dart';
import 'package:job_circle/models/nature_of_work.dart';
import 'package:job_circle/models/process_model.dart';
import 'package:job_circle/screens/jobs/location_search.dart';
import 'package:job_circle/themes/colors.dart';

class SuggestionTextField extends StatefulWidget {
  final String? companyID, process, role, hint, title;
  final int textfieldNumber;
  final Function(bool) onChanged;
  final Function getFunctionalAreaId;
  final Function onTapCallback;
  TextEditingController controller = TextEditingController();
  SuggestionTextField(
      {super.key,
      required this.companyID,
      required this.controller,
      required this.textfieldNumber,
      required this.process,
      required this.role,
      required this.hint,
      required this.title,
      required this.onTapCallback,
      required this.getFunctionalAreaId,
      required this.onChanged});

  @override
  State<SuggestionTextField> createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  @override
  void initState() {
    super.initState();
    suggestionList.clear();
    suggestionList1.clear();
    jobtitleSuggestion.clear();
    jobtitleSuggestion1.clear();
    NatureOfWorkSuggestion.clear();
    NatureOfWorkSuggestion1.clear();
  }

  List<ProcessModel> suggestionList = [];
  List<ProcessModel> suggestionList1 = [];

  List<RoleModel> jobtitleSuggestion = [];
  List<RoleModel> jobtitleSuggestion1 = [];

  List<NatureOfWorkModel> NatureOfWorkSuggestion = [];
  List<NatureOfWorkModel> NatureOfWorkSuggestion1 = [];

  Future<List<NatureOfWorkModel>> getJobNatureOfWork(
      {required String companyId,
      required String role,
      required String process}) async {
    String encodedProcess = Uri.encodeComponent(process);
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctFunctionalArea?companyid=$companyId&rolename=$role&process=$encodedProcess&page=1&size=10000"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<NatureOfWorkModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      NatureOfWorkResponseModel? roleResponseModel;
      try {
        roleResponseModel = NatureOfWorkResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['functional_area']?.toString();
        if (value !=
                null /* &&
            value.toLowerCase().startsWith(pattern.toLowerCase()) */
            ) {
          NatureOfWorkModel natureOfWork = NatureOfWorkModel.fromJson(entry);
          if (!NatureOfWorkSuggestion.any((element) =>
              element.functional_area == natureOfWork.functional_area)) {
            setState(() {
              uniqueValues.add(natureOfWork.id!.toInt());
            });
            //  suggestions.add(role);
            NatureOfWorkSuggestion.add(natureOfWork);
          }
        }
      }

      return NatureOfWorkSuggestion;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<RoleModel>> getJobTitle(String companyId, String proces) async {
    String encodedProcess = Uri.encodeComponent(proces);
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctRolename?companyid=$companyId&process=$encodedProcess&page=1&size=10000"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<RoleModel> suggestions = [];
      List<int> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      RoleResponseModel? roleResponseModel;
      try {
        roleResponseModel = RoleResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */

      for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value !=
                null /* &&
            value.toLowerCase().startsWith(pattern.toLowerCase()) */
            ) {
          RoleModel role = RoleModel.fromJson(entry);
          if (!jobtitleSuggestion
              .any((element) => element.roleName == role.roleName)) {
            setState(() {
              uniqueValues.add(role.id);
            });
            //  suggestions.add(role);
            jobtitleSuggestion.add(role);
          }
        }
      }

      return jobtitleSuggestion;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  Future<List<ProcessModel>> getJobProcess(
    String name,
  ) async {
    final response = await http.get(Uri.parse(
        // 'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'
        "http://${GlobalConstants.API_Host}/jobCRPF/v1/getDistinctProcess?companyid=$name&page=1&size=10000"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<ProcessModel> suggestions = [];
      List<String> uniqueValues = [];

      Map<String, dynamic> jsonMap;
      try {
        jsonMap = data as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse response data as JSON');
      }

      ProcessResponseModel? roleResponseModel;
      try {
        roleResponseModel = ProcessResponseModel.fromJson(jsonMap);
      } catch (e) {
        throw Exception('Failed to parse JSON data into RoleResponseModel');
      }

      String resultKey = roleResponseModel.resultKey;

      // suggestions = roleResponseModel.getRoles();
      /*  String firstRoleName =
          suggestions.isNotEmpty ? suggestions[0].roleName : ''; */
      List<dynamic> content = data['resultData']['content'];

      /*  for (var entry in content) {
        String? value = entry['rolename']?.toString();
        if (value != null &&
            value.toLowerCase().startsWith(pattern.toLowerCase())) {
          if (!uniqueValues.contains(value)) {
            uniqueValues.add(value);
            RoleModel jobTitle = RoleModel.fromJson(entry);
            suggestions.add(jobTitle);
          }
        }
      } */
      for (var entry in content) {
        String? value = entry['process']?.toString();
        if (value !=
                null /* &&
            value.toLowerCase().startsWith(pattern.toLowerCase()) */
            ) {
          ProcessModel role = ProcessModel.fromJson(entry);
          if (!suggestionList
              .any((element) => element.process == role.process)) {
            setState(() {
              uniqueValues.add(role.process);
            });
            //  suggestions.add(role);
            suggestionList.add(role);
          }
        }
      }

      return suggestionList;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  bool isProcessSubmited = false;
  bool isTextFieldClicked = false;

  onTap() async {
    widget.textfieldNumber == 1
        ? getJobProcess(widget.companyID.toString())
        : widget.textfieldNumber == 2
            ? getJobTitle(
                widget.companyID.toString(), widget.process.toString())
            : getJobNatureOfWork(
                companyId: widget.companyID.toString(),
                role: widget.role.toString(),
                process: widget.process.toString());
    setState(() {
      isTextFieldClicked = true;
      // suggestionList;
      // Replace `fetchSuggestions` with your own logic to retrieve the suggestionList
    });
  }

  bool isEdit = false;

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  int? functionalAreaId;

  /*  void getFunctionalAreaId(int id) {
    setState(() {
      functionalAreaId = id;
    });
  } */

  String searchKeyWord = "";

  @override
  Widget build(BuildContext context) {
    List<ProcessModel> filterSuggestions(String userInput) {
      if (userInput.isEmpty) {
        return suggestionList; // Return the original suggestion list when the user input is empty
      } else {
        // Perform filtering based on the user input
        final filteredList = suggestionList.where((suggestion) {
          final suggestionName = suggestion.process.toString().toLowerCase();
          final input = userInput.toLowerCase();
          return suggestionName.startsWith(input);
        }).toList();

        // Return an empty list if the filtered list is empty (user canceled input)
        return filteredList;
      }
    }

    List<RoleModel> filterSuggestionsJobtitle(String userInput) {
      if (userInput.isEmpty) {
        return jobtitleSuggestion; // Return the original suggestion list when the user input is empty
      } else {
        // Perform filtering based on the user input
        final filteredListjobTitle = jobtitleSuggestion.where((suggestion) {
          final suggestionName = suggestion.roleName.toString().toLowerCase();
          final input = userInput.toLowerCase();
          return suggestionName.startsWith(input);
        }).toList();

        // Return the full suggestion list if the filtered list is empty (user canceled input)
        return userInput.isNotEmpty ? filteredListjobTitle : jobtitleSuggestion;
      }
    }

    List<NatureOfWorkModel> filterSuggestionsNatureOfWork(String userInput) {
      if (userInput.isEmpty) {
        return NatureOfWorkSuggestion; // Return the original suggestion list when the user input is empty
      } else {
        // Perform filtering based on the user input
        final filteredList = NatureOfWorkSuggestion.where((suggestion) {
          final suggestionName =
              suggestion.functional_area.toString().toLowerCase();
          final input = userInput.toLowerCase();
          return suggestionName.startsWith(input);
        }).toList();

        // Return the full suggestion list if the filtered list is empty (user canceled input)
        return userInput.isNotEmpty ? filteredList : NatureOfWorkSuggestion;
      }
    }

    return Container(
      child: isProcessSubmited
          ? InkWell(
              onTap: () {
                //  log("Requesting Focus");

                setState(() {
                  widget.controller.clear();
                  isProcessSubmited = false;
                  handleBoolChange(false);
                  suggestionList.clear();
                  suggestionList1.clear();
                  jobtitleSuggestion.clear();
                  jobtitleSuggestion1.clear();
                  NatureOfWorkSuggestion.clear();
                  NatureOfWorkSuggestion1.clear();
                  widget.controller.clear();
                  widget.onTapCallback(controller);
                  // widget.focusNode.requestFocus;
                  // handleFocusNodeRequest();
                  //focusNode.requestFocus();
                  // handleFocusNodeChange();
                  //focusNode.requestFocus();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.title}",
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 18.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 25.h,
                      width: double.maxFinite,
                      // height: MediaQuery.of(context).size.height / 26.h,
                      margin:
                          const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.controller.text,
                              style: GoogleFonts.sourceSansPro(
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15.sp)),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          )
                          /*  Image.asset(
                            "assets/images/close.png",
                            height: 12,
                          ) */
                        ],
                      )),
                ],
              ))
          : Container(
              child: Column(
                children: [
                  widget.textfieldNumber == 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.title}",
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25.h,
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: widget.hint,
                                  hintStyle: GoogleFonts.sourceSansPro(
                                    color: Constants.subtitleclr,
                                    fontSize: 15.sp,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 122, 113, 111),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffff0eceb),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 15),
                                ),
                                onTap: onTap,

                                /* () {
                                                getJobProcess(CompanyID.toString());
                          
                                                setState(() {
                                                  isTextFieldClicked = true;
                                                });
                                              }, */
                                onSubmitted: (value) {
                                  setState(() {
                                    isProcessSubmited = true;
                                    // handleBoolChange(true);
                                  });
                                },
                                onChanged: (value) {
                                  searchKeyWord = value;
                                  setState(() {
                                    suggestionList1 = filterSuggestions(value);
                                  });
                                },
                                controller: widget.controller,
                              ),
                            ),
                          ],
                        )
                      : widget.textfieldNumber == 2
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.title}",
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        25.h,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: widget.hint,
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
                                      onTap: onTap,

                                      /* () {
                                                getJobProcess(CompanyID.toString());
                              
                                                setState(() {
                                                  isTextFieldClicked = true;
                                                });
                                              }, */
                                      onSubmitted: (value) {
                                        setState(() {
                                          isProcessSubmited = true;
                                          // handleBoolChange(true);
                                        });
                                      },
                                      onChanged: (value) {
                                        searchKeyWord = value;
                                        setState(() {
                                          jobtitleSuggestion1 =
                                              filterSuggestionsJobtitle(value);
                                        });
                                      },
                                      controller: widget.controller,
                                    )),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.title}",
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 25.h,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: widget.hint,
                                      hintStyle: GoogleFonts.sourceSansPro(
                                        color: Constants.subtitleclr,
                                        fontSize: 15.sp,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 122, 113, 111),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffff0eceb),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.only(left: 15),
                                    ),
                                    onTap: onTap,

                                    /* () {
                                                getJobProcess(CompanyID.toString());
                              
                                                setState(() {
                                                  isTextFieldClicked = true;
                                                });
                                              }, */
                                    onSubmitted: (value) {
                                      setState(() {
                                        isProcessSubmited = true;
                                        // handleBoolChange(true);
                                      });
                                    },
                                    onChanged: (value) {
                                      searchKeyWord = value;
                                      setState(() {
                                        NatureOfWorkSuggestion1 =
                                            filterSuggestionsNatureOfWork(
                                                value);
                                      });
                                    },
                                    controller: widget.controller,
                                  ),
                                ),
                              ],
                            ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (isTextFieldClicked)
                    widget.textfieldNumber == 1
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final suggestion = searchKeyWord.isEmpty
                                  ? suggestionList[index]
                                  : suggestionList1[index];
                              final isOddIndex = index % 2 == 0;
                              // Check if the index is odd or even

                              return InkWell(
                                onTap: () {
                                  // getValuOfProcess(suggestion.widget.controller);
                                  setState(() {
                                    isProcessSubmited = true;
                                    widget.controller.text =
                                        suggestion.process.toString();
                                    handleBoolChange(true);
                                    searchKeyWord = "";
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: isOddIndex
                                          ? Colors.blueGrey[100]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    suggestion.process.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                        // Customize text color based on odd/even index
                                        ),
                                  ),
                                  // Customize background color based on odd/even index
                                ),
                              );
                            },
                            itemCount: widget.controller.text.isEmpty
                                ? suggestionList.length
                                : suggestionList1.length,
                          )
                        : widget.textfieldNumber == 2
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const ScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final suggestion = searchKeyWord.isEmpty
                                      ? jobtitleSuggestion[index]
                                      : jobtitleSuggestion1[index];
                                  final isOddIndex = index % 2 == 0;
                                  // Check if the index is odd or even

                                  return InkWell(
                                    onTap: () {
                                      // getValuOfProcess(suggestion.widget.controller);
                                      setState(() {
                                        isProcessSubmited = true;
                                        widget.controller.text =
                                            suggestion.roleName.toString();
                                        handleBoolChange(true);
                                        searchKeyWord = "";
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          color: isOddIndex
                                              ? Colors.blueGrey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        suggestion.roleName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                            // Customize text color based on odd/even index
                                            ),
                                      ),
                                      // Customize background color based on odd/even index
                                    ),
                                  );
                                },
                                itemCount: widget.controller.text.isEmpty
                                    ? jobtitleSuggestion.length
                                    : jobtitleSuggestion1.length,
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const ScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final suggestion = searchKeyWord.isEmpty
                                      ? NatureOfWorkSuggestion[index]
                                      : NatureOfWorkSuggestion1[index];
                                  final isOddIndex = index % 2 == 0;
                                  // Check if the index is odd or even

                                  return InkWell(
                                    onTap: () {
                                      // getValuOfProcess(suggestion.widget.controller);
                                      setState(() {
                                        isProcessSubmited = true;
                                        widget.controller.text = suggestion
                                            .functional_area
                                            .toString();
                                        handleBoolChange(true);
                                        widget
                                            .getFunctionalAreaId(suggestion.id);
                                        searchKeyWord = "";
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          color: isOddIndex
                                              ? Colors.blueGrey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        suggestion.functional_area.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                            // Customize text color based on odd/even index
                                            ),
                                      ),
                                      // Customize background color based on odd/even index
                                    ),
                                  );
                                },
                                itemCount: widget.controller.text.isEmpty
                                    ? NatureOfWorkSuggestion.length
                                    : NatureOfWorkSuggestion1.length,
                              ),
                ],
              ),
            ),
    );
  }
}
