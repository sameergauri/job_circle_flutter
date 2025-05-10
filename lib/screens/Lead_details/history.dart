// ignore_for_file: unnecessary_null_comparison, unused_result, unused_local_variable, avoid_print, non_constant_identifier_names, avoid_unnecessary_containers
// ignore_for_file: todo
import 'dart:convert';

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/constants/custom_dialogue_to_generate_new_lead.dart';
import 'package:job_circle/constants/custom_network_image.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';

import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:timelines/timelines.dart';

final getLeadHistory =
    FutureProvider.family<List<Applicant>, int>((ref, no) async {
  try {
    final interviewList = await _HistoryState.fetchAllApplicants(no);
    return interviewList;
  } catch (e) {
    throw Exception('Failed to fetch faq details'); // Throw an exception
  }
});

class History extends ConsumerStatefulWidget {
  final int no;
  final Applicant item;
  final int report_to;
  final String source_name;
  final int user_id;
  final String user_role;

  const History(
      {super.key,
      required this.no,
      required this.item,
      required this.report_to,
      required this.source_name,
      required this.user_id,
      required this.user_role});

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  List<String> getStatuses(List<Applicant> applicants) {
    return applicants
        .map((e) => e.executive_status != null
            ? e.executive_status.toString()
            : e.s2ExecutiveStatus)
        // .where((element) => element == "Application" || element == "Assign")
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  List<String> getNtiveStatus(List<Applicant> applicants) {
    return applicants
        .where(
            (e) => (e.is_status_hide != null ? e.is_status_hide == 1 : false))
        .where((element) =>
            element.hr_status_id != 14 && element.hr_status_id != 13)
        .map((e) => e.hr_status != null ? e.hr_status.toString() : e.s2HrStatus)
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  List<String> getSubStatus(List<Applicant> applicants) {
    return applicants
        .map((e) => e.hr_sub_status != null
            ? e.hr_sub_status.toString()
            : e.s2HrSubStatus)
        // .where((element) => element == "Application" || element == "Assign")
        .where((status) => status != null)
        .map(
            (status) => status!) // Non-null assertion to handle non-null values
        .toSet()
        .toList()
      ..sort();
  }

  // TODO::API function..

  static Future<List<Applicant>> fetchAllApplicants(int number) async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/leads/v1/getLeadsByContactNo?contactNo=$number&pageNumber=1&pageSize=100');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        List<Applicant> applicants =
            contentList.map((json) => Applicant.fromJson(json)).toList();
        applicants.sort((a, b) {
          // Use null-aware operators to handle nullable DateTime objects
          final aTimestamp = a.dol;
          final bTimestamp = b.dol;

          if (aTimestamp != null && bTimestamp != null) {
            return bTimestamp.compareTo(aTimestamp);
          } else if (aTimestamp == null && bTimestamp != null) {
            return 1; // b comes before a
          } else if (aTimestamp != null && bTimestamp == null) {
            return -1; // a comes before b
          } else {
            return 0; // timestamps are both null, consider them equal
          }
        });
        return applicants;
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
    }
  }

  //
  //
  //

  bool isLoading = false;
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    var getHistoryData = ref.watch(getLeadHistory(widget.no));
    return PageStorage(
        bucket: PageStorageBucket(),
        child: getHistoryData != null
            ? getHistoryData.when(data: (fetchdata) {
                List<Applicant>? dataList = fetchdata;

                // Define a flag to track if any item meets the condition
                bool anyItemMeetsCondition = false;

                for (Applicant item in dataList) {
                  if (item.executive_status != null ||
                      item.s2ExecutiveStatus != null) {
                    // If the condition is met for any item, set the flag to true and break the loop
                    anyItemMeetsCondition = true;
                    break;
                  }
                }
                if (anyItemMeetsCondition) {
                  final data = fetchdata;
                  final statuses = getStatuses(data);
                  final substatus = getSubStatus(data);
                  final negativeStatus = getNtiveStatus(data);
                  return DefaultTabController(
                    length: statuses.length,
                    child: Scaffold(
                      floatingActionButton: DraggableFab(
                        //  initPosition: const Offset(3, 1),
                        child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Constants.borderColor,
                            elevation: 0,
                            child: const Icon(
                              Icons.add,
                              // size: 30.sp,
                              color: Constants.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogueToGenerateLeadFromLeadDetails(
                                      report_to: widget.report_to,
                                      source_name: widget.source_name,
                                      user_id: widget.user_id,
                                      user_role: widget.user_role,
                                      title: "for an Interview.",
                                      cancel: () {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      isLineUp: false,
                                      refreshCallback: () {
                                      
                                        ref.refresh(fetchAllReferalProvider);
                                        ref.refresh(fetchAllApplyProvider);
                                        ref.refresh(getLeadHistory(
                                            widget.item.contactNo!.toInt()));
                                        Navigator.pop(context);
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      },
                                      item: widget.item,
                                      statusDdId: 1);
                                },
                              );
                            }),
                      ),
                      /*  floatingActionButton: FloatingActionButton(  //TODO: Refresh button.....
                          backgroundColor: Constants.maintheme_light_color,
                          onPressed: () {
                            ref.refresh(fetchAllApplicantProvider);
                          },
                          child: const Icon(Icons.refresh),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked, */
                      backgroundColor: Constants.bgColorWhite,
                      appBar: PreferredSize(
                        preferredSize:
                            const Size(double.maxFinite, kToolbarHeight / 1.3),
                        child: AppBar(
                          elevation: 0,
                          backgroundColor: Constants.bgColorWhite,
                          bottom: TabBar(
                            physics: const AlwaysScrollableScrollPhysics(),
                            labelPadding:
                                const EdgeInsets.only(left: 5, right: 5),
                            labelColor: Colors.black,
                            isScrollable: true,
                            labelStyle:
                                GoogleFonts.varela(fontWeight: FontWeight.bold),
                            unselectedLabelColor: Colors.black,
                            unselectedLabelStyle: GoogleFonts.varela(
                                fontWeight: FontWeight.normal),
                            indicatorSize: TabBarIndicatorSize.tab,
                            splashBorderRadius: BorderRadius.circular(8),
                            indicatorWeight: 7.h,
                            indicatorPadding: EdgeInsets.only(
                                bottom: 8.h, left: 3.w, right: 3.w),
                            indicator: BoxDecoration(
                              color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Constants.borderColor),
                            ),
                            tabs: statuses
                                .map(
                                  (status) => customTab(status
                                      // Show status in the top-level tab bar
                                      ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: statuses.map((status) {
                          // Filter applicants based on the current status

                          final applicants = data
                              .where((applicant) =>
                                  applicant.executive_status != null
                                      ? applicant.executive_status.toString() ==
                                          status
                                      : applicant.s2ExecutiveStatus == status)
                              .toList();

                          final subStatuses = data
                              .map((lead) =>
                                  lead.hr_sub_status?.toString() ??
                                  lead.s2HrSubStatus)
                              .where((spoc) => spoc != null)
                              .toSet()
                              .toList()
                            ..sort();

                          List<String> substatusWithData = [];
                          for (String? sub in subStatuses) {
                            // Check if there are leads associated with this referral source
                            bool hasDataForSpoc = data.any((lead) =>
                                (lead.executive_status == status ||
                                    lead.s2ExecutiveStatus == status) &&
                                (lead.hr_sub_status == sub ||
                                    lead.s2HrSubStatus == sub));
                            if (hasDataForSpoc) {
                              substatusWithData
                                  .add(sub!); // Add non-null referral sources
                            }
                          }

                          if (
                              // substatusWithData.isEmpty ||
                              status == "Application" || status == "Line-up") {
                            // No second tab bar needed if subStatuses is empty
                            return RefreshIndicator(
                              triggerMode: RefreshIndicatorTriggerMode.anywhere,
                              displacement:
                                  100.0, // Adjust the distance to trigger the refresh
                              color: Colors.blue,
                              onRefresh: () async {
                                await _onRefresh();
                              },
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: applicants.length,
                                itemBuilder: (context, index) {
                                  final applicant = applicants[index];
                                  return listViewItem_new(
                                    context,
                                    applicant,
                                  );
                                },
                              ),
                            );
                          } else if (status == "Not Selected/Not shortlist") {
                            return DefaultTabController(
                              length: negativeStatus.length,
                              child: Scaffold(
                                appBar: PreferredSize(
                                  preferredSize: const Size(
                                      double.maxFinite, kToolbarHeight / 1.3),
                                  child: AppBar(
                                    // title: const Text("Hello"),
                                    elevation: 0,
                                    backgroundColor: Constants.bgColorWhite,
                                    bottom: TabBar(
                                      unselectedLabelStyle: GoogleFonts.varela(
                                          fontWeight: FontWeight.normal),
                                      labelStyle: GoogleFonts.varela(
                                          fontWeight: FontWeight.bold),
                                      labelPadding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      labelColor: Colors.black,
                                      isScrollable: true,
                                      unselectedLabelColor: Colors.black,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      splashBorderRadius:
                                          BorderRadius.circular(8),
                                      indicatorWeight: 7.h,
                                      indicatorPadding: EdgeInsets.only(
                                          bottom: 8.h, left: 3.w, right: 3.w),
                                      indicator: BoxDecoration(
                                        color: Constants.borderColor,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Constants.borderColor),
                                      ),
                                      /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                      tabs: negativeStatus
                                          .map((subStatus) => customTab(
                                                subStatus,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                body: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: negativeStatus.map((subStatus) {
                                    // Filter applicants based on the current status and sub_status
                                    final filteredApplicants = applicants
                                        .where((applicant) =>
                                            (applicant.hr_status.toString() ==
                                                    subStatus ||
                                                applicant.s2HrStatus
                                                        .toString() ==
                                                    subStatus) &&
                                            (applicant.executive_status ==
                                                    status ||
                                                applicant.s2ExecutiveStatus ==
                                                    status))
                                        .toList();

                                    return RefreshIndicator(
                                      triggerMode:
                                          RefreshIndicatorTriggerMode.anywhere,
                                      displacement:
                                          100.0, // Adjust the distance to trigger the refresh
                                      color: Colors.blue,
                                      onRefresh: () async {
                                        await _onRefresh();
                                      },
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filteredApplicants.length,
                                        itemBuilder: (context, index) {
                                          final applicant =
                                              filteredApplicants[index];

                                          return listViewItem_new(
                                            context,
                                            applicant,
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          } else {
                            // Second tab bar needed for subStatuses
                            return DefaultTabController(
                              length: substatusWithData.length,
                              child: Scaffold(
                                appBar: PreferredSize(
                                  preferredSize: const Size(
                                      double.maxFinite, kToolbarHeight / 1.3),
                                  child: AppBar(
                                    // title: const Text("Hello"),
                                    elevation: 0,
                                    backgroundColor: Constants.bgColorWhite,
                                    bottom: TabBar(
                                      unselectedLabelStyle: GoogleFonts.varela(
                                          fontWeight: FontWeight.normal),
                                      labelStyle: GoogleFonts.varela(
                                          fontWeight: FontWeight.bold),
                                      labelPadding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      labelColor: Colors.black,
                                      isScrollable: true,
                                      unselectedLabelColor: Colors.black,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      splashBorderRadius:
                                          BorderRadius.circular(8),
                                      indicatorWeight: 7.h,
                                      indicatorPadding: EdgeInsets.only(
                                          bottom: 8.h, left: 3.w, right: 3.w),
                                      indicator: BoxDecoration(
                                        color: Constants.borderColor,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Constants.borderColor),
                                      ),
                                      /*  onTap: (value) {
                                  setState(() {
                                    isSelect = !isSelect;
                                  });
                                }, */
                                      tabs: substatusWithData
                                          .map((subStatus) => customTab(
                                                subStatus == "" &&
                                                        status ==
                                                            "Interview bay"
                                                    ? "In Process"
                                                    : subStatus == "" &&
                                                            status == "Select"
                                                        ? "Hired"
                                                        : subStatus,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                body: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: substatusWithData.map((subStatus) {
                                    // Filter applicants based on the current status and sub_status
                                    final filteredApplicants = applicants
                                        .where((applicant) =>
                                            (applicant.hr_sub_status
                                                        .toString() ==
                                                    subStatus ||
                                                applicant.s2HrSubStatus
                                                        .toString() ==
                                                    subStatus) &&
                                            (applicant.executive_status ==
                                                    status ||
                                                applicant.s2ExecutiveStatus ==
                                                    status))
                                        .toList();

                                    return RefreshIndicator(
                                      triggerMode:
                                          RefreshIndicatorTriggerMode.anywhere,
                                      displacement:
                                          100.0, // Adjust the distance to trigger the refresh
                                      color: Colors.blue,
                                      onRefresh: () async {
                                        await _onRefresh();
                                      },
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filteredApplicants.length,
                                        itemBuilder: (context, index) {
                                          final applicant =
                                              filteredApplicants[index];

                                          return listViewItem_new(
                                            context,
                                            applicant,
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                        }).toList(),
                      ),
                      //),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("No data to display"),
                  );
                }
              }, error: (error, stackTrace) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/nodata.png",
                          height: 500.0.h,
                          width: 500.0.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Technical Error we Will available in while...",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.varela(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }, loading: () {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              })
            : Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/nodata.png",
                        height: 500.0.h,
                        width: 500.0.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "No Data Found",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.varela(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
  //
  //
  //
  //
  //
  // TODO:: Custom Function....

  Widget customTab(String title) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: Row(
          children: [
            Text(title, style: GoogleFonts.varela()),
          ],
        ));
  }

  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));

    ref.refresh(getLeadHistory(widget.no));
    // Update the UI with new data

    // Call this to end the refresh animation
  }

  //
  //
  //
  //
  //
  //
  //
  //
  //
  Widget listViewItem_new(
    BuildContext context,
    Applicant item,
  ) {
    List<String>? finalinterviewRounds = item.inteviewrounds
        ?.map((round) => round
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('"', '')
            .trim())
        .expand((formattedRound) => formattedRound.split(','))
        .toSet()
        .map((round) => round.trim())
        .where((round) => round.isNotEmpty)
        .toList();
    int selectedRoundIndex = item.interview_rounds != null
        ? finalinterviewRounds!.indexOf(item.interview_rounds.toString())
        : 0;
    return Container(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.5, 2),
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: Colors.grey.shade200)
                ],
                borderRadius: BorderRadius.circular(8.r)),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${item.role_code != null && item.role_code != "" ? item.role_code : item.lead_level}",
                                        style: GoogleFonts.varela(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${item.process} | ${item.natureOfWork}",
                                    style: GoogleFonts.varela(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          item.company_icon !=
                                  null //TODO:: Company icon for all leads
                              ? Container(
                                  //margin: const EdgeInsets.only(right: 10),
                                  child: CustomImage(
                                  imageUrl:
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${item.company_icon}",
                                  defaultImageUrl: "assets/images/cmpny.png",
                                  height: 60,
                                ))
                              : const SizedBox(),
                        ],
                      ),

                      /*   if (item.hr_status_id ==
                          12) //TODO:: Sub Status for assign
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${item.hr_sub_status}",
                                style: GoogleFonts.varela(
                                    color: Constants.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ), */
                      if (item.hr_status_id ==
                          13) //TODO::  DOJ for join in select
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (item.doj != null)
                                Container(
                                  margin: EdgeInsets.only(bottom: 4.h),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 4.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: Colors.black)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 15.sp,
                                      ),
                                      Text(DateFormat('dd MMM yy')
                                              .format(item.doj!)
                                          // Display 'N/A' if doj is null
                                          ),
                                    ],
                                  ),
                                ),
                              const SizedBox(
                                width: 12,
                              ),
                              if (item.salary !=
                                  null) //TODOD:: Salary for join in select
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 4.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: Colors.black)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.currency_rupee_outlined,
                                        size: 15.sp,
                                      ),
                                      Text(item.salary
                                              .toString()
                                              .replaceAll(".0", "")
                                          // Display 'N/A' if doj is null
                                          ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      //
                      //
                      //
                      //
                      if (item.status_id ==
                          1) //TODO:: Interview rounds for in process
                        Container(
                          margin: EdgeInsets.only(bottom: 4.h),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Constants.borderColor)),
                          //  padding: const EdgeInsets.only(bottom: 5),
                          height: MediaQuery.of(context).size.height / 15,
                          child: Timeline.tileBuilder(
                            //  scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(bottom: 10),

                            shrinkWrap: true,
                            // padding: const EdgeInsets.only(top: 0),
                            theme: TimelineThemeData(
                              direction: Axis.horizontal,
                              connectorTheme: const ConnectorThemeData(
                                space: 8.0,
                                thickness: 2.0,
                              ),
                            ),
                            builder: TimelineTileBuilder.connected(
                              contentsAlign: ContentsAlign.basic,
                              connectionDirection: ConnectionDirection.before,
                              itemCount: finalinterviewRounds != null
                                  ? finalinterviewRounds.length
                                  : 0,
                              itemExtentBuilder: (_, __) {
                                return (MediaQuery.of(context).size.width -
                                        50) /
                                    finalinterviewRounds!.length.toDouble();
                              },
                              oppositeContentsBuilder: (context, index) {
                                return Container();
                              },
                              contentsBuilder: (context, index) {
                                return finalinterviewRounds != null
                                    ? Text(finalinterviewRounds[index])
                                    : const Text("");
                              },
                              indicatorBuilder: (_, index) {
                                if (index == selectedRoundIndex) {
                                  // Customize the selected round indicator
                                  return const OutlinedDotIndicator(
                                    borderWidth: 4.0,
                                    color: Colors.green,
                                  );
                                } else if (index > selectedRoundIndex) {
                                  // Customize indicators for other rounds
                                  return OutlinedDotIndicator(
                                    borderWidth: 4.0,
                                    color: Colors.grey.shade400,
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 8.r,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 13.h,
                                    ),
                                  ); /* const DotIndicator(
                                                              //   borderWidth: 4.0,
                                                              color: Colors.green,
                                                            ); */
                                }
                              },
                              connectorBuilder: (_, index, type) {
                                if (index == selectedRoundIndex) {
                                  // Customize the selected round connector
                                  return const DashedLineConnector(
                                    color: Colors.green,
                                  );
                                } else if (index > selectedRoundIndex) {
                                  // Customize connectors for other rounds
                                  return DashedLineConnector(
                                    color: Colors.grey.shade400,
                                  );
                                } else {
                                  return const DashedLineConnector(
                                    color: Colors.green,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      //
                      //
                      //
                      //
                      if (item.hr_sub_status ==
                              "Drop-out" || //TODO:: interview rounds for dropout, onhold and reject
                          item.hr_sub_status == "On-Hold" ||
                          item.hr_status == "Reject" ||
                          item.s2HrStatus == "Reject")
                        Container(
                          margin: EdgeInsets.only(bottom: 4.h),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Constants.borderColor,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Constants.borderColor)),
                          //  padding: const EdgeInsets.only(bottom: 5),
                          height: MediaQuery.of(context).size.height / 15,
                          child: Timeline.tileBuilder(
                            //  scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(bottom: 10),

                            shrinkWrap: true,
                            // padding: const EdgeInsets.only(top: 0),
                            theme: TimelineThemeData(
                              direction: Axis.horizontal,
                              connectorTheme: const ConnectorThemeData(
                                space: 8.0,
                                thickness: 2.0,
                              ),
                            ),
                            builder: TimelineTileBuilder.connected(
                              contentsAlign: ContentsAlign.basic,
                              connectionDirection: ConnectionDirection.before,
                              itemCount: finalinterviewRounds != null
                                  ? finalinterviewRounds.length
                                  : 0,
                              itemExtentBuilder: (_, __) {
                                return (MediaQuery.of(context).size.width -
                                        50) /
                                    finalinterviewRounds!.length.toDouble();
                              },
                              oppositeContentsBuilder: (context, index) {
                                return Container();
                              },
                              contentsBuilder: (context, index) {
                                return finalinterviewRounds != null
                                    ? Text(finalinterviewRounds[index])
                                    : const Text("");
                              },
                              indicatorBuilder: (_, index) {
                                if (index == selectedRoundIndex) {
                                  // Customize the selected round indicator
                                  return const OutlinedDotIndicator(
                                    borderWidth: 4.0,
                                    color: Colors.red,
                                  );
                                } else if (index > selectedRoundIndex) {
                                  // Customize indicators for other rounds
                                  return OutlinedDotIndicator(
                                    borderWidth: 4.0,
                                    color: Colors.grey.shade400,
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 8.r,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 13.h,
                                    ),
                                  ); /* const DotIndicator(
                                                              //   borderWidth: 4.0,
                                                              color: Colors.green,
                                                            ); */
                                }
                              },
                              connectorBuilder: (_, index, type) {
                                if (index == selectedRoundIndex) {
                                  // Customize the selected round connector
                                  return const DashedLineConnector(
                                    color: Colors.green,
                                  );
                                } else if (index > selectedRoundIndex) {
                                  // Customize connectors for other rounds
                                  return DashedLineConnector(
                                    color: Colors.grey.shade400,
                                  );
                                } else {
                                  return const DashedLineConnector(
                                    color: Colors.green,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      //
                      //
                      //
                      //
                      if (item.remark != null &&
                          item.remark !=
                              "") //TODO:: Remark for all negative status lead
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.grey.shade300),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 4.w),
                          margin: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item.remark.toString(),
                              ),
                            ],
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  //
  //
  //
  //
  //
  //
  //
  //
  //
}
