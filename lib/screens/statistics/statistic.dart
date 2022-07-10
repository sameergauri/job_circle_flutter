import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/webview/webviewd.dart';
import 'package:job_circle/service/LeadService.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Statestics extends StatefulWidget {
  const Statestics({Key? key}) : super(key: key);

  @override
  State<Statestics> createState() => _StatesticsState();
}

class _StatesticsState extends State<Statestics> {
  dynamic leadCounts = [];
  var userId = 0;
  var usertype = -1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // if failed,use refreshFailed()
    await Future.delayed(const Duration(milliseconds: 300));
    getCountData();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 300));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      usertype = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);

      getCountData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,

        child: const Icon(Icons.add),

        onPressed: () {
          Navigator.pushNamed(context, ERoute.application.name,
              arguments: {"isnew": true});
        },
      ),
      appBar: AppBar(title: const Text("Dashboard")
          // SizedBox(
          //   height: 40,
          //   child: TextField(
          //     enableInteractiveSelection: false, // will disable paste operation

          //     // onTap: () {
          //     //   showSearch(context: context, delegate: DataSearch());
          //     // },
          //     decoration: InputDecoration(
          //       prefixIcon: const Icon(Icons.search_outlined),
          //       filled: true,
          //       contentPadding:
          //           const EdgeInsets.only(left: 14.0, bottom: 0.0, top: 0.0),
          //       fillColor: Colors.white,
          //       hintText: 'Search job...',
          //       hintStyle: const TextStyle(
          //         color: Colors.grey,
          //         fontSize: 18,
          //       ),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(6.0),
          //       ),
          //     ),
          //     style: const TextStyle(
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          ),
      body: SafeArea(
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
          child: ResponsiveGridRow(children: [
            for (var s in leadCounts)
              if (s['count'] > 0)
                ResponsiveGridCol(
                  xs: 12,
                  md: 12,
                  child: SizedBox(
                    height: 70,
                    child: Card(
                      child: GestureDetector(
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebviewData(
                                        // url: "https://www.youtube.com/",
                                        url: GlobalConstants.WEB_Host +
                                            "/mobile/leadlist?sourceid=${userId.toString()}&status=${s['code']}",
                                        title: "${s['title']}",
                                      )));
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${s['title']}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                "${s['count']}",
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                              ),
                              const Icon(Icons.arrow_right)
                            ],
                          ),
                        ),
                      ),
                      color: HexColor("${s['color']}"),
                    ),
                  ),
                ),
          ]),
        ),
      )),
    );
  }

  getCountData() async {
    userId =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);

    var result = await LeadService().getLoadCounts({
      "data": {
        "flag": "partner_dashboard",
        "sourceid": userId,
        "usertype": usertype
      }
    });
    var d = Utils.parseResponse(result);
    if (d.resultKey == 'SUCCESS') {
      setState(() {
        leadCounts = d.resultData;
      });
    }
    _refreshController.refreshCompleted();
    // for (var element in d.resultData) {
    //   print(element['title']);
    // }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
