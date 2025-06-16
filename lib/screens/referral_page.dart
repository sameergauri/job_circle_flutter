// ignore_for_file: unused_result

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/referl_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/new_jobs/job_detail/job_detail_page.dart';
import 'package:job_circle/themes/colors.dart';

final referAts = FutureProvider<RefeLeadModel>((ref) async {
  var userid =
      await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
  try {
    final uri = Uri.parse(
            'http://${GlobalConstants.API_Host_one}/leads/v1/getAtsDataReferralJobs')
        .replace(queryParameters: {'userId': userid});

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return RefeLeadModel.fromJson(jsonData['resultData']);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
});

class ReferalPage extends ConsumerWidget {
  const ReferalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final atsDataAsync = ref.watch(referAts);

    return Scaffold(
      backgroundColor: Colors.white,
      body: atsDataAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
          color: Constants.darkBlue,
        )),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (atsData) {
          /*   final tabs = atsData.applicationData.keys.toList(); */
          final desiredOrder = [
            "Application",
            "Contact HR",
            "Interview bey",
            "Shortlisted",
            "Not Shortlisted"
          ];

          String extractLabel(String input) {
            // Removes anything like " (2)" at the end
            return input.replaceAll(RegExp(r'\s*\(\d+\)$'), '');
          }

          final tabs = atsData.applicationData.keys.toList();

          tabs.sort((a, b) {
            final labelA = extractLabel(a);
            final labelB = extractLabel(b);

            int indexA = desiredOrder.indexOf(labelA);
            int indexB = desiredOrder.indexOf(labelB);

            indexA = indexA == -1 ? desiredOrder.length : indexA;
            indexB = indexB == -1 ? desiredOrder.length : indexB;

            return indexA.compareTo(indexB);
          });
          if (tabs.isNotEmpty) {
            return DefaultTabController(
              length: tabs.length,
              child: Column(
                children: [
                  TabBar(
                    dividerHeight: 1.0,
                    indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Constants.orange, width: 3.0),
                    ),
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                    indicatorWeight: 3.0,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelColor: Constants.black,
                    unselectedLabelColor: Constants.subtitleclr,
                    indicatorColor: Constants.orange,
                    labelStyle: GoogleFonts.merriweather(
                        color: Constants.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                    unselectedLabelStyle: GoogleFonts.merriweather(
                        color: Constants.subtitleclr,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                    tabs: tabs
                        .map((tab) => Tab(
                              child: customTextForWeather(
                                title: tab,
                                fontSize: 12,
                              ),
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: tabs.map((tab) {
                        final applications = atsData.applicationData[tab] ?? [];

                        return RefreshIndicator(
                          backgroundColor: Colors.white,
                          color: Constants.darkBlue,
                          onRefresh: () async {
                            ref.refresh(referAts);
                          },
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final app = applications[index];
                              return Column(
                                children: [
                                  listViewItem_new(context, app, tab),
                                  if (index !=
                                      applications.length -
                                          1) // ✅ Add Divider except last item
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Divider(thickness: 1.0),
                                    ),
                                ],
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/noref.gif"),
                  Text(
                    "You haven't refer anyone yet!",
                    style: GoogleFonts.varela(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Search for jobs and start refer your friend. You can track your applications here!",
                          style: GoogleFonts.varela(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  /* InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          color: Constants.darkBlue,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        "View Jobs",
                        style: GoogleFonts.varela(color: Colors.white),
                      ),
                    ),
                  ), */
                  const Spacer(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget listViewItem_new(BuildContext context, Application item, String tab) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailPage(
              resume: "",
              jobId: item.jobId!,
              fromWhere: FromWhere.referalPage,
            ),
          ),
        );
        /* SharedPreferences pref = await Utils.getSharedPreferences();
        var userType = await Utils.getPreferencesValue(
            pref, ESharedPreferences.user_type.name);
        var userrole =
            await Utils.getPreferencesValue(pref, ESharedPreferences.role.name);
        var id = await Utils.getPreferencesValue(
            pref, ESharedPreferences.user_id.name);
        int? userid = int.tryParse(id);
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return JobDetailsForCandidate(
                hint: 0,
                userrole: userrole.toString(),
                userid: userid!,
                userType: userType,
                Applies: false,
                referal: true,
                is_freelancer: 3,
                // id: item.jobid,
                // id: item.,
              );
            },
          ));
        } */
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Constants.lightdull,
                  child: Text(
                    item.applicantName.isNotEmpty
                        ? item.applicantName[0].toUpperCase()
                        : '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Constants.subtitleclr,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: customTextForWeather(
                        title:
                            "${item.applicantName.toString()} ${item.lastName.toString()}",
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    customTextForWeather(
                      title:
                          "${item.process.toString()} || ${item.level.toString()}",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            ),
            Container(
                decoration: BoxDecoration(
                    color: Constants.lightdull,
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextForWeather(
                      title: item.referralFeedback1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.statusId == 3 ||
                              item.statusId == 4 ||
                              item.statusId == 6 ||
                              item.statusId == 8 ||
                              item.statusId == 9 ||
                              item.statusId == 10 ||
                              item.statusId == 11 ||
                              item.statusId == 14
                          ? Constants.red
                          : item.statusId == 12 || item.statusId == 13
                              ? Constants.darkgreen
                              : Constants.darkBlue,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    customTextForWeather(
                      title: "• ${item.referralFeedback2}",
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Constants.subtitleclr,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
