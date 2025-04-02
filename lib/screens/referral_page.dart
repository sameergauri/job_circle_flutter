import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/referl_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/jobs/job_details_for_candidate.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

final atsDataProvider = FutureProvider<RefeLeadModel>((ref) async {
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
    final atsDataAsync = ref.watch(atsDataProvider);

    return Scaffold(
      body: atsDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (atsData) {
          final tabs = atsData.applicationData.keys.toList();

          return DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.orange,
                  labelColor: Colors.black,
                  isScrollable: true,
                  tabs: tabs
                      .map((tab) => Tab(
                            child: customTextForWeather(
                              title: tab,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ))
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: tabs.map((tab) {
                      final applications = atsData.applicationData[tab] ?? [];

                      return ListView.builder(
                        itemCount: applications.length,
                        itemBuilder: (context, index) {
                          final app = applications[index];
                          return Column(
                            children: [
                              listViewItem_new(context, app),
                              const Divider()
                            ],
                          );
                        },
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
    BuildContext context,
    Application item,
  ) {
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
                // id: item.jobid,
                // id: item.,
              );
            },
          ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${item.applicantName.toString()} ${item.lastName.toString()}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "${item.process.toString()} || ${item.level.toString()}",
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Constants.lightdull,
                  borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              width: double.maxFinite,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.verified_user)),
                title: customTextForWeather(
                  title: item.referralFeedback1,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: customTextForWeather(
                  title: item.referralFeedback1,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Constants.subtitleclr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
