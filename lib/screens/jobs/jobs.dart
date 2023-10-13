// ignore_for_file: await_only_futures

import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:circular_menu/circular_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/constants/assets_images_url.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/interceptors/no_internet.dart';
import 'package:job_circle/models/active_state_model.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/models/location_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/jobs/career_assets.dart';
import 'package:job_circle/screens/jobs/filter.dart';
import 'package:job_circle/screens/jobs/job_details.dart';
import 'package:job_circle/screens/jobs/job_form.dart';
import 'package:job_circle/screens/jobs/location_search.dart';
import 'package:job_circle/screens/jobs/matching_jobs.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/job_details_model.dart';
import '../../service/masterService.dart';
import 'add_resume.dart';

class Jobs extends ConsumerStatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  ConsumerState<Jobs> createState() => _JobsState();
}

class _JobsState extends ConsumerState<Jobs>
    with SingleTickerProviderStateMixin {
  final filterJobType = <String>[
    "All",
    "Work from home",
    "Part-time",
    "Night shift"
  ];

  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  late int selectedJobTypeIndex = 0;
  late List jobItems = [];
  List<String> citiesList = [];
  List<Content> locations = [];
  late ScrollController _controllerListView;

  var searchText = "";
  var sortByd = "Recomended";
  var _page = 0;
  var _hasNextPage = true;
  var _isFirstLoadRunning = false;
  var _isLoadMoreRunning = false;
  final _pageSize = 20;
  var localtion = "";
  var licationid = 0;
  late var usertype = -1;
  var role = "0";
  String bannerUrl = "";
  bool isbannerVisible = false;

  final List<String> _favorites = [];

  bool isEdit = false;
  void _handleItemTap(String item) {
    setState(() {
      _favorites.add(item);
    });
  }

  /* String formatSalaryRange(int minSalary, int maxSalary) {
    String formattedMinSalary = '';
    String formattedMaxSalary = '';

    if (minSalary >= 100000) {
      formattedMinSalary = (minSalary / 100000).toStringAsFixed(2);
    } else if (minSalary >= 1000) {
      formattedMinSalary = '${(minSalary / 1000).toStringAsFixed(2)}k';
    } else {
      formattedMinSalary = minSalary.toStringAsFixed(1);
    }

    if (maxSalary >= 100000) {
      formattedMaxSalary = (maxSalary / 100000).toStringAsFixed(2);
    } else if (maxSalary >= 1000) {
      formattedMaxSalary = '${(maxSalary / 1000).toStringAsFixed(2)}k';
    } else {
      formattedMaxSalary = maxSalary.toStringAsFixed(1);
    }

    return maxSalary == 0.0
        ? formattedMinSalary
        : '$formattedMinSalary - $formattedMaxSalary';
  } */
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

  bool isMenuOpen = false;

  // CircularMenuController _menuController = CircularMenuController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  BottomSheetController bottomSheetDialogController = BottomSheetController();

  var locationid = 0;

  var locationname = "";
  var user_selected_lcoation;
  var partner_request = 1;

  Future<void> _onRefresh() async {
    // if failed,use refreshFailed()
    await Future.delayed(const Duration(milliseconds: 200));

    searchAgain();
    _refreshController.refreshCompleted();
  }

  Future<void> _onRefreshForMyJobs({Map<String, String>? data}) async {
    // if failed,use refreshFailed()
    await Future.delayed(const Duration(milliseconds: 200));
    log(data.toString());
    searchAgain(data: data);
    _refreshController.refreshCompleted();
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

  NumberFormat format = NumberFormat.compact();

  @override
  void initState() {
    bindInit();
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
    setState(() {
      Utils.setPreference(
          null,
          user_selected_lcoation = ESharedPreferences
              .user_selected_lcoation.name, // set job location at jobs page.
          user_selected_lcoation);
      searchAgain();
      bindItems();

      bindProfileSummary();

      fetchJobs();
      // getJobDetails()
    });
  }

  TextEditingController searchController = TextEditingController();

  void bindInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usertype = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);
    role = await Utils.getPreferencesValue(null, ESharedPreferences.role.name);

    var userRaw = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_rawData.name);
    if (userRaw != null) {
      var jUserRaw = jsonDecode(userRaw);
      locationid = jUserRaw['locationid'];
      locationname = jUserRaw['location'];
    }

    user_selected_lcoation = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_selected_lcoation.name);
    setState(() {
      user_selected_lcoation = locationname;
      Utils.setPreference(
          null,
          ESharedPreferences
              .user_selected_lcoation.name, // set job location at jobs page.
          user_selected_lcoation);
    });
    /* if (localtion != "") {                         set job location on jobs page 23/03/23
      // user_selected_lcoation ?? localtion;
      await Utils.setPreference(
          null,
          ESharedPreferences.user_selected_lcoation.name,
          user_selected_lcoation);
    } */

    await bindLocation();
    /*  if (user_selected_lcoation == null) {
      searchLocation(context);
    } */
    bindBanner();
    bindItems();
    //_controllerListView = ScrollController()..addListener(_loadMore);

    setState(() {});
  }

  JobDetailsModel jobDetailsModel = JobDetailsModel();

  @override
  void dispose() {
    //_controllerListView.removeListener(_loadMore);
    super.dispose();
  }

  ProfileSummaryModel profileSummaryModel = ProfileSummaryModel();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int? cutTab;
  bool isSelect = false;
  bool isMyJobs = false;
  bool isSelected = false;
  bool saved = false;

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Job circle App',
        text: 'Install jobcircle app',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.job_circle',
        chooserTitle: 'Example Chooser Title');
  }

  final _controller = PageController(
    // viewportFraction: 0.8,

    initialPage: 0,
  );

  uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "Uploading...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res =
          await FileUploadService().uploadSingleFile("cv", result.files.single);
      var resultD = Utils.parseResponse(res);
      Navigator.pop(context);
      if (resultD.resultKey == 'SUCCESS') {
        return resultD.resultData[0];
      }
      // File file = File(result.files.single.readStream.first!);
    } else {
      Navigator.pop(context);
      return null;
      // User canceled the picker
    }
  }

  var profile_cv_link = "";
  var profile_cv_file = "";
  var profile_final_pic = "";
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  save({filePath, data}) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'profile_pic') {
        profilemodel.profile_pic = filePath;
        profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      } else if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;
        profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
        profile_cv_file = Utils.getFileName(profile_cv_link);

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromJson(dataResult);

      // user_selected_lcoation = user_selected_lcoation;
    }
    setState(() {});
  }

  Future<void> addToFav(int jobId) async {
    try {
      var id = profilemodel.id; //this id is null, get the user id
      final response = await http.post(
        Uri.parse("http://192.168.1.110:9090/favjob/v1/$id/$jobId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
//ek min wait kr //api ka issue ho skta hai may be
      if (response.statusCode == 200) {
        print('Post request successful');
      } else {
        print('Error during post request: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromFav(int favJobId) async {
    var id = profileSummaryModel.id;
    final response = await http.post(
      Uri.parse("http://${GlobalConstants.API_Host_one}/favjob/v1/$favJobId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Error during post request: ${response.statusCode}');
    }
  }

  List jobs = [];
  Future<void> fetchJobs() async {
    Uri url = Uri.parse(
        'http://192.168.1.110:9090/favjob/v1/all?pageNumber=1&pageSize=100');
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

  /*  Map<String, List<String>> data = {
    'Company': ['Company1', 'Company2'],
    'Skills': ['Skill1', 'skill2'],
    'process': ['p1', 'p2'],
  }; */

/*   late String selectedKey = data.keys.first;
  final int _tabIndex = 0; */

  late Map<String, String> staticMap = {
    'spoc': '${profilemodel.id}',
  };
  late Map<String, String> staticMap1 = {
    'spoc': '${profilemodel.report_to}',
  };

  @override
  Widget build(BuildContext context) {
    //var _selectedIndex = 1;

    return Scaffold(
        key: scaffoldKey,
        drawer: ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
          child: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                SizedBox(
                  height: 200,
                  child: UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(left: 10.w),
                    decoration:
                        const BoxDecoration(color: Constants.themeBgColorLight),
                    accountName: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Name",
                          style: GoogleFonts.varela(
                              fontSize: 12.sp, color: Constants.themeBgColor),
                        ),
                        Text(
                          "Tag line",
                          style: GoogleFonts.varela(
                              fontSize: 12.sp, color: Colors.black),
                        ),
                        Text(
                          "Location",
                          style: GoogleFonts.varela(
                              fontSize: 12.sp, color: Colors.black),
                        )
                      ],
                    ),
                    accountEmail: const Text(""),
                    currentAccountPictureSize: const Size.square(40),
                    currentAccountPicture: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ERoute.profile_summary.name);
                        },
                        child: profile_final_pic == ""
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
                                    Image.asset("assets/images/company.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain)),
                                backgroundImage: Image.network(
                                  profile_final_pic,
                                ).image,
                              )), //circleAvatar
                  ),
                ), //DrawerHeader
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
                      Navigator.pushNamedAndRemoveUntil(context,
                          ERoute.login.value, (Route<dynamic> route) => false);
                      // Navigator.pushReplacementNamed(context, nextRoute.value);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: usertype == 3
            ? Visibility(
                visible: role != "1" && role != "2",
                child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    /*       Navigator.push(
                context, // second
                MaterialPageRoute(builder: (context) => const JobListPage())); */
                    /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WebviewData(
                          // url: "https://www.youtube.com/",
                          url: GlobalConstants.WEB_Host + "/mobile/jobform",
                          // url: "192.168.31.107:9090/mobile/jobform",
                          title: "New Job",
                        )));
    
            setState(() {}); */

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JobForm(formEdit: false),
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
                  child: profile_final_pic != null
                      ? CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 190, 190, 190),
                          radius: 43,
                          onBackgroundImageError: ((error, stackTrace) =>
                              Image.asset("assets/images/company.png",
                                  height: 80, width: 80, fit: BoxFit.contain)),
                          backgroundImage: Image.network(
                            profile_final_pic,
                          ).image,
                        )
                      : Icon(
                          Icons.person,
                          size: 14.h,
                        ),
                  /* IconButton(
                    icon: profileSummaryModel.profile_pic != null
                        ? Image.network(
                            profileSummaryModel.profile_pic.toString())
                        : Icon(
                            Icons.person,
                            size: 16.h,
                          ),
                    onPressed: () =>
                        /*  Navigator.pushNamed(
                        context,
                        ERoute.profile_summary
                            .name), */
                        Scaffold.of(context).openDrawer(),
                  ), */
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
              indicatorSize: TabBarIndicatorSize.tab,
              splashBorderRadius: BorderRadius.circular(8.r),
              //indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 5,
              indicatorPadding: EdgeInsets.only(
                  top: 10.h, bottom: 12.h, left: 3.w, right: 3.w),
              indicator: isSelect
                  ? BoxDecoration(
                      color: Constants.borderColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: Constants.borderColor) // Creates border
                      )
                  : null,
              onTap: (value) {
                setState(() {
                  cutTab = value;
                  isSelect = !isSelect;
                  if (value == 1) {
                    // sortByd = "New Jobs";
                    isSelect
                        ? searchAgain(
                            data: role == "1" || role == "2"
                                ? staticMap1
                                : staticMap)
                        : searchAgain();
                    // isSelect ? ;
                  }
                  if (value == 2) {
                    sortByd = "Newer Jobs";
                    isSelect == true ? null : sortByd = "";
                    // Map<String, String> newData = {"work_type": "hybrid"};
                    searchAgain();
                  }
                  if (value == 3) {
                    // sortByd = "New Jobs";
                    Map<String, String> newData1 = {
                      "work_type": "workfromhome"
                    };
                    searchAgain(data: newData1);
                  }
                  if (value == 4) {
                    // sortByd = "New Jobs";
                    Map<String, String> newData1 = {"work_type": "fresher"};
                    searchAgain(data: newData1);
                  }
                  if (value == 5) {
                    // sortByd = "New Jobs";
                    Map<String, String> newData1 = {
                      "work_type": "workfromhome"
                    };
                    searchAgain(data: newData1);
                  }
                  if (value == 6) {
                    // sortByd = "New Jobs";
                    Map<String, String> newData1 = {
                      "work_type": "workfromhome"
                    };
                    searchAgain(data: newData1);
                  }
                  if (value == 7) {
                    // sortByd = "New Jobs";
                    Map<String, String> newData1 = {
                      "work_type": "workfromhome"
                    };
                    searchAgain(data: newData1);
                  }
                  if (value == 8) {
                    // sortByd = "New Jobs";
                    Map<String, String> newData1 = {
                      "work_type": "workfromhome"
                    };
                    searchAgain(data: newData1);
                  }
                });
              },

              isScrollable: true,
              tabs: [
                Tab(
                  child: InkWell(
                    onTap: () async {
                      /*  showCustomModelBottomSheet(
                        context,
                      ); */
                      CustomSheet.customSheet(
                          context: context,
                          onDone: (data) {
                            searchAgain(data: data);
                          });
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JobFilter())); */
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
                          // const Text("Sort by"),
                          /* DropdownButton<String>(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
                            underline: const SizedBox(),
                            style: const GoogleFonts.varela(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                            value: sortByd,
                            alignment: Alignment.bottomRight,
                            items: <String>[
                              'Recomended',
                              // 'Salary - high to low',
                              // 'Distance - newr to far',
                              'Newer Jobs'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: const GoogleFonts.varela(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                            onChanged: (_) {
                              setState(() {
                                sortByd = _.toString();
                                searchAgain();
                              });
                            },
                          ), */
                        ],
                      ),
                    ),
                  ),
                ),
                //  if (usertype == 3)
                /*  Tab(
                  child: InkWell(
                    onTap: () {
                      searchAgain(
                          data: role == "1" || role == "2"
                              ? staticMap1
                              : staticMap);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(color: Constants.borderColor)),
                      height: 33.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("My Jobs"),
                          /* Image.asset(
                              "assets/images/updown.png",
                              height: 15.h,
                            ) */
                        ],
                      ),
                    ),
                  ),
                ), */
                Tab(
                  child: customTab("My Jobs", "assets/images/check.png", 1),
                ),
                /* Tab(child: customTab("New Jobs", "assets/images/check.png", 2)),
                Tab(
                    child: customTab(
                        "Work from home", "assets/images/check.png", 3)),
                Tab(child: customTab("Fresher", "assets/images/check.png", 4)),
                Tab(
                    child: customTab(
                        "Work from office", "assets/images/check.png", 5)),
                Tab(child: customTab("Hybrid", "assets/images/check.png", 6)),
                Tab(
                    child:
                        customTab("Recomended", "assets/images/check.png", 7)),
                Tab(
                    child:
                        customTab("Saved Jobs", "assets/images/check.png", 7)), */

                /*    Tab(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Colors.red, width: 1)),
                        child: const Center(
                            child: Text('Work From Home +')))), */
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
                  height: 30.h,
                  width: MediaQuery.of(context).size.width / 1.65.w,
                  child: TextField(
                    onChanged: (String q) {
                      searchText = q;
                      searchAgain();
                    },
                    controller: searchController,
                    enableInteractiveSelection:
                        false, // will disable paste operation
                    //focusNode: AlwaysDisabledFocusNode(),
                    /* onTap: () {
                      showSearch(
                          context: context,
                          delegate: DataSearch(
                              onSelected: (String q) =>
                                  {searchText = q, searchAgain()}));
                    }, */
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.search_outlined),
                      filled: true,
                      contentPadding:
                          const EdgeInsets.only(left: 14.0, bottom: 5, top: 5),
                      fillColor: Constants.themeBgColorLight,
                      hintText: 'Search company, process, role...',
                      hintStyle: GoogleFonts.varela(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    style: GoogleFonts.varela(
                      color: const Color.fromARGB(255, 177, 14, 3),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              SizedBox(
                // margin: const EdgeInsets.only(top: 10),
                // width: MediaQuery.of(context).size.height * 0.10.w,
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Icon(
                    Icons.pin_drop,
                    color: Constants.themeBgColor,
                    size: 15.h,
                  ),
                  GestureDetector(
                      onTap: (() async {
                        bool istrue = false;
                        TextEditingController loc = TextEditingController();
                        // searchLocation(context); // old
                        // searchAgain();
                        searchLocation(context);

                        /* showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only()),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                height:
                                    MediaQuery.of(context).size.height / 1.16,
                                child: Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Change Location",
                                        style: GoogleFonts.varela(
                                            color: Constants.themeBgColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          searchLocation(context);
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Which city do you want to work in?",
                                                  style: GoogleFonts.varela(
                                                      color: Colors.grey)),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text.rich(
                                                  TextSpan(
                                                      text:
                                                          user_selected_lcoation ??
                                                              '',
                                                      style:
                                                          GoogleFonts.varela()),
                                                ),
                                              ),
                                              const Divider(),
                                              SizedBox(
                                                height: 20.h,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ThemeButton(
                                            width: 100.w,
                                            radious: 30,
                                            themeButtonSize:
                                                ThemeButtonSize.small,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            text: "Cancel",
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          ThemeButton(
                                            width: 100.w,
                                            radious: 30,
                                            themeButtonSize:
                                                ThemeButtonSize.small,
                                            onPressed: () {
                                              searchAgain();
                                              Navigator.pop(context);
                                            },
                                            text: "Submit",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }); */
                      }),
                      child: Text(
                          user_selected_lcoation == "" &&
                                  user_selected_lcoation == null
                              ? 'Select Location'
                              : user_selected_lcoation,
                          style: GoogleFonts.varela(
                            color: Constants.themeBgColor,
                            fontSize: 14.sp,
                            //fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ))

                      /* Text.rich(
                        TextSpan(
                          text: '',
                          style: const GoogleFonts.varela(
                              color: Colors.red, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: user_selected_lcoation ?? '',
                                style: const GoogleFonts.varela(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                )),
                            // can add more TextSpans here...
                          ],
                        ),
                      ) */

                      // const Text(
                      //   "Searching jobs in $localtion",
                      //   style: GoogleFonts.varela(color: Colors.white, fontSize: 18),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      ),
                ]),
              ),
            ],
          ),

          // bottom: const PreferredSize(
          //     child: Text(
          //       "Search New Jobs",
          //       style:
          //           GoogleFonts.varela(color: Colors.white, fontWeight: FontWeight.bold),
          //     ),
          //     preferredSize: Size.zero),
          elevation: 0,
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          // actions: [
          //   // IconButton(
          //   //     onPressed: () {
          //   //       showSearch(context: context, delegate: DataSearch());
          //   //     },
          //   //     icon: const Icon(Icons.search_outlined)),
          //   SizedBox(
          //     width: 10,
          //   ),

          //   SizedBox(
          //     width: 100,
          //     child: Row(children: const [
          //       Icon(Icons.pin_drop),
          //       Expanded(
          //         child: Text(
          //           "Mumbai",
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //     ]),
          //   )
          // ],
        ),
        //  backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              // Text(profileSummaryModel.mobile.toString()),
              // const SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 40,
              //   child: ListView.builder(
              //     itemBuilder: (BuildContext, index) {
              //       return GestureDetector(
              //         onTap: (() =>
              //             {selectedJobTypeIndex = index, setState(() {})}),
              //         child: Container(
              //           alignment: Alignment.center,
              //           margin: EdgeInsets.symmetric(
              //               horizontal: index < filterJobType.length ? 5 : 0),
              //           padding: const EdgeInsets.symmetric(horizontal: 20),
              //           decoration: BoxDecoration(
              //               color: selectedJobTypeIndex == index
              //                   ? Colors.white.withOpacity(0.7)
              //                   : Colors.white.withOpacity(0.2),
              //               borderRadius: BorderRadius.circular(60)),
              //           child: Text(
              //             filterJobType[index].toString(),
              //             style: GoogleFonts.varela(
              //                 fontSize: 16,
              //                 color: selectedJobTypeIndex == index
              //                     ? Colors.black
              //                     : Colors.white),
              //           ),
              //         ),
              //       );
              //     },
              //     itemCount: filterJobType.length,
              //     padding: const EdgeInsets.all(5),
              //     scrollDirection: Axis.horizontal,
              //   ),
              // ),

              /*   const SizedBox(
                height: 5,
              ), */
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.only(top: 0),
                      decoration: const BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color.fromARGB(255, 245, 245, 245),
                        //     blurRadius: 10.0,
                        //     offset: Offset(2, 2),
                        //   ),
                        // ],
                        color: Constants.bgPanelColor,
                        //  color: Color(0xfff0f1fe),
                        /*  borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ) */
                      ),
                      child: Column(
                        children: [
                          /* Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 15,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      BottomDialog().showBottomDialog(
                                          context,
                                          IntrinsicHeight(
                                            child: Container(
                                                width: double.maxFinite,
                                                clipBehavior: Clip.antiAlias,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                decoration:
                                                    const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            150,
                                                    child:
                                                        const JobFilter())),
                                          ),
                                          true,
                                          controller:
                                              bottomSheetDialogController);
                                    },
                                    child: Visibility(
                                      visible: false,
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.filter_alt_outlined,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Filter",
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.varela(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /* SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // const Text("Sort by"),
          
                                      DropdownButton<String>(
                                        icon: const Icon(
                                          Icons.filter_list,
                                          color: Colors.black,
                                        ),
                                        underline: const SizedBox(),
                                        style: const GoogleFonts.varela(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                        value: sortByd,
                                        alignment: Alignment.bottomRight,
                                        items: <String>[
                                          'Recomended',
                                          // 'Salary - high to low',
                                          // 'Distance - newr to far',
                                          'Newer Jobs'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: const GoogleFonts.varela(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          );
                                        }).toList(),
                                        onChanged: (_) {
                                          setState(() {
                                            sortByd = _.toString();
                                            searchAgain();
                                            setState(() {});
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ), */
                              ],
                            ),
                          ), */
                          Expanded(
                            flex: 1,
                            child: SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              header: const WaterDropHeader(),
                              footer: CustomFooter(
                                builder:
                                    (BuildContext context, LoadStatus? mode) {
                                  Widget body;
                                  if (mode == LoadStatus.idle) {
                                    body = const Text("");
                                  } else if (mode == LoadStatus.loading) {
                                    body = const CupertinoActivityIndicator();
                                  } else if (mode == LoadStatus.failed) {
                                    body =
                                        const Text("Load Failed! Click retry!");
                                  } else if (mode == LoadStatus.canLoading) {
                                    body = const Text("Release to load more");
                                  } else {
                                    body = Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        const Text("No more jobs available!"),
                                      ],
                                    );
                                  }
                                  return SizedBox(
                                    height: 55.0.h,
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onRefresh: () async {
                                log(isSelect.toString());
                                await _onRefreshForMyJobs(
                                    data: !isSelect
                                        ? null
                                        : role == "1" || role == "2"
                                            ? staticMap1
                                            : staticMap);
                              },
                              /*  : () async {
                                      log(isSelect.toString());
                                      await _onRefresh();
                                    }, */
                              onLoading: _onLoading,
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
                                    /*   /*   SizedBox(               //suggestion
                                      height: 5.h,
                                    ), */
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (searchText != "")
                                          RichText(
                                            text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          " for " + searchText,
                                                      style: GoogleFonts.varela(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          color: Colors.black)),
                                                  TextSpan(
                                                      text:
                                                          " in $user_selected_lcoation ",
                                                      style: GoogleFonts.varela(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black)),
                                                ],
                                                text: "Jobs",
                                                style: GoogleFonts.varela(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black)),
                                          ),
                                        if (searchText != "")
                                          IconButton(
                                              onPressed: () => {
                                                    searchText = "",
                                                    searchAgain(),
                                                    setState(() => {})
                                                  },
                                              icon: const Icon(
                                                Icons.highlight_off,
                                                size: 19,
                                              ))
                                      ],
                                    ), */
                                    Visibility(
                                      visible: jobItems.isEmpty &&
                                          !_isLoadMoreRunning,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "./assets/images/unboxing.gif",
                                              height: 125.0.h,
                                              width: 125.0.w,
                                            ),
                                            Text(
                                              "No jobs available here. \r\nTry another location, company, role etc..",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.varela(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
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
                                        return GestureDetector(
                                            onTap: () {
                                              /*   Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobDetails(
                                                            id: int.parse(
                                                              (jobItems[index]
                                                                  ["id"]),
                                                            ),
                                                            userId: profilemodel
                                                                .id
                                                                .toString(),
                                                          ))); */
                                              Navigator.pushNamed(
                                                context,
                                                ERoute.jobsdetail.name,
                                                arguments: {
                                                  'id': jobItems[index]["id"],
                                                },
                                              );

                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               JobDetails(
                                              //                 id: jobItems[index]
                                              //                     ['id'],
                                              //               )));
                                            },
                                            child: Column(
                                              children: [
                                                listViewItem_new(
                                                    context,
                                                    index,
                                                    jobItems[index],
                                                    jobs.contains(
                                                            jobItems[index]
                                                                ["id"])
                                                        ? true
                                                        : false),
                                                SizedBox(
                                                  height: 7.h,
                                                )
                                              ],
                                            ));
                                      },
                                      itemCount: jobItems.length,
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
  }

  nav() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CareerAssets()));
  }

  showCustomModelBottomSheet(
    BuildContext context,
  ) {
    bool isNext = false;

    return showModalBottomSheet<void>(
        // context and builder are
        // required properties in this widget
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState1) {
            return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  pages(isNext, true, context),
                  pages(isNext, false, context),
                ]);
          });
        });
  }

  Widget pages(bool isNext, bool isFirst, BuildContext context) {
    bool isSelected1 = false;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              isFirst
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "All Filter",
                            style: GoogleFonts.varela(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Clear All",
                              style: GoogleFonts.varela(
                                  color: Constants.themeBgColor),
                            ),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _controller.previousPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 10),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 16.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Apply Filter",
                                  style: GoogleFonts.varela(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Clear",
                              style: GoogleFonts.varela(
                                  color: Constants.themeBgColor),
                            ),
                          )
                        ],
                      ),
                    ),
              isFirst
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTiles("Company", isNext),
                        customTiles("Nature of work", isNext),
                        customTiles("Skills", isNext),
                        customTiles("Role / Designation", isNext),
                        customTiles("Education", isNext),
                        customTiles("Experience", isNext),
                        customTiles("Shift", isNext),
                        customTiles("Week off", isNext),
                        customTiles("Salary", isNext),
                        customTiles("Languages", isNext),
                        customTiles("Job Type", isNext),
                        customTiles("Locality", isNext),
                      ],
                    )
                  : SizedBox(
                      // height: MediaQuery.of(context).size.height / 2.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 35,
                            child: TextField(
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Constants.themeBgColorLight,
                                  contentPadding: const EdgeInsets.all(8),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Constants.borderColor)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Constants.borderColor)),
                                  hintText: "Search Company"),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelected1 = !isSelected1;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Company 1",
                                        style:
                                            GoogleFonts.varela(fontSize: 14.sp),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Icon(
                                        Icons.add,
                                        size: 14.h,
                                      )
                                    ],
                                  ),
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: isSelected1
                                          ? Constants.themeBgColor
                                          : Colors.white,
                                      border: Border.all(
                                        color: Constants.borderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.6.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Next",
                                  style: GoogleFonts.varela(
                                      fontWeight: FontWeight.bold,
                                      color: Constants.themeBgColor),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.themeBgColor),
                                    borderRadius: BorderRadius.circular(15)),
                              )
                            ],
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        //  height: MediaQuery.of(context).size.height / 2.h,
        width: double.maxFinite,
      ),
    );
  }

  Widget customTiles(String title, bool isNext) {
    return Column(
      children: [
        const Divider(),
        InkWell(
          onTap: () {
            title == "Company"
                ? _controller.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  )
                : () {};
          },
          child: Container(
            width: double.maxFinite,
            child: Text(
              title,
              style: GoogleFonts.varela(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            // margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.symmetric(vertical: 5),
            // decoration: BoxDecoration(border: Border.all(color: Constants.borderColor)),
          ),
        ),
      ],
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

  /*  bindLocation() async {
    var result = await MasterService().masterGetByGroups(
        {'groupName': 'city', 'pageNumber': '1', 'pageSize': '1500'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      dynamic resultValue = Utils.parseResponse(result).resultData['content'];
      for (var i = 0; i < resultValue.length; i++) {
        locations.add(LocationItem(
            id: resultValue[i]['id'], name: resultValue[i]['value']));
      }
    }
    return "done";
  } */

  Future<MyModel> bindLocation() async {
    const apiUrl =
        "http://${GlobalConstants.API_Host_one}/jobs/v1/city?pageNumber=1&pageSize=1000";
    List<String> cityList = [];

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        MyModel myModel = MyModel.fromJson(jsonData);

        if (myModel.resultData?.content != null) {
          for (Content content in myModel.resultData!.content!) {
            if (content.name != null) {
              locations.add(Content(id: content.id, name: content.name));
            }
          }
        }

        return myModel;
      } else {
        throw Exception(
            'Failed to fetch data from the API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching data from the API: $e');
    }
  }

  void bindBanner() async {
    var bannerResult = await MasterService().masterGetByGroups(
        {'groupName': 'banner', 'pageNumber': '1', 'pageSize': '1'});
    if (Utils.parseResponse(bannerResult).resultKey == 'SUCCESS') {
      dynamic resultValues =
          Utils.parseResponse(bannerResult).resultData['content'];
      if (resultValues.length > 0) {
        var bannerData = resultValues[0]['value'];
        if (resultValues[0]['active'] == 1) {
          bannerUrl = GlobalConstants.ASSET_URL + bannerData;
          isbannerVisible = true;
        }
      }
      setState(() {});
    }
  }

  Widget listViewItem(BuildContext context, int index, item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            // Stack(
            //   children: [
            //     Image.network(
            //       item['icon'],
            //       errorBuilder: ((context, error, stackTrace) => Image.asset(
            //           "assets/images/company.png",
            //           height: 80,
            //           width: 80,
            //           fit: BoxFit.contain)),
            //       height: 80,
            //       width: 80,
            //       fit: BoxFit.contain,
            //     ),
            //     Container(
            //       height: 80,
            //       width: 80,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         backgroundBlendMode: BlendMode.darken,
            //         gradient: const LinearGradient(
            //             begin: FractionalOffset.topCenter,
            //             end: FractionalOffset.bottomCenter,
            //             colors: [
            //               Color.fromARGB(57, 158, 158, 158),
            //               Color.fromARGB(203, 0, 0, 0),
            //             ],
            //             stops: [
            //               0.8,
            //               1.0
            //             ]),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: const [
            //             Text(
            //               "  ",
            //               style: GoogleFonts.varela(
            //                   color: Colors.white,
            //                   fontSize: 11,
            //                   fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     Container(
            //       color: Colors.amber,
            //     )
            //   ],
            // ),
            // const SizedBox(
            //   width: 20,
            // ),
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['companyname'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varela(
                          fontWeight: FontWeight.w700, fontSize: 15.sp),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    if (item['location'] != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            item['location'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                                color: Colors.black54, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item['rolename'] != null)
                            Text(
                              item['rolename'],
                              style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.sp),
                            ),
                          if (item['process'] != null)
                            Text(
                              item['process'],
                              style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    // ThemeButton(
                    //   onPressed: () {},
                    //   text: "APPLY",
                    //   width: 130,
                    //   radious: 5,
                    //   color: Colors.green,
                    //   themeButtonSize: ThemeButtonSize.xsmall,
                    // )
                  ],
                )),

            const Icon(Icons.navigate_next),
            // TextButton(
            //   onPressed: (() {
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //         builder: (context) => const JobDetails()));
            //   }),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     children: const [Icon(Icons.navigate_next)],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget listViewItem_new(BuildContext context, int index, item, bool isTrue) {
    var favProvider = ref.watch(favJobProvider(item['id'] ?? 0));
    String _colorName;
    Color _color;
    List<String>? myStrings;
    List<String> updatedList = [];
    bool stopIteration = false;
    if (item['skills'] != null) {
      myStrings = item['skills'].split(",");
      updatedList = myStrings!.map((item) => item.trim()).toList();

      // do something with the parts array
    } else {
      // handle the case where str is null
    }

    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            //set border radius more than 50% of height and width to make circle
          ),
          // shadowColor: Constants.themeBgColor,
          elevation: 4,
          // padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 1),
          /* decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color.fromARGB(255, 213, 213, 213),
                width: 0.0.w,
                style: BorderStyle.solid), //Border.all
        
            borderRadius: BorderRadius.circular(10.r),
            //BorderRadius.only
            /************************************/
            /* The BoxShadow widget  is here */
            /************************************/
            boxShadow: [
              BoxShadow(
                color: Colors.amber.shade100,
                offset: const Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ), //BoxShadow
            ],
          ), */
          // margin: const EdgeInsets.only(bottom: 10),
          // elevation: 0.1,
          child: Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h, top: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /* const Icon(
                      Icons.account_balance,
                      size: 20,
                      color: Color.fromARGB(255, 118, 118, 118),
                    ), */

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['rolename'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (item['process'] != null)
                                Text(
                                  item['process'].toString(),
                                  style: GoogleFonts.varela(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
                                ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "||",
                                style: GoogleFonts.varela(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              // if (item["0"] != null)
                              Text(
                                item['naturofwork'].toString(),
                                style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              )
                              // item['process']
                              /*  Image.asset(
                          "assets/images/compny.png",
                          height: 17.h,
                          // color: Colors.black,
                          ), */

                              // if (item['process'] != null)
                              //   Text(
                              //     item['process'],
                              //     style: const GoogleFonts.varela(
                              //         color: Colors.black54,
                              //         fontWeight: FontWeight.normal,
                              //         fontSize: 13),
                              //   ),
                              // if (item['rolename'] != null)
                              //   const Text(
                              //     " | ",
                              //     style: GoogleFonts.varela(
                              //         color: Colors.black54,
                              //         fontWeight: FontWeight.normal,
                              //         fontSize: 13),
                              //   ),
                              // if (item['rolename'] != null)
                            ],
                          ),
                        ],
                      ),
                    ),
                    /* Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        favProvider
                                .whenData(
                                  (value) => IconButton(
                                      onPressed: () async {
                                        if (value?.isFav ?? false) {
                                          await removeFromFav(value!.id);
                                        } else {
                                          await addToFav(value?.jobDetails.id ??
                                              item['id'] ??
                                              0);
                                        }
        
                                        ref.refresh(favJobProvider(item['id'] ??
                                            0)); //yeha null hai value
                                      },
                                      icon: Icon(
                                          /*   jobs[index]["id"].toString() ==
                                        item[index]["id"].toString() */
                                          value?.isFav ?? false
                                              ? Icons.bookmark
                                              : Icons.bookmark_border_outlined,
                                          size: 18.h,
                                          color: Constants.themeBgColor)),
                                )
                                .valueOrNull ??
                            const SizedBox.shrink(),
                        IconButton(
                            onPressed: () async {
                              const url =
                                  "https://wa.me/?text=Hey buddy, try this super cool new app!";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(Icons.share,
                                size: 15.h, color: Constants.themeBgColor)),
                      ],
                    )), */
                  ],
                ),
                /*  const SizedBox(
                  height: 15,
                ),
                Text(
                  item['salary'] ?? '',
                  style: const GoogleFonts.varela(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ), */
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  if (item['companyname'] != null) //&&
                      // item['process'] != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Image.asset(
                              "assets/images/cmpny.png",
                              height: 12.h,
                            ),
                          ),
                          /* SizedBox(
                            child: Icon(
                              Icons.business_outlined,
                              size: 12.h,
                              color: Constants.subtitleclr,
                            ),
                          ), */
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            item['companyname'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                                // color: Colors.black54,
                                color: Constants.subtitleclr,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          ),
                        ],
                      ),
                      item["isfresher"] == "Fresher"
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
                          : (item["total_experience"] != null)
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
                                    item["maxexperience"] == "& above"
                                        ? item["minexperience"] == "0.6"
                                            ? Text(
                                                // "${item["minexperience"].replaceAll(".0", "")} Years & above.",
                                                "6 Month & Above.",
                                                style: GoogleFonts.varela(
                                                    // color: Colors.black54,
                                                    color:
                                                        Constants.subtitleclr,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13.sp),
                                              )
                                            : Text(
                                                "${item["minexperience"].replaceAll(".0", "")} Years & above.",
                                                style: GoogleFonts.varela(
                                                    // color: Colors.black54,
                                                    color:
                                                        Constants.subtitleclr,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13.sp),
                                              )
                                        : Text(
                                            "${item["minexperience"].replaceAll(".0", "")} - ${item["maxexperience"].replaceAll(".0", "")} Years",
                                            style: GoogleFonts.varela(
                                                // color: Colors.black54,
                                                color: Constants.subtitleclr,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13.sp),
                                          )
                                  ],
                                )
                              : const SizedBox(),

                      if (item['minctc'] != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              ConstImageUrl.wallet,
                              height: 14.h,
                            ),
                            /* Icon(
                              Icons.currency_rupee,
                              size: 13.h,
                              color: Constants.subtitleclr,
                            ), */
                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              formatSalaryRange(item['minctc'].toInt(),
                                  item['maxctc'].toInt()),
                              style: GoogleFonts.varela(
                                fontSize: 13.sp,
                                color: Constants.subtitleclr,
                              ),
                            ),
                            if (item['ismonthly'] != "")
                              Text(
                                " ${item['ismonthly']}",
                                style: GoogleFonts.varela(
                                  fontSize: 13.sp,
                                  color: Constants.subtitleclr,
                                ),
                              )

                            /* Text(
                              item['total_salary'],
                              style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            ) */
                          ],
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/loc.png",
                            height: 14.sp,
                          ),
                          /* Icon(
                            Icons.pin_drop_outlined,
                            size: 13.sp,
                            color: Constants.subtitleclr,
                          ), */
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            item['location'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.varela(
                              fontSize: 13.sp,
                              color: Constants.subtitleclr,
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
                if (updatedList != null)
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    children: [
                      ...updatedList
                          .take(5)
                          .map(
                            (item) => Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "#$item"
                                    .replaceAll('"', '')
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: GoogleFonts.varela(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      if (updatedList.length > 5)
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          //   margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Constants.borderColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${updatedList.length - 5}'
                                .replaceAll('"', '')
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            style: GoogleFonts.varela(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      /*  Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '+${myStrings.length - 5} more',
                            style: const GoogleFonts.varela(color: Colors.white),
                          ),
                        ), */
                    ],
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  color: Colors.grey.shade400,
                  width: double.maxFinite,
                  height: 0.5.h,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        usertype == 3 && profilemodel.id == item['spoc']
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MatchingJobs()));
                                  /* JobPostApiService.postJobApply(
                              jobId: item['id'],
                              userId: int.parse(profilemodel.id.toString()),
                              context: context);
                          /*  Navigator.pushNamed(context, ERoute.application.name,
                              arguments: {
                                "isnew": false,
                                "prevModel": jobDetailsModel,
                                "refer": true,
                                "cmpnyname": item['companyname'].toString()
                              }); */ */
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.subtitleclr),
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
                        //TODO: old code to display matching jobs and tag line as per login type.
                        /* usertype == 3
                            ? profilemodel.id == item['spoc']
                                ? Visibility(
                                    visible: usertype == 3,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MatchingJobs()));
                                        /* JobPostApiService.postJobApply(
                              jobId: item['id'],
                              userId: int.parse(profilemodel.id.toString()),
                              context: context);
                          /*  Navigator.pushNamed(context, ERoute.application.name,
                              arguments: {
                                "isnew": false,
                                "prevModel": jobDetailsModel,
                                "refer": true,
                                "cmpnyname": item['companyname'].toString()
                              }); */ */
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.h, horizontal: 8.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constants.subtitleclr),
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    ),
                                  )
                                : SizedBox(
                                    child: Text(
                                      //𝘧𝘳𝘦𝘦 𝘢𝘯𝘥 𝘷𝘦𝘳𝘪𝘧𝘪𝘦𝘥 𝘑𝘰𝘣
                                      "Asking payment strictly prohibited",
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.subtitleclr),
                                      softWrap: true,
                                    ),
                                  )
                            : SizedBox(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/verified.png",
                                      height: 16.h,
                                      color: Constants.themeBgColor,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      //𝘧𝘳𝘦𝘦 𝘢𝘯𝘥 𝘷𝘦𝘳𝘪𝘧𝘪𝘦𝘥 𝘑𝘰𝘣
                                      "100% free and verified Job",
                                      style: GoogleFonts.varela(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.subtitleclr),
                                    ),
                                  ],
                                ),
                              ) */
                      ],
                    ),
                    const Spacer(),
                    Visibility(
                      visible: usertype == 3,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddResume(
                                        company_name: item['companyname'],
                                        role: item['rolename'],
                                        process: item['process'],
                                        nature_of_work: item['naturofwork'],
                                        company_id: item['compnayid'],
                                        jobId: item['id'],
                                        sourceId: profilemodel.id != null
                                            ? profilemodel.id!.toInt()
                                            : 0,
                                        sourceName:
                                            "${profilemodel.first_name.toString()} ${profilemodel.last_name.toString()}",
                                        isRefer: false,
                                        spocId: item['spoc'],
                                      )));
                          /* JobPostApiService.postJobApply(
                              jobId: item['id'],
                              userId: int.parse(profilemodel.id.toString()),
                              context: context);
                          /*  Navigator.pushNamed(context, ERoute.application.name,
                              arguments: {
                                "isnew": false,
                                "prevModel": jobDetailsModel,
                                "refer": true,
                                "cmpnyname": item['companyname'].toString()
                              }); */ */
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.themeBgColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: Constants.themeBgColor,
                                size: 15.h,
                              ),
                              Text(
                                "Resume",
                                style: TextStyle(
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
                      visible: usertype == 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoInternet()));
                          /*  JobPostApiService.postJobApply(
                              jobId: item['id'],
                              userId: int.parse(profilemodel.id.toString()),
                              context: context); */
                          /*  Navigator.pushNamed(context, ERoute.application.name,
                              arguments: {
                                "isnew": false,
                                "prevModel": jobDetailsModel,
                                "refer": true,
                                "cmpnyname": item['companyname'].toString()
                              }); */
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                              border: Border.all(color: Constants.themeBgColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Apply",
                            style: GoogleFonts.varela(
                                color: Constants.themeBgColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                    /* ThemeButton(
                      color: Constants.themeBgColor,
                      width: 90.w,
                      radious: 30.r,
                      themeButtonSize: ThemeButtonSize.small,
                      onPressed: () {
                        Navigator.pushNamed(context, ERoute.application.name,
                            arguments: {
                              "isnew": false,
                              "prevModel": jobDetailsModel,
                            });
                      },
                      fontsize: 11.sp,
                      text: "Apply Now ",
                    ), */
                  ],
                ),
              ],
            ),
          ),
        ),
        item["spoc"].toString() == profilemodel.id.toString()
            ? Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: CircularMenu(
                  toggleButtonOnPressed: () {
                    setState(() {
                      isMenuOpen =
                          !isMenuOpen; // Toggle the menu open/close state
                    });
                  },
                  radius: 55.r,
                  alignment: Alignment.topRight,
                  backgroundWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(100.0),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.varela(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              children: const <TextSpan>[
                                //  TextSpan(text: 'Press the menu button'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  toggleButtonSize: isMenuOpen ? 24.h : 18.h,
                  toggleButtonMargin: 10,
                  toggleButtonPadding: 0,
                  startingAngleInRadian: 0.4 * pi,
                  endingAngleInRadian: 3.4,
                  curve: Curves.bounceInOut,
                  reverseCurve: Curves.bounceInOut,
                  toggleButtonIconColor: Constants.themeBgColor,
                  toggleButtonColor: Colors.transparent,
                  items: [
                    CircularMenuItem(
                        icon: Icons.delete_outlined,
                        color: Colors.transparent,
                        iconColor: Colors.red,
                        iconSize: 18.h,
                        onTap: () {
                          setState(() {
                            _color = Colors.red;
                            _colorName = 'red';
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Dialog Title'),
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
                                      Autogenerated model = Autogenerated(
                                          active: 0
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
                                      Map<String, dynamic> jsonData =
                                          model.toJson();
                                      JobPostApiService.jobInActive(
                                          jsonData, item['id']);
                                      _onRefresh();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                    CircularMenuItem(
                        icon: Icons.bookmark_add_outlined,
                        color: Colors.transparent,
                        iconColor: Colors.brown,
                        iconSize: 18.h,
                        onTap: () {
                          setState(() {
                            _color = Colors.brown;
                            _colorName = 'Brown';
                          });
                        }),
                    CircularMenuItem(
                        icon: Icons.share,
                        color: Colors.transparent,
                        iconColor: Colors.green,
                        iconSize: 18.h,
                        onTap: () async {
                          setState(() {
                            _color = Colors.green;
                            _colorName = 'Green';
                          });
                          const url =
                              "https://wa.me/?text=Hey buddy, try this super cool new app!";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                    CircularMenuItem(
                        icon: Icons.edit,
                        color: Colors.transparent,
                        iconColor: Colors.red,
                        iconSize: 18.h,
                        onTap: () {
                          setState(() {
                            _color = Colors.red;
                            _colorName = 'red';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobForm(
                                          formEdit: true,
                                          companyName:
                                              item['companyname'].toString(),
                                          companyId:
                                              item["compnayid"].toString(),
                                          jobTitle: item['rolename'].toString(),
                                          natureOfWork:
                                              item['naturofwork'].toString(),
                                          process: item['process'].toString(),
                                        )));
                          });
                        }),
                  ],
                ),
              )
            /*  : Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  isEdit = true;
                                });
                              },
                              icon: Icon(Icons.more_vert,
                                  size: 24.h, color: Constants.themeBgColor)),
                        ],
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                  ) */
            : Positioned(
                top: 0,
                right: 0,
                child: Container(
                  child: Column(
                    children: [
                      favProvider
                              .whenData(
                                (value) => IconButton(
                                    onPressed: () async {
                                      if (value?.isFav ?? false) {
                                        await removeFromFav(value!.id);
                                      } else {
                                        await addToFav(value?.jobDetails.id ??
                                            item['id'] ??
                                            0);
                                      }

                                      ref.refresh(favJobProvider(item['id'] ??
                                          0)); //yeha null hai value
                                    },
                                    icon: Icon(
                                        /*   jobs[index]["id"].toString() ==
                                      item[index]["id"].toString() */
                                        value?.isFav ?? false
                                            ? Icons.bookmark
                                            : Icons.bookmark_add_outlined,
                                        size: 18.h,
                                        color: Constants.themeBgColor)),
                              )
                              .valueOrNull ??
                          const SizedBox.shrink(),
                      IconButton(
                          onPressed: () async {
                            const url =
                                "https://wa.me/?text=Hey buddy, try this super cool new app!";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          icon: Icon(Icons.share,
                              size: 15.h, color: Constants.themeBgColor)),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  margin: const EdgeInsets.only(right: 10),
                ),
              ),
      ],
    );
  }

  Widget customSkill(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          //  color: Constants.themeBgColorLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Constants.subtitleclr, width: 0.5)),
      child: Text(
        title,
        style: GoogleFonts.varela(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Constants.subtitleclr),
      ),
    );
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false) {
      bindItems();
    }
  }

  void searchAgain({Map<String, String>? data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _page = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    jobItems = [];
    setState(() => {locationid = prefs.getInt("loc")!});
    bindItems(data: data);
  }

  void bindItems({Map<String, String>? data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getInt('loc') != null) {
        locationid = prefs.getInt('loc')!;
      }
      _isLoadMoreRunning = true;

      // Display a progress indicator at the bottom
    });
    _page += 1; // Increase _page by 1
    try {
      var seardData = {"page": _page.toString(), "size": _pageSize.toString()};
      if (locationid > 0 && data == null) {
        seardData['location'] = locationid.toString();
      }

      // seardData['sort'] = sortByd;
      seardData['sortType'] = 'asc';

      seardData['rolename'] = searchText;
      seardData['company'] = searchText;
      seardData['process'] = searchText;

      Map<String, String> finalData = {...seardData, if (data != null) ...data};
      var result = await JobSearchService().getJobSearch(finalData);
      RequestResult res = Utils.parseResponse(result);
      var list = res.resultData as List;
      setState(() {
        for (var item in list) {
          if (!jobItems.contains(item)) {
            jobItems.add(item);
          }
        }
        // jobItems.addAll(list);
        if (list.length < _pageSize) {
          _hasNextPage = false;
        }
      });
    } catch (err) {
      print(err);
    }
    setState(() {
      _isLoadMoreRunning = false;
      _refreshController
          .loadComplete(); // Display a progress indicator at the bottom
    });
  }

  void searchLocation(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // Set background color to transparent
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height /
            1.10, // Set the maximum height of the bottom sheet
      ),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {}, // Prevent tap event propagation
          child: LocationSearchBottomSheet(
            jobItems: jobItems,
            locations: locations,
            onSelected: (locationItem) async {
              String locationName = locationItem.name.toString();
              user_selected_lcoation = locationItem.name.toString();
              int locationId = int.parse(locationItem.id.toString());

              await prefs.setInt('loc', locationId);

              // Assuming `Utils` is a custom class you have defined
              await Utils.setPreference(
                null,
                ESharedPreferences.user_selected_lcoation.name,
                user_selected_lcoation.toString(),
              );

              await prefs.reload(); // Reload SharedPreferences

              // Assuming `searchAgain()` is a function you have defined
              searchAgain();

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<String> cities = [];
  List dataList = [];
  final recentCities = [];
  final Function(String) onSelected;
  @override
  TextInputAction get textInputAction => TextInputAction.none;

  @override
  String get searchFieldLabel => 'Search company, process, role...';

  DataSearch({required this.onSelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions

    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return const Card();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = cities
        .where(
            (element) => element.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                //showResults(context);
                close(context, query);
                onSelected(query);
              },
              leading: const Icon(Icons.search),
              title: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: query,
                          style: GoogleFonts.varela(
                              fontWeight: FontWeight.normal,
                              color: Colors.black))
                    ],
                    text: "Search for ",
                    style: GoogleFonts.varela(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
        itemCount: 1);
  }

  // void locationList() async {
  //   var result = await UserDataService().masterGetByGroup(
  //       {'groupName': 'location', 'pageNumber': '1', 'pageSize': '10'});
  //   if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
  //     ddlValues = Utils.parseResponse(result).resultData;
  //     // list=ddlValues["content"];

  //     jobLocationList = (ddlValues["content"] as List)
  //         .map<AutoCompleteModel>(
  //             (e) => AutoCompleteModel(e['id'].toString(), e['value'], e))
  //         .toList();
  //     final productId = ModalRoute.of(context)!.settings.arguments;
  //     print(productId);
  //     setState(() {
  //       selectedLocation = AutoCompleteModel("0", "", {});
  //     });
  //   }
  // }
}

class LocationItem {
  String? name;
  int? id;
  LocationItem({this.name, this.id});
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
