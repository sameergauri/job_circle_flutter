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
import 'package:intl/intl.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/models/cooling.dart';
import 'package:job_circle/models/new_job_model.dart';
import 'package:job_circle/screens/Billing/banking_detal.dart';
import 'package:job_circle/screens/Billing/list_of_invoice.dart';
import 'package:job_circle/screens/Billing/view_and_generate_invoice.dart';
import 'package:job_circle/screens/contact_us.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/screens/jobs/job_details.dart';
import 'package:job_circle/screens/jobs/job_form.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';
import 'package:job_circle/screens/new_jobs/add_cv_to_apply.dart';
import 'package:job_circle/screens/new_jobs/filter_jobs.dart';
import 'package:job_circle/screens/new_jobs/location_selector.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/service/data_get_api_service.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../enums/enums.dart';
import '../../models/active_state_model.dart';
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

  Widget customTab(String title, String img, int select, ProfileModel model) {
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

  bool isTabFilterSelected(ProfileModel model) {
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

  void startSearchFieldAnimation() {
    /*  timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        currentSearchFieldIndex =
            (currentSearchFieldIndex + 1) % searchFields.length;
      });
    }); */
  }

  final FocusNode _dearchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final jobsController = ref.watch(jobsProvider);
    final profileProfile = ref.watch(profileSummaryProvider);
    var userid =
        Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
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
          if (data.is_freelancer == 2) {
            //TODO:: 1 = JobSeeker, 2 = Freelancer, 0 = Both. // login type for user.
            freelancer = true;
            jobSeeker = false;
            both = false;
          } else if (data.is_freelancer == 1) {
            jobSeeker = true;
            freelancer = false;
            both = false;
          }
        });
        if (jobsController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          drawer: ClipRRect(
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(15)),
            child: Drawer(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Container(
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
                          data.profilePic == null
                              ? InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pop();

                                    data.usertype != 3
                                        ? await Navigator.pushNamed(context,
                                            ERoute.profile_summary.name)
                                        : await Navigator.pushNamed(
                                            context,
                                            ERoute
                                                .profile_summary_partner.name);

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
                                        ? await Navigator.pushNamed(context,
                                            ERoute.profile_summary.name)
                                        : await Navigator.pushNamed(
                                            context,
                                            ERoute
                                                .profile_summary_partner.name);

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
                          Text(
                            "${data.firstName.toString().toTitleCase()} ${data.lastName.toString().toTitleCase()}",
                            style: GoogleFonts.varela(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(data.userLocation.toString(),
                              style: GoogleFonts.varela(
                                fontSize: 14.sp,
                                color: Colors.black,
                              )),
                          if (data.usertype == 1)
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
                                            both = false;
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
                                            both = false;
                                            freelancer = true;
                                          });
                                          ref.refresh(profileSummaryProvider);
                                        },
                                        child: CustomContainerForUserSelection(
                                            "Freelancer", freelancer),
                                      ),
                                      /*   GestureDetector(
                                        onTap: () async {
                                          await JobPostApiService
                                              .updateFreelancerActivity(
                                                  0, data.id!.toInt());
                                          setState(() {
                                            jobSeeker = false;
                                            both = true;
                                            freelancer = false;
                                          });
                                          ref.refresh(profileSummaryProvider);
                                        },
                                        child: CustomContainerForUserSelection(
                                            "Both", both),
                                      ) */
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  /* UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(left: 10.w),
                    decoration:
                        const BoxDecoration(color: Constants.themeBgColorLight),
                    accountName: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data.firstName.toString()} ${data.lastName.toString()}",
                          style: GoogleFonts.varela(
                              fontSize: 16.sp,
                              color: Constants.themeBgColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(data.userLocation.toString(),
                            style: GoogleFonts.varela(
                                fontSize: 14.sp, color: Constants.themeBgColor))
                      ],
                    ),
                    accountEmail: null,

                    //  currentAccountPictureSize: const Size.square(40),
                    currentAccountPicture: InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await Navigator.pushNamed(
                              context, ERoute.profile_summary.name);

                          closeDrawer(); // Call the function to close the drawer
                        },
                        child: data.profilePic == null
                            ? CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 190, 190, 190),
                                radius: 43,
                                onBackgroundImageError: ((error, stackTrace) =>
                                    Image.asset("assets/images/company.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain)),
                                backgroundImage: Image.asset(
                                        "assets/images/company.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain)
                                    .image)
                            : CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 190, 190, 190),
                                radius: 43,
                                onBackgroundImageError: ((error, stackTrace) =>
                                    Image.network(
                                        "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profilePic}",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain)),
                                backgroundImage: Image.network(
                                  "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profilePic}",
                                ).image,
                              )),
                  ), */
                  /*  ListTile(   //TODO: not in use for now.
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 5.1,
                    leading: Image.asset(
                      "assets/images/career.png",
                      height: 18.h,
                      color: Constants.themeBgColor,
                    ),
                    title: const Text('Career Assets'),
                    onTap: () {
                      Navigator.pop(context);
                      nav();
                    },
                  ), */

                  if (data.usertype == 1 && !jobSeeker)
                    ExpansionTile(
                      leading: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/1570/1570887.png",
                        height: 22.h,
                        color: Colors.black,
                      ),
                      title: const Text('Account'),
                      children: [
                        ListTile(
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.network(
                            "https://cdn-icons-png.flaticon.com/128/1159/1159679.png",
                            height: 22.h,
                            color: Colors.black,
                          ),
                          title: const Text('View & Generate Invoice'),
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
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.network(
                            "https://cdn-icons-png.flaticon.com/128/1019/1019709.png",
                            height: 22.h,
                            color: Colors.black,
                          ),
                          title: const Text('Payment Status'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListOfInvoice()));
                            /*  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentStatus())); */
                            closeDrawer();
                            // Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.network(
                            "https://cdn-icons-png.flaticon.com/128/2830/2830155.png",
                            height: 22.h,
                            color: Colors.black,
                          ),
                          title: const Text('My Banking Detail'),
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
                            // Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  if (data.usertype == 1 && jobSeeker)
                    ExpansionTile(
                      leading: Image.asset(
                        "assets/images/contactus.png",
                        height: 20.h,
                      ),
                      title: const Text('Report Fraud'),
                      children: [
                        ListTile(
                          minLeadingWidth: 0.0,
                          minVerticalPadding: 5.1,
                          leading: Image.asset(
                            "assets/images/email.png",
                            color: Colors.black,
                            height: 25.sp,
                          ),
                          title: const Text('rahul@jobcircle.co.in'),
                          onTap: () async {
                            await launchUrl(
                                Uri.parse("mailto:rahul@jobcircle.co.in?"));
                            closeDrawer();
                          },
                        ),
                      ],
                    ),
                  if (data.usertype == 1 && !jobSeeker)
                    ListTile(
                      minLeadingWidth: 0.0,
                      minVerticalPadding: 5.1,
                      leading: Image.asset(
                        "assets/images/contactus.png",
                        height: 20.h,
                      ),
                      title: const Text('Contact Us'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ContactUS()));
                        closeDrawer();
                        // Navigator.pop(context);
                      },
                    ),
                  ListTile(
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 5.1,
                    leading: Image.asset(
                      "assets/images/share.png",
                      height: 20.h,
                    ),
                    title: const Text('Share App'),
                    onTap: () {
                      share();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 5.1,
                    leading: Image.asset(
                      "assets/images/logout.png",
                      height: 22.h,
                      color: Colors.red,
                    ),
                    title: const Text('LogOut'),
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
                      child: data.profilePic != null
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
              )
              /* TabBar(
                labelPadding: const EdgeInsets.only(left: 5, right: 5),
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                // indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(8.r),
                //indicatorSize: TabBarIndicatorSize.label,
                // indicatorWeight: 5,
                indicatorPadding: EdgeInsets.only(
                    top: 10.h, bottom: 13.h, left: 5.w, right: 5.w),
                indicator: isTabFilterSelected(data)
                    ? BoxDecoration(
                        color: Constants.borderColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Constants.borderColor),
                      )
                    : BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.transparent),
                      ),

                onTap: (value) {
                  setState(() {
                    cutTab = value;

                    if (value == 1 && data.usertype == 1) {
                      jobsController.toggleFavoriteJobs(data);
                    }

                    if (value == 1 && data.usertype != 1) {
                      jobsController.toggleMyJobsFilter(data);
                    }

                    if (value == 2) {
                      jobsController.toggleFreshersFilter(data);
                    }
                  });
                },

                isScrollable: true,
                tabs: [
                  Tab(
                    child: InkWell(
                      onTap: () async {
                        FilterDialog filterDialog = FilterDialog(
                          (List<JobsModel> updatedfilteredJobsData) {},
                          storedSelectedOptions,
                          storedSelectedCategory,
                          storedSelectedColumn,
                          onFilterDialogClosed,
                        );
                        filterDialog.showFilterDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Constants.borderColor)),
                        height: 28.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Filter"),
                            SizedBox(
                              width: 5.w,
                            ),
                            const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (data.usertype != 1)
                    Tab(
                      child: customTab(
                          "My Jobs", "assets/images/check.png", 1, data),
                    ),
                  if (data.usertype == 1)
                    Tab(
                      child: customTab(
                          "Save Jobs", "assets/images/check.png", 1, data),
                    ),
                  Tab(
                    child: customTab(
                        "Fresher", "assets/images/check.png", 2, data),
                  ),
                ],
              ) */
              ,
            ),
            toolbarHeight: MediaQuery.of(context).size.width *
                0.11, //TODO : AppBar height and remove extra space above the appbar.
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
                        hintStyle: GoogleFonts.varela(
                          color: Colors.grey,
                          fontSize: 14.sp,
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
                      style: GoogleFonts.varela(color: Colors.black),
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
                              child: Text(
                                jobsController.selectedLocation.isNotEmpty
                                    ? jobsController.selectedLocation
                                    : 'City',
                                style: GoogleFonts.varela(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  // height: 12.0,
                                  // textBaseline: TextBaseline.alphabetic,
                                  // decoration: TextDecoration.underline,
                                ),
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
                              /*  Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "No job found.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.varela(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ) */
                            ],
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: selectedLocation != null &&
                      //       selectedLocation.isEmpty &&
                      //       data.jobs.isNotEmpty,
                      //   child: Center(
                      //     child: Column(
                      //       children: [
                      //         Image.asset(
                      //           "./assets/images/unboxing.gif",
                      //           height: 125.0.h,
                      //           width: 125.0.w,
                      //         ),
                      //         Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(
                      //                   horizontal: 20),
                      //           child: Text(
                      //             "Please choose the city where you are currently searching for job opportunities.",
                      //             textAlign: TextAlign.center,
                      //             style: GoogleFonts.varela(
                      //               fontSize: 15.sp,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      if (jobsController.filteredJobs.isNotEmpty)
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

                                //
                                //
                                //
                                //
                                //TODO:: Sorting jobs as per sponsored_position

                                /*   filteredJobs.sort((job1, job2) {
                                  // Sponsored jobs come first
                                  if (job1.sponsored_position == 1 &&
                                      job2.sponsored_position != 1) {
                                    return -1; // job1 comes first
                                  } else if (job1.sponsored_position != 1 &&
                                      job2.sponsored_position == 1) {
                                    return 1; // job2 comes first
                                  }

                                  // Sort by other criteria if sponsored position is the same or both are not sponsored
                                  // In this case, sort by job ID in ascending order (assuming job ID is unique)
                                  return (job2.id ?? 0).compareTo(job1.id ?? 0);
                                }); */

                                var item = filteredJobs[index];
                                /*  var item = jobsController
                                    .filteredJobs[index]; */

                                /* 
                                   */
                                if (item.skills != null) {
                                  myString = item.skills!;
                                  updatedList = myString
                                      .map((item) => item.trim())
                                      .toList();

                                  // do something with the parts array
                                } else {
                                  // handle the case where str is null
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    var usertype =
                                        await Utils.getPreferencesValue(prefs,
                                            ESharedPreferences.user_type.name);
                                    var userrole =
                                        await Utils.getPreferencesValue(prefs,
                                            ESharedPreferences.role.name);
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return JobDetails(
                                          id: item.id,
                                          Applies: false,
                                          referal: false,
                                          is_freelancer: data.usertype == 3
                                              ? 3
                                              : data.is_freelancer?.toInt() ??
                                                  0,
                                          userType: usertype,
                                          userrole: userrole,
                                        );
                                      },
                                    ));
                                    /*  Navigator.pushNamed(
                                      context,
                                      ERoute.jobsdetail.name,
                                      arguments: {'id': item.id},
                                    ); */
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
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
                                                          8.r)),

                                              /* shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(10.r),
                                              ), */

                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 1),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  item.sponsored_position != //TODO:: Urgent Hiring.
                                                          null
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5.h),
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
                                                              color: Colors
                                                                  .orange),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                size: 15.sp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              /*  Image.asset(
                                                                  "assets/images/top.png",
                                                                  height: 15.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ), */
                                                              Text(
                                                                "Urgent Hiring",
                                                                style: GoogleFonts.varela(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12.sp),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.w,
                                                        right: 5.w,
                                                        bottom: 5.h,
                                                        top: 5.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        item.roleName ??
                                                                            '',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.varela(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 16.sp),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.w,
                                                                      ),
                                                                      if (item
                                                                          .languagesKnown!
                                                                          .isNotEmpty)
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/languages.png",
                                                                          height:
                                                                              18.h,
                                                                        ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.w,
                                                                      ),
                                                                      /* if (item.is_campus ==  //TODO: for campus....
                                                                          1)
                                                                        Image.asset(
                                                                          "assets/images/campus.png",
                                                                          height:
                                                                              18.h,
                                                                        ), */
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (item.process !=
                                                                          null)
                                                                        Text(
                                                                          item.process
                                                                              .toString(),
                                                                          style: GoogleFonts.varela(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14.sp),
                                                                        ),
                                                                      const SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        "||",
                                                                        style: GoogleFonts
                                                                            .varela(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      // if (item["0"] != null)
                                                                      Text(
                                                                        item.natureOfWork
                                                                            .toString(),
                                                                        style: GoogleFonts.varela(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize: 14.sp),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 1),
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/cmpny.png",
                                                                      height:
                                                                          12.5.h,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8.w,
                                                                  ),
                                                                  Text(
                                                                    item.companyName
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.varela(
                                                                        // color: Colors.black54,
                                                                        color: Constants.subtitleclr,
                                                                        fontWeight: FontWeight.normal,
                                                                        fontSize: 13.sp),
                                                                  ),
                                                                ],
                                                              ),
                                                              item.isFresher ==
                                                                      "Fresher"
                                                                  ? Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/bag.png",
                                                                          height:
                                                                              12.5.h,
                                                                          //  color: Constants.subtitleclr,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8.w,
                                                                        ),
                                                                        Text(
                                                                          "Fresher can apply.",
                                                                          style: GoogleFonts.varela(
                                                                              // color: Colors.black54,
                                                                              color: Constants.subtitleclr,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 13.sp),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : (item.totalExperience !=
                                                                          null)
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset(
                                                                              "assets/images/bag.png",
                                                                              height: 12.5.h,
                                                                              //  color: Constants.subtitleclr,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 8.w,
                                                                            ),
                                                                            item.maxExperience == "& above"
                                                                                ? item.minExperience == "0.6"
                                                                                    ? Text(
                                                                                        // "${item.minexperience.replaceAll(".0", "")} Years & above.",
                                                                                        "6 Month & Above.",
                                                                                        style: GoogleFonts.varela(
                                                                                            // color: Colors.black54,
                                                                                            color: Constants.subtitleclr,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontSize: 13.sp),
                                                                                      )
                                                                                    : Text(
                                                                                        "${item.minExperience?.replaceAll(".0", "")} Years & above.",
                                                                                        style: GoogleFonts.varela(
                                                                                            // color: Colors.black54,
                                                                                            color: Constants.subtitleclr,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontSize: 13.sp),
                                                                                      )
                                                                                : Text(
                                                                                    "${item.minExperience?.replaceAll(".0", "")} - ${item.maxExperience?.replaceAll(".0", "")} Years",
                                                                                    style: GoogleFonts.varela(
                                                                                        // color: Colors.black54,
                                                                                        color: Constants.subtitleclr,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontSize: 13.sp),
                                                                                  )
                                                                          ],
                                                                        )
                                                                      : const SizedBox(),
                                                              if (item.minCTC !=
                                                                  null)
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/wallet.png",
                                                                      height:
                                                                          12.5.h,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          6.w,
                                                                    ),
                                                                    Text(
                                                                      formatSalaryRange(
                                                                          item.minCTC!
                                                                              .toInt(),
                                                                          item.maxCTC!
                                                                              .toInt()),
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        fontSize:
                                                                            13.sp,
                                                                        color: Constants
                                                                            .subtitleclr,
                                                                      ),
                                                                    ),
                                                                    if (item.isMonthly !=
                                                                        "")
                                                                      Text(
                                                                        " ${item.isMonthly}",
                                                                        style: GoogleFonts
                                                                            .varela(
                                                                          fontSize:
                                                                              13.sp,
                                                                          color:
                                                                              Constants.subtitleclr,
                                                                        ),
                                                                      )
                                                                  ],
                                                                ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/loc.png",
                                                                    height:
                                                                        12.5.sp,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 6.w,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      item.location ??
                                                                          '',
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        fontSize:
                                                                            13.sp,
                                                                        color: Constants
                                                                            .subtitleclr,
                                                                      ),
                                                                    ),
                                                                  )

                                                                  /* Text(
                                                                    item.location ??
                                                                        '',
                                                                    maxLines:
                                                                        2,
                                                                    overflow:
                                                                        TextOverflow.ellipsis,
                                                                    style: GoogleFonts
                                                                        .varela(
                                                                      fontSize:
                                                                          18.sp,
                                                                      color:
                                                                          Constants.subtitleclr,
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                  ), */
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3.h,
                                                        ),
                                                        Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          spacing: 8.0,
                                                          children: [
                                                            ...updatedList
                                                                .take(5)
                                                                .map(
                                                                  (skillItem) =>
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            4,
                                                                        horizontal:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child: Text(
                                                                      "#$skillItem"
                                                                          .replaceAll(
                                                                              '"',
                                                                              '')
                                                                          .replaceAll(
                                                                              '[',
                                                                              '')
                                                                          .replaceAll(
                                                                              ']',
                                                                              ''),
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            13.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            if (updatedList
                                                                    .length >
                                                                5)
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Constants
                                                                      .borderColor,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Text(
                                                                  '+${updatedList.length - 5}'
                                                                      .replaceAll(
                                                                          '"',
                                                                          '')
                                                                      .replaceAll(
                                                                          '[',
                                                                          '')
                                                                      .replaceAll(
                                                                          ']',
                                                                          ''),
                                                                  style:
                                                                      GoogleFonts
                                                                          .varela(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        13.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      5.h),
                                                          color: Colors
                                                              .grey.shade400,
                                                          width:
                                                              double.maxFinite,
                                                          height: 0.5.h,
                                                        ),
                                                        Column(
                                                          children: [
                                                            if (data.usertype ==
                                                                3)
                                                              Row(
                                                                children: [
                                                                  data.usertype ==
                                                                              3 &&
                                                                          data.id ==
                                                                              item.spoc
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => const MatchingJobs()));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                const EdgeInsets.only(right: 10),
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Constants.subtitleclr),
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.min,
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
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => AddResume(
                                                                                      report_to: data.reportTo!.toInt(),
                                                                                      interviewRounds: item.interviewrounds!.first.replaceAll('[', '').replaceAll(']', '').replaceAll('"', ''),
                                                                                      company_name: item.companyName.toString(),
                                                                                      role: item.roleName.toString(),
                                                                                      process: item.process.toString(),
                                                                                      nature_of_work: item.natureOfWork.toString(),
                                                                                      company_id: item.companyId!.toInt(),
                                                                                      jobId: item.id!.toInt(),
                                                                                      sourceId: data.id != null ? data.id!.toInt() : 0,
                                                                                      sourceName: "${data.firstName.toString()} ${data.lastName.toString()}",
                                                                                      isRefer: false,
                                                                                      spocId: item.spoc!.toInt(),
                                                                                      is90: item.payment_clause == "90 Days" ? true : false,
                                                                                      is30: item.payment_clause == "30 Days" ? true : false,
                                                                                      userNumber: data.mobile!.toInt(),
                                                                                      useAlternateNumber: data.alternate_no!.toInt(),
                                                                                    )));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                10),
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                4.h,
                                                                            horizontal: 8.w),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(color: Constants.blue),
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
                                                                              color: Constants.blue,
                                                                              size: 15.h,
                                                                            ),
                                                                            Text(
                                                                              "Resume",
                                                                              style: TextStyle(
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
                                                            Row(
                                                              children: [
                                                                if (data.usertype ==
                                                                        1 &&
                                                                    (data.is_freelancer ==
                                                                            null ||
                                                                        data.is_freelancer ==
                                                                            1))
                                                                  const Spacer(),
                                                                Visibility(
                                                                  visible: data
                                                                              .usertype ==
                                                                          1 &&
                                                                      (data.is_freelancer == 0 ||
                                                                          data.is_freelancer ==
                                                                              1 ||
                                                                          data.is_freelancer ==
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

                                                                            /*  showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return CustomDialog(
                                                                                fetchDataFromApi:
                                                                                    () {},
                                                                                onClose: () {
                                                                                  Navigator.pop(
                                                                                      context);
                                                                                  /*  Navigator.pushAndRemoveUntil(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => HomeScreen(),
                                                                                      ),
                                                                                      (route) => false); */
                                                                                },
                                                                                isFisrt:
                                                                                    false,
                                                                                title:
                                                                                    "Error",
                                                                                subtitle:
                                                                                    "Resume is not uploaded in your profile");
                                                                          },
                                                                        ); */
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

                                                                          /*  showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return CustomDialog(
                                                                                fetchDataFromApi:
                                                                                    () {},
                                                                                onClose: () {
                                                                                  Navigator.pop(
                                                                                      context);
                                                                                  /*  Navigator.pushAndRemoveUntil(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => HomeScreen(),
                                                                                      ),
                                                                                      (route) => false); */
                                                                                },
                                                                                isFisrt:
                                                                                    false,
                                                                                title:
                                                                                    "Error",
                                                                                subtitle:
                                                                                    "Resume is not uploaded in your profile");
                                                                          },
                                                                        ); */
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
                                                                    (data.is_freelancer !=
                                                                                null &&
                                                                            data.is_freelancer ==
                                                                                2 ||
                                                                        data.is_freelancer ==
                                                                            0))
                                                                  const Spacer(),
                                                                /* if (item.payoutType !=   //TODO:: commented because i wanna display refer now button for all hiring if the hiring dont have payout..
                                                                    null) */
                                                                Visibility(
                                                                  visible: data
                                                                              .usertype ==
                                                                          1 &&
                                                                      (data.is_freelancer == 2 ||
                                                                          data.is_freelancer ==
                                                                              0 ||
                                                                          data.is_freelancer ==
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
                                                                                    useAlternateNumber: data.alternate_no?.toInt() ?? 0,
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
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /*  item.is_campus == 1  // TODO: left corner Ribbin indicator.... for campus hiring..
                                                ? Positioned(
                                                    top: 0,
                                                    left: 10,
                                                    child: Banner(
                                                        color:
                                                            const Color.fromARGB(
                                                                255, 68, 6, 1),
                                                        message: "Campus",
                                                        textStyle:
                                                            GoogleFonts.varela(),
                                                        location: BannerLocation
                                                            .topStart),
                                                  )
                                                : const SizedBox() */
                                          ],
                                        ),
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
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 15.w),
                                                  child: CircularMenu(
                                                    toggleButtonOnPressed: () {
                                                      setState(() {
                                                        isMenuOpen =
                                                            !isMenuOpen; // Toggle the menu open/close state
                                                      });
                                                    },
                                                    radius: 35.r,
                                                    alignment:
                                                        Alignment.topRight,
                                                    backgroundWidget: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(100.0),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                style: GoogleFonts.varela(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                children: const <TextSpan>[
                                                                  //  TextSpan(text: 'Press the menu button'),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    toggleButtonSize: isMenuOpen
                                                        ? 24.h
                                                        : 18.h,
                                                    toggleButtonMargin: 10,
                                                    toggleButtonPadding: 0,
                                                    startingAngleInRadian:
                                                        0.4 * pi,
                                                    endingAngleInRadian: 3.4,
                                                    curve: Curves.bounceInOut,
                                                    reverseCurve:
                                                        Curves.bounceInOut,
                                                    toggleButtonIconColor:
                                                        Constants.subtitleclr,
                                                    toggleButtonColor:
                                                        Colors.transparent,
                                                    items: [
                                                      CircularMenuItem(
                                                          icon: Icons
                                                              .delete_outlined,
                                                          color: Colors
                                                              .transparent,
                                                          iconColor: Colors.red,
                                                          iconSize: 18.h,
                                                          onTap: () {
                                                            setState(() {
                                                              color =
                                                                  Colors.red;
                                                              colorName = 'red';
                                                            });
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Inavtive'),
                                                                  content:
                                                                      const Text(
                                                                          'Clicking on the OK button will inctivate the job'),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: const Text(
                                                                          'OK'),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                        // Perform any action here
                                                                        // Navigator.of(context).pop();
                                                                        Autogenerated model = Autogenerated(
                                                                            active:
                                                                                0
                                                                            /*  active: 0,
                                id: jobDetailsModel.id,
                                companyId: jobDetailsModel.compnayid,
                                roleName:jobDetailsModel.rolename,
                                natureOfWork:
                                   jobDetailsModel.naturofwork,
                                process:jobDetailsModel.process,
                                noOfVacancy: jobDetailsModel.no_of_vacancy,
                                ageGroup: jobDetailsModel.age_group,
                                boundry_limits: jobDetailsModel.boundarylimits,
                                education: jobDetailsModel.education,
                                eligible: jobDetailsModel.eligible,
                                gender: jobDetailsModel.gender,
                                skills: jobDetailsModel.skills,
                              keyResponsible: jobDetailsModel.key_responsible,
                              minExperience: jobDetailsModel.minexperience.toString(),
                              maxExperience: jobDetailsModel.maxexperience.toString(),
                              minCtc: jobDetailsModel.minctc!.toInt(),
                              maxCtc: jobDetailsModel.maxctc!.toInt(),
                             // minAge:jobDetailsModel.minAge,
                             // maxAge: jobDetailsModel.maxAge,
                             isFresher: jobDetailsModel.isfresher,
                             isMonthly: jobDetailsModel.ismonthly,
                             empType: jobDetailsModel.emptype,
                             shiftDesc: jobDetailsModel.shiftdesc,
                             shiftTime: jobDetailsModel.shifttime,
                             interviewRounds: jobDetailsModel.inteviewrounds,
                             jobBenefits: jobDetailsModel.job_benifits,
                            languageKnown: jobDetailsModel.languageknown, */

                                                                            );
                                                                        Map<String,
                                                                                dynamic>
                                                                            jsonData =
                                                                            model.toJson();
                                                                        await JobPostApiService.jobInActive(
                                                                            jsonData,
                                                                            item.id!.toInt());
                                                                        ref.refresh(
                                                                            jobsProvider);
                                                                        // ref.refresh(profileSummaryProvider);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }),
                                                      /*  CircularMenuItem(
                                                          icon: Icons
                                                              .bookmark_add_outlined,
                                                          color: Colors
                                                              .transparent,
                                                          iconColor:
                                                              Colors
                                                                  .brown,
                                                          iconSize: 18.h,
                                                          onTap: () {
                                                            setState(() {
                                                              _color = Colors
                                                                  .brown;
                                                              _colorName =
                                                                  'Brown';
                                                            });
                                                          }), */
                                                      /*  CircularMenuItem(
                                                          icon:
                                                              Icons.share,
                                                          color: Colors
                                                              .transparent,
                                                          iconColor:
                                                              Colors
                                                                  .green,
                                                          iconSize: 18.h,
                                                          onTap:
                                                              () async {
                                                            setState(() {
                                                              _color = Colors
                                                                  .green;
                                                              _colorName =
                                                                  'Green';
                                                            });
                                                            const url =
                                                                "https://wa.me/?text=Hey buddy, try this super cool new app!";
                                                            if (await canLaunch(
                                                                url)) {
                                                              await launch(
                                                                  url);
                                                            } else {
                                                              throw 'Could not launch $url';
                                                            }
                                                          }), */
                                                      CircularMenuItem(
                                                          icon: Icons.edit,
                                                          color: Colors
                                                              .transparent,
                                                          iconColor: Colors.red,
                                                          iconSize: 18.h,
                                                          onTap: () {
                                                            setState(() {
                                                              /* _color =
                                                                  Colors
                                                                      .red;
                                                              _colorName =
                                                                  'red'; */
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          JobForm(
                                                                            formEdit:
                                                                                true,
                                                                            companyName:
                                                                                item.companyName.toString(),
                                                                            companyId:
                                                                                item.companyId.toString(),
                                                                            jobTitle:
                                                                                item.roleName.toString(),
                                                                            natureOfWork:
                                                                                item.natureOfWork.toString(),
                                                                            process:
                                                                                item.process.toString(),
                                                                          )));
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                ),
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
                                                  jobsController.isFavLoading
                                                      ? const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          child:
                                                              SizedBox.square(
                                                            dimension: 10,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 1,
                                                            ),
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () async {
                                                            if ((item.isFav ??
                                                                    0) ==
                                                                1) {
                                                              await jobsController
                                                                  .removeFromFav(
                                                                      item.favJobId!
                                                                          .toInt(),
                                                                      data);
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
                                                          icon: Icon(
                                                              /*   jobs[index]["id"].toString() ==
                            item[index]["id"].toString() */
                                                              (item.isFav) == 1 &&
                                                                      (item.userId ==
                                                                          data
                                                                              .id)
                                                                  ? Icons
                                                                      .bookmark
                                                                  : Icons
                                                                      .bookmark_add_outlined,
                                                              size: 22.h,
                                                              color: Colors.grey
                                                                  .shade400)),
                                                ],
                                              ))
                                    ],
                                  ),
                                );
                              },
                              /* itemCount: _searchController
                                      .text.isEmpty
                                  ? (selectedLocation != null &&
                                          selectedLocation.isNotEmpty
                                      ? filteredData.isNotEmpty
                                          ? filteredData.length
                                          : data.jobs.length
                                      : data.jobs.length)
                                  : searchResults.length, */

                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 5, right: 5),
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                        ),
                      /*       if (_isLoadMoreRunning == true)
                          const Padding(
                            padding: EdgeInsets.only(
                                //  top: 10,
                                bottom: 40),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ), */
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: data.usertype == 3
              ? Visibility(
                  visible:
                      jobsController.role != "1" && jobsController.role != "2",
                  child: FloatingActionButton(
                    backgroundColor: Constants.themeBgColor,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const JobForm(formEdit: false),
                          ));
                    },
                  ))
              : const SizedBox(),
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
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  bool jobSeeker = false, freelancer = false, both = false;

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
}
