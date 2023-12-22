import 'dart:async';
import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/assets_images_url.dart';
import 'package:job_circle/models/new_job_model.dart';
import 'package:job_circle/screens/jobs/Applied_jobs.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/screens/jobs/job_form.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';
import 'package:job_circle/screens/new_jobs/add_cv_to_apply.dart';
import 'package:job_circle/screens/new_jobs/filter_jobs.dart';
import 'package:job_circle/screens/new_jobs/location_selector.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_banners/super_banners.dart';

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

    List<JobsModel> supprtStaffList = jobsController.jobs
        .where((job) => job.is_support_staff == 1)
        .where((element) => element.active == 1)
        .toList();

    // print(favoriteJobs);
    String colorName;
    Color color;
    return profileProfile.when(
      data: (data) {
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
                                    await Navigator.pushNamed(
                                        context, ERoute.profile_summary.name);

                                    closeDrawer(); // Call the function to close the drawer
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Constants.themeBgColor,
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
                                    await Navigator.pushNamed(
                                        context, ERoute.profile_summary.name);

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
                            "${data.firstName.toString()} ${data.lastName.toString()}",
                            style: GoogleFonts.varela(
                                fontSize: 16.sp,
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(data.userLocation.toString(),
                              style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  color: Constants.themeBgColor))
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
                  ListTile(
                    minLeadingWidth: 0.0,
                    minVerticalPadding: 5.1,
                    leading: Image.asset(
                      "assets/images/share.png",
                      height: 20.h,
                      color: Constants.themeBgColor,
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
                      color: Constants.themeBgColor,
                    ),
                    title: const Text('LogOut'),
                    onTap: () {
                      prefs.clear();

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
                      radius: 2.r,
                      child: data.profilePic != null
                          ? CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 190, 190, 190),
                              radius: 35,
                              onBackgroundImageError: ((error, stackTrace) =>
                                  Image.asset("assets/images/company.png",
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
                    if (data.usertype != 1)
                      const SizedBox(
                        width: 5,
                      ),
                    if (data.usertype != 1)
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
                          child: customTab("Support staff",
                              "assets/images/check.png", 5, data)),
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
                          borderSide:
                              const BorderSide(color: Constants.themeBgColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Constants.themeBgColor),
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
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: Constants.themeBgColor,
                          size: 15.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final selected = await showModalBottomSheet<String>(
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
                              color: Constants.themeBgColor,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                "assets/images/nodata.gif",
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
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ERoute.jobsdetail.name,
                                      arguments: {'id': item.id},
                                    );
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
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.w,
                                                    right: 5.w,
                                                    bottom: 5.h,
                                                    top: 5.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.varela(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16.sp),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5.w,
                                                                  ),
                                                                  if (item
                                                                      .languagesKnown!
                                                                      .isNotEmpty)
                                                                    Image
                                                                        .network(
                                                                      "https://cdn.discordapp.com/attachments/1095606068614283337/1177834889115074610/5665479-middle-removebg-preview.png?ex=6573f338&is=65617e38&hm=6b274668f0c3fdf32153d15150ee7679b7c29644241fd51c52c18afe745c7c35&",
                                                                      height:
                                                                          18.h,
                                                                    ),
                                                                  SizedBox(
                                                                    width: 5.w,
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
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14.sp),
                                                                    ),
                                                                  const SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  Text(
                                                                    "||",
                                                                    style: GoogleFonts
                                                                        .varela(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  // if (item["0"] != null)
                                                                  Text(
                                                                    item.natureOfWork
                                                                        .toString(),
                                                                    style: GoogleFonts.varela(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14.sp),
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
                                                          const EdgeInsets.only(
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 1),
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/cmpny.png",
                                                                  height: 12.h,
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
                                                                style: GoogleFonts
                                                                    .varela(
                                                                        // color: Colors.black54,
                                                                        color: Constants
                                                                            .subtitleclr,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            13.sp),
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
                                                                    Image.asset(
                                                                      "assets/images/bag.png",
                                                                      height:
                                                                          12.h,
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
                                                                              12.h,
                                                                          //  color: Constants.subtitleclr,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8.w,
                                                                        ),
                                                                        item.maxExperience ==
                                                                                "& above"
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
                                                                Image.network(
                                                                  ConstImageUrl
                                                                      .wallet,
                                                                  height: 14.h,
                                                                ),
                                                                SizedBox(
                                                                  width: 6.w,
                                                                ),
                                                                Text(
                                                                  formatSalaryRange(
                                                                      item.minCTC!
                                                                          .toInt(),
                                                                      item.maxCTC!
                                                                          .toInt()),
                                                                  style:
                                                                      GoogleFonts
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
                                                                      color: Constants
                                                                          .subtitleclr,
                                                                    ),
                                                                  )
                                                              ],
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
                                                                height: 14.sp,
                                                              ),
                                                              SizedBox(
                                                                width: 6.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  item.location ??
                                                                      '',
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      GoogleFonts
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
                                                          WrapAlignment.start,
                                                      spacing: 8.0,
                                                      children: [
                                                        ...updatedList
                                                            .take(5)
                                                            .map(
                                                              (skillItem) =>
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
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                                  style:
                                                                      GoogleFonts
                                                                          .varela(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        13.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        if (updatedList.length >
                                                            5)
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 5),
                                                            padding:
                                                                const EdgeInsets
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
                                                                      '"', '')
                                                                  .replaceAll(
                                                                      '[', '')
                                                                  .replaceAll(
                                                                      ']', ''),
                                                              style: GoogleFonts
                                                                  .varela(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13.sp,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.h),
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: double.maxFinite,
                                                      height: 0.5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            data.usertype ==
                                                                        3 &&
                                                                    data.id ==
                                                                        item.spoc
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => const MatchingJobs()));
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
                                                                                Constants.subtitleclr),
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
                                                                            style:
                                                                                TextStyle(
                                                                              color: Constants.subtitleclr,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15.h,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              data.usertype ==
                                                                  1,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              if (data.cvLink !=
                                                                  null) {
                                                                await JobPostApiService.postJobApply(
                                                                    jobId: item
                                                                        .id!
                                                                        .toInt(),
                                                                    userId: await Utils.getPreferencesValue(
                                                                        null,
                                                                        ESharedPreferences
                                                                            .user_id
                                                                            .name),
                                                                    context:
                                                                        context);
                                                                ref.refresh(
                                                                    fetchAllApplyProvider);
                                                                ref.refresh(
                                                                    fetchAllTalentPool);
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
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                              ),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4.h,
                                                                      horizontal:
                                                                          16.w),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Constants
                                                                          .themeBgColor),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child: Text(
                                                                "Apply",
                                                                style: GoogleFonts.varela(
                                                                    color: Constants
                                                                        .themeBgColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Visibility(
                                                          visible:
                                                              data.usertype ==
                                                                  3,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          AddResume(
                                                                            company_name:
                                                                                item.companyName.toString(),
                                                                            role:
                                                                                item.roleName.toString(),
                                                                            process:
                                                                                item.process.toString(),
                                                                            nature_of_work:
                                                                                item.natureOfWork.toString(),
                                                                            company_id:
                                                                                item.companyId!.toInt(),
                                                                            jobId:
                                                                                item.id!.toInt(),
                                                                            sourceId: data.id != null
                                                                                ? data.id!.toInt()
                                                                                : 0,
                                                                            sourceName:
                                                                                "${data.firstName.toString()} ${data.lastName.toString()}",
                                                                            isRefer:
                                                                                false,
                                                                            spocId:
                                                                                item.spoc!.toInt(),
                                                                            is90: item.payment_clause == "90 Days"
                                                                                ? true
                                                                                : false,
                                                                            is30: item.payment_clause == "30 Days"
                                                                                ? true
                                                                                : false,
                                                                            userNumber:
                                                                                data.mobile!.toInt(),
                                                                            useAlternateNumber:
                                                                                data.alternate_no!.toInt(),
                                                                          )));
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          10),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          4.h,
                                                                      horizontal:
                                                                          8.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Constants
                                                                        .themeBgColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    Icons.add,
                                                                    color: Constants
                                                                        .themeBgColor,
                                                                    size: 15.h,
                                                                  ),
                                                                  Text(
                                                                    "Resume",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Constants
                                                                          .themeBgColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15.h,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (item.payoutType !=
                                                            null)
                                                          Visibility(
                                                            visible:
                                                                data.usertype ==
                                                                    1,
                                                            child: InkWell(
                                                              onTap: () {
                                                                var profilemodel;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AddResume(
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
                                                                            )));
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  left: 10,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            4.h,
                                                                        horizontal:
                                                                            10.w),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                child: Text(
                                                                  "Refer Now",
                                                                  style: GoogleFonts.varela(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (item.is_campus == 1)
                                              Positioned(
                                                left: 10.w,
                                                child: CornerBanner(
                                                    elevation: 1,
                                                    bannerColor: Constants.blue,
                                                    child: Text(
                                                      "Campus",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )),
                                              ),

                                            /*  item.is_campus == 1  // TODO: left corner Ribbin indicator.... fro campus hiring..
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
                                              children: [
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
                                                        Constants.themeBgColor,
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
                                              right: 6.w,
                                              child: Column(
                                                children: [
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
                                                              color: Constants
                                                                  .themeBgColor)),
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
        return const Center(
          child: Text("Due to some technical issue data not loaded"),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
