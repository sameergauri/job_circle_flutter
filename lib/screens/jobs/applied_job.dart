import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_details_model.dart';
import 'package:job_circle/screens/jobs/report.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../themes/colors.dart';

//enum Issue { no, incorrect, recruiter, other }

class AppliedJob extends StatefulWidget {
  const AppliedJob({
    super.key,
  });

  @override
  State<AppliedJob> createState() => _AppliedJobState();
}

class _AppliedJobState extends State<AppliedJob>
    with SingleTickerProviderStateMixin {
  JobDetailsModel jobDetailsModel = JobDetailsModel();
  var _isLoadMoreRunning = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool saved = false;
  var _page = 0;
  var locationid = 0;
  final _pageSize = 15;
  var sortByd = "Recomended";
  var _hasNextPage = true;
  var _isFirstLoadRunning = false;
  var localtion = "";
  var licationid = 0;
  late var usertype = -1;
  var role = "0";
  String bannerUrl = "";
  var searchText = "";
  bool isbannerVisible = false;
  late List jobItems = [];
  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
    //  bindInit();
    fetchData();
    // bindInit();
  }

  void bindInit() async {
    fetchData();
    //_controllerListView = ScrollController()..addListener(_loadMore);

    setState(() {});
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false) {
      fetchData();
    }
  }

  void searchAgain() async {
    _page = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    jobItems = [];
    setState(() => {});
    fetchData();
  }

  late List<dynamic> data;
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse('http://192.168.2.108:9090/jobs/v2/search?status=APPLIED'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      data = jsonDecode(response.body);
      var list = data;
      setState(() {
        jobItems.addAll(list);
        print(jobItems);
      });
      return jobItems;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  /* void bindItems() async {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    });
    _page += 1; // Increase _page by 1
    try {
      Future<void> fetchJobs() async {
        Uri url = Uri.parse('http://192.168.2.101:9090/jobs/v2');
        final response = await http.get(url, headers: {
          "Content-Type": "application/json"
        }); // replace with your API endpoint
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print(data);
          var list = data as List;
          setState(() {
            jobItems.addAll(list);
            print(jobItems);
          });
        } else {
          print("Somthing Wrong");
          // handle error
        }
      }
    } catch (err) {
      print(err);
    }
    setState(() {
      _isLoadMoreRunning = false;
      _refreshController
          .loadComplete(); // Display a progress indicator at the bottom
    });
  } */

  late final TabController _tabController =
      TabController(length: 5, vsync: this);

  int? cutTab;
  // ignore: deprecated_member_use, prefer_collection_literals

  //Issue? _issue;
  final bool _show = true;
  int _radioValue = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    print("first" + value.toString() + "radiovalue" + _radioValue.toString());
  }

  String dropdownvalue = 'recruiter 1';
  bool num = false;

  // List of items in our dropdown menu
  var items = [
    'recruiter 1',
    'recruiter 2',
    'recruiter 3',
    'recruiter 4',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text(
            "Application status",
            style: TextStyle(color: Colors.black),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(0, 35.1),
            child: TabBar(
              labelPadding: const EdgeInsets.only(left: 5, right: 5),
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              splashBorderRadius: BorderRadius.circular(50),
              //indicatorSize: TabBarIndicatorSize.label,
              // indicatorWeight: 0,
              indicator: BoxDecoration(
                  color: Constants.borderColor,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: Constants.borderColor) // Creates border
                  ),
              onTap: (value) {
                setState(() {
                  cutTab = value;
                });
              },

              isScrollable: true,
              tabs: [
                /* Tab(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        // context and builder are
                        // required properties in this widget
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  "Apply Filter",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            height: MediaQuery.of(context).size.height / 2.h,
                            width: double.maxFinite,
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(color: Constants.borderColor)),
                    height: 33.h,
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
                            style: const TextStyle(
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
                                    style: const TextStyle(
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
              Tab(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(color: Constants.borderColor)),
                    height: 33.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Salary"),
                        Image.asset(
                          "assets/images/updown.png",
                          height: 15.h,
                        )
                      ],
                    ),
                  ),
                ),
              ), */
                Tab(
                    child: customTab(
                        "Application Sent", "assets/images/check.png", 2)),
                Tab(
                    child:
                        customTab("Processing", "assets/images/check.png", 3)),
                Tab(
                    child: customTab(
                        "Interview Schedule", "assets/images/check.png", 4)),
                Tab(child: customTab("Selected", "assets/images/check.png", 5)),
                Tab(child: customTab("Rejected", "assets/images/check.png", 6)),

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
        ),
        body: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ERoute.jobsdetail.name,
                    arguments: {'id': jobItems[index]['id']},
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
                    listViewItem_new(context, index, jobItems[index], true),
                    SizedBox(
                      height: 12.h,
                    )
                  ],
                ));
          },
          itemCount: jobItems.length,
          padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          scrollDirection: Axis.vertical,
        )
        /* SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customContainer(context, "Executive", "Gebs Healthcare Solution",
                "Airoli, Andheri", "15,000 - 28,000 per month"),
            customContainer(
                context,
                "Sr. AR Associate",
                "Gebs Healthcare Solution",
                "Airoli, Andheri",
                "18,000 - 28,000 per month"),
            customContainer(context, "Team Leader", "ICICI Lombard", "Vashi",
                "18,000 - 28,000 per month"),
            customContainer(context, "Team Leader", "ICICI Lombard", "Vashi",
                "18,000 - 28,000 per month"),
            customContainer(context, "Team Leader", "ICICI Lombard", "Vashi",
                "18,000 - 28,000 per month"),
          ],
        ),
      ), */
        );
  }

  Widget listViewItem_new(BuildContext context, int index, item, bool isTrue) {
    List<String>? myStrings;
    bool stopIteration = false;
    if (item['skills'] != null) {
      myStrings = item['skills'].split(",");
      // do something with the parts array
    } else {
      // handle the case where str is null
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        //set border radius more than 50% of height and width to make circle
      ),
      shadowColor: Constants.themeBgColor,
      elevation: 4,
      // padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
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

                Column(
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
                        Image.asset(
                          "assets/images/proces.png",
                          height: 12.h,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (item['process'] != null)
                          Text(
                            item['process'],
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          "|",
                          style: GoogleFonts.varela(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        if (item["naturofwork"] != null)
                          Text(
                            item['naturofwork'].toString(),
                            style: GoogleFonts.varela(
                                fontWeight: FontWeight.w500, fontSize: 14.sp),
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
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    /* IconButton(
                        onPressed: () {
                          /*  posSaveData(item);
                          setState(() {
                            // saved = !saved;
                          });
                          /*  setState(() {
                            _handleItemTap(jobItems[index]);
                           
                          }); */ */
                        },
                        icon: Icon(
                            /*   jobs[index]["id"].toString() ==
                                    item[index]["id"].toString() */
                            isTrue
                                ? Icons.bookmark
                                : Icons.bookmark_border_outlined,
                            size: 18.h,
                            color: Constants.themeBgColor)), */
                    /* IconButton(
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
                            size: 15.h, color: Constants.themeBgColor)), */
                  ],
                )),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['companyname'] != null) //&&
                  // item['process'] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Icon(
                          Icons.business_outlined,
                          size: 12.h,
                          color: Constants.subtitleclr,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        item['companyname'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.varela(
                            // color: Colors.black54,
                            color: Constants.subtitleclr,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 2.h,
                ),
                item["minexperience"] == null
                    ? item["maxexperience"] == null
                        ? const SizedBox()
                        : const SizedBox()
                    : Row(
                        children: [
                          Image.asset(
                            "assets/images/bag.png",
                            height: 10.h,
                            color: Constants.subtitleclr,
                          ),
                          SizedBox(
                            width: 4.2.w,
                          ),
                          Text(
                            "${item["minexperience"]} - ${item["maxexperience"]} Year ",
                            style: GoogleFonts.varela(
                                // color: Colors.black54,
                                color: Constants.subtitleclr,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp),
                          )
                        ],
                      ),
                SizedBox(
                  height: 2.h,
                ),
                if (item['maxctc'] != null &&
                    item['minctc'] != null &&
                    item['minctc'] != 0.0 &&
                    item['maxctc'] != 0.0)
                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: 13.h,
                        color: Constants.subtitleclr,
                      ),
                      SizedBox(
                        width: 1.8.w,
                      ),
                      Text(
                        item['minctc'].toString(),
                        style: GoogleFonts.varela(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                      const Text(" - "),
                      Text(
                        item['maxctc'].toString(),
                        style: GoogleFonts.varela(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 15,
                      color: Constants.subtitleclr,
                    ),
                    SizedBox(
                      width: 3.4.w,
                    ),
                    Text(
                      item['location'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varela(
                        fontSize: 12.sp,
                        color: Constants.subtitleclr,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            if (myStrings != null)
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: stopIteration == false ? 3 : myStrings.length,
                      itemBuilder: (context, index) {
                        if (index == 3) {
                          stopIteration = true;
                        }
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: Text(myStrings![index]
                                .replaceAll('"', '')
                                .replaceAll('[', '')
                                .replaceAll(']', '')));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  const Text("+2")
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
                    SizedBox(
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
                    ),
                  ],
                ),

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
    );
  }

  Widget customTab(String title, String img, int select) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 9.5.h, horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: cutTab == select
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
              ));
  }

  Container customContainer(BuildContext context, String title,
      String cmpnyName, String loctn, String slry) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h, top: 5.h),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(2.0, 6.0),
            blurRadius: 10,
            spreadRadius: 2)
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Report()));
                  /* showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return SingleChildScrollView(
                            child: Container(
                                //height: MediaQuery.of(context).size.height,
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Column(
                                  children: [
                                    const Text(
                                      "What issue did you face?",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    customRadio(
                                        setState, "No Response from HR", 0),
                                    if (_radioValue == 0)
                                      Container(
                                        width: double.maxFinite,
                                        margin: const EdgeInsets.only(left: 24),
                                        padding: const EdgeInsets.only(
                                            left: 40, right: 40),
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 5),
                                            border: OutlineInputBorder(),
                                            hintText: 'Tell us what happened',
                                          ),
                                        ),
                                      ),
                                    customRadio(setState,
                                        "Incorrect Job Information", 1),
                                    if (_radioValue == 1)
                                      Container(
                                        width: double.maxFinite,
                                        margin: const EdgeInsets.only(left: 24),
                                        padding: const EdgeInsets.only(
                                            left: 40, right: 40),
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 5),
                                            border: OutlineInputBorder(),
                                            hintText:
                                                'Which info do you think incorrect',
                                          ),
                                        ),
                                      ),
                                    customRadio(setState,
                                        "Recruiter asked for money", 2),
                                    if (_radioValue == 2)
                                      Container(
                                          width: double.maxFinite,
                                          margin:
                                              const EdgeInsets.only(left: 24),
                                          padding: const EdgeInsets.only(
                                            left: 40,
                                          ),
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                    "Please provide the name of recruiter who asked for money or select other option if you dont know the name"),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    // color: Colors.amber,
                                                    width: 100.w,
                                                    height: 20,
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        value: dropdownvalue,
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        items: items.map(
                                                            (String items) {
                                                          return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items
                                                                .toString()),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            dropdownvalue =
                                                                newValue
                                                                    .toString();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  dropdownvalue == "other"
                                                      ? SizedBox(
                                                          width: 200.w,
                                                          child: TextField(
                                                            maxLength: 10,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          5),
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  "Recruiter Contact Number",
                                                              hintText:
                                                                  'Please Enter the contact number of that recruiter',
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                              Container(
                                                width: double.maxFinite,
                                                padding: const EdgeInsets.only(
                                                    //left: 40,
                                                    right: 40),
                                                child: const TextField(
                                                  decoration: InputDecoration(
                                                    prefix: Icon(Icons
                                                        .currency_rupee_rounded),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 5),
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText:
                                                        'How much money they asked',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    customRadio(setState, "Other", 3),
                                    if (_radioValue == 3)
                                      Container(
                                        width: double.maxFinite,
                                        margin: const EdgeInsets.only(left: 24),
                                        padding: const EdgeInsets.only(
                                            left: 40, right: 40),
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 5),
                                            border: OutlineInputBorder(),
                                            hintText:
                                                'Tell me about your issue',
                                          ),
                                        ),
                                      ),
                                    /*  RadioListTile(
                                      title: const Text(
                                          "Recruiter Asked for money"),
                                      value: Issue.recruiter,
                                      groupValue: _issue,
                                      onChanged: handleSelection,
                                    ),
                                    RadioListTile(
                                      title: const Text("Other"),
                                      value: Issue.other,
                                      groupValue: _issue,
                                      onChanged: handleSelection,
                                    ), */
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 20, top: 20, right: 10),
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        Constants.themeBgColor),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: const Text(
                                              "Submit",
                                              style: TextStyle(
                                                  color: Constants.themeBgColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        });
                      }); */
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Image.asset(
                    "assets/images/report.png",
                    height: 13.h,
                    color: Constants.themeBgColor,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/proces.png",
                height: 13.h,
                color: Colors.black,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Healthcare",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "|",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Blended",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
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
              //     style: const TextStyle(
              //         color: Colors.black54,
              //         fontWeight: FontWeight.normal,
              //         fontSize: 13),
              //   ),
              // if (item['rolename'] != null)
              //   const Text(
              //     " | ",
              //     style: TextStyle(
              //         color: Colors.black54,
              //         fontWeight: FontWeight.normal,
              //         fontSize: 13),
              //   ),
              // if (item['rolename'] != null)
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Icon(
                    Icons.currency_rupee,
                    size: 14.h,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const Icon(
                    Icons.location_pin,
                    size: 16,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                ],
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Company name",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        // color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700,
                        fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    slry,
                    style: TextStyle(
                        // color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade700,
                        fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Location",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13.sp),
                  ),
                ],
              )
            ],
          ),
          /* Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            cmpnyName,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.pin_drop_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(loctn)
            ],
          ),
          Row(
            children: [
              const Icon(Icons.currency_rupee_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(slry)
            ],
          ),
          const SizedBox(
            height: 20,
          ), */
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade200),
            width: double.infinity,
            child: Row(
              children: [
                Image.asset(
                  "assets/images/alert.png",
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Application sent succesfully",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "To improve chances, try similar jobs",
                      style: TextStyle(fontSize: 12.sp),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: const [
                    Icon(
                      Icons.phone_android,
                      size: 14,
                      color: Constants.themeBgColor,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      "Call Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/whatsapp.png",
                      height: 14.h,
                      color: Colors.greenAccent[400],
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      "Chat Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Constants.themeBgColor),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  "Similar Jobs",
                  style: TextStyle(
                      color: Constants.themeBgColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget customRadio(
    StateSetter setState,
    String title,
    int value,
  ) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      title: Text(title),
      leading: Radio(
        value: value,
        groupValue: _radioValue,
        onChanged: (value) {
          setState(() {
            _radioValue = value as int;
          });
          _handleRadioValueChange(value as int);
        },
      ),
    );
  }
}

/* Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey)),
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
                        style: const TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
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
                                style: const TextStyle(
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
                      ),
                    ],
                  ),
                ), */
