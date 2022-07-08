import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../service/masterService.dart';

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
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

  var _page = 0;
  var _hasNextPage = true;
  var _isFirstLoadRunning = false;
  var _isLoadMoreRunning = false;
  final _pageSize = 10;
  var localtion = "";
  var licationid = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // if failed,use refreshFailed()
    await Future.delayed(Duration(milliseconds: 1000));
    bindItems();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    bindItems();
    _controllerListView = ScrollController()..addListener(_loadMore);
    bindLocation();
  }

  @override
  void dispose() {
    _controllerListView.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var _selectedIndex = 1;

    return Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: FloatingActionButton(
        //   // isExtended: true,

        //   child: const Icon(Icons.add),

        //   onPressed: () {
        //     Navigator.pushNamed(context, ERoute.application.name);

        //     setState(() {});
        //   },
        // ),
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            child: TextField(
              enableInteractiveSelection: false, // will disable paste operation
              focusNode: AlwaysDisabledFocusNode(),
              onTap: () {
                showSearch(context: context, delegate: DataSearch());
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                filled: true,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 0.0),
                fillColor: Colors.white,
                hintText: 'Search job...',
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
                            showSearch(
                                context: context,
                                delegate: LocationSearch(locations: locations));
                          }),
                          child: Text.rich(
                            TextSpan(
                              text: 'Searching jobs in ',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                    text: localtion,
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
                                                    const EdgeInsets.all(16),
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
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.black38,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(16),
                                                        ),
                                                      ),
                                                      height: 7,
                                                      width: 60,
                                                    ),
                                                    Material(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                          SizedBox(
                                                            height: 300,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                          // ThemeButton(
                                                          //   onPressed: () {},
                                                          //   text: "APPLY",
                                                          //   width: 130,
                                                          //   radious: 5,
                                                          //   themeButtonSize:
                                                          //       ThemeButtonSize
                                                          //           .small,
                                                          // )
                                                        ])),
                                                  ],
                                                )),
                                          ),
                                          true);
                                    },
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
                                        value: "Recomended",
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
                                        onChanged: (_) {},
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
                              enablePullUp: false,
                              header: const WaterDropHeader(),
                              // footer: CustomFooter(
                              //   builder:
                              //       (BuildContext context, LoadStatus? mode) {
                              //     Widget body;
                              //     if (mode == LoadStatus.idle) {
                              //       body = Text("pull up load");
                              //     } else if (mode == LoadStatus.loading) {
                              //       body = CupertinoActivityIndicator();
                              //     } else if (mode == LoadStatus.failed) {
                              //       body = Text("Load Failed!Click retry!");
                              //     } else if (mode == LoadStatus.canLoading) {
                              //       body = Text("release to load more");
                              //     } else {
                              //       body = Text("No more Data");
                              //     }
                              //     return Container(
                              //       height: 55.0,
                              //       child: Center(child: body),
                              //     );
                              //   },
                              // ),
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: SingleChildScrollView(
                                controller: _controllerListView,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
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
                                        image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzhsRgBZ1tPJFXJI47f3YvYnbouanQ9YvxCA&usqp=CAU")),

                                        //  color: Color(0xfff0f1fe),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 80,
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      width: double.infinity,
                                    ),
                                    const SizedBox(
                                      height: 20,
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

  void bindLocation() async {
    var result = await MasterService().masterGetByGroups(
        {'groupName': 'city', 'pageNumber': '1', 'pageSize': '1000'});
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      dynamic resultValue = Utils.parseResponse(result).resultData['content'];
      for (var i = 0; i < resultValue.length; i++) {
        locations.add(LocationItem(
            id: resultValue[i]['id'], name: resultValue[i]['value']));
      }
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
              color: Color.fromARGB(255, 213, 213, 213),
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
                                Text(
                                  item['location'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14),
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
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        (_controllerListView.position.maxScrollExtent -
                (_controllerListView.position.maxScrollExtent -
                    _controllerListView.position.extentAfter) <
            100)) {
      bindItems();
    }
  }

  void bindItems() async {
    setState(() {
      _isLoadMoreRunning = true; // Display a progress indicator at the bottom
    });
    _page += 1; // Increase _page by 1
    try {
      var result = await JobSearchService().getJobSearch(
          {"page": _page.toString(), "size": _pageSize.toString()});
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
      _isLoadMoreRunning = false; // Display a progress indicator at the bottom
    });
  }
}

class DataSearch extends SearchDelegate<String> {
  List<String> cities = [];
  List dataList = [];
  final recentCities = ["Kalyan", "Thane"];

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
        },
        leading: const Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black))
              ],
              text: suggestionList[index].substring(0, query.length),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      itemCount: suggestionList.length,
    );
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

  LocationSearch({required this.locations});

  final cities = ["Kalyan1", "Thane1"];
  final recentCities = ["Kalyan1", "Thane1"];

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
    final suggestionList = locations
        .where((element) =>
            element.name!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          //showResults(context);
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
