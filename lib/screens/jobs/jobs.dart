import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/screens/jobs/job_details.dart';
import 'package:job_circle/service/JobSearchService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';

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
  @override
  void initState() {
    super.initState();
    bindJobItems();
  }

  @override
  Widget build(BuildContext context) {
    //var _selectedIndex = 1;
    const localtion = "Mumbai";

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
                              context: context, delegate: LoacationSearch());
                        }),
                        child: const Text(
                          "Searching jobs in $localtion",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                                          'Salary - high to low',
                                          'Distance - newr to far',
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
                            child: SingleChildScrollView(
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
                                    height: 45,
                                    margin: const EdgeInsets.only(
                                        left: 40.0, right: 40.0),
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const JobDetails()));
                                          },
                                          child: listViewItem(
                                              context, index, jobItems[index]));
                                    },
                                    itemCount: jobItems.length,
                                    padding: const EdgeInsets.all(5),
                                    scrollDirection: Axis.vertical,
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
            Stack(
              children: [
                Image.network(
                  item['icon'],
                  errorBuilder: ((context, error, stackTrace) => Image.asset(
                      "assets/images/male.png",
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain)),
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    backgroundBlendMode: BlendMode.darken,
                    gradient: const LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Color.fromARGB(57, 158, 158, 158),
                          Color.fromARGB(203, 0, 0, 0),
                        ],
                        stops: [
                          0.8,
                          1.0
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          "  ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.amber,
                )
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['companyname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      item['rolename'],
                      style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.location_city,
                          size: 17,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Andheri",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
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

  void bindJobItems() async {
    var result = await JobSearchService().getJobSearch({});
    RequestResult res = Utils.parseResponse(result);

    setState(() {
      jobItems = res.resultData as List;
    });
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = ["Kalyan", "Thane"];
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

class LoacationSearch extends SearchDelegate<String> {
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
