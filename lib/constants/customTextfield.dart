import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customButton.dart';
import 'package:job_circle/constants/gobal.dart';

import '../themes/colors.dart';

class CustomJobFormTextField extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  // List<String>? selectedValuesList = [];
  final bool isCompany;
  BuildContext contextIn;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool) onChanged;
  final String name;
  final String? pId;
  // final Function(FocusNode) onFocusNodeRequested;

  CustomJobFormTextField({
    Key? key,
    this.controller,
    // required this.isEdit,
    // required this.focusNode,
    // this.selectedValuesList,
    required this.contextIn,
    required this.isCompany,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.pId,
    required this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  }) : super(key: key);

  @override
  _CustomJobFormTextFieldState createState() => _CustomJobFormTextFieldState();
}

class _CustomJobFormTextFieldState extends State<CustomJobFormTextField> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  List<dynamic> suggestions = [];
  List<dynamic> ParentId = [];
  FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;

  //List<String> selectedValuesList = [];

  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged(newValue);
  }

  InkWell customContainerSelect(bool isSelect) {
    return InkWell(
        onTap: () {
          //  log("Requesting Focus");
          focusNode.requestFocus();

          setState(() {
            controller!.clear();
            handleBoolChange(false);
            // widget.focusNode.requestFocus;
            // handleFocusNodeRequest();
            //focusNode.requestFocus();
            // handleFocusNodeChange();
            //focusNode.requestFocus();
          });
        },
        child: Container(
            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelect ? const Color(0xfff310d44) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            /* decoration: BoxDecoration(
                //310D44   color code for dark purple
                //3D3635   color code for greybrown
                color: isSelect ? const Color(0xfff310d44) : null,
                border: isSelect
                    ? null
                    : Border.all(
                        color: isSelect
                            ? Colors.deepOrange.shade400
                            : Colors.grey),
                borderRadius: BorderRadius.circular(18)), */
            //  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: isSelect
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(controller!.text,
                          style: GoogleFonts.sourceSansPro(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15.sp)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "assets/images/cross.png",
                        height: 12,
                      )
                    ],
                  )
                : Text(widget.controller!.text,
                    style: GoogleFonts.sourceSansPro(fontSize: 15.sp))));
  }

  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/company/v1/all?pageNumber=1&pageSize=100'));

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

  Future<List> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['value'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();

      print(suggestions);
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(widget.focusNode);
     ab Try kr zara
      ha  ek min
    }
  } */

/*   void handleFocusNodeRequest() {
    widget.onFocusNodeRequested; // Pass the focusNode itself
  } */

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isEdit
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                customContainerSelect(true),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 25.h,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TypeAheadFormField<dynamic>(
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 4.0,
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (value) {
                        suggestion = null;
                      },
                      autofocus: true,
                      focusNode: focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
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
                        contentPadding: const EdgeInsets.only(left: 15),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isNotEmpty) {
                        suggestion = widget.isCompany
                            ? await getSuggestions(pattern)
                            : await getJobTitle(pattern, widget.name) ?? [];
                        return suggestion!;
                      } else {
                        return <dynamic>[];
                      }
                    },
                    itemBuilder: (context, suggestion) {
                      final index = suggestions.indexOf(suggestion);
                      final isOdd = index % 2 == 0;
                      final backgroundColor =
                          isOdd ? Colors.grey.shade200 : Colors.white;

                      return Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        controller!.text = suggestion.toString();
                        firstText = controller!.text;
                        handleBoolChange(true);
                        //FocusScope.of(context).nextFocus();
                      });
                    },
                    noItemsFoundBuilder: (value) {
                      final message = suggestion != null && suggestion!.isEmpty
                          ? 'No result found. Search again and select from suggestion.'
                          : 'Searching';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomFormTextFieldMultiSelect extends StatefulWidget {
  final TextEditingController? controller;
  //final bool isEdit;
  // final FocusNode focusNode;
  final String hintText;
  List<String>? selectedValuesList = [];

  BuildContext contextIn;
  final String title;
  final Function(String)? getSuggestions;
  final String? firstText;
  final Function(bool)? onChanged;
  final String name;

  CustomFormTextFieldMultiSelect({
    Key? key,
    this.controller,
    // required this.isEdit,
    // required this.focusNode,
    this.selectedValuesList,
    required this.contextIn,
    required this.title,
    required this.hintText,
    required this.name,
    this.getSuggestions,
    this.onChanged,
    this.firstText,
    // required this.onFocusNodeRequested
  }) : super(key: key);

  @override
  State<CustomFormTextFieldMultiSelect> createState() =>
      _CustomFormTextFieldMultiSelectState();
}

class _CustomFormTextFieldMultiSelectState
    extends State<CustomFormTextFieldMultiSelect> {
  List<dynamic>? suggestion;
  bool isEdit = false;
  bool isLoading = false;
  List<dynamic> suggestions = [];
  List<dynamic> suggestionsLast = [];
  FocusNode focusNode = FocusNode();
// Example usage of the handleFocusNodeChange method
  late TextEditingController? controller = widget.controller;
  // late bool isEdit = widget.isEdit;
  // final FocusNode focusNode = widget.focusNode;
  late String hintText = widget.hintText;
  late String title = widget.title;

  late String? firstText = widget.firstText;
  String? selectedValue;

  List<String>? selectedValuesList = [];
  bool isDuplicate = false;
  String? customValue;
  bool showAddButton = false;
  void handleBoolChange(bool newValue) {
    setState(() {
      isEdit = newValue;
    });
    widget.onChanged!(newValue);
  }

  Future<List> getJobTitle(String pattern, String name) async {
    final response = await http.get(Uri.parse(
        '${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$name&pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['value'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      suggestionsLast = data['resultData']['content']
          .map((e) => e['value'].toString())
          .toList();
      print(suggestions);

      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  /* Future<List<dynamic>> fetchSuggestions(String pattern) async {
    //List<dynamic> suggestions = [];

    if (pattern.isNotEmpty) {
      suggestions = await getJobTitle(pattern, widget.name) ?? [];
      showAddButton = !suggestions.contains(pattern);
    } else {
      showAddButton = true;
    }

    return suggestions;
  } */

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.sourceSansPro(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: double.infinity,
            //  height: MediaQuery.of(context).size.height / 9.h,
            margin: selectedValuesList!.isEmpty
                ? const EdgeInsets.only(bottom: 10, top: 5)
                : const EdgeInsets.only(
                    bottom: 10,
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectedValuesList!.isEmpty
                    ? Container()
                    : Wrap(
                        spacing: 8,
                        children: selectedValuesList!.map((e) {
                          return Chip(
                            label: Text(e),
                            onDeleted: () {
                              setState(() {
                                selectedValuesList!.remove(e);
                              });
                            },
                          );
                        }).toList()),

                /* SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: selectedValuesList!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(selectedValuesList![index]),
                      );
                    },
                  ),
                ), */
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 25.h,
                        child: TypeAheadFormField<dynamic>(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (selectedValuesList!.contains(value)) {
                                isDuplicate = true;
                                return 'Already Added';
                              }
                              isDuplicate = false;
                              return null;
                            },
                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              elevation: 4.0,
                            ),
                            textFieldConfiguration: TextFieldConfiguration(
                              onChanged: (value) {
                                setState(() {
                                  customValue = value;
                                  showAddButton = !suggestions.contains(value);
                                });
                              },

                              //enabled: false,

                              autofocus: true,
                              focusNode: focusNode,
                              textCapitalization: TextCapitalization.sentences,
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: hintText,
                                hintStyle: GoogleFonts.sourceSansPro(
                                  color: Constants.subtitleclr,
                                  fontSize: 15.sp,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDuplicate
                                        ? Colors.red
                                        : const Color.fromARGB(
                                            255, 122, 113, 111),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: isDuplicate
                                        ? Colors.red
                                        : const Color(0xffff0eceb),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.only(left: 15),
                                errorText: isDuplicate ? 'Already Added' : null,
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              if (pattern.isNotEmpty) {
                                isLoading =
                                    true; // Set isLoading to true when fetching suggestions
                                setState(
                                    () {}); // Trigger a rebuild to show the "Searching" message

                                suggestion =
                                    await getJobTitle(pattern, widget.name) ??
                                        [];
                                showAddButton = !suggestion!.contains(pattern);

                                isLoading =
                                    false; // Set isLoading to false after suggestions are fetched
                                setState(
                                    () {}); // Trigger a rebuild to hide the "Searching" message

                                return suggestion!;
                              } else {
                                suggestion = [];
                                showAddButton = false;
                                return <dynamic>[];
                              }
                            },
                            itemBuilder: (context, suggestion) {
                              final index = suggestions.indexOf(suggestion);
                              final isOdd = index % 2 == 0;
                              final backgroundColor =
                                  isOdd ? Colors.grey.shade200 : Colors.white;

                              return Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(
                                    suggestion.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              if (selectedValuesList!.contains(suggestion)) {
                                setState(() {
                                  isDuplicate = true;
                                  controller!.clear();
                                  showAddButton = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Already Added")),
                                );
                              } else if (suggestion != null) {
                                setState(() {
                                  selectedValuesList!.add(suggestion);
                                  isDuplicate = false;
                                  showAddButton = true;
                                  controller!.clear();
                                });
                              }
                              /*  setState(() {                    //before Validation...
                              controller!.clear();
                              if (!selectedValuesList!.contains(suggestion)) {
                                setState(() {
                                  selectedValuesList!.add(suggestion);
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Already Added")));
                              }
                                          
                              //controller!.text += suggestion.toString();   // textField me show krne ke liy ke kya selected hai
                              //  firstText = controller!.text;
                              //  handleBoolChange(true);
                              // FocusScope.of(context).autofocus(focusNode);  // on hold
                            }); */
                            },
                            /* noItemsFoundBuilder: (BuildContext context) {
                            if (isLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Searching...',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              );
                            } else {
                              return AddButtonVisibilityWidget(
                                isLoading: false,
                                suggestions: suggestion,
                                customValue: customValue,
                                selectedValuesList: selectedValuesList,
                                onAddButtonPressed: () {
                                  setState(() {
                                selectedValuesList!.add(suggestion.toString());
                                isDuplicate = false;
                                //showAddButton = true;
                                controller!.clear();

                              });
                            });},
   
                          }, */
                            noItemsFoundBuilder: (BuildContext context) {
                              return AddButtonVisibilityWidget(
                                suggestions: suggestion,
                                customValue: customValue,
                                selectedValuesList: selectedValuesList,
                                isLoading: isLoading,
                                onAddButtonPressed: () {
                                  if (selectedValuesList!
                                      .contains(customValue)) {
                                    setState(() {
                                      isDuplicate = true;
                                      controller!.clear();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Already Added")),
                                    );
                                  } else {
                                    setState(() {
                                      selectedValuesList!.add(customValue!);
                                      isDuplicate = false;
                                      controller!.clear();
                                    });
                                  }
                                },
                              );
                            }
                            /* final message =
                                suggestion != null && suggestion!.isEmpty
                                    ? 'No items found'
                                    : 'Searching';

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                message,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            );
                          }, */
                            ),
                      ),
                    ),
                    /*  if (showAddButton &&
                        customValue != null &&
                        customValue!.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          if (selectedValuesList!.contains(customValue)) {
                            setState(() {
                              isDuplicate = true;
                              controller!.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Already Added")),
                            );
                          } else {
                            setState(() {
                              selectedValuesList!.add(customValue!);
                              isDuplicate = false;
                              controller!.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                      ) */
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



















//////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////