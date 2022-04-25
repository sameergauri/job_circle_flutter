import 'package:flutter/material.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Jobs"),
          elevation: 0,
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
        backgroundColor: Colors.red,
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
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            color: selectedJobTypeIndex == index
                                ? Colors.white.withOpacity(0.7)
                                : Colors.transparent,
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
                      padding: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 208, 208, 208),
                              blurRadius: 10.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: Color(0xfffef1e9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Filtered Result",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text("Sort by"),
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
                                            child: Text(value),
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
                              itemBuilder: (BuildContext, index) {
                                return Card(
                                  margin: EdgeInsets.only(bottom: 30),
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
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.contain,
                                            ),
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                backgroundBlendMode:
                                                    BlendMode.darken,
                                                gradient: LinearGradient(
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    colors: [
                                                      Colors.grey
                                                          .withOpacity(0.2),
                                                      Colors.black
                                                          .withOpacity(0.4),
                                                    ],
                                                    stops: const [
                                                      0.0,
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
                                                      "",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
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
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "ICICI Lombard",
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
                                                    Text(
                                                      "Andheri",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                  width: 100,
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
                              itemCount: 33,
                              shrinkWrap: true,
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
