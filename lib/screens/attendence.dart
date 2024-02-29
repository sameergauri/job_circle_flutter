// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers
// ignore_for_file: todo
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/attendance_data_model.dart';

class Attendence extends StatefulWidget {
  const Attendence({super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  /* // const Attendence({super.key});
  // List points = []; */
  bool isclockin = true;
  bool isgraph = false;
  final List<DataModel> _list = List<DataModel>.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _list.add(DataModel(key: "0", value: "2"));
    _list.add(DataModel(key: "1", value: "4"));
    _list.add(DataModel(key: "2", value: "6"));
    _list.add(DataModel(key: "3", value: "8"));
    _list.add(DataModel(key: "4", value: "4"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Attendance"),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(1, 1),
                        blurRadius: 5)
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person_2_outlined),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome User",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Digital Product Managers",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
              isclockin == false
                  ? Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(1, 1),
                              blurRadius: 5)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Lets get to work",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                "assets/images/write.png",
                                height: 25,
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isclockin = true;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 80),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text(
                                "Clock In",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          const Text(
                            "your hour's will be calculated here",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )
                  : Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              offset: const Offset(1, 1),
                              blurRadius: 5)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Lets get to work",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                "assets/images/write.png",
                                height: 25,
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isclockin = false;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 80),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Text(
                                "Clock Out",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "You started at : ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                DateFormat('hh:mm:ss a').format(DateTime.now()),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              Container(
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                    //color: Colors.white,
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Request Leaves",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          customContainer("Anual Leave", "20 Days",
                              "assets/images/leave.png", Colors.green.shade100),
                          customContainer("Sick Leave", "18 Days",
                              "assets/images/sick.png", Colors.indigo.shade100),
                          customContainer("Paid Holiday", "28 Days",
                              "assets/images/id-card.png", Colors.red.shade100),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Previous history",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isgraph = !isgraph;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              isgraph ? "Normal View" : "Graphical View",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              isgraph == true
                  ? SizedBox()/* Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
              //              color: Colors.grey.shade300,
                            offset: const Offset(1, 1),
                            blurRadius: 5)
                      ]),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 250,
                        child: BarChart(BarChartData(
                          backgroundColor: Colors.white,
                          barGroups: _chartGroups(),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                              bottomTitles:
                                  AxisTitles(sideTitles: _bottomTitles),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 2,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          "Hr ${value.toString()}",
                                          style: const TextStyle(fontSize: 16),
                                        );
                                      })),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false))),
                        )),
                      ),
                    ) */
                  : Container(
                      child: Column(
                        children: [
                          Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: const Offset(1, 1),
                                        blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, bottom: 20),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 21,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text("10"),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Total Working Hours"),
                                    Text("2 hrs")
                                  ],
                                ),
                                subtitle: const Text(
                                    "Assigned Work : Modification in ui"),
                              )),
                          Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: const Offset(1, 1),
                                        blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, bottom: 20),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 21,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text("9"),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Total Working Hours"),
                                    Text("4 hrs")
                                  ],
                                ),
                                subtitle: const Text(
                                    "Assigned Work : Modification in ui"),
                              )),
                          Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: const Offset(1, 1),
                                        blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, bottom: 20),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 21,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text("8"),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Total Working Hours"),
                                    Text("6 hrs")
                                  ],
                                ),
                                subtitle: const Text(
                                    "Assigned Work : Modification in ui"),
                              ))
                        ],
                      ),
                    )
            ]
                /* SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(1, 1),
                        blurRadius: 5),
                  ]),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Person Name",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.desk_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Designation",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  )),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(1, 1),
                      blurRadius: 5)
                ]),
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Stared at ",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      ),
                                      Text(
                                        "10:00 AM",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey.shade600),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        DateFormat('EEEE, dd,MMM,yyyy')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    DateFormat('hh:mm:ss a')
                                        .format(DateTime.now()),
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "Check Out",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                //color: Colors.red,
                                child: const Text(
                                  "Take a Break",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Break time left",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                  Text(
                                    "30 min",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(1, 1),
                      blurRadius: 5)
                ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Today",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        Text(
                          "Total Time  1:24:48 h",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Clock in",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "11:23",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Clock out",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "17:23",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Text(
                              "0:05:36 h",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Clock in",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "11:23",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Clock out",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "17:23",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const Text(
                              "0:05:36 h",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(1, 1),
                      blurRadius: 5)
                ]),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                width: double.maxFinite,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Previous History",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 250,
                      child: BarChart(BarChartData(
                        backgroundColor: Colors.white,
                        barGroups: _chartGroups(),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 2,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        "Hr ${value.toString()}",
                                        style: const TextStyle(fontSize: 16),
                                      );
                                    })),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false))),
                      )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            "Normal View",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ) */

                /* Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                DateFormat('hh:mm:ss a').format(DateTime.now()),
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                DateFormat('EEEE, dd,MMM,yyyy')
                                    .format(DateTime.now()),
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ThemeButton(
                  width: 150,
                  radious: 15,
                  onPressed: () {},
                  text: "Check In",
                  // color: Colors.red,
                  themeButtonSize: ThemeButtonSize.medium,
                ),
                ThemeButton(
                  width: 150,
                  radious: 15,
                  onPressed: () {},
                  text: "Check Out",
                  // color: Colors.red,
                  themeButtonSize: ThemeButtonSize.medium,
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Day",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Start Time",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "End Time",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd,MMM,').format(DateTime.utc(2023, 2, 9)),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.utc(2023, 2, 9)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 9, 09, 00, 00)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 9, 18, 00, 00)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd,MMM,').format(DateTime.utc(2023, 2, 8)),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.utc(2023, 2, 8)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 8, 09, 00, 00)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 8, 18, 00, 00)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd,MMM,').format(DateTime.utc(2023, 2, 7)),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.utc(2023, 2, 7)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 7, 09, 00, 00)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 7, 18, 00, 00)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd,MMM,').format(DateTime.utc(2023, 2, 6)),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.utc(2023, 2, 6)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 6, 09, 00, 00)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 6, 18, 00, 00)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd,MMM,').format(DateTime.utc(2023, 2, 5)),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.utc(2023, 2, 5)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 5, 09, 00, 00)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 5, 18, 00, 00)),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd,MMM,').format(DateTime.utc(2023, 2, 4)),
                  ),
                  Text(
                    DateFormat('EEE').format(DateTime.utc(2023, 2, 4)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 4, 09, 00, 00)),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a')
                        .format(DateTime.utc(2023, 2, 4, 18, 00, 00)),
                  )
                ],
              ),
            ),

            /* Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.only(
                top: 20,
              ),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Screen 1 for attendance",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(
                    height: 10,
                    thickness: 3,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "FRI - 20 Jan 2023",
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Sign In Time :- 09:30 AM",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Sign Out Time :-",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Total Hours :-",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 4)),
                        child: const Text(
                          "SIGN OUT",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ) */
          ],
        ),
      ), */
                )));
  }

  Container customContainer(
      String title, String subtitle, String img, Color clr) {
    return Container(
      height: 190,
      width: 190,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      margin: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
      /*   margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20), */
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 1),
            blurRadius: 10)
      ], borderRadius: BorderRadius.circular(15), color: clr),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Colors.white),
                child: Image.asset(
                  img,
                  // height: 40,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          )
        ],
      ),
    );
  }

/*   List<BarChartGroupData> _chartGroups() {
    List<BarChartGroupData> list =
        List<BarChartGroupData>.empty(growable: true);
    for (int i = 0; i < _list.length; i++) {
      list.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: double.parse(_list[i].value!), color: Colors.red)
      ]));
    }
    return list;
  }
 */
 /*  SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 0:
            text = "10 Feb";
            break;
          case 1:
            text = "09 Feb";
            break;
          case 2:
            text = "08 Feb";
            break;
          case 3:
            text = "07 Feb";
            break;
          case 4:
            text = "06 Feb";
            break;
        }
        return Text(text);
      }); */
}
