// ignore_for_file: unused_result, unused_field, unused_local_variable, use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names
// ignore_for_file: todo
import 'dart:async';
import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/models/active_state_model.dart';
import 'package:job_circle/models/new_job_model.dart';
import 'package:job_circle/screens/Billing/banking_detal.dart';
import 'package:job_circle/screens/Billing/list_of_invoice.dart';
import 'package:job_circle/screens/Billing/view_and_generate_invoice.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/screens/jobs/job_details.dart';
import 'package:job_circle/screens/jobs/job_details_for_cc.dart';

import 'package:job_circle/screens/new_jobs/filter_jobs.dart';
import 'package:job_circle/screens/new_jobs/location_selector.dart';
import 'package:job_circle/screens/new_jobs/profile_jobs_model.dart';
import 'package:job_circle/screens/profile/profile_summary_partner.dart';
import 'package:job_circle/screens/profile/user_profile.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../enums/enums.dart';
import '../../themes/colors.dart';
import '../jobs/career_assets.dart';
import '../jobs/matching_jobs.dart';
import 'job_provider.dart';

class NewJobsV1 extends ConsumerStatefulWidget {
  const NewJobsV1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewJobsV1State();
}

class _NewJobsV1State extends ConsumerState<NewJobsV1>
    with SingleTickerProviderStateMixin {
  final bool isbannerVisible = false;
  final String bannerUrl = '';
  int? cutTab;

  final ScrollController _scrollController = ScrollController();
  final screenshotController = ScreenshotController();

  void closeDrawer() {
    Scaffold.of(context).closeDrawer();
  }

  bool isMenuOpen = false;

  final List<String> searchFields = [
    'Company',
    'Process',
    'Designation',
    'Functional Area',
    'Skills',
  ];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> _onRefresh() async {
    // Perform a global refresh (e.g., fetch new data for all tabs)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      ref.refresh(jobsProvider);
      // Update the UI with new data
    });
    _refreshController
        .refreshCompleted(); // Call this to end the refresh animation
  }

  void _onLoading() {
    // Your loading more logic here
    // ...

    // When your loading more logic is done, call load complete
    _refreshController.loadComplete();
  }

  String formatSalaryRange(int minSalary, int maxSalary) {
    String formattedMinSalary = '';
    String formattedMaxSalary = '';

    if (minSalary >= 100000) {
      formattedMinSalary = (minSalary / 100000).toStringAsFixed(2);
    } else if (minSalary >= 1000) {
      formattedMinSalary =
          '${(minSalary / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0*$'), '')}k';
    } else {
      formattedMinSalary = minSalary
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'(?<=\.\d*?)0*$'), '');
    }

    if (maxSalary >= 100000) {
      formattedMaxSalary = (maxSalary / 100000).toStringAsFixed(2);
    } else if (maxSalary >= 1000) {
      formattedMaxSalary =
          '${(maxSalary / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0*$'), '')}k';
    } else {
      formattedMaxSalary = maxSalary
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'(?<=\.\d*?)0*$'), '');
    }

    // Remove ".00" if present
    formattedMinSalary = formattedMinSalary.replaceAll(RegExp(r'\.00$'), '');
    formattedMaxSalary = formattedMaxSalary.replaceAll(RegExp(r'\.00$'), '');

    return maxSalary == 0
        ? formattedMinSalary
        : '$formattedMinSalary - $formattedMaxSalary';
  }

  int currentSearchFieldIndex = 0;
  nav() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CareerAssets()));
  }

  List<String> storedSelectedOptions = [];
  String storedSelectedCategory = '';
  List<String> storedSelectedColumn = [];

  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  void onFilterDialogClosed(List<String> selectedOptions,
      String selectedCategory, List<String> selectedColumn) {
    setState(() {
      storedSelectedOptions = selectedOptions;
      storedSelectedCategory = selectedCategory;
      storedSelectedColumn = selectedColumn;
    });
  }

  Widget customTab(
      String title, String img, int select, ProfileModelForJob model) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: cutTab == select
                ? isTabFilterSelected(model)
                    ? Constants.borderColor
                    : Colors.white
                : Colors.white,
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: cutTab == select
            ? isTabFilterSelected(model)
                ? Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        img,
                        height: 12.h,
                        //width: 15.w,
                      )
                    ],
                  )
                : Row(
                    children: [
                      Text(title),
                      /* Icon(
                        Icons.add,
                        size: 15.h,
                      ) */
                    ],
                  )
            : Row(
                children: [
                  Text(title),
                  /*  Icon(
                    Icons.add,
                    size: 15.h,
                  ) */
                ],
              ));
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Job circle App',
        text: 'Install jobcircle app',
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.job_circle_flutter',
        chooserTitle: 'Example Chooser Title');
  }

  late SharedPreferences prefs;

  bool isTabFilterSelected(ProfileModelForJob model) {
    final jobController = ref.watch(jobsProvider);
    if (cutTab == 6) {
      return jobController.isFavoriteTabSelected;
    } else if (cutTab == 1 && model.usertype != 1) {
      return jobController.isMyJobsTabSelected;
    } else if (cutTab == 2) {
      return jobController.isFreshersTabSelected;
    } else if (cutTab == 3) {
      return jobController.isLanguilTabSelected;
    } else if (cutTab == 4) {
      return jobController.isCompusTabSelected;
    } else if (cutTab == 5) {
      return jobController.isSupportStaff;
    }

    return false;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      prefs = await SharedPreferences.getInstance();
    });
    startSearchFieldAnimation();

    super.initState();
  }

  @override
  void dispose() {
    // Clear the searchController when the screen is disposed

    super.dispose();
  }

  List<String> updatedList = [];
  List<String> myString = [];
  late Timer timer;

  void startSearchFieldAnimation() {}

  final FocusNode _dearchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final jobsController = ref.watch(jobsProvider);
    final profileProfile = ref.watch(profileSummaryProvider);
    /*  var userid =
        Utils.getPreferencesValue(null, ESharedPreferences.user_id.name); */
    List<JobsModel> favoriteJobs = jobsController.jobs
        .where((job) => job.isFav == 1)
        .where((element) => element.userId == profileProfile.value!.id)
        .where((element) => element.active == 1)
        .toList();
    List<JobsModel> campusHiringList = jobsController.jobs
        .where((job) => job.is_campus == 1)
        // .where((element) => element.location == jobsController.selectedLocation)
        .where((element) => element.active == 1)
        .toList();

    List<JobsModel> linguistic = jobsController.jobs
        .where((job) => job.languagesKnown!.isNotEmpty)
        // .where((element) => element.location == jobsController.selectedLocation)
        .where((element) => element.active == 1)
        .toList();

    List<JobsModel> supprtStaffList = jobsController.jobs
        .where((job) => job.is_support_staff == 1)
        .where((element) => element.active == 1)
        .toList();

    // print(favoriteJobs);
    String colorName;
    Color color;
    return profileProfile.when(
      data: (data) {
        setState(() {
          if (data.isFreelancer == 2) {
            //TODO:: 1 = JobSeeker, 2 = Freelancer, 0 = Both. // login type for user.
            freelancer = true;
            jobSeeker = false;
          } else if (data.isFreelancer == 1) {
            jobSeeker = true;
            freelancer = false;
          }
        });
        if (jobsController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Constants.darkBlue),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          drawer: ClipRRect(
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(15)),
            child: Drawer(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    color: Constants.borderColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.w,
                          /* top: data.usertype != 1
                              ? kToolbarHeight
                              : kToolbarHeight / 2, */
                          top: kToolbarHeight,
                          bottom: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data.profilePic == null || data.profilePic == " "
                              ? InkWell(
                                  onTap: () async {
                                    ref.refresh(ProfileDataProvider);
                                    Navigator.of(context).pop();

                                    data.usertype != 3
                                        ? /* await Navigator.pushNamed(context,
                                            ERoute.profile_summary.name) */
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserProfile()))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const PartnerProfile())));
                                    /*  await Navigator.pushNamed(
                                            context,
                                            ERoute
                                                .profile_summary_partner.name); */

                                    closeDrawer(); // Call the function to close the drawer
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 35,
                                      onBackgroundImageError:
                                          ((error, stackTrace) => Image.asset(
                                                data.gender != "Male"
                                                    ? "assets/images/leadfemal.png"
                                                    : "assets/images/leadmale.png",
                                                // height: 8.h,
                                              ).image),
                                      backgroundImage: Image.asset(
                                        data.gender != "Male"
                                            ? "assets/images/leadfemal.png"
                                            : "assets/images/leadmale.png",
                                        // height: 8.h,
                                      ).image))
                              : InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    data.usertype != 3
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserProfile()))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PartnerProfile()));

                                    closeDrawer(); // Call the function to close the drawer
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: const Color.fromARGB(
                                        255, 190, 190, 190),
                                    radius: 35,
                                    onBackgroundImageError:
                                        ((error, stackTrace) => Image.network(
                                            "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profilePic}",
                                            fit: BoxFit.fill)),
                                    backgroundImage: Image.network(
                                      "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profilePic}",
                                      fit: BoxFit.fill,
                                    ).image,
                                  ),
                                ),
                          customTextForWeather(
                              title:
                                  "${data.firstName.toString().toTitleCase()} ${data.lastName.toString().toTitleCase()}",
                              fontSize: 16,
                              color: Constants.black,
                              fontWeight: FontWeight.bold),
                          customTextForMonst(
                            title:
                                formatLocality(data.user_locality.toString()),
                            fontSize: 12,
                            color: Constants.subtitleclr,
                          )
                          /*  if (data.usertype == 1)   //TODO:: Button to switch jobseekr to freelancer....
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.white),
                              margin: EdgeInsets.only(top: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await JobPostApiService
                                              .updateFreelancerActivity(
                                                  1, data.id!.toInt());

                                          setState(() {
                                            jobSeeker = true;
                                            freelancer = false;
                                          });
                                          ref.refresh(profileSummaryProvider);
                                        },
                                        child: CustomContainerForUserSelection(
                                            "Job Seeker", jobSeeker),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await JobPostApiService
                                              .updateFreelancerActivity(
                                                  2, data.id!.toInt());

                                          setState(() {
                                            jobSeeker = false;
                                            freelancer = true;
                                          });
                                          ref.refresh(profileSummaryProvider);
                                        },
                                        child: CustomContainerForUserSelection(
                                            "Freelancer", freelancer),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ), */
                        ],
                      ),
                    ),
                  ),
                  if (data.usertype == 1)
                    ExpansionTile(
                      dense: true,
                      textColor: Constants.darkBlue,

                      iconColor: Constants.darkBlue,
                      collapsedIconColor: Constants.darkBlue,
                      //  collapsedTextColor: Constants.darkBlue,
                      //  collapsedIconColor: Constants.black,
                      leading: Image.network(
                        'https://assets.api.uizard.io/api/cdn/stream/768b2a61-82db-4e34-b49b-1e8a12feea17.png',
                        height: 20,
                        color: Constants.darkBlue,
                      ),
                      title: const customTextForWeather(
                        title: 'Referral Program',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Constants.darkBlue,
                      ),
                      children: [
                        ListTile(
                          dense: true,
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.network(
                            'https://assets.api.uizard.io/api/cdn/stream/5fdfd683-2909-4188-b2e4-2f02ad6e7f91.png',
                            height: 20,
                            color: Colors.black,
                          ),
                          title: const customTextForWeather(
                              title: 'View & Generate Invoice',
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenerateInvoice(
                                    name: data.middleName != null &&
                                            data.middleName != ""
                                        ? "${data.firstName} ${data.middleName} ${data.lastName}"
                                        : "${data.firstName} ${data.lastName}",
                                    profilePic: data.profilePic.toString(),
                                    gender: data.gender.toString(),
                                  ),
                                ));
                            closeDrawer();
                            //Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          dense: true,
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.network(
                            'https://assets.api.uizard.io/api/cdn/stream/e512a1a4-0c69-49d2-a063-fd4f83727d79.png',
                            height: 20,
                            color: Colors.black,
                          ),
                          title: const customTextForWeather(
                              title: 'Payment Status',
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListOfInvoice()));
                          },
                        ),
                        ListTile(
                          dense: true,
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.network(
                            'https://assets.api.uizard.io/api/cdn/stream/68a2443e-6941-40d9-8948-f61e8a319a72.png',
                            height: 20,
                            color: Colors.black,
                          ),
                          title: const customTextForWeather(
                              title: 'My Banking Detail',
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BankingDetals(
                                          name: data.middleName != null &&
                                                  data.middleName != ""
                                              ? "${data.firstName} ${data.middleName} ${data.lastName}"
                                              : "${data.firstName} ${data.lastName}",
                                          profilePic:
                                              data.profilePic.toString(),
                                          gender: data.gender.toString(),
                                        )));
                            closeDrawer();
                          },
                        ),
                      ],
                    ),
                  if (data.usertype == 1)
                    ListTile(
                      dense: true,
                      minLeadingWidth: 0.0,
                      minVerticalPadding: 5.1,
                      leading: Image.network(
                        'https://assets.api.uizard.io/api/cdn/stream/d19cf674-b262-4aa5-86b5-32d1942f8966.png',
                        //color: Colors.black,
                        height: 20,
                      ),
                      title: const customTextForWeather(
                          title: 'Write to us',
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                      onTap: () async {
                        await launchUrl(
                            Uri.parse("mailto:support@jobcircle.co.in?"));
                        closeDrawer();
                      },
                    ),
                  /*  ExpansionTile(
                      leading: Image.asset(
                        "assets/images/contactus.png",
                        height: 20.h,
                      ),
                      title: Text(
                        'Contact Us',
                        style: GoogleFonts.varela(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        
                      ],
                    ), */
                  /*   if (data.usertype == 1)
                    ListTile(
                      minLeadingWidth: 0.0,
                      minVerticalPadding: 5.1,
                      leading: Image.asset(
                        "assets/images/contactus.png",
                        height: 20.h,
                      ),
                      title: Text(
                        'Contact Us',
                        style: GoogleFonts.varela(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ContactUS()));
                        closeDrawer();
                        // Navigator.pop(context);
                      },
                    ), */
                  ListTile(
                    dense: true,
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 5.1,
                    leading: Image.asset(
                      "assets/images/share.png",
                      height: 18,
                    ),
                    title: const customTextForWeather(
                        title: 'Share App',
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                    onTap: () {
                      share();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    dense: true,
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 5.1,
                    leading: Image.asset(
                      'assets/images/logout.png',
                      height: 20,
                    ),
                    title: const customTextForWeather(
                        title: 'LogOut',
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                    onTap: () {
                      prefs.clear();
                      jobsController.searchController.clear();
                      Future.delayed(const Duration(seconds: 0), () async {
                        await AppUtils.clearSession();
                        await Navigator.pushNamedAndRemoveUntil(
                            context,
                            ERoute.login.value,
                            (Route<dynamic> route) => false);
                      });
                      prefs.setString('selectedLocation', "");
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(
                                "https://www.linkedin.com/company/job-circle/");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Image.asset(
                                "assets/images/linkdin.png",
                                height: 18.sp,
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(
                                "https://whatsapp.com/channel/0029VaWd8KB7NoZwpZQLCN35");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Image.asset(
                                "assets/images/whatsapp.png",
                                height: 18.sp,
                                color: Colors.green,
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(
                                "https://www.instagram.com/jobcircleofficial?igsh=MTZzbXJ4dGJjaGt3ag==");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Image.asset(
                                "assets/images/instagram.png",
                                height: 18.sp,
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(
                                "https://www.facebook.com/JobCircleOfficial");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Image.asset(
                                "assets/images/facebook.png",
                                height: 18.sp,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          appBar: AppBar(
            leadingWidth: 50,
            leading: Builder(
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                ),
                child: InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: CircleAvatar(
                      backgroundColor: Constants.bgColorWhite,
                      radius: 2.r,
                      child: data.profilePic != null && data.profilePic != " "
                          ? CircleAvatar(
                              backgroundColor: Constants.borderColor,
                              radius: 35,
                              onBackgroundImageError: ((error, stackTrace) =>
                                  Image.asset("assets/images/cmpny.png",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.contain)),
                              backgroundImage: Image.network(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profilePic}",
                                fit: BoxFit.fill,
                              ).image,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: Image.asset(
                                data.gender != "Male"
                                    ? "assets/images/leadfemal.png"
                                    : "assets/images/leadmale.png",
                                height: 8.h,
                              ).image,
                            )),
                ),
              ),
            ),
            titleSpacing: 4,
            iconTheme: const IconThemeData(color: Constants.themeBgColor),
            bottom: PreferredSize(
              preferredSize: Size(0, 30.h),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        FilterDialog filterDialog = FilterDialog(
                            onFilterApplied:
                                (List<JobsModel> updatedfilteredJobsData) {},
                            storedSelectedOptions: storedSelectedOptions,
                            storedSelectedCategory: storedSelectedCategory,
                            storedSelectedColumn: storedSelectedColumn,
                            onDialogClosed: onFilterDialogClosed,
                            profileModel: data);
                        filterDialog.showFilterDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Constants.borderColor)),
                        // height: 28.h,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Filter"),
                            SizedBox(
                                // width: 5.w,
                                ),
                            Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (data.usertype == 3 && data.role != "HR-Executive")
                      const SizedBox(
                        width: 5,
                      ),
                    if (data.usertype == 3 && data.role != "HR-Executive")
                      InkWell(
                          onTap: () {
                            cutTab = 1;
                            jobsController.toggleMyJobsFilter(data);
                          },
                          child: customTab(
                              "My Jobs", "assets/images/check.png", 1, data)),
                    if (favoriteJobs.isNotEmpty)
                      const SizedBox(
                        width: 5,
                      ),
                    if (favoriteJobs.isNotEmpty)
                      InkWell(
                          onTap: () {
                            cutTab = 6;

                            jobsController.toggleFavoriteJobs(data);
                          },
                          child: customTab("Saved Jobs",
                              "assets/images/check.png", 6, data)),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                        onTap: () {
                          cutTab = 2;

                          jobsController.toggleFreshersFilter(data);
                        },
                        child: customTab(
                            "Fresher", "assets/images/check.png", 2, data)),
                    // if (data.usertype == 1)
                    const SizedBox(
                      width: 5,
                    ),
                    // if (data.usertype == 1)

                    InkWell(
                        onTap: () {
                          cutTab = 3;
                          jobsController.toggleLanguilJobs(data);
                        },
                        child: customTab(
                            "Linguistic", "assets/images/check.png", 3, data)),
                    const SizedBox(
                      width: 5,
                    ),
                    if (campusHiringList.isNotEmpty)
                      InkWell(
                          onTap: () {
                            cutTab = 4;
                            jobsController.toggleCompusJobs(data);
                          },
                          child: customTab("Campus Hiring",
                              "assets/images/check.png", 4, data)),
                    const SizedBox(
                      width: 5,
                    ),
                    if (supprtStaffList.isNotEmpty)
                      InkWell(
                          onTap: () {
                            cutTab = 5;
                            jobsController.toggleSupportStaff(data);
                          },
                          child: customTab(
                              "Lateral", //TODO:: "Support Staff" earlier.... but now its lateral....
                              "assets/images/check.png",
                              5,
                              data)),
                  ],
                ),
              ),
            ),
            /*   toolbarHeight: MediaQuery.of(context).size.width *
                0.11, */ //TODO : AppBar height and remove extra space above the appbar.
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    //margin: const EdgeInsets.symmetric(vertical: 10),
                    //height: 30.h,
                    height: MediaQuery.of(context).size.height / 26.h,
                    // width: MediaQuery.of(context).size.width / 3.w,
                    child: TextField(
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      focusNode: _dearchFocus,
                      controller: jobsController.searchController,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding:
                            const EdgeInsets.only(left: 5.0, bottom: 5, top: 5),
                        fillColor: Constants.bgColorWhite,
                        hintText:
                            'Search Jobs by ${searchFields[currentSearchFieldIndex]}',
                        hintMaxLines: 1,
                        hintStyle: GoogleFonts.merriweather(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      style: GoogleFonts.merriweather(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            jobsController.selectedLocation.isEmpty
                                ? Icon(
                                    Icons.pin_drop,
                                    color: Colors.black,
                                    size: 15.h,
                                  )
                                : const SizedBox(),
                            GestureDetector(
                              onTap: () async {
                                final selected =
                                    await showModalBottomSheet<String>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return LocationSelector(
                                      locationList: jobsController.locationList,
                                      onLocationSelected: (selectedLocation) {
                                        if (selectedLocation.isNotEmpty) {
                                          jobsController.selectedLocation =
                                              selectedLocation;
                                          jobsController.toggleLocationFilter();
                                          //  jobsController.filterData.clear();
                                          cutTab =
                                              0; // TODO : to reset selected tab clear when user select location .
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                              child: customTextForWeather(
                                title:
                                    jobsController.selectedLocation.isNotEmpty
                                        ? jobsController.selectedLocation
                                        : 'City',
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                // height: 12.0,
                                // textBaseline: TextBaseline.alphabetic,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: OverlaySupport(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(top: 0),
                  padding: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                    color: Constants.bgPanelColor,
                  ),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isbannerVisible,
                        child: SizedBox(
                          height: 10.h,
                        ),
                      ),
                      Visibility(
                        visible: isbannerVisible,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(255, 192, 192, 192),
                                  blurRadius: 2.0,
                                  spreadRadius: 1),
                            ],
                            color: Constants.bgPanelColor,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(bannerUrl)),

                            //  color: Color(0xfff0f1fe),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          height: 80.h,
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          width: double.infinity,
                        ),
                      ),
                      Visibility(
                        visible: jobsController.selectedLocation.isEmpty,
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/nolocation.gif",
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Please choose the city where you are currently searching for job opportunities.",
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
                      ),
                      Visibility(
                        //TODO: when no jobs fond at specified location..
                        visible: jobsController.filteredJobs.isEmpty &
                            jobsController.selectedLocation.isNotEmpty,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/nodata.png",
                                //  height: 300.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (jobsController.filteredJobs.isNotEmpty &&
                          jobsController.selectedLocation
                              .isNotEmpty) //TODO:: changes done to avoid the select loc image and data at the same time.
                        Expanded(
                          child: SmartRefresher(
                            header: const WaterDropHeader(),
                            // enablePullUp: true,
                            enablePullDown: true,
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(
                              // primary: false,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: jobsController.filteredJobs
                                  .where((job) => job.active == 1)
                                  .length,
                              itemBuilder: (context, index) {
                                var filteredJobs = jobsController.filteredJobs
                                    .where((job) => job.active == 1)
                                    .toList(); // Convert the filtered iterable to a list

                                //TODO:: Sorting jobs as per sponsored_position
                                //
                                //
                                //
                                //
                                filteredJobs.sort((job1, job2) {
                                  int compareSponsoredPosition() {
                                    if (job1.sponsored_position == null &&
                                        job2.sponsored_position == null) {
                                      return 0; // Both are null, treat them as equal
                                    } else if (job1.sponsored_position !=
                                            null &&
                                        job2.sponsored_position == null) {
                                      return -1; // job1 comes first
                                    } else if (job1.sponsored_position ==
                                            null &&
                                        job2.sponsored_position != null) {
                                      return 1; // job2 comes first
                                    } else {
                                      // Sort by sponsored_position from 1 to 5
                                      return job1.sponsored_position!
                                          .compareTo(job2.sponsored_position!);
                                    }
                                  }

                                  // Compare sponsored_position first
                                  int sponsoredPositionComparison =
                                      compareSponsoredPosition();
                                  if (sponsoredPositionComparison != 0) {
                                    return sponsoredPositionComparison;
                                  }

                                  // If sponsored_position is the same or both are null, sort by job ID in descending order
                                  return (job2.id ?? 0).compareTo(job1.id ?? 0);
                                });

                                var item = filteredJobs[index];

                                if (item.skills != null) {
                                  myString = item.skills!;
                                  updatedList = myString
                                      .map((item) => item.trim())
                                      .toList();

                                  // do something with the parts array
                                } else {
                                  // handle the case where str is null
                                }
                                return InkWell(
                                  onTap: () async {
                                    var usertype =
                                        await Utils.getPreferencesValue(prefs,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(prefs,
                                            ESharedPreferences.role.name);
                                    var userid =
                                        await Utils.getPreferencesValue(prefs,
                                            ESharedPreferences.user_id.name);
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return data.usertype == 3
                                            ? JobDetailsForCC(
                                                id: item.id,
                                                Applies: false,
                                                referal: false,
                                                userid: int.tryParse(userid)!,
                                                userType: int.tryParse(
                                                    usertype.toString()),
                                                userrole: userrole.toString(),
                                              )
                                            : JobDetails(
                                                id: item.id,
                                                Applies: false,
                                                referal: false,
                                                is_freelancer:
                                                    data.usertype == 3
                                                        ? 3
                                                        : data.isFreelancer
                                                                ?.toInt() ??
                                                            0,
                                                userType: int.tryParse(
                                                    usertype.toString()),
                                                // userrole: userrole,
                                              );
                                      },
                                    ));
                                  },
                                  child: Stack(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            /*  decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: const Offset(
                                                          0.5, 2),
                                                      blurRadius: 2,
                                                      spreadRadius: 2,
                                                      color: Colors
                                                          .grey.shade200)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.r)), */
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                item.sponsored_position != //TODO:: Urgent Hiring.
                                                        null
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 5),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2.h,
                                                                horizontal:
                                                                    4.w),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        8.r),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        8.r)),
                                                            color:
                                                                Colors.orange),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              size: 15.sp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const customTextForWeather(
                                                                title:
                                                                    "Urgent Hiring",
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12)
                                                          ],
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 5.w,
                                                    right: 5.w,
                                                    bottom: 5.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        dense:
                                                            true, // Reduces default padding

                                                        leading: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Constants
                                                                      .lightdull),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Image.asset(
                                                            "assets/images/company.png",
                                                            color: Constants
                                                                .subtitleclr,
                                                          ),
                                                        ),
                                                        minVerticalPadding: 0.0,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        title: Row(
                                                          children: [
                                                            customTextForWeather(
                                                                title:
                                                                    item.roleName ??
                                                                        '',
                                                                maxlines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            if (item
                                                                .languagesKnown!
                                                                .isNotEmpty)
                                                              Image.asset(
                                                                "assets/images/languages.png",
                                                                height: 18.h,
                                                              ),
                                                          ],
                                                        ),
                                                        subtitle:
                                                            customTextForWeather(
                                                                title:
                                                                    "${item.process.toString()} || ${item.natureOfWork.toString()}",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          item.isFresher ==
                                                                  "Fresher"
                                                              ? Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              18,
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/exp_bag.png",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              12,
                                                                        ),
                                                                        const customTextForWeather(
                                                                            title:
                                                                                "Fresher can apply.",

                                                                            // color: Colors.black54,
                                                                            color:
                                                                                Constants.black,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 12)
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    )
                                                                  ],
                                                                )
                                                              : (item.totalExperience !=
                                                                      null)
                                                                  ? Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 18,
                                                                              width: 18,
                                                                              child: Image.asset(
                                                                                "assets/images/exp_bag.png",
                                                                                fit: BoxFit.cover,
                                                                                //  color: Constants.subtitleclr,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 12),
                                                                            item.maxExperience == "& above"
                                                                                ? item.minExperience == "0.6"
                                                                                    ? const customTextForWeather(
                                                                                        // "${item.minexperience.replaceAll(".0", "")} Years & above.",
                                                                                        title: "6 Month & Above.",

                                                                                        // color: Colors.black54,
                                                                                        color: Constants.black,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontSize: 12)
                                                                                    : customTextForWeather(
                                                                                        title: "${item.minExperience?.replaceAll(".0", "")} Yrs & above.",

                                                                                        // color: Colors.black54,
                                                                                        color: Constants.black,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontSize: 12)
                                                                                : customTextForWeather(
                                                                                    title: "${item.minExperience?.replaceAll(".0", "")} - ${item.maxExperience?.replaceAll(".0", "")} Yrs",

                                                                                    // color: Colors.black54,
                                                                                    color: Constants.black,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontSize: 12)
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              4,
                                                                        )
                                                                      ],
                                                                    )
                                                                  : const SizedBox(),
                                                          if (item.minCTC !=
                                                              null)
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          17,
                                                                      width: 17,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/wallet.png",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 12,
                                                                    ),
                                                                    customTextForWeather(
                                                                      title: formatSalaryRange(
                                                                          item.minCTC!
                                                                              .toInt(),
                                                                          item.maxCTC!
                                                                              .toInt()),
                                                                      fontSize:
                                                                          12,
                                                                      color: Constants
                                                                          .black,
                                                                    ),
                                                                    if (item.isMonthly !=
                                                                        "")
                                                                      customTextForWeather(
                                                                        title:
                                                                            " ${item.isMonthly}",
                                                                        fontSize:
                                                                            12,
                                                                        color: Constants
                                                                            .black,
                                                                      )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                )
                                                              ],
                                                            ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 18,
                                                                    width: 18,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/loc.png",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      color: Constants
                                                                          .subtitleclr,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 12,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        customTextForWeather(
                                                                      title:
                                                                          item.location ??
                                                                              '',
                                                                      maxlines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          12,
                                                                      color: Constants
                                                                          .black,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          /*  const customTextForWeather(
                                                            title: "Skills : ",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ), */
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      "Skills : ", // Bold "Skills" text
                                                                  style: GoogleFonts
                                                                      .merriweather(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12,
                                                                    color: Constants
                                                                        .black,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: updatedList
                                                                      .map((skillItem) => skillItem
                                                                          .replaceAll(
                                                                              '"',
                                                                              '')
                                                                          .replaceAll(
                                                                              '[',
                                                                              '')
                                                                          .replaceAll(
                                                                              ']',
                                                                              ''))
                                                                      .join(
                                                                          ', '), // Normal text for skills
                                                                  style: GoogleFonts
                                                                      .merriweather(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12,
                                                                    color: Constants
                                                                        .subtitleclr,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          /*  if (updatedList  //TODO:: When skill is more thn 3 to display ...
                                                                  .length >
                                                              3)
                                                            const customTextForWeather(
                                                              title: "........",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                            ), */
                                                          /* ...updatedList
                                                              .take(3)
                                                              .map(
                                                                (skillItem) =>
                                                                    customTextForWeather(
                                                                  title: skillItem
                                                                      .replaceAll(
                                                                          '"',
                                                                          '')
                                                                      .replaceAll(
                                                                          '[',
                                                                          '')
                                                                      .replaceAll(
                                                                          ']',
                                                                          ''),
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                ),
                                                              ), */
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          if (data.usertype ==
                                                                  3 &&
                                                              data.role !=
                                                                  "HR-Manager")
                                                            Row(
                                                              children: [
                                                                data.usertype ==
                                                                            3 &&
                                                                        data.id ==
                                                                            item.spoc
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const MatchingJobs()));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              right: 10),
                                                                          padding: EdgeInsets.symmetric(
                                                                              vertical: 4.h,
                                                                              horizontal: 8.w),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Constants.subtitleclr),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                "Matching CV",
                                                                                style: TextStyle(
                                                                                  color: Constants.subtitleclr,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 15.h,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox(),
                                                                const Spacer(),
                                                                Visibility(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => AddResume(
                                                                                    // report_to: data.reportTo!.toInt(),
                                                                                    interviewRounds: item.interviewrounds!.first.replaceAll('[', '').replaceAll(']', '').replaceAll('"', ''),
                                                                                    company_name: item.companyName.toString(),
                                                                                    role: item.roleName.toString(),
                                                                                    process: item.process.toString(),
                                                                                    nature_of_work: item.natureOfWork.toString(),
                                                                                    company_id: item.companyId!.toInt(),
                                                                                    jobId: item.id!.toInt(),
                                                                                    /*    sourceId: data.id != null ? data.id!.toInt() : 0,
                                                                                    sourceName: "${data.firstName.toString()} ${data.lastName.toString()}", */
                                                                                    isRefer: false,
                                                                                    spocId: item.spoc!,
                                                                                    is90: item.payment_clause == "90 Days" ? true : false,
                                                                                    is30: item.payment_clause == "30 Days" ? true : false,
                                                                                    userNumber: data.mobile!.toInt(),
                                                                                    useAlternateNumber: data.alternateNo!.toInt(),
                                                                                  )));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: 4
                                                                              .h,
                                                                          horizontal:
                                                                              8.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Constants.blue),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Constants.blue,
                                                                            size:
                                                                                15.h,
                                                                          ),
                                                                          Text(
                                                                            "Resume",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Constants.blue,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15.h,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          /* Row(    //TODO:: Apply and refer button for freelancer and jobseeker
                                                            children: [
                                                              if (data.usertype ==
                                                                      1 &&
                                                                  (data.isFreelancer ==
                                                                          null ||
                                                                      data.isFreelancer ==
                                                                          1))
                                                                const Spacer(),
                                                              Visibility(
                                                                visible: data
                                                                            .usertype ==
                                                                        1 &&
                                                                    (data.isFreelancer == 0 ||
                                                                        data.isFreelancer ==
                                                                            1 ||
                                                                        data.isFreelancer ==
                                                                            null),
                                                                child:
                                                                    InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    CoolingForApply apiresult = await ApplicationAPI.getStatusAndDolOfUser(
                                                                        //TODO:: To avoid dublicate
                                                                        companyId: item.companyId!.toInt(),
                                                                        process: item.process.toString(),
                                                                        role: item.roleName.toString(),
                                                                        now: item.natureOfWork.toString());
                                                                    //
                                                                    //
                                                                    //
                                      
                                                                    DateTime dolDate = apiresult.dol !=
                                                                            ""
                                                                        ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(apiresult
                                                                            .dol)
                                                                        : DateTime
                                                                            .now();
                                                                    DateTime
                                                                        currentDate =
                                                                        DateTime
                                                                            .now();
                                                                    int differenceInDays = currentDate
                                                                        .difference(
                                                                            dolDate)
                                                                        .inDays;
                                                                    final diff =
                                                                        differenceInDays >
                                                                            30;
                                                                    //
                                                                    //
                                                                    //
                                                                    if (item.id ==
                                                                        apiresult
                                                                            .jobid) {
                                                                      if (apiresult.status != "Interview bay" &&
                                                                          apiresult.status !=
                                                                              "Assign" &&
                                                                          apiresult.status !=
                                                                              "Application" &&
                                                                          (apiresult.dol == "" ||
                                                                              diff)) {
                                                                        if (data.cvLink !=
                                                                            null) {
                                                                          await JobPostApiService.postJobApply(
                                                                              jobId: item.id!.toInt(),
                                                                              userId: await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name),
                                                                              number: await Utils.getPreferencesValue(null, ESharedPreferences.user_mobile.name),
                                                                              context: context);
                                                                          ref.refresh(fetchAllApplyProvider);
                                                                          ref.refresh(fetchAllTalentPoolProvider);
                                                                        } else {
                                                                          if (item.id !=
                                                                              null) {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => AddCvtoApply(
                                                                                          jobId: item.id!.toInt(),
                                                                                        )));
                                                                          }
                                                                        }
                                                                      } else {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return CustomDialog(
                                                                                fetchDataFromApi: () {},
                                                                                onClose: () {
                                                                                  Navigator.pop(context);
                                                                                  /*  Navigator.pushAndRemoveUntil(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => HomeScreen(),
                                                                                    ),
                                                                                    (route) => false); */
                                                                                },
                                                                                isFisrt: false,
                                                                                title: "Error",
                                                                                subtitle: "Your CV is already in process in the PipeLine");
                                                                          },
                                                                        );
                                                                      }
                                                                    } else {
                                                                      if (data.cvLink !=
                                                                          null) {
                                                                        await JobPostApiService.postJobApply(
                                                                            jobId: item.id!.toInt(),
                                                                            userId: await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name),
                                                                            number: await Utils.getPreferencesValue(null, ESharedPreferences.user_mobile.name),
                                                                            context: context);
                                                                        ref.refresh(
                                                                            fetchAllApplyProvider);
                                                                        ref.refresh(
                                                                            fetchAllTalentPoolProvider);
                                                                      } else {
                                                                        if (item.id !=
                                                                            null) {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => AddCvtoApply(
                                                                                        jobId: item.id!.toInt(),
                                                                                      )));
                                                                        }
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                      left:
                                                                          10,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: 4
                                                                            .h,
                                                                        horizontal:
                                                                            16.w),
                                                                    decoration: BoxDecoration(
                                                                        border:
                                                                            Border.all(color: Constants.navyblue),
                                                                        borderRadius: BorderRadius.circular(8)),
                                                                    child:
                                                                        Text(
                                                                      "Apply",
                                                                      style: GoogleFonts.varela(
                                                                          color:
                                                                              Constants.navyblue,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (data.usertype ==
                                                                      1 &&
                                                                  (data.isFreelancer !=
                                                                              null &&
                                                                          data.isFreelancer ==
                                                                              2 ||
                                                                      data.isFreelancer ==
                                                                          0))
                                                                const Spacer(),
                                                              /* if (item.payoutType !=   //TODO:: commented because i wanna display refer now button for all hiring if the hiring dont have payout..
                                                                  null) */
                                                              Visibility(
                                                                visible: data
                                                                            .usertype ==
                                                                        1 &&
                                                                    (data.isFreelancer == 2 ||
                                                                        data.isFreelancer ==
                                                                            0 ||
                                                                        data.isFreelancer ==
                                                                            null),
                                                                child:
                                                                    InkWell(
                                                                  onTap: () {
                                                                    var profilemodel;
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => AddResume(
                                                                                  report_to: data.reportTo!.toInt(),
                                                                                  company_name: item.companyName.toString(),
                                                                                  role: item.roleName.toString(),
                                                                                  process: item.process.toString(),
                                                                                  nature_of_work: item.natureOfWork.toString(),
                                                                                  company_id: item.companyId!.toInt(),
                                                                                  //anyId!.toInt(),
                                                                                  jobId: item.id!.toInt(),
                                                                                  sourceId: data.id!.toInt(),
                                                                                  sourceName: "${data.firstName.toString()} ${data.lastName.toString()}",
                                                                                  isRefer: true,
                                                                                  spocId: item.spoc!.toInt(),
                                                                                  is90: item.payment_clause == "90 Days" ? true : false,
                                                                                  is30: item.payment_clause == "30 Days" ? true : false,
                                                                                  userNumber: data.mobile!.toInt(),
                                                                                  useAlternateNumber: data.alternateNo?.toInt() ?? 0,
                                                                                  interviewRounds: item.interviewrounds!.first.replaceAll('[', '').replaceAll(']', '').replaceAll('"', ''),
                                                                                )));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                      left:
                                                                          10,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: 4
                                                                            .h,
                                                                        horizontal:
                                                                            10.w),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(8)),
                                                                    child:
                                                                        Text(
                                                                      "Refer Now",
                                                                      style: GoogleFonts.varela(
                                                                          color:
                                                                              Colors.blue,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ), */
                                                          //
                                                          //
                                                          //
                                                          //
                                                          //
                                                          //
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (data.role != "HR-Manager" &&
                                                    index !=
                                                        jobsController
                                                                .filteredJobs
                                                                .where((job) =>
                                                                    job.active ==
                                                                    1)
                                                                .length -
                                                            1)
                                                  const Divider(
                                                    thickness: 1.0,
                                                  )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      item.spoc.toString() == data.id.toString()
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                if (item.is_campus == 1)
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10.w,
                                                          top: 5.h),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.h,
                                                              horizontal: 4.w),
                                                      decoration: BoxDecoration(
                                                        color: Constants.blue,
                                                        border: Border.all(
                                                            color:
                                                                Constants.blue),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8.r),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8.r)),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/campus.png",
                                                            height: 15.sp,
                                                          ),
                                                          Text(
                                                            "Campus",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      )),
                                                
                                              ],
                                            )
                                          : Positioned(
                                              top: 0,
                                              right: 10.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  if (item.is_campus ==
                                                      1) //TODO:: Campus Hiring hilights for jobseeker.
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5.h),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2.h,
                                                                horizontal:
                                                                    4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Constants.blue,
                                                          border: Border.all(
                                                              color: Constants
                                                                  .blue),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.r),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8.r)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/campus.png",
                                                              height: 15.sp,
                                                            ),
                                                            Text(
                                                              "Campus",
                                                              style: GoogleFonts.roboto(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        )),
                                                  /* jobsController.isFavLoading(
                                                          item.id ?? 0)
                                                      ? const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          child:
                                                              SizedBox.square(
                                                            dimension: 10,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Constants
                                                                  .darkBlue,
                                                              strokeWidth: 1,
                                                            ),
                                                          ),
                                                        )
                                                      : */
                                                  Column(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () async {
                                                            if ((item.isFav ??
                                                                    0) ==
                                                                1) {
                                                              await jobsController
                                                                  .removeFromFav(
                                                                item.favJobId!
                                                                    .toInt(),
                                                                data,
                                                                item.id ?? 0,
                                                              );
                                                              setState(() {
                                                                jobsController
                                                                    .toggleLocationFilter(
                                                                        jobs: jobsController
                                                                            .jobs);
                                                              });
                                                            } else {
                                                              await jobsController
                                                                  .addToFav(
                                                                      item.id ??
                                                                          0,
                                                                      data);
                                                            }
                                                          },
                                                          icon: jobsController
                                                                  .isFavLoading(
                                                                      item.id ??
                                                                          0)
                                                              ? const CircularProgressIndicator(
                                                                  color: Constants
                                                                      .darkBlue,
                                                                  strokeWidth:
                                                                      0.5,
                                                                )
                                                              : (item.isFav) ==
                                                                          1 &&
                                                                      (item.userId ==
                                                                          data
                                                                              .id)
                                                                  ? Image
                                                                      .network(
                                                                      'https://assets.api.uizard.io/api/cdn/stream/f117beed-bf61-4a09-99cc-1663cb34976d.png',
                                                                      color: Constants
                                                                          .darkBlue,
                                                                      height:
                                                                          20,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      "https://assets.api.uizard.io/api/cdn/stream/12857f7d-d98f-4034-ad83-785107b51515.png",
                                                                      height:
                                                                          20,
                                                                    )
                                                          /*  onPressed:
                                                                    () async {
                                                                  if ((item.isFav ??
                                                                          0) ==
                                                                      1) {
                                                                    await jobsController.removeFromFav(
                                                                        item.favJobId!
                                                                            .toInt(),
                                                                        data);
                                                                    setState(
                                                                        () {
                                                                      jobsController.toggleLocationFilter(
                                                                          jobs:
                                                                              jobsController.jobs);
                                                                    });
                                                                  } else {
                                                                    await jobsController.addToFav(
                                                                        item.id ??
                                                                            0,
                                                                        data);
                                                                  }
                                                                }, */

                                                          /* Icon(
                                                                    /*   jobs[index]["id"].toString() ==
                                                                                      item[index]["id"].toString() */
                                                                    (item.isFav) ==
                                                                                1 &&
                                                                            (item.userId ==
                                                                                data
                                                                                    .id)
                                                                        ? Icons
                                                                            .bookmark
                                                                        : Icons
                                                                            .bookmark_add_outlined,
                                                                    size: 22.h,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400) */
                                                          ),
                                                      /*  InkWell(
                                                              onTap: () async {
                                                               
                                                                await FlutterShare
                                                                    .share(
                                                                        title:
                                                                            "Exciting Opportunities at ${item.companyName} for ${item.roleName}",
                                                                        text:
                                                                            "Exciting Opportunities at ${item.companyName} for ${item.roleName}\n\nSalary : ${formatSalaryRange(item.minCTC!.toInt(), item.maxCTC!.toInt())} ${item.isMonthly}\n\nExperience : ${item.isFresher == "Fresher" ? "Fresher Can Apply" : item.maxExperience == "& above" ? item.minExperience == "0.6" ? "6 Month & Above" : "${item.minExperience?.replaceAll(".0", "")} Years & above." : "${item.minExperience?.replaceAll(".0", "")} - ${item.maxExperience?.replaceAll(".0", "")} Years"}\n\nLocation : ${item.location ?? ''}\n\nSkills Required : ${updatedList.map((e) => e)}\n\nContact to Hr : 7507810000",
                                                                        linkUrl:
                                                                            'https://play.google.com/store/apps/details?id=com.job_circle_flutter',
                                                                        chooserTitle:
                                                                            'Example Chooser Title');
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                "assets/images/share.png",
                                                                height: 15.h,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            ), */
                                                    ],
                                                  ),
                                                ],
                                              ))
                                    ],
                                  ),
                                );
                              },

                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 5, right: 5),
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
         
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/maintenance.gif",
                height: 200.sp,
              ),
              Text("Application is under maintenance.",
                  style: GoogleFonts.varela(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 21, 176, 187))),
            ],
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(
            color: Constants.darkBlue,
          ),
        );
      },
    );
  }

  bool jobSeeker = false, freelancer = false;

  Widget CustomContainerForUserSelection(String title, bool isSelect) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: isSelect ? Constants.blue : Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      child: Text(title,
          style: GoogleFonts.varela(
              fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
              color: isSelect ? Colors.white : Colors.black)),
    );
  }

  void showOverlay(BuildContext context) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0.0,
        right: 0.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color(0xFF0db3ae),
          child: const Text(
            'OPEN',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after a delay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void captureAndShareImage() async {
    try {
      // Capture the screenshot
      final image = await screenshotController.capture();
      if (image == null) return;

      // Save the image to the gallery
      final time = DateTime.now()
          .toIso8601String()
          .replaceAll('.', '-')
          .replaceAll(':', '-');
      final name = "Screenshot_$time";
      final result = await ImageGallerySaver.saveImage(image, name: name);

      // Extract the file path from the result
      final savedPath = result['filePath'] as String?;

      if (savedPath != null && savedPath.isNotEmpty) {
        // Share the image using whatsapp_share2
        await WhatsappShare.shareFile(
          filePath: [savedPath], // List of file paths to share
          text: 'Great picture',
          phone: '8446062685', // Message to accompany the image
        );
        print('Image shared successfully to WhatsApp');
      } else {
        print("Failed to save image: $result");
      }
    } catch (e) {
      print("Error capturing and sharing image: $e");
    }
  }

  String formatLocality(String locality) {
    // Split the string by comma
    List<String> parts = locality.split(',');

    if (parts.length >= 2) {
      // Trim any leading or trailing spaces/tabs from both parts
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();

      // Combine the parts with a single space after the comma
      return '$part1, $part2';
    }

    // If there's no comma, return the original string
    return locality;
  }

  /* void captureAndShareImage() async {
    try {
      // Capture the screenshot
      final image = await screenshotController.capture();
      if (image == null) return;

      // Save the image to the gallery
      final time = DateTime.now()
          .toIso8601String()
          .replaceAll('.', '-')
          .replaceAll(':', '-');
      final name = "Screenshot_$time";
      final result = await ImageGallerySaver.saveImage(image, name: name);

      // Extract the file path from the result
      final savedPath = result['filePath'] as String?;

      if (savedPath != null && savedPath.isNotEmpty) {
        // Share the image using the saved path
        // await Share.shareXFiles([XFile(savedPath)], text: 'Great picture');
      } else {
        print("Failed to save image: $result");
      }
    } catch (e) {
      print("Error capturing and sharing image: $e");
    }
  } */

  /* Future<String> sveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "Screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result['filePath'];
  } */
}
