// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class CompanySelectionDialogForFilter extends StatefulWidget {
  final List<String?> compnyList;
  final List<String?> selectedCompanies;

  const CompanySelectionDialogForFilter(
      {super.key, required this.compnyList, required this.selectedCompanies});

  @override
  _CompanySelectionDialogForFilterState createState() =>
      _CompanySelectionDialogForFilterState();
}

class _CompanySelectionDialogForFilterState
    extends State<CompanySelectionDialogForFilter> {
  late List<String?> localSelectedCompanies;

  @override
  void initState() {
    super.initState();
    localSelectedCompanies = List.from(widget.selectedCompanies);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Companies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.compnyList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (localSelectedCompanies
                          .contains(widget.compnyList[index])) {
                        localSelectedCompanies.remove(widget.compnyList[index]);
                      } else {
                        localSelectedCompanies.add(widget.compnyList[index]);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.grey.shade400
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          widget.compnyList[index].toString(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        localSelectedCompanies
                                .contains(widget.compnyList[index])
                            ? const Icon(Icons.done_all,
                                size: 18, color: Colors.blue)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      localSelectedCompanies
                          .clear(); // Clear the selected companies list
                    });
                    Navigator.pop(context,
                        localSelectedCompanies); // Close the dialog and pass the updated state
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                    child: Text(
                      "Reset",
                      style: GoogleFonts.varela(
                          color: Colors.red, fontSize: 16.sp),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, localSelectedCompanies);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                    child: Text(
                      "OK",
                      style: GoogleFonts.varela(
                          color: Constants.blue, fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogueForStatusTeam extends StatefulWidget {
  final List<String?> statusList;
  final List<String?> selectedStatusList;

  const CustomDialogueForStatusTeam(
      {super.key,
      required this.statusList,
      required this.selectedStatusList});

  @override
  _CustomDialogueForStatusTeamState createState() =>
      _CustomDialogueForStatusTeamState();
}

class _CustomDialogueForStatusTeamState
    extends State<CustomDialogueForStatusTeam> {
  late List<String?> localSelectedStatus;

  @override
  void initState() {
    super.initState();
    localSelectedStatus = List.from(widget.selectedStatusList);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Companies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.statusList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (localSelectedStatus
                          .contains(widget.statusList[index])) {
                        localSelectedStatus.remove(widget.statusList[index]);
                      } else {
                        localSelectedStatus.add(widget.statusList[index]);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.grey.shade400
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          widget.statusList[index] == null
                              ? "Select"
                              : widget.statusList[index].toString(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        localSelectedStatus.contains(widget.statusList[index])
                            ? const Icon(Icons.done_all,
                                size: 18, color: Colors.blue)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      localSelectedStatus
                          .clear(); // Clear the selected companies list
                    });
                    Navigator.pop(context,
                        localSelectedStatus); // Close the dialog and pass the updated state
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                    child: Text(
                      "Reset",
                      style: GoogleFonts.varela(
                          color: Colors.red, fontSize: 16.sp),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, localSelectedStatus);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                    child: Text(
                      "OK",
                      style: GoogleFonts.varela(
                          color: Constants.blue, fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
