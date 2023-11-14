import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/constants/assets_images_url.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/active_state_model.dart';
import 'package:job_circle/models/new_job_model.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/screens/jobs/career_assets.dart';
import 'package:job_circle/screens/jobs/job_form.dart';
import 'package:job_circle/screens/jobs/matching_jobs.dart';
import 'package:job_circle/screens/new_jobs/filter_jobs.dart';
import 'package:job_circle/screens/new_jobs/location_selector.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsDataModelForJobs {
  final List<JobsModel> jobs;
  final ProfileModel profile;

  JobsDataModelForJobs({
    required this.jobs,
    required this.profile,
  });
}

final JobsProvider = FutureProvider<List<JobsModel>>((ref) async {
  final jobResponse = await _NewJobsState.bindAllJobs();
  if (jobResponse != null) {
    return (jobResponse).map((item) => JobsModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load experience data');
  }
});

final userJobDataProvider = FutureProvider<JobsDataModelForJobs>((ref) async {
  final profileSummary = await _NewJobsState
      .bindProfileSummary(); //ref.watch(profileSummaryProvider);
  final profileSummaryData = ProfileModel.fromJson(profileSummary);
  final jobs = await _NewJobsState.bindAllJobs();
  final jobsData = (jobs).map((item) => JobsModel.fromJson(item)).toList();
  return JobsDataModelForJobs(jobs: jobsData, profile: profileSummaryData);
});

/* final jobsProvider = FutureProvider<List<JobsModel>>((ref) async {
  final jobsRes = await _NewJobsState.bindJobs();
  if (jobsRes != null) {
    return (jobsRes).map((item) => JobsModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load education data');
  }
});

final jobsDataProvider = FutureProvider<JobsDataModel>((ref) async {
  final job = await _NewJobsState.bindJobs();
  final jobsData = (job).map((item) => JobsModel.fromJson(item)).toList();
  final profile = await _NewJobsState.bindProfileSummary();
  final profileData =
      (profile).map((item) => ProfileModel.fromJson(item));

  return JobsDataModel(
    jobs: jobsData,
    profile: profileData,
  );
}); */

class NewJobs extends ConsumerStatefulWidget {
  const NewJobs({super.key});

  @override
  ConsumerState<NewJobs> createState() => _NewJobsState();
}

class _NewJobsState extends ConsumerState<NewJobs>
    with SingleTickerProviderStateMixin {
  ProfileModel profileModel = ProfileModel();

  List<JobsModel> allJobs = [];
  late JobsModel jobsModel;
  List<JobsModel> filteredJobsData = [];
  List<JobsModel> filteredData = [];
  List<JobsModel> searchResults = [];

  late int selectedJobTypeIndex = 0;
  List<String> citiesList = [];
  late ScrollController _controllerListView;
  Map<String, String> fresher = {};
  var searchText = "";
  var sortByd = "Recomended";
  var localtion = "";
  var licationid = 0;
  late var usertype = -1;
  var role = "0";
  String bannerUrl = "";
  bool isbannerVisible = false;
  int currentTabIndex = 0; // Initialize with the index of the default tab
  int? cutTab;
  bool isSelect = false;
  bool isMyJobs = false;
  bool isSelected = false;
  bool saved = false;
  int favId = 1;
  int favjobId = 0;
  final _hasNextPage = true;
  final _isLoadMoreRunning = false;
  List<String>? myStrings;
  List<String> updatedList = [];
  bool stopIteration = false;
  bool isMenuOpen = false;
  bool isFilterApplied = false;
  bool isFilter = false;

  List<String> storedSelectedOptions = [];
  String storedSelectedCategory = '';
  List<String> storedSelectedColumn = [];

  List<String> locationList = [];

  late Function(Map<String, String>) onDone;

  String selectedLocation = "";
  String selectedLoc = '';

  late final TabController _tabController =
      TabController(length: 3, vsync: this);
  final TextEditingController _searchController = TextEditingController();
  TextEditingController loc = TextEditingController();

  final List<String> searchFields = [
    'Company',
    'Process',
    'Designation',
    'Functional Area',
    'Skills',
  ];

  int currentSearchFieldIndex = 0;
  late Timer timer;

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

  final int _tabIndex = 0;
  final _controller = PageController(
    initialPage: 0,
  );

  void startSearchFieldAnimation() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        currentSearchFieldIndex =
            (currentSearchFieldIndex + 1) % searchFields.length;
      });
    });
  }

  void onFilterDialogClosed(List<String> selectedOptions,
      String selectedCategory, List<String> selectedColumn) {
    setState(() {
      storedSelectedOptions = selectedOptions;
      storedSelectedCategory = selectedCategory;
      storedSelectedColumn = selectedColumn;
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  BottomSheetController bottomSheetDialogController = BottomSheetController();

  final int _currentPage = 1;
  static const int _pageSize = 3000;

  Future<void> _loadSelectedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLocation = prefs.getString('selectedLocation') ?? '';
    });
  }

  static Future<List<dynamic>> bindAllJobs() async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/jobs/v1/all?pageNumber=1&pageSize=$_pageSize'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);

      return parsedResponse['resultData']['content'];
    } else {
      throw Exception('Failed to load data');
    }
  }
  /* Future<void> _fetchAllJobs() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host_one}/jobs/v1/all?pageNumber=$_currentPage&pageSize=$_pageSize';
      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        List<JobsModel> jobs =
            contentList.map((json) => JobsModel.fromJson(json)).toList();

        // List<JobsModel> filteredjobs = [];

        _currentPage++;
        setState(() {
          allJobs = jobs;
        });
      }
    } catch (e) {
      print('Error loading more data: $e');
    }
  } */

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _loadSelectedLocation();
      setState(() {});
    });
    // _fetchAllJobs();

    /*  _fetchAllJobs().then((_) {
      filteredJobsData = allJobs;

      filteredData = filteredJobsData;
      _searchController.addListener(_onSearchChanged);
      _loadSelectedLocation();
      setState(() {});
    }); */

    startSearchFieldAnimation();

    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  void bindInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);
    role = await Utils.getPreferencesValue(null, ESharedPreferences.role.name);

    var userRaw = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_rawData.name);
    setState(() {});
  }

  void initData() async {}

  @override
  void dispose() {
    _searchController.dispose();
    // _animationController?.dispose();
    super.dispose();
  }

  static Future<Map<String, dynamic>> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/profileSummary/$id'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData")) {
        return parsedResponse["resultData"] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addToFav(int jobId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://${GlobalConstants.API_Host_one}/favjob/v1/$userId/$jobId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
      } else {
        print('Error during post request: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromFav(
    int favJobId,
  ) async {
    final response = await http.delete(
      Uri.parse("http://${GlobalConstants.API_Host_one}/favjob/v1/$favJobId"),
      headers: <String, String>{},
    );

    if (response.statusCode == 200) {
      print('Post request successful');
      // searchAgain();
    } else {
      print('Error during post request: ${response.statusCode}');
    }
  }

  List jobs = [];
  Future<void> fetchJobs() async {
    Uri url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/favjob/v1/all?pageNumber=1&pageSize=100');
    final response = await http.get(url); // replace with your API endpoint
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      var list = data as List;
      setState(() {
        jobs.addAll(list);
        // print(jobs);
      });
    } else {
      print("Somthing Wrong");
      // handle error
    }
  }

  void closeDrawer() {
    Scaffold.of(context).closeDrawer();
  }

  nav() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CareerAssets()));
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Job circle App',
        text: 'Install jobcircle app',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.job_circle',
        chooserTitle: 'Example Chooser Title');
  }

  // List<JobsModel> searchResults = [];

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    List<String> searchTerms = query.split(',');

    setState(() {
      // Filter the profileSummaries based on the search query
      filteredData = filteredData.where((job) {
        final skillsAsString = job.skills?.join(", ") ?? "";
        final jobInfo = [
          job.companyName!.toLowerCase(),
          job.process!.toLowerCase(),
          job.roleName!.toLowerCase(),
          job.natureOfWork!.toLowerCase(),
          skillsAsString.toLowerCase(),
        ];

        // Check if any of the search terms match any job information
        return searchTerms.any((term) {
          return jobInfo.any((info) => info.contains(term));
        });
      }).toList();

      // Update the searchResults list with filteredJobsData
      isFilterApplied = true;
      searchResults = filteredData.toList();
    });
  }

  void _onSearchTextChanged(String text, List<JobsModel> filter) {
    setState(() {
      // Check if _searchController.text is empty
      if (_searchController.text.isEmpty) {
        refreshData(filteredData);
      }
    });
  }

  void _applyLocationFilter(String selectedLocation, allJobs) {
    setState(() {
      filteredData = allJobs
          .where((job) => selectedLocation.contains(job.city ?? ''))
          .toList();
      isFilterApplied = true;

      // Update spocList here
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 200));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    if (!_hasNextPage) {
      _refreshController.loadNoData();
    } else {
      _loadMore();
      if (mounted) setState(() {});
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false) {
      filteredData = filteredJobsData;
    }
  }

  void refreshData(List<JobsModel> filter) {
    setState(() {
      filteredData = filter;
    });
  }

  void _applyFreshFilter(List<JobsModel> freshFilte) {
    setState(() {
      filteredData =
          freshFilte.where((job) => job.isFresher == "Fresher").toList();
    });
    isFilterApplied = true;
  }

  void _applyFavFilter(List<JobsModel> freshFilte, ProfileModel profileModel) {
    setState(() {
      filteredData = freshFilte
          .where((job) =>
              contains(job.isFav, 1) && contains(job.userId, profileModel.id))
          .toList();
    });
    isFilterApplied = true;
  }

  void _applySpocFilter(List<JobsModel> freshFilte, ProfileModel profileModel) {
    setState(() {
      filteredData = freshFilte
          .where((job) => contains(job.spoc, profileModel.id))
          .toList();
    });
  }

  void _applySpocReportToFilter(
      List<JobsModel> freshFilte, ProfileModel profileModel) {
    setState(() {
      filteredData = freshFilte
          .where((job) => contains(job.spoc, profileModel.reportTo))
          .toList();
    });
    isFilterApplied = true;
  }

  bool contains(dynamic? value, dynamic searchTerm) {
    if (value is int && searchTerm is int) {
      return value == searchTerm;
    } else if (value is String && searchTerm is String) {
      return value.toLowerCase().contains(searchTerm.toLowerCase());
    }

    return false;
  }

  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    String _colorName;
    Color _color;
    var combinedData = ref.watch(userJobDataProvider);

    return combinedData.when(
      data: (jobData) {
        setState(() {
          allJobs = jobData.jobs.map((e) => e).toList();
          if (selectedLocation.isNotEmpty) {
            filteredData = List.from(allJobs);
          }
        });
        return Scaffold(
            drawer: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(15)),
              child: Drawer(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    UserAccountsDrawerHeader(
                      margin: EdgeInsets.only(left: 10.w),
                      decoration: const BoxDecoration(
                          color: Constants.themeBgColorLight),
                      accountName: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${jobData.profile.firstName.toString()} ${jobData.profile.lastName.toString()}",
                            style: GoogleFonts.varela(
                                fontSize: 16.sp,
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(jobData.profile.userLocation.toString(),
                              style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  color: Constants.themeBgColor))
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
                          child: jobData.profile.profilePic == null
                              ? CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 190, 190, 190),
                                  radius: 43,
                                  onBackgroundImageError:
                                      ((error, stackTrace) => Image.asset(
                                          "assets/images/company.png",
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
                                  onBackgroundImageError:
                                      ((error, stackTrace) => Image.network(
                                          "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobData.profile.profilePic}",
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.contain)),
                                  backgroundImage: Image.network(
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobData.profile.profilePic}",
                                  ).image,
                                )),
                    ),
                    ListTile(
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
                    ),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            floatingActionButton: jobData.profile.usertype == 3
                ? Visibility(
                    visible: role != "1" && role != "2",
                    child: FloatingActionButton(
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
            appBar: AppBar(
              leading: Builder(
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    left: 22.w,
                  ),
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: CircleAvatar(
                      radius: 2.r,
                      child: jobData.profile.profilePic != null
                          ? CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 190, 190, 190),
                              radius: 43,
                              onBackgroundImageError: ((error, stackTrace) =>
                                  Image.asset("assets/images/company.png",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.contain)),
                              backgroundImage: Image.network(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${jobData.profile.profilePic}",
                              ).image,
                            )
                          : Icon(
                              Icons.person,
                              size: 14.h,
                            ),
                    ),
                  ),
                ),
              ),
              iconTheme: const IconThemeData(color: Constants.themeBgColor),
              bottom: PreferredSize(
                preferredSize: Size(0, 25.h),
                child: TabBar(
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
                  indicator: isSelect
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
                      isSelect = !isSelect;
                      if (value == 1 && jobData.profile.usertype == 1) {
                        isSelect
                            ? _applyFavFilter(jobData.jobs, jobData.profile)
                            : filteredData = jobData.jobs;
                      }

                      if (value == 1 && jobData.profile.usertype != 1) {
                        // sortByd = "New Jobs";
                        isSelect
                            ? role == "1" || role == "2"
                                ? _applySpocReportToFilter(
                                    jobData.jobs, jobData.profile)
                                : _applySpocFilter(
                                    jobData.jobs, jobData.profile)
                            : filteredData = jobData.jobs;
                      }

                      if (value == 2 && jobData.profile.usertype == 1) {
                        isSelect
                            ? filteredData = jobData.jobs
                                .where((job) => job.isFresher == "Fresher")
                                .toList()
                            : filteredData = jobData.jobs;
                      }
                    });
                  },

                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: InkWell(
                        onTap: () async {
                          FilterDialog filterDialog = FilterDialog(
                              onFilterApplied:
                                  (List<JobsModel> updatedfilteredJobsData) {
                                setState(() {
                                  filteredData = updatedfilteredJobsData;
                                });
                              },
                              storedSelectedOptions: storedSelectedOptions,
                              storedSelectedCategory: storedSelectedCategory,
                              storedSelectedColumn: storedSelectedColumn,
                              onDialogClosed: onFilterDialogClosed,
                              profileModel: profileModel);
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
                    if (jobData.profile.usertype != 1)
                      Tab(
                        child:
                            customTab("My Jobs", "assets/images/check.png", 1),
                      ),
                    if (jobData.profile.usertype == 1)
                      Tab(
                        child: customTab(
                            "Save Jobs", "assets/images/check.png", 1),
                      ),
                    if (jobData.profile.usertype == 1)
                      Tab(
                        child:
                            customTab("Fresher", "assets/images/check.png", 2),
                      ),
                  ],
                ),
              ),
              toolbarHeight: MediaQuery.of(context).size.width * 0.17,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      //margin: const EdgeInsets.symmetric(vertical: 10),
                      //height: 30.h,
                      height: MediaQuery.of(context).size.height / 26.h,
                      width: MediaQuery.of(context).size.width / 1.65.w,
                      child: TextField(
                        onChanged: (value) {
                          _onSearchTextChanged(
                              _searchController.text, filteredData);
                        },
                        controller: _searchController,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 5.0, bottom: 5, top: 5),
                          fillColor: Constants.bgColorWhite,
                          hintText:
                              'Search Jobs by ${searchFields[currentSearchFieldIndex]}',
                          hintMaxLines: 2,
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
                  SizedBox(
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
                              builder: (BuildContext context) {
                                return LocationSelector(
                                  locationList: locationList = jobData.jobs
                                      .map((job) => job.city ?? '')
                                      .toSet()
                                      .toList(),
                                  onLocationSelected: (selectedLocation) {
                                    if (selectedLocation.isNotEmpty) {
                                      setState(() {
                                        this.selectedLocation =
                                            selectedLocation;
                                        _applyLocationFilter(
                                            selectedLocation, jobData.jobs);
                                      });
                                    }
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            selectedLocation.isNotEmpty
                                ? selectedLocation
                                : 'Select Location',
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
                ],
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          margin: const EdgeInsets.only(top: 0),
                          padding: const EdgeInsets.only(top: 0),
                          decoration: const BoxDecoration(
                            color: Constants.bgPanelColor,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (isbannerVisible)
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      if (isbannerVisible)
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 192, 192, 192),
                                                  blurRadius: 2.0,
                                                  spreadRadius: 1),
                                            ],
                                            color: Constants.bgPanelColor,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(bannerUrl)),

                                            //  color: Color(0xfff0f1fe),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          height: 80.h,
                                          margin: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          width: double.infinity,
                                        ),
                                      Visibility(
                                        visible: filteredData.isEmpty &&
                                            searchResults.isEmpty &&
                                            jobData.jobs.isNotEmpty,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "./assets/images/unboxing.gif",
                                                height: 125.0.h,
                                                width: 125.0.w,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
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
                                      if (filteredData.isNotEmpty)
                                        ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var item =
                                                _searchController.text.isEmpty
                                                    ? filteredData.isNotEmpty
                                                        ? filteredData[index]
                                                        : jobData.jobs[index]
                                                    : searchResults[index];
/* 
                                            if (data.jobs[index].skills !=
                                                null) {
                                              if (data.jobs[index].skills
                                                  is String) {
                                                // If skills is a String, split it
                                                myStrings = (data.jobs[index]
                                                        .skills as String)
                                                    .split(",");
                                                updatedList = myStrings!
                                                    .map(
                                                        (skill) => skill.trim())
                                                    .toList();
                                              } else if (data.jobs[index].skills
                                                  is List<String>) {
                                                // If skills is already a List, use it directly
                                                updatedList = (data.jobs[index]
                                                        .skills as List<String>)
                                                    .map(
                                                        (skill) => skill.trim())
                                                    .toList();
                                              }
                                            } */
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
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                      elevation: 4,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              top: 1),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
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
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          if (item.process !=
                                                                              null)
                                                                            Text(
                                                                              item.process.toString(),
                                                                              style: GoogleFonts.varela(fontWeight: FontWeight.w500, fontSize: 14.sp),
                                                                            ),
                                                                          const SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            "||",
                                                                            style:
                                                                                GoogleFonts.varela(
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          // if (item["0"] != null)
                                                                          Text(
                                                                            item.natureOfWork.toString(),
                                                                            style:
                                                                                GoogleFonts.varela(fontWeight: FontWeight.w500, fontSize: 14.sp),
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
                                                                        padding:
                                                                            const EdgeInsets.only(top: 1),
                                                                        child: Image
                                                                            .asset(
                                                                          "assets/images/cmpny.png",
                                                                          height:
                                                                              12.h,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8.w,
                                                                      ),
                                                                      Text(
                                                                        item.companyName
                                                                            .toString(),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset(
                                                                              "assets/images/bag.png",
                                                                              height: 12.h,
                                                                              //  color: Constants.subtitleclr,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 8.w,
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
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Image.asset(
                                                                                  "assets/images/bag.png",
                                                                                  height: 12.h,
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
                                                                        Image
                                                                            .network(
                                                                          ConstImageUrl
                                                                              .wallet,
                                                                          height:
                                                                              14.h,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              6.w,
                                                                        ),
                                                                        Text(
                                                                          formatSalaryRange(
                                                                              item.minCTC!.toInt(),
                                                                              item.maxCTC!.toInt()),
                                                                          style:
                                                                              GoogleFonts.varela(
                                                                            fontSize:
                                                                                13.sp,
                                                                            color:
                                                                                Constants.subtitleclr,
                                                                          ),
                                                                        ),
                                                                        if (item.isMonthly !=
                                                                            "")
                                                                          Text(
                                                                            " ${item.isMonthly}",
                                                                            style:
                                                                                GoogleFonts.varela(
                                                                              fontSize: 13.sp,
                                                                              color: Constants.subtitleclr,
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
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/loc.png",
                                                                        height:
                                                                            14.sp,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            6.w,
                                                                      ),
                                                                      Text(
                                                                        item.location ??
                                                                            '',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .varela(
                                                                          fontSize:
                                                                              13.sp,
                                                                          color:
                                                                              Constants.subtitleclr,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3.h,
                                                            ),
                                                            if (updatedList !=
                                                                null)
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
                                                                          margin:
                                                                              const EdgeInsets.only(bottom: 5),
                                                                          padding: const EdgeInsets.symmetric(
                                                                              vertical: 4,
                                                                              horizontal: 8),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "#$skillItem".replaceAll('"', '').replaceAll('[', '').replaceAll(']',
                                                                                ''),
                                                                            style:
                                                                                GoogleFonts.varela(
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 13.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                                  if (updatedList
                                                                          .length >
                                                                      5)
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
                                                                        color: Constants
                                                                            .borderColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '+${updatedList.length - 5}'
                                                                            .replaceAll('"',
                                                                                '')
                                                                            .replaceAll('[',
                                                                                '')
                                                                            .replaceAll(']',
                                                                                ''),
                                                                        style: GoogleFonts
                                                                            .varela(
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                              color: Colors.grey
                                                                  .shade400,
                                                              width: double
                                                                  .maxFinite,
                                                              height: 0.5.h,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    profileModel.usertype ==
                                                                                3 &&
                                                                            profileModel.id ==
                                                                                item.spoc
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MatchingJobs()));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: const EdgeInsets.only(right: 10),
                                                                              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Constants.subtitleclr),
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                              child: Row(
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
                                                                        : const SizedBox()
                                                                  ],
                                                                ),
                                                                const Spacer(),
                                                                Visibility(
                                                                  visible: jobData
                                                                          .profile
                                                                          .usertype ==
                                                                      3,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => AddResume(
                                                                                    company_name: item.companyName.toString(),
                                                                                    role: item.roleName.toString(),
                                                                                    process: item.process.toString(),
                                                                                    nature_of_work: item.natureOfWork.toString(),
                                                                                    company_id: item.companyId!.toInt(),
                                                                                    jobId: item.id!.toInt(),
                                                                                    sourceId: profileModel.id != null ? profileModel.id!.toInt() : 0,
                                                                                    sourceName: "${profileModel.firstName.toString()} ${profileModel.lastName.toString()}",
                                                                                    isRefer: false,
                                                                                    spocId: item.spoc!.toInt(),
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
                                                                                Constants.themeBgColor),
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
                                                                                Constants.themeBgColor,
                                                                            size:
                                                                                15.h,
                                                                          ),
                                                                          Text(
                                                                            "Resume",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Constants.themeBgColor,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15.h,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: jobData
                                                                          .profile
                                                                          .usertype ==
                                                                      1,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      var profilemodel;
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => AddResume(
                                                                                    company_name: item.companyName.toString(),
                                                                                    role: item.roleName.toString(),
                                                                                    process: item.process.toString(),
                                                                                    nature_of_work: item.natureOfWork.toString(),
                                                                                    company_id: item.companyId!.toInt(),
                                                                                    //anyId!.toInt(),
                                                                                    jobId: item.id!.toInt(),
                                                                                    sourceId: jobData.profile.id!.toInt(),
                                                                                    sourceName: "${jobData.profile.firstName.toString()} ${jobData.profile.lastName.toString()}",
                                                                                    isRefer: true,
                                                                                    spocId: item.spoc!.toInt(),
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
                                                                          border:
                                                                              Border.all(color: Constants.themeBgColor),
                                                                          borderRadius: BorderRadius.circular(8)),
                                                                      child:
                                                                          Text(
                                                                        "Refer Now",
                                                                        style: GoogleFonts.varela(
                                                                            color:
                                                                                Constants.themeBgColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: jobData
                                                                          .profile
                                                                          .usertype ==
                                                                      1,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      JobPostApiService.postJobApply(
                                                                          jobId: item
                                                                              .id!
                                                                              .toInt(),
                                                                          userId: int.parse(jobData
                                                                              .profile
                                                                              .id
                                                                              .toString()),
                                                                          context:
                                                                              context);
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
                                                                              Border.all(color: Constants.themeBgColor),
                                                                          borderRadius: BorderRadius.circular(8)),
                                                                      child:
                                                                          Text(
                                                                        "Apply",
                                                                        style: GoogleFonts.varela(
                                                                            color:
                                                                                Constants.themeBgColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  item.spoc.toString() ==
                                                          jobData.profile.id
                                                              .toString()
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 15.w),
                                                          child: CircularMenu(
                                                            toggleButtonOnPressed:
                                                                () {
                                                              setState(() {
                                                                isMenuOpen =
                                                                    !isMenuOpen; // Toggle the menu open/close state
                                                              });
                                                            },
                                                            radius: 55.r,
                                                            alignment: Alignment
                                                                .topRight,
                                                            backgroundWidget:
                                                                Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        100.0),
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        style: GoogleFonts.varela(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        children: const <
                                                                            TextSpan>[
                                                                          //  TextSpan(text: 'Press the menu button'),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            toggleButtonSize:
                                                                isMenuOpen
                                                                    ? 24.h
                                                                    : 18.h,
                                                            toggleButtonMargin:
                                                                10,
                                                            toggleButtonPadding:
                                                                0,
                                                            startingAngleInRadian:
                                                                0.4 * pi,
                                                            endingAngleInRadian:
                                                                3.4,
                                                            curve: Curves
                                                                .bounceInOut,
                                                            reverseCurve: Curves
                                                                .bounceInOut,
                                                            toggleButtonIconColor:
                                                                Constants
                                                                    .themeBgColor,
                                                            toggleButtonColor:
                                                                Colors
                                                                    .transparent,
                                                            items: [
                                                              CircularMenuItem(
                                                                  icon: Icons
                                                                      .delete_outlined,
                                                                  color: Colors
                                                                      .transparent,
                                                                  iconColor:
                                                                      Colors
                                                                          .red,
                                                                  iconSize:
                                                                      18.h,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _color =
                                                                          Colors
                                                                              .red;
                                                                      _colorName =
                                                                          'red';
                                                                    });
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Dialog Title'),
                                                                          content:
                                                                              const Text('This is the dialog content.'),
                                                                          actions: [
                                                                            ElevatedButton(
                                                                              child: const Text('Cancel'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                            ElevatedButton(
                                                                              child: const Text('OK'),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                // Perform any action here
                                                                                // Navigator.of(context).pop();
                                                                                Autogenerated model = Autogenerated(active: 0
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
                                                                                Map<String, dynamic> jsonData = model.toJson();
                                                                                JobPostApiService.jobInActive(jsonData, item.id!.toInt());
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }),
                                                              CircularMenuItem(
                                                                  icon: Icons
                                                                      .bookmark_add_outlined,
                                                                  color: Colors
                                                                      .transparent,
                                                                  iconColor:
                                                                      Colors
                                                                          .brown,
                                                                  iconSize:
                                                                      18.h,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _color =
                                                                          Colors
                                                                              .brown;
                                                                      _colorName =
                                                                          'Brown';
                                                                    });
                                                                  }),
                                                              CircularMenuItem(
                                                                  icon: Icons
                                                                      .share,
                                                                  color: Colors
                                                                      .transparent,
                                                                  iconColor:
                                                                      Colors
                                                                          .green,
                                                                  iconSize:
                                                                      18.h,
                                                                  onTap:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      _color =
                                                                          Colors
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
                                                                  }),
                                                              CircularMenuItem(
                                                                  icon: Icons
                                                                      .edit,
                                                                  color: Colors
                                                                      .transparent,
                                                                  iconColor:
                                                                      Colors
                                                                          .red,
                                                                  iconSize:
                                                                      18.h,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _color =
                                                                          Colors
                                                                              .red;
                                                                      _colorName =
                                                                          'red';
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => JobForm(
                                                                                    formEdit: true,
                                                                                    companyName: item.companyName.toString(),
                                                                                    companyId: item.companyId.toString(),
                                                                                    jobTitle: item.roleName.toString(),
                                                                                    natureOfWork: item.natureOfWork.toString(),
                                                                                    process: item.process.toString(),
                                                                                  )));
                                                                    });
                                                                  }),
                                                            ],
                                                          ),
                                                        )
                                                      : Positioned(
                                                          top: 0,
                                                          right: 6.w,
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                if ((item.isFav ??
                                                                        0) ==
                                                                    1) {
                                                                  await removeFromFav(item
                                                                      .favJobId!
                                                                      .toInt());
                                                                  combinedData =
                                                                      ref.refresh(
                                                                          userJobDataProvider);
                                                                } else {
                                                                  await addToFav(
                                                                      item.id ??
                                                                          0,
                                                                      jobData
                                                                          .profile
                                                                          .id!
                                                                          .toInt());
                                                                  // ignore: unused_result
                                                                  combinedData =
                                                                      ref.refresh(
                                                                          userJobDataProvider);
                                                                }
                                                              },
                                                              icon: Icon(
                                                                  /*   jobs[index]["id"].toString() ==
                                      item[index]["id"].toString() */
                                                                  (item.isFav) == 1 &&
                                                                          (item.userId ==
                                                                              jobData
                                                                                  .profile.id)
                                                                      ? Icons
                                                                          .bookmark
                                                                      : Icons
                                                                          .bookmark_add_outlined,
                                                                  size: 22.h,
                                                                  color: Constants
                                                                      .themeBgColor)),
                                                        )
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
                                          itemCount:
                                              _searchController.text.isEmpty
                                                  ? filteredData.isNotEmpty
                                                      ? filteredData.length
                                                      : jobData.jobs.length
                                                  : searchResults.length,
                                          padding: const EdgeInsets.only(
                                              bottom: 5, left: 5, right: 5),
                                          scrollDirection: Axis.vertical,
                                        ),
                                      if (_isLoadMoreRunning == true)
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              //  top: 10,
                                              bottom: 40),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text("Error while fetching data"),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget customTab(String title, String img, int select) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: cutTab == select
            ? isSelect
                ? Row(
                    children: [
                      Text(title),
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
                      Icon(
                        Icons.add,
                        size: 15.h,
                      )
                    ],
                  )
            : Row(
                children: [
                  Text(title),
                  Icon(
                    Icons.add,
                    size: 15.h,
                  )
                ],
              ));
  }
}

/* // ignore_for_file: unused_result//TODO: old new jobs code done by me......

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/constants/assets_images_url.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/active_state_model.dart';
import 'package:job_circle/models/new_job_model.dart';
import 'package:job_circle/screens/jobs/add_resume.dart';
import 'package:job_circle/screens/jobs/career_assets.dart';
import 'package:job_circle/screens/jobs/job_form.dart';
import 'package:job_circle/screens/jobs/matching_jobs.dart';
import 'package:job_circle/screens/new_jobs/filter_jobs.dart';
import 'package:job_circle/screens/new_jobs/location_selector.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsDataModelForJobs {
  final List<JobsModel> jobs;
  final ProfileModel profile;

  JobsDataModelForJobs({
    required this.jobs,
    required this.profile,
  });
}

final profileSummaryJobProvider = FutureProvider<ProfileModel>((ref) async {
  final summaryResponse = await _NewJobsState.bindProfileSummary();
  // Simulate fetching profile summary data (replace with actual API call)
  // await Future.delayed(const Duration(seconds: 2));
  if (summaryResponse != null) {
    return ProfileModel.fromJson(summaryResponse);
  } else {
    throw Exception('Failed to load profile summary data');
  }
  // return ProfileModel('John Doe');
});

final JobsProvider = FutureProvider<List<JobsModel>>((ref) async {
  final jobResponse = await _NewJobsState.bindAllJobs();
  if (jobResponse != null) {
    return (jobResponse).map((item) => JobsModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load experience data');
  }
});

final userJobDataProvider = FutureProvider<JobsDataModelForJobs>((ref) async {
  final profileSummary = await _NewJobsState
      .bindProfileSummary(); //ref.watch(profileSummaryProvider);
  final profileSummaryData = ProfileModel.fromJson(profileSummary);
  final jobs = await _NewJobsState.bindAllJobs();
  final jobsData = (jobs).map((item) => JobsModel.fromJson(item)).toList();
  return JobsDataModelForJobs(jobs: jobsData, profile: profileSummaryData);
});

/* final jobsProvider = FutureProvider<List<JobsModel>>((ref) async {
  final jobsRes = await _NewJobsState.bindJobs();
  if (jobsRes != null) {
    return (jobsRes).map((item) => JobsModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load education data');
  }
});

final jobsDataProvider = FutureProvider<JobsDataModel>((ref) async {
  final job = await _NewJobsState.bindJobs();
  final jobsData = (job).map((item) => JobsModel.fromJson(item)).toList();
  final profile = await _NewJobsState.bindProfileSummary();
  final profileData =
      (profile).map((item) => ProfileModel.fromJson(item));

  return JobsDataModel(
    jobs: jobsData,
    profile: profileData,
  );
}); */

class NewJobs extends ConsumerStatefulWidget {
  const NewJobs({super.key});

  @override
  ConsumerState<NewJobs> createState() => _NewJobsState();
}

class _NewJobsState extends ConsumerState<NewJobs>
    with SingleTickerProviderStateMixin {
  ProfileModel profileModel = ProfileModel();

  List<JobsModel> allJobs = [];
  late JobsModel jobsModel;
  List<JobsModel> filteredJobsData = [];
  List<JobsModel> filteredData = [];

  late int selectedJobTypeIndex = 0;
  List<String> citiesList = [];
  late ScrollController _controllerListView;
  Map<String, String> fresher = {};
  var searchText = "";
  var sortByd = "Recomended";
  var localtion = "";
  var licationid = 0;
  late var usertype = -1;
  var role = "0";
  String bannerUrl = "";
  bool isbannerVisible = false;
  int currentTabIndex = 0; // Initialize with the index of the default tab
  int? cutTab;
  bool isSelect = false;
  bool isMyJobs = false;
  bool isSelected = false;
  bool saved = false;
  int favId = 1;
  int favjobId = 0;
  final _hasNextPage = true;
  final _isLoadMoreRunning = false;
  List<String>? myStrings;
  List<String> updatedList = [];
  bool stopIteration = false;
  bool isMenuOpen = false;

  List<String> storedSelectedOptions = [];
  String storedSelectedCategory = '';
  List<String> storedSelectedColumn = [];

  List<String> locationList = [];

  late Function(Map<String, String>) onDone;

  String selectedLocation = "";
  String selectedLoc = '';

  late final TabController _tabController =
      TabController(length: 3, vsync: this);
  final TextEditingController _searchController = TextEditingController();
  TextEditingController loc = TextEditingController();

  final List<String> searchFields = [
    'Company',
    'Process',
    'Designation',
    'Functional Area',
    'Skills',
  ];

  int currentSearchFieldIndex = 0;
  late Timer timer;

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

  final int _tabIndex = 0;
  final _controller = PageController(
    initialPage: 0,
  );

  void startSearchFieldAnimation() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      setState(() {
        currentSearchFieldIndex =
            (currentSearchFieldIndex + 1) % searchFields.length;
      });
    });
  }

  void onFilterDialogClosed(List<String> selectedOptions,
      String selectedCategory, List<String> selectedColumn) {
    setState(() {
      storedSelectedOptions = selectedOptions;
      storedSelectedCategory = selectedCategory;
      storedSelectedColumn = selectedColumn;
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  BottomSheetController bottomSheetDialogController = BottomSheetController();

  final int _currentPage = 1;
  static const int _pageSize = 3000;

  Future<void> _loadSelectedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLocation = prefs.getString('selectedLocation') ?? '';
    });
  }

  static Future<List<dynamic>> bindAllJobs() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/jobs/v1/all?pageNumber=1&pageSize=$_pageSize'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      return parsedResponse['resultData']['content'];
    } else {
      throw Exception('Failed to load data');
    }
  }
  /* Future<void> _fetchAllJobs() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host_one}/jobs/v1/all?pageNumber=$_currentPage&pageSize=$_pageSize';
      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        List<JobsModel> jobs =
            contentList.map((json) => JobsModel.fromJson(json)).toList();

        // List<JobsModel> filteredjobs = [];

        _currentPage++;
        setState(() {
          allJobs = jobs;
        });
      }
    } catch (e) {
      print('Error loading more data: $e');
    }
  } */

  @override
  void initState() {
    bindInit();
    _refreshController = RefreshController(initialRefresh: false);
    bindProfileSummary();
    // _fetchAllJobs();

    /*  _fetchAllJobs().then((_) {
      filteredJobsData = allJobs;

      filteredData = filteredJobsData;
      _searchController.addListener(_onSearchChanged);
      _loadSelectedLocation();
      setState(() {});
    }); */

    startSearchFieldAnimation();

    super.initState();
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  void bindInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);
    role = await Utils.getPreferencesValue(null, ESharedPreferences.role.name);

    var userRaw = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_rawData.name);
    setState(() {});
  }

  void initData() async {}

  @override
  void dispose() {
    _searchController.dispose();
    // _animationController?.dispose();
    super.dispose();
  }

  static Future<Map<String, dynamic>> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/profileSummary/$id'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData")) {
        return parsedResponse["resultData"] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addToFav(int jobId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            "http://${GlobalConstants.API_Host_one}/favjob/v1/$userId/$jobId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
      } else {
        print('Error during post request: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromFav(
    int favJobId,
  ) async {
    final response = await http.delete(
      Uri.parse("http://${GlobalConstants.API_Host_one}/favjob/v1/$favJobId"),
      headers: <String, String>{},
    );

    if (response.statusCode == 200) {
      print('Post request successful');
      // searchAgain();
    } else {
      print('Error during post request: ${response.statusCode}');
    }
  }

  List jobs = [];
  Future<void> fetchJobs() async {
    Uri url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/favjob/v1/all?pageNumber=1&pageSize=100');
    final response = await http.get(url); // replace with your API endpoint
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      var list = data as List;
      setState(() {
        jobs.addAll(list);
        // print(jobs);
      });
    } else {
      print("Somthing Wrong");
      // handle error
    }
  }

  void closeDrawer() {
    Scaffold.of(context).closeDrawer();
  }

  nav() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CareerAssets()));
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Job circle App',
        text: 'Install jobcircle app',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.job_circle',
        chooserTitle: 'Example Chooser Title');
  }

  List<JobsModel> searchResults = [];

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    List<String> searchTerms = query.split(',');

    setState(() {
      // Filter the profileSummaries based on the search query
      filteredData = filteredData.where((job) {
        final skillsAsString = job.skills?.join(", ") ?? "";
        final jobInfo = [
          job.companyName!.toLowerCase(),
          job.process!.toLowerCase(),
          job.roleName!.toLowerCase(),
          job.natureOfWork!.toLowerCase(),
          skillsAsString.toLowerCase(),
        ];

        // Check if any of the search terms match any job information
        return searchTerms.any((term) {
          return jobInfo.any((info) => info.contains(term));
        });
      }).toList();

      // Update the searchResults list with filteredJobsData
      searchResults = filteredData.toList();
    });
  }

  void _onSearchTextChanged(String text, List<JobsModel> filter) {
    setState(() {
      // Check if _searchController.text is empty
      if (_searchController.text.isEmpty) {
        refreshData(filter);
      }
    });
  }

  void _applyLocationFilter(String selectedLocation, List<JobsModel> filter) {
    filteredJobsData = allJobs
        .where((job) =>
            // Check if the job's city is in the selectedLocation list.
            job.city == selectedLocation)
        .toList();

    // Update spocList here
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 200));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    if (!_hasNextPage) {
      _refreshController.loadNoData();
    } else {
      _loadMore();
      if (mounted) setState(() {});
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false) {
      filteredData = filteredJobsData;
    }
  }

  void refreshData(List<JobsModel> filter) {
    setState(() {
      filteredData = filter;
    });
  }

  void _applyFreshFilter(List<JobsModel> freshFilte) {
    setState(() {
      filteredData =
          freshFilte.where((job) => job.isFresher == "Fresher").toList();
    });
  }

  /*  void _applyFreshFilter(List<JobsModel> freshFilte) {
    setState(() {
      filteredData = freshFilte
          .where((job) => contains(job.isFresher, "Fresher"))
          .toList();
    });
  } */

  void _applyFavFilter(List<JobsModel> freshFilte, ProfileModel profileModel) {
    setState(() {
      filteredData = freshFilte
          .where((job) =>
              contains(job.isFav, 1) && contains(job.userId, profileModel.id))
          .toList();
    });
  }

  void _applySpocFilter(List<JobsModel> freshFilte, ProfileModel profileModel) {
    setState(() {
      filteredData = freshFilte
          .where((job) => contains(job.spoc, profileModel.id))
          .toList();
    });
  }

  void _applySpocReportToFilter(
      List<JobsModel> freshFilte, ProfileModel profileModel) {
    setState(() {
      filteredData = freshFilte
          .where((job) => contains(job.spoc, profileModel.reportTo))
          .toList();
    });
  }

  bool contains(dynamic? value, dynamic searchTerm) {
    if (value is int && searchTerm is int) {
      return value == searchTerm;
    } else if (value is String && searchTerm is String) {
      return value.toLowerCase().contains(searchTerm.toLowerCase());
    }

    return false;
  }

  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    String _colorName;
    Color _color;
    final combinedData = ref.watch(userJobDataProvider);

    return combinedData.when(
      data: (data) {
        setState(() {
          _searchController.addListener(_onSearchChanged);
          _loadSelectedLocation();
          allJobs = data.jobs.map((e) => e).toList();
        });
        return Scaffold(
            drawer: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(15)),
              child: Drawer(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    UserAccountsDrawerHeader(
                      margin: EdgeInsets.only(left: 10.w),
                      decoration: const BoxDecoration(
                          color: Constants.themeBgColorLight),
                      accountName: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data.profile.firstName.toString()} ${data.profile.lastName.toString()}",
                            style: GoogleFonts.varela(
                                fontSize: 16.sp,
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(data.profile.userLocation.toString(),
                              style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  color: Constants.themeBgColor))
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
                          child: data.profile.profilePic == null
                              ? CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 190, 190, 190),
                                  radius: 43,
                                  onBackgroundImageError:
                                      ((error, stackTrace) => Image.asset(
                                          "assets/images/company.png",
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
                                  backgroundColor: Constants.themeBgColor,
                                  radius: 43,
                                  onBackgroundImageError:
                                      ((error, stackTrace) => Image.network(
                                          "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profile.profilePic}",
                                          fit: BoxFit.contain)),
                                  backgroundImage: Image.network(
                                    "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profile.profilePic}",
                                  ).image,
                                )),
                    ),
                    ListTile(
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
                    ),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            floatingActionButton: data.profile.usertype == 3
                ? Visibility(
                    visible: role != "1" && role != "2",
                    child: FloatingActionButton(
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
            appBar: AppBar(
              leading: Builder(
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    left: 22.w,
                  ),
                  child: InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: CircleAvatar(
                      radius: 2.r,
                      child: data.profile.profilePic != null
                          ? CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 190, 190, 190),
                              radius: 43,
                              onBackgroundImageError: ((error, stackTrace) =>
                                  Image.asset("assets/images/company.png",
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.contain)),
                              backgroundImage: Image.network(
                                "https://s3.ap-south-1.amazonaws.com/job-circle-2/${data.profile.profilePic}",
                              ).image,
                            )
                          : Icon(
                              Icons.person,
                              size: 14.h,
                            ),
                    ),
                  ),
                ),
              ),
              iconTheme: const IconThemeData(color: Constants.themeBgColor),
              bottom: PreferredSize(
                preferredSize: Size(0, 25.h),
                child: TabBar(
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
                  indicator: isSelect
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
                      isSelect = !isSelect;
                      if (value == 1 && data.profile.usertype == 1) {
                        isSelect
                            ? _applyFavFilter(data.jobs, data.profile)
                            : refreshData(data.jobs);
                      }

                      if (value == 1 && data.profile.usertype != 1) {
                        // sortByd = "New Jobs";
                        isSelect
                            ? role == "1" || role == "2"
                                ? _applySpocReportToFilter(
                                    data.jobs, data.profile)
                                : _applySpocFilter(data.jobs, data.profile)
                            : refreshData(data.jobs);
                      }

                      if (value == 2 && data.profile.usertype == 1) {
                        isSelect
                            ? _applyFreshFilter(data.jobs)
                            : refreshData(data.jobs);
                      }
                    });
                  },

                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: InkWell(
                        onTap: () async {
                          FilterDialog filterDialog = FilterDialog(
                            filteredData,
                            data.jobs,
                            (List<JobsModel> updatedfilteredJobsData) {
                              // Update your filteredJobsData in the calling class
                              setState(() {
                                filteredData = updatedfilteredJobsData;
                              });
                            },
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
                    if (data.profile.usertype != 1)
                      Tab(
                        child:
                            customTab("My Jobs", "assets/images/check.png", 1),
                      ),
                    if (data.profile.usertype == 1)
                      Tab(
                        child: customTab(
                            "Save Jobs", "assets/images/check.png", 1),
                      ),
                    if (data.profile.usertype == 1)
                      Tab(
                        child:
                            customTab("Fresher", "assets/images/check.png", 2),
                      ),
                  ],
                ),
              ),
              toolbarHeight: MediaQuery.of(context).size.width * 0.17,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      //margin: const EdgeInsets.symmetric(vertical: 10),
                      //height: 30.h,
                      height: MediaQuery.of(context).size.height / 26.h,
                      width: MediaQuery.of(context).size.width / 1.65.w,
                      child: TextField(
                        onChanged: (value) {
                          _onSearchTextChanged(
                              _searchController.text, data.jobs);
                        },
                        controller: _searchController,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 5.0, bottom: 5, top: 5),
                          fillColor: Constants.bgColorWhite,
                          hintText:
                              'Search Jobs by ${searchFields[currentSearchFieldIndex]}',
                          hintMaxLines: 2,
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
                  SizedBox(
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
                              builder: (BuildContext context) {
                                return LocationSelector(
                                  locationList: locationList = allJobs
                                      .map((job) =>
                                          job.city ??
                                          '') // Adjust this based on your object structure
                                      .toSet()
                                      .toList(),
                                  onLocationSelected: (selectedLocation) {
                                    if (selectedLocation.isNotEmpty) {
                                      setState(() {
                                        this.selectedLocation =
                                            selectedLocation;
                                        _applyLocationFilter(
                                            selectedLocation, data.jobs);
                                      });
                                    }
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            selectedLocation.isNotEmpty
                                ? selectedLocation
                                : 'Select Location',
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
                ],
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          margin: const EdgeInsets.only(top: 0),
                          padding: const EdgeInsets.only(top: 0),
                          decoration: const BoxDecoration(
                            color: Constants.bgPanelColor,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (isbannerVisible)
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      if (isbannerVisible)
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 192, 192, 192),
                                                  blurRadius: 2.0,
                                                  spreadRadius: 1),
                                            ],
                                            color: Constants.bgPanelColor,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(bannerUrl)),

                                            //  color: Color(0xfff0f1fe),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          height: 80.h,
                                          margin: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          width: double.infinity,
                                        ),
                                      Visibility(
                                        visible: filteredData.isEmpty &&
                                            searchResults.isEmpty,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "./assets/images/unboxing.gif",
                                                height: 125.0.h,
                                                width: 125.0.w,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                  "Please choose the city where you are currently searching for job opportunities.",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.varela(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext, index) {
                                          // var item = _searchController.text.isEmpty
                                          //     ? filteredJobsData[index]
                                          //     : searchResults[index];
                                          var item = data.jobs[index];
                                          /* _searchController
                                                  .text.isEmpty
                                              ? (selectedLocation != null ||
                                                      selectedLocation != ""
                                                  ? filteredData
                                                      .where((job) =>
                                                          selectedLocation
                                                              .contains(
                                                                  job.city ??
                                                                      ''))
                                                      .toList()
                                                  : filteredData)[index]
                                              : searchResults[index];*/

                                          if (data.jobs[index].skills != null) {
                                            if (data.jobs[index].skills
                                                is String) {
                                              // If skills is a String, split it
                                              myStrings = (data.jobs[index]
                                                      .skills as String)
                                                  .split(",");
                                              updatedList = myStrings!
                                                  .map((skill) => skill.trim())
                                                  .toList();
                                            } else if (data.jobs[index].skills
                                                is List<String>) {
                                              // If skills is already a List, use it directly
                                              updatedList = (data.jobs[index]
                                                      .skills as List<String>)
                                                  .map((skill) => skill.trim())
                                                  .toList();
                                            }
                                          }

                                          _applyLocationFilter(
                                              selectedLocation, data.jobs);

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
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                    ),
                                                    elevation: 4,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 1),
                                                    child: Padding(
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
                                                                        left:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      item.roleName ??
                                                                          '',
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.varela(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              16.sp),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        if (item.process !=
                                                                            null)
                                                                          Text(
                                                                            item.process.toString(),
                                                                            style:
                                                                                GoogleFonts.varela(fontWeight: FontWeight.w500, fontSize: 14.sp),
                                                                          ),
                                                                        const SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                          "||",
                                                                          style:
                                                                              GoogleFonts.varela(
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
                                                                              fontWeight: FontWeight.w500,
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
                                                                          top:
                                                                              1),
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/cmpny.png",
                                                                        height:
                                                                            12.h,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          8.w,
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
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
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
                                                                                height: 12.h,
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
                                                                      Image
                                                                          .network(
                                                                        ConstImageUrl
                                                                            .wallet,
                                                                        height:
                                                                            14.h,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            6.w,
                                                                      ),
                                                                      Text(
                                                                        formatSalaryRange(
                                                                            item.minCTC!.toInt(),
                                                                            item.maxCTC!.toInt()),
                                                                        style: GoogleFonts
                                                                            .varela(
                                                                          fontSize:
                                                                              13.sp,
                                                                          color:
                                                                              Constants.subtitleclr,
                                                                        ),
                                                                      ),
                                                                      if (item.isMonthly !=
                                                                          "")
                                                                        Text(
                                                                          " ${item.isMonthly}",
                                                                          style:
                                                                              GoogleFonts.varela(
                                                                            fontSize:
                                                                                13.sp,
                                                                            color:
                                                                                Constants.subtitleclr,
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
                                                                      height:
                                                                          14.sp,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          6.w,
                                                                    ),
                                                                    Text(
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
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 3.h,
                                                          ),
                                                          if (updatedList !=
                                                              null)
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
                                                                        margin: const EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        padding: const EdgeInsets.symmetric(
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
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "#$skillItem"
                                                                              .replaceAll('"', '')
                                                                              .replaceAll('[', '')
                                                                              .replaceAll(']', ''),
                                                                          style:
                                                                              GoogleFonts.varela(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                13.sp,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                                if (updatedList
                                                                        .length >
                                                                    5)
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
                                                                      color: Constants
                                                                          .borderColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
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
                                                                      style: GoogleFonts
                                                                          .varela(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                            width: double
                                                                .maxFinite,
                                                            height: 0.5.h,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  profileModel.usertype ==
                                                                              3 &&
                                                                          profileModel.id ==
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
                                                                      : const SizedBox()
                                                                ],
                                                              ),
                                                              const Spacer(),
                                                              Visibility(
                                                                visible: data
                                                                        .profile
                                                                        .usertype ==
                                                                    3,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => AddResume(
                                                                                  company_name: item.companyName.toString(),
                                                                                  role: item.roleName.toString(),
                                                                                  process: item.process.toString(),
                                                                                  nature_of_work: item.natureOfWork.toString(),
                                                                                  company_id: item.companyId!.toInt(),
                                                                                  jobId: item.id!.toInt(),
                                                                                  sourceId: profileModel.id != null ? profileModel.id!.toInt() : 0,
                                                                                  sourceName: "${profileModel.firstName.toString()} ${profileModel.lastName.toString()}",
                                                                                  isRefer: false,
                                                                                  spocId: item.spoc!.toInt(),
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
                                                                        horizontal:
                                                                            8.w),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Constants.themeBgColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Constants.themeBgColor,
                                                                          size:
                                                                              15.h,
                                                                        ),
                                                                        Text(
                                                                          "Resume",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Constants.themeBgColor,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                15.h,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: data
                                                                        .profile
                                                                        .usertype ==
                                                                    1,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    var profilemodel;
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => AddResume(
                                                                                  company_name: item.companyName.toString(),
                                                                                  role: item.roleName.toString(),
                                                                                  process: item.process.toString(),
                                                                                  nature_of_work: item.natureOfWork.toString(),
                                                                                  company_id: item.companyId!.toInt(),
                                                                                  //anyId!.toInt(),
                                                                                  jobId: item.id!.toInt(),
                                                                                  sourceId: data.profile.id!.toInt(),
                                                                                  sourceName: "${data.profile.firstName.toString()} ${data.profile.lastName.toString()}",
                                                                                  isRefer: true,
                                                                                  spocId: item.spoc!.toInt(),
                                                                                )));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 10,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            4.h,
                                                                        horizontal:
                                                                            10.w),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Constants
                                                                                .themeBgColor),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                    child: Text(
                                                                      "Refer Now",
                                                                      style: GoogleFonts.varela(
                                                                          color: Constants
                                                                              .themeBgColor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: data
                                                                        .profile
                                                                        .usertype ==
                                                                    1,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    JobPostApiService.postJobApply(
                                                                        jobId: item
                                                                            .id!
                                                                            .toInt(),
                                                                        userId: int.parse(data
                                                                            .profile
                                                                            .id
                                                                            .toString()),
                                                                        context:
                                                                            context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 10,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            4.h,
                                                                        horizontal:
                                                                            16.w),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Constants
                                                                                .themeBgColor),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                    child: Text(
                                                                      "Apply",
                                                                      style: GoogleFonts.varela(
                                                                          color: Constants
                                                                              .themeBgColor,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                item.spoc.toString() ==
                                                        data.profile.id
                                                            .toString()
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 15.w),
                                                        child: CircularMenu(
                                                          toggleButtonOnPressed:
                                                              () {
                                                            setState(() {
                                                              isMenuOpen =
                                                                  !isMenuOpen; // Toggle the menu open/close state
                                                            });
                                                          },
                                                          radius: 55.r,
                                                          alignment: Alignment
                                                              .topRight,
                                                          backgroundWidget:
                                                              Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          100.0),
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style: GoogleFonts.varela(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      children: const <
                                                                          TextSpan>[
                                                                        //  TextSpan(text: 'Press the menu button'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          toggleButtonSize:
                                                              isMenuOpen
                                                                  ? 24.h
                                                                  : 18.h,
                                                          toggleButtonMargin:
                                                              10,
                                                          toggleButtonPadding:
                                                              0,
                                                          startingAngleInRadian:
                                                              0.4 * pi,
                                                          endingAngleInRadian:
                                                              3.4,
                                                          curve: Curves
                                                              .bounceInOut,
                                                          reverseCurve: Curves
                                                              .bounceInOut,
                                                          toggleButtonIconColor:
                                                              Constants
                                                                  .themeBgColor,
                                                          toggleButtonColor:
                                                              Colors
                                                                  .transparent,
                                                          items: [
                                                            CircularMenuItem(
                                                                icon: Icons
                                                                    .delete_outlined,
                                                                color: Colors
                                                                    .transparent,
                                                                iconColor:
                                                                    Colors.red,
                                                                iconSize: 18.h,
                                                                onTap: () {
                                                                  setState(() {
                                                                    _color =
                                                                        Colors
                                                                            .red;
                                                                    _colorName =
                                                                        'red';
                                                                  });
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Dialog Title'),
                                                                        content:
                                                                            const Text('This is the dialog content.'),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            child:
                                                                                const Text('Cancel'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          ElevatedButton(
                                                                            child:
                                                                                const Text('OK'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              // Perform any action here
                                                                              // Navigator.of(context).pop();
                                                                              Autogenerated model = Autogenerated(active: 0
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
                                                                              Map<String, dynamic> jsonData = model.toJson();
                                                                              JobPostApiService.jobInActive(jsonData, item.id!.toInt());
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                }),
                                                            CircularMenuItem(
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
                                                                }),
                                                            CircularMenuItem(
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
                                                                }),
                                                            CircularMenuItem(
                                                                icon:
                                                                    Icons.edit,
                                                                color: Colors
                                                                    .transparent,
                                                                iconColor:
                                                                    Colors.red,
                                                                iconSize: 18.h,
                                                                onTap: () {
                                                                  setState(() {
                                                                    _color =
                                                                        Colors
                                                                            .red;
                                                                    _colorName =
                                                                        'red';
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => JobForm(
                                                                                  formEdit: true,
                                                                                  companyName: item.companyName.toString(),
                                                                                  companyId: item.companyId.toString(),
                                                                                  jobTitle: item.roleName.toString(),
                                                                                  natureOfWork: item.natureOfWork.toString(),
                                                                                  process: item.process.toString(),
                                                                                )));
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                      )
                                                    : Positioned(
                                                        top: 0,
                                                        right: 6.w,
                                                        child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              if ((item.isFav ??
                                                                      0) ==
                                                                  1) {
                                                                await removeFromFav(item
                                                                    .favJobId!
                                                                    .toInt());
                                                                ref.refresh(
                                                                    userJobDataProvider);
                                                              } else {
                                                                await addToFav(
                                                                    item.id ??
                                                                        0,
                                                                    data.profile
                                                                        .id!
                                                                        .toInt());
                                                                // ignore: unused_result
                                                                ref.refresh(
                                                                    userJobDataProvider);
                                                              }
                                                            },
                                                            icon: Icon(
                                                                /*   jobs[index]["id"].toString() ==
                                      item[index]["id"].toString() */
                                                                (item.isFav) ==
                                                                            1 &&
                                                                        (item.userId ==
                                                                            data
                                                                                .profile.id)
                                                                    ? Icons
                                                                        .bookmark
                                                                    : Icons
                                                                        .bookmark_add_outlined,
                                                                size: 22.h,
                                                                color: Constants
                                                                    .themeBgColor)),
                                                      )
                                              ],
                                            ),
                                          );
                                        },
                                        /*  itemCount: _searchController.text.isEmpty
                                        ? filteredData.length
                                        : searchResults.length, */
                                        itemCount: _searchController
                                                .text.isEmpty
                                            ? (selectedLocation != null
                                                ? filteredData
                                                    .where((job) =>
                                                        selectedLocation
                                                            .contains(
                                                                job.city ?? ''))
                                                    .toList()
                                                    .length
                                                : data.jobs.length)
                                            : searchResults.length,
                                        padding: const EdgeInsets.only(
                                            bottom: 5, left: 5, right: 5),
                                        scrollDirection: Axis.vertical,
                                      ),
                                      if (_isLoadMoreRunning == true)
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              //  top: 10,
                                              bottom: 40),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text("Error while fetching data"),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget customTab(String title, String img, int select) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: cutTab == select
            ? isSelect
                ? Row(
                    children: [
                      Text(title),
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
                      Icon(
                        Icons.add,
                        size: 15.h,
                      )
                    ],
                  )
            : Row(
                children: [
                  Text(title),
                  Icon(
                    Icons.add,
                    size: 15.h,
                  )
                ],
              ));
  }
}
 */
