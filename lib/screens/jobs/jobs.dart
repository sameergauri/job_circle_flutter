import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/models/autocompleteModel.dart';
import 'package:job_circle/screens/jobs/job_filter.dart';
import 'package:job_circle/screens/webview/webviewd.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../service/masterService.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> with SingleTickerProviderStateMixin {
  final filterJobType = <String>[
    "All",
    "Work from home",
    "Part-time",
    "Night shift"
  ];

  late int selectedJobTypeIndex = 0;
  late List jobItems = [];
  List<String> citiesList = [];
  List<LocationItem> locations = [];
  late ScrollController _controllerListView;
  var searchText = "";
  var sortByd = "Recomended";
  var _page = 0;
  var _hasNextPage = true;
  var _isFirstLoadRunning = false;
  var _isLoadMoreRunning = false;
  final _pageSize = 15;
  var localtion = "";
  var licationid = 0;
  late var usertype = -1;
  var role = "0";
  String bannerUrl = "";
  bool isbannerVisible = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  BottomSheetController bottomSheetDialogController = BottomSheetController();

  var locationid = 0;

  var locationname = "";
  var user_selected_lcoation;

  void _onRefresh() async {
    // if failed,use refreshFailed()
    await Future.delayed(const Duration(milliseconds: 200));

    searchAgain();
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

  @override
  void initState() {
    super.initState();
    bindInit();
  }

  void bindInit() async {
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
    if (localtion != "") {
      user_selected_lcoation ?? localtion;
      await Utils.setPreference(
          null, ESharedPreferences.user_selected_lcoation.name, localtion);
    }

    await bindLocation();
    if (user_selected_lcoation == null) {
      searchLocation(context);
    }
    bindBanner();
    bindItems();
    //_controllerListView = ScrollController()..addListener(_loadMore);

    setState(() {});
  }

  @override
  void dispose() {
    //_controllerListView.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var _selectedIndex = 1;

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Visibility(
            visible: usertype == EUserType.employee.value && role != "4",
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WebviewData(
                              // url: "https://www.youtube.com/",
                              url: GlobalConstants.WEB_Host + "/mobile/jobform",
                              title: "New Job",
                            )));

                setState(() {});
              },
            )),
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            child: TextField(
              enableInteractiveSelection: false, // will disable paste operation
              focusNode: AlwaysDisabledFocusNode(),
              onTap: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(
                        onSelected: (String q) =>
                            {searchText = q, searchAgain()}));
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                filled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 0.0),
                fillColor: Colors.white,
                hintText: 'Search company, process, role...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          // bottom: const PreferredSize(
          //     child: Text(
          //       "Search New Jobs",
          //       style:
          //           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //     ),
          //     preferredSize: Size.zero),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
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
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
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
              //             style: TextStyle(
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
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  height: 30,
                  child: Row(children: [
                    const Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: (() {
                            searchLocation(context);
                          }),
                          child: Text.rich(
                            TextSpan(
                              text: 'Searching jobs in ',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                    text: user_selected_lcoation ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    )),
                                // can add more TextSpans here...
                              ],
                            ),
                          )

                          // const Text(
                          //   "Searching jobs in $localtion",
                          //   style: TextStyle(color: Colors.white, fontSize: 18),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 10, left: 15, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                decoration: const BoxDecoration(
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
                                                    child: const JobFilter())),
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
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
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
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                ),
                              ],
                            ),
                          ),
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
                                      children: const [
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("No more jobs available!"),
                                      ],
                                    );
                                  }
                                  return SizedBox(
                                    height: 55.0,
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (isbannerVisible)
                                      const SizedBox(
                                        height: 10,
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
                                              BorderRadius.circular(8),
                                        ),
                                        height: 80,
                                        margin: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        width: double.infinity,
                                      ),
                                    const SizedBox(
                                      height: 20,
                                    ),
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
                                                      style: const TextStyle(
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black)),
                                                ],
                                                text: "Jobs",
                                                style: const TextStyle(
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
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      visible: jobItems.length == 0 &&
                                          !_isLoadMoreRunning,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "./assets/images/unboxing.gif",
                                              height: 125.0,
                                              width: 125.0,
                                            ),
                                            const Text(
                                              "No jobs available here. \r\nTry another location, company, role etc..",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
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
                                              Navigator.pushNamed(
                                                context,
                                                ERoute.jobsdetail.name,
                                                arguments: {
                                                  'id': jobItems[index]['id']
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
                                                listViewItem_new(context, index,
                                                    jobItems[index]),
                                                const SizedBox(
                                                  height: 12,
                                                )
                                              ],
                                            ));
                                      },
                                      itemCount: jobItems.length,
                                      padding: const EdgeInsets.all(5),
                                      scrollDirection: Axis.vertical,
                                    ),
                                    if (_isLoadMoreRunning == true)
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 40),
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

  bindLocation() async {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            //               style: TextStyle(
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
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    if (item['location'] != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            item['location'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item['rolename'] != null)
                            Text(
                              item['rolename'],
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                          if (item['process'] != null)
                            Text(
                              item['process'],
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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

  Widget listViewItem_new(BuildContext context, int index, item) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 213, 213, 213),
              width: 0.0,
              style: BorderStyle.solid), //Border.all

          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          //BorderRadius.only
          /************************************/
          /* The BoxShadow widget  is here */
          /************************************/
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 219, 219, 219),
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
        ),
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0.1,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance,
                                size: 20,
                                color: Color.fromARGB(255, 118, 118, 118),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                item['companyname'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (item['rolename'] != null &&
                                    item['process'] != null)
                                  const Icon(
                                    Icons.person,
                                    size: 17,
                                    color: Color.fromARGB(255, 118, 118, 118),
                                  ),
                                const SizedBox(
                                  width: 5,
                                ),
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
                                Expanded(
                                  child: Text(
                                    item['process'] + " | " + item['rolename'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (item['location'] != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  size: 17,
                                  color: Color.fromARGB(255, 118, 118, 118),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    item['location'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      )),
                  const Icon(Icons.navigate_next),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false) {
      bindItems();
    }
  }

  void searchAgain() async {
    _page = 0;
    _hasNextPage = true;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    jobItems = [];
    setState(() => {});
    bindItems();
  }

  void bindItems() async {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    });
    _page += 1; // Increase _page by 1
    try {
      var seardData = {"page": _page.toString(), "size": _pageSize.toString()};
      if (locationid > 0) {
        seardData['location'] = locationid.toString();
      }

      seardData['sort'] = sortByd;
      seardData['sortType'] = 'asc';
      seardData['company'] = searchText;
      var result = await JobSearchService().getJobSearch(seardData);
      RequestResult res = Utils.parseResponse(result);
      var list = res.resultData as List;
      setState(() {
        jobItems.addAll(list);
        if (list.length < _pageSize) {
          _hasNextPage = false;
        }
      });
    } catch (err) {
      print('Something went wrong!');
    }
    setState(() {
      _isLoadMoreRunning = false;
      _refreshController
          .loadComplete(); // Display a progress indicator at the bottom
    });
  }

  void searchLocation(context) async {
    showSearch(
        context: context,
        delegate: LocationSearch(
            locations: locations,
            onSelected: (locationitem) async => {
                  locationname = locationitem.name.toString(),
                  user_selected_lcoation = locationitem.name.toString(),
                  locationid = int.parse(locationitem.id.toString()),
                  await Utils.setPreference(
                      null,
                      ESharedPreferences.user_selected_lcoation.name,
                      user_selected_lcoation.toString()),
                  searchAgain(),
                }));
  }
}

class DataSearch extends SearchDelegate<String> {
  List<String> cities = [];
  List dataList = [];
  final recentCities = [];
  final Function(String) onSelected;
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
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black))
                    ],
                    text: "Search for ",
                    style: const TextStyle(
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

class LocationSearch extends SearchDelegate<String> {
  List<LocationItem> locations = [];
  final Function(LocationItem) onSelected;

  LocationSearch({required this.locations, required this.onSelected});

  final cities = [];
  final recentCities = [];
  @override
  String get searchFieldLabel => 'Select City';

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
  void showResults(BuildContext context) {
    super.showResults(context);
    showSuggestions(context);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = locations
        .where((element) =>
            element.name!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          //showResults(context);
          onSelected(suggestionList[index]);
          close(context, query);
        },
        leading: const Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: suggestionList[index].name!.substring(query.length),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black))
              ],
              text: suggestionList[index].name!.substring(0, query.length),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
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
