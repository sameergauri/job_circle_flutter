import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/service/LeadService.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Statestics extends StatefulWidget {
  const Statestics({Key? key}) : super(key: key);

  @override
  State<Statestics> createState() => _StatesticsState();
}

class _StatesticsState extends State<Statestics> {
  dynamic leadCounts = [];
  var userId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCountData();
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
          child: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              // showing snackbar
              getCountData();
            });
          },
          child: ResponsiveGridRow(children: [
            for (var s in leadCounts)
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: SizedBox(
                  height: 100,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${s['title']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                          Text(
                            "${s['count']}",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                        ],
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
      "data": {"flag": "partner_dashboard", "sourceid": userId}
    });
    var d = Utils.parseResponse(result);
    if (d.resultKey == 'SUCCESS') {
      setState(() {
        leadCounts = d.resultData;
      });
    }
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
