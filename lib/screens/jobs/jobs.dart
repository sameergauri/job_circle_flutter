import 'package:flutter/material.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';

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

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 1;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Jobs"),
          bottom: const PreferredSize(
              child: Text(
                "Search New Jobs",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              preferredSize: Size.zero),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            SizedBox(
              width: 100,
              child: Row(children: const [
                Icon(Icons.pin_drop),
                Expanded(
                  child: Text(
                    "Mumbai",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color.fromARGB(255, 124, 124, 124),
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.roofing_outlined),
                    activeIcon: Icon(Icons.roofing),
                    label: 'Home',
                    backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_customize_outlined),
                  activeIcon: Icon(Icons.dashboard_customize_rounded),
                  label: 'Jobs',
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  activeIcon: Icon(Icons.account_circle_rounded),
                  label: 'Profile',
                  backgroundColor: Colors.blue,
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.black45,
              selectedItemColor: Theme.of(context).primaryColor,
              iconSize: 30,
              onTap: (int) {},
              elevation: 100),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  itemBuilder: (BuildContext, index) {
                    return GestureDetector(
                      onTap: (() =>
                          {selectedJobTypeIndex = index, setState(() {})}),
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            horizontal: index < filterJobType.length ? 5 : 0),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: selectedJobTypeIndex == index
                                ? Colors.white.withOpacity(0.7)
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(60)),
                        child: Text(
                          filterJobType[index].toString(),
                          style: TextStyle(
                              fontSize: 16,
                              color: selectedJobTypeIndex == index
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    );
                  },
                  itemCount: filterJobType.length,
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 10,
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
                          color: Colors.white,
                          //  color: Color(0xfff0f1fe),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 15),
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
                                                            children: [
                                                          SizedBox(
                                                            height: 300,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                          ThemeButton(
                                                            onPressed: () {},
                                                            text: "APPLY",
                                                            width: 130,
                                                            radious: 5,
                                                            themeButtonSize:
                                                                ThemeButtonSize
                                                                    .small,
                                                          )
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
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // const Text("Sort by"),
                                      const Icon(Icons.filter_list),
                                      DropdownButton<String>(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                        value: "Salary - high to low",
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
                                                style: TextStyle(
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
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext, index) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Image.network(
                                              'https://www.adityabirla.com/Assets/images/our-download-logo.png',
                                              errorBuilder: ((context, error,
                                                      stackTrace) =>
                                                  Image.asset(
                                                      "assets/images/male.png",
                                                      height: 140,
                                                      width: 120,
                                                      fit: BoxFit.contain)),
                                              height: 140,
                                              width: 120,
                                              fit: BoxFit.contain,
                                            ),
                                            Container(
                                              height: 140,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                backgroundBlendMode:
                                                    BlendMode.darken,
                                                gradient: const LinearGradient(
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          57, 158, 158, 158),
                                                      Color.fromARGB(
                                                          203, 0, 0, 0),
                                                    ],
                                                    stops: [
                                                      0.8,
                                                      1.0
                                                    ]),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: const [
                                                    Text(
                                                      "  ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                        // Container(
                                        //   width: 100,
                                        //   height: 100,
                                        //   child: ShaderMask(
                                        //     shaderCallback: (rect) {
                                        //       return LinearGradient(
                                        //         begin: Alignment.topCenter,
                                        //         end: Alignment.bottomCenter,
                                        //         colors: [
                                        //           Colors.transparent,
                                        //           Color.fromARGB(30, 0, 0, 0),
                                        //           Color.fromARGB(65, 0, 0, 0),
                                        //         ],
                                        //       ).createShader(Rect.fromLTRB(0, 0,
                                        //           rect.width, rect.height));
                                        //     },
                                        //     blendMode: BlendMode.darken,
                                        //     child: Image.network(
                                        //       'https://cdn-web.heartfulness.org/en/wp-content/uploads/2020/06/ICICI-Logo-iyd.jpg',
                                        //       height: 90,
                                        //       fit: BoxFit.contain,
                                        //     ),
                                        //   ),
                                        //   // decoration: BoxDecoration(
                                        //   //   backgroundBlendMode:
                                        //   //       BlendMode.darken,
                                        //   //   gradient: LinearGradient(
                                        //   //       begin:
                                        //   //           FractionalOffset.topCenter,
                                        //   //       end: FractionalOffset
                                        //   //           .bottomCenter,
                                        //   //       colors: [
                                        //   //         Colors.grey.withOpacity(0.0),
                                        //   //         Colors.black,
                                        //   //       ],
                                        //   //       stops: [
                                        //   //         0.0,
                                        //   //         1.0
                                        //   //       ]),
                                        //   //   image: DecorationImage(
                                        //   //     image: NetworkImage(
                                        //   //         "https://cdn-web.heartfulness.org/en/wp-content/uploads/2020/06/ICICI-Logo-iyd.jpg"),
                                        //   //     fit: BoxFit.fitWidth,
                                        //   //   ),
                                        //   // ),
                                        // ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Aditya birla Private limited ",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  "CRT(Service)",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                ThemeButton(
                                                  onPressed: () {},
                                                  text: "APPLY",
                                                  width: 130,
                                                  radious: 5,
                                                  color: Colors.green,
                                                  themeButtonSize:
                                                      ThemeButtonSize.xsmall,
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),

                                  // ListTile(
                                  //   leading: Image.asset(
                                  //       "assets/images/male.png",
                                  //       height: 90),
                                  //   title: const Text("This is title"),
                                  //   subtitle: const Text("This is subtitle"),
                                  //   trailing: const Text("This is subtitle"),

                                  // ),
                                );
                              },
                              itemCount: 8,
                              padding: const EdgeInsets.all(5),
                              scrollDirection: Axis.vertical,
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
}
