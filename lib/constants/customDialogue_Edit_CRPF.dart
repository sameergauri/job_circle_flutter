// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/customTextfield.dart';
import 'package:job_circle/screens/jobs/talent_pool_detail.dart';
import 'package:job_circle/themes/colors.dart';

class CustomDialogueForCRPF extends StatefulWidget {
  final List<String> status;
  final String selectedStatus;
  final ValueSetter<String>? getStatus;
  final String companyName, process, role;
  bool isEdit = false;

  CustomDialogueForCRPF(
      {super.key,
      required this.status,
      required this.selectedStatus,
      required this.getStatus,
      required this.companyName,
      required this.process,
      required this.role,
      required this.isEdit});

  @override
  State<CustomDialogueForCRPF> createState() => _CustomDialogueForCRPFState();
}

class _CustomDialogueForCRPFState extends State<CustomDialogueForCRPF> {
  TextEditingController shorListController = TextEditingController();
  bool isEdit4 = false;
  String? CompanyID;

  void getCompanyId(String id) {
    setState(() {
      CompanyID = id;
    });
  }

  String? setStatus;

  /* void getStatus(String value) {
    setState(() {
      setStatus = value;
    });
  } */

  PopupMenuItem<String> customMenuItem(String option, bool isOdd) {
    return PopupMenuItem<String>(
      value: option,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          option,
          style: TextStyle(
            color: isOdd ? Colors.grey.shade400 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String? SelectedValue;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding:
            EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w, bottom: 20.h),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          widget.isEdit
              ? InkWell(
                  onTap: () {
                    setState(() {
                      widget.isEdit = false;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Constants.subtitleclr,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text(
                          "${widget.companyName} ${widget.process} ${widget.role}",
                          style: GoogleFonts.varela(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              : CustomJobFormTextField(
                  onTapCallback: () {},
                  //focusNode: cmpnyFocusNode,
                  isCompany: true,
                  name: "company",
                  /* onFocusNodeRequested: (p0) {
                                  focusNode.requestFocus();
                                }, */
                  title: "Client Name",
                  controller: shorListController,
                  // isEdit: isEdit,
                  //  focusNode: focusNode,
                  onChanged: (p0) {
                    isEdit4 = p0;
                  },
                  contextIn: context,
                  onSubmit: getCompanyId,
                  hintText: "Aditya birla Health Insurance",
                  // getSuggestions: getSuggestions,
                  onIDSelected: () {}),
          Row(
            children: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    SelectedValue = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return widget.status.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;
                    bool isOdd = index % 2 == 1;
                    return customMenuItem(option, isOdd);
                  }).toList();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Constants.subtitleclr,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        SelectedValue == null
                            ? widget.selectedStatus
                            : SelectedValue.toString(),
                        style: GoogleFonts.varela(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 13,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                offset: const Offset(0, 32),
                elevation: 16,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(SelectedValue);
                  widget.getStatus!(SelectedValue == null
                      ? selectedStatus.toString()
                      : SelectedValue.toString());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Constants.borderColor)),
                  child: const Text("Update"),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
