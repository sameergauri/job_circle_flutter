// ignore_for_file: unused_result

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/applied_job_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/jobs/job_details_for_candidate.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

final appliedAts = FutureProvider<AppliedJobModel>((ref) async {
  var userid =
      await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
  try {
    final uri = Uri.parse(
            'http://${GlobalConstants.API_Host_one}/leads/v1/getAtsDataAppliedJobs')
        .replace(queryParameters: {'userId': userid});

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return AppliedJobModel.fromJson(jsonData['resultData']);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
});

class AppliedPage extends ConsumerWidget {
  const AppliedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final atsDataAsync = ref.watch(appliedAts);

    return Scaffold(
      body: atsDataAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(
          color: Constants.darkBlue,
        )),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (atsData) {
          /*    final tabs = atsData.applicationData.keys
              .where((element) => !element.contains("-"))
              .toList(); */
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

                              // fontWeight: FontWeight.w600,
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
                          ref.refresh(appliedAts);
                        },
                        child: ListView.builder(
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
        },
      ),
    );
  }

  Widget listViewItem_new(
      BuildContext context, AppliedApplicant item, String tab) {
    // List<String>? myStrings;
    //  bool stopIteration = false;

    return InkWell(
      onTap: () async {
        SharedPreferences pref = await Utils.getSharedPreferences();
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
                id: item.jobId,
                // id: item.,
              );
            },
          ));
        }
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
                    child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/14644/14644423.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover)),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: customTextForWeather(
                        title: item.level.toString(),
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
                          "${item.process} || ${item.jobLocation?.join(', ') ?? ''}",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Constants.lightdull,
                      borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  width: double.maxFinite,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 8),
                    title: customTextForWeather(
                      title: item.applyFeedback1.toString(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: tab.contains("Not Shortlisted")
                          ? Constants.red
                          : Constants.darkgreen,
                    ),
                    subtitle: customTextForWeather(
                      title: "• ${item.applyFeedback2.toString()}",
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Constants.subtitleclr,
                    ),
                  ),
                ),
                Container(
                  child: tab.contains("Contact HR")
                      ? TextButton(
                          onPressed: () async {
                            launchUrlString("tel://${item.sourcecontactNo}");
                          },
                          child: const customTextForWeather(
                            title: "Call HR",
                            color: Constants.darkBlue,
                            fontWeight: FontWeight.bold,
                          ))
                      : tab.contains("Not Shortlisted")
                          ? TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              },
                              child: const customTextForWeather(
                                title: "Similar Jobs",
                                color: Constants.darkBlue,
                                fontWeight: FontWeight.bold,
                              ))
                          : tab.contains("Interview bey")
                              ? TextButton(
                                  onPressed: () {},
                                  child: const customTextForWeather(
                                    title: "Refer and earn",
                                    color: Constants.darkBlue,
                                    fontWeight: FontWeight.bold,
                                  ))
                              : null,
                )
              ],
            ),

            /*   InkWell(
              onTap: () async {
                SharedPreferences pref = await Utils.getSharedPreferences();
                var userType = await Utils.getPreferencesValue(
                    pref, ESharedPreferences.user_type.name);
                var userrole = await Utils.getPreferencesValue(
                    pref, ESharedPreferences.role.name);
                var id = await Utils.getPreferencesValue(
                    pref, ESharedPreferences.user_id.name);
                int? userid = int.tryParse(id);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return JobDetailsForCandidate(
                      userrole: userrole.toString(),
                      hint: 1,
                      userid: userid!,
                      userType: userType,
                      Applies: false,
                      referal: true,
                      is_freelancer: 3,
                      id: item.jobId,
                    );
                  },
                ));
              },
              child: const customTextForWeather(
                title: "Interview FAQ",
                color: Constants.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ), */
          ],
        ),
      ),
    );
  }

  String formatSalary(String input) {
    final cleanedInput = input.replaceAll(',', '');
    final parts = cleanedInput.split('-');

    if (parts.length != 2) return input;

    final start = double.tryParse(parts[0]) ?? 0;
    final endAndType = parts[1].split(' ');
    final end = double.tryParse(endAndType[0]) ?? 0;
    final type = endAndType.length > 1
        ? endAndType.sublist(1).join(' ').toLowerCase()
        : '';

    if (type.contains("lac")) {
      final startLac = (start / 100000).toStringAsFixed(2);
      final endLac = (end / 100000).toStringAsFixed(2);

      return end > 0 ? "$startLac - $endLac LPA" : "$startLac LPA";
    }

    if (type.contains("month")) {
      final startK = (start / 1000).round();
      final endK = (end / 1000).round();

      return end > 0 ? "${startK}k - ${endK}k PM" : "${startK}k PM";
    }

    return input; // fallback
  }
}
