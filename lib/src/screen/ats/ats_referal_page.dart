// ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/ats/ats_referal_page_model.dart';
import 'package:job_circle/src/provider/ats/ats_referal_job_page_provider.dart';
import 'package:job_circle/src/screen/Jobs/job_detail_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class ATSReferalPage extends StatefulWidget {
  const ATSReferalPage({super.key});

  @override
  State<ATSReferalPage> createState() => _ATSReferalPageState();
}

class _ATSReferalPageState extends State<ATSReferalPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReferalPageProvider>().fetchReleralJob();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      body: Consumer<ReferalPageProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Scaffold(
              backgroundColor: colors.bgColor,
              body: Center(
                child: CircularProgressIndicator(color: colors.atsTabTextColor),
              ),
            );
          }

          if (provider.error != null) {
            return Scaffold(
              backgroundColor: colors.bgColor,
              body: Center(child: Text('Error: ${provider.error}')),
            );
          }

          final atsData = provider.atsData;
          if (atsData == null || atsData.applicationData.isEmpty) {
            return Scaffold(
              backgroundColor: colors.bgColor,
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(CustomAssetUrl.norefimageicon),
                    Text(
                      "You haven't refer anyone yet!",
                      style: GoogleFonts.varela(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
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
            backgroundColor: colors.bgColor,
            body: DefaultTabController(
              length: tabs.length,
              child: Column(
                children: [
                  TabBar(
                    dividerHeight: 1.0,
                    indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.orangeLine!,
                        width: 3.0,
                      ),
                    ),

                    indicatorWeight: 3.0,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelColor: colors.atsTabTextColor!,
                    unselectedLabelColor: colors.subtitleTextColor!,
                    indicatorColor: colors.orangeLine!,
                    labelStyle: GoogleFonts.merriweather(
                      color: colors.subtabTitleColor!,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: GoogleFonts.merriweather(
                      color: colors.subtitleTextColor!,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: tabs
                        .map(
                          (tab) => Tab(
                            child: customText(
                              title: tab,
                              fontSize: 12,
                              color: colors.subtabTitleColor,
                            ),
                          ),
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
                            physics: const BouncingScrollPhysics(),
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              final app = applications[index];
                              return Column(
                                children: [
                                  listViewItemNew(context, app, tab, colors),
                                  if (index != applications.length - 1)
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
    Application item,
    String tab,
    AppColors colors,
  ) {
    return InkWell(
      onTap: () async {
        NavigationService.push(
          JobDetailPage(
            resume: "",
            jobId: item.jobId!,
            fromWhere: FromWhere.referalPage,
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
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: customText(
                        title:
                            "${item.applicantName.toString()} ${item.lastName.toString()}",
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                        color: colors.headingColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    customText(
                      title:
                          "${item.process.toString()} || ${item.level.toString()}",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      color: colors.subtitleTextColor,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.atsCardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title: item.referralFeedback1,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        item.statusId == 3 ||
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
                  const SizedBox(height: 4),
                  customText(
                    title: "• ${item.referralFeedback2}",
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: Constants.subtitleclr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
