// ignore_for_file: todo

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/ats/ats_applied_page_model.dart';
import 'package:job_circle/src/provider/ats/ats_applied_job_page_provider.dart';
import 'package:job_circle/src/screen/Jobs/job_detail_page.dart';
import 'package:job_circle/src/screen/home_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class AtsAppliedPage extends StatefulWidget {
  const AtsAppliedPage({super.key});

  @override
  State<AtsAppliedPage> createState() => _AtsAppliedPageState();
}

class _AtsAppliedPageState extends State<AtsAppliedPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     context.read<AppliedPageProvider>().fetchAppliedJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.white,
      body: Consumer<AppliedPageProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: const Center(
                child: CircularProgressIndicator(color: Constants.darkBlue),
              ),
            );
          }

          if (provider.error != null) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text('Error: ${provider.error}')),
            );
          }

          final atsData = provider.atsData;
          if (atsData == null || atsData.applicationData.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(CustomAssetUrl.nojobimageicon),
                    Text(
                      "You haven't applied yet!",
                      style: GoogleFonts.varela(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Search for jobs and start applying. You can track your applications here!",
                            style: GoogleFonts.varela(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          }

          final desiredOrder = [
            "Application",
            "Contact HR",
            "Interview bey",
            "Shortlisted",
            "Not Shortlisted",
          ];

          String extractLabel(String input) {
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

          return Scaffold(
            backgroundColor: Colors.white,
            body: DefaultTabController(
              length: tabs.length,
              child: Column(
                children: [
                  TabBar(
                    dividerHeight: 1.0,
                    indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Constants.orange,
                        width: 3.0,
                      ),
                    ),

                    indicatorWeight: 3.0,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelColor: Constants.black,
                    unselectedLabelColor: Constants.subtitleclr,
                    indicatorColor: Constants.orange,
                    labelStyle: GoogleFonts.merriweather(
                      color: Constants.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: GoogleFonts.merriweather(
                      color: Constants.subtitleclr,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: tabs
                        .map(
                          (tab) =>
                              Tab(child: customText(title: tab, fontSize: 12)),
                        )
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
                            provider.refresh();
                          },
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final app = applications[index];
                              return Column(
                                children: [
                                  listViewItemNew(context, app, tab),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
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
            ),
          );
        },
      ),
    );
  }

  Widget listViewItemNew(
    BuildContext context,
    AppliedApplicant item,
    String tab,
  ) {
    return InkWell(
      onTap: () async {
        NavigationService.push(
          JobDetailPage(
            resume: "",
            jobId: item.jobId!,
            fromWhere: FromWhere.appliedPage,
          ),
        );
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
                    item.companyLogo != null &&
                            item.companyLogo != 'null' &&
                            item.companyLogo != ""
                        ? "${GlobalConstants.Image_url}${item.companyLogo}"
                        : CustomIconUrl.companyicon,

                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: customText(
                        title: item.level.toString(),
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    customText(
                      title:
                          "${item.process} || ${item.jobLocation?.join(', ') ?? ''}",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Constants.lightdull,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        title: item.applyFeedback1.toString(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            item.statusId == 3 ||
                                item.statusId == 4 ||
                                item.statusId == 6 ||
                                item.statusId == 8 ||
                                item.statusId == 9
                            ? Constants.red
                            : item.statusId == 12 ||
                                  item.statusId == 13 ||
                                  item.statusId == 10 ||
                                  item.statusId == 11 ||
                                  item.statusId == 14
                            ? Constants.darkgreen
                            : Constants.darkBlue,
                      ),
                      SizedBox(height: 4),
                      customText(
                        title: "• ${item.applyFeedback2.toString()}",
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Constants.subtitleclr,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: tab.contains("Contact HR")
                      ? customButton(item, "Call HR", () async {
                          FlutterPhoneDirectCaller.callNumber(
                            "91${item.sourcecontactNo}",
                          );
                        })
                      : tab.contains("Not Shortlisted")
                      ? customButton(item, "More Jobs", () async {
                          NavigationService.pushAndRemoveUntil(HomeScreen());
                        })
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell customButton(
    AppliedApplicant item,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Constants.darkBlue),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: customText(
          title: title,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Constants.darkBlue,
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

    return input;
  }
}
