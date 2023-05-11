import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';

class ReferNow extends StatefulWidget {
  const ReferNow({super.key});

  @override
  State<ReferNow> createState() => _ReferNowState();
}

class _ReferNowState extends State<ReferNow>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 5, vsync: this);

  int? cutTab;
  Offset position = const Offset(.0, 200.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.themeBgColor,
          foregroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.pushNamed(context, ERoute.application.name, arguments: {
              "isnew": true,
              // "prevModel": jobDetailsModel,
              "refer": false
            });
          },
          child: Image.asset(
            "assets/images/add.png",
            height: 30.h,
            color: Constants.borderColor,
          )),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Who you refere",
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
              Tab(
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
              Tab(child: customTab("New Jobs", "assets/images/check.png", 2)),
              Tab(
                  child: customTab(
                      "Work from home", "assets/images/check.png", 3)),
              Tab(
                  child: customTab(
                      "Work from office", "assets/images/check.png", 4)),
              Tab(child: customTab("Hybrid", "assets/images/check.png", 5)),
              Tab(child: customTab("Recomended", "assets/images/check.png", 6)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
                customContainer(context, "Candidate Name", "ICICI Lombard",
                    "Vashi", "18,000 - 28,000 per month"),
              ],
            ),
          ),
          /* Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
                feedback: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, ERoute.application.name,
                          arguments: {
                            "isnew": true,
                            // "prevModel": jobDetailsModel,
                            "refer": false
                          });
                    }),
                child: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, ERoute.application.name,
                          arguments: {
                            "isnew": true,
                            // "prevModel": jobDetailsModel,
                            "refer": false
                          });
                    }),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                  print(position);
                  print(position.dx);
                  print(position.dy);
                }),
          ) */
        ],
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
            offset: const Offset(0, 0),
            blurRadius: 5)
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_2_outlined,
                        size: 17.h,
                        color: Colors.greenAccent[400],
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Qualification"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("|"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Experience"),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "assets/images/cv.png",
                    height: 20.h,
                  ),
                ],
              )
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
                    size: 17,
                    color: Color.fromARGB(255, 118, 118, 118),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Image.asset(
                    "assets/images/proces.png",
                    height: 15.h,
                    color: Colors.black,
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
                        fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Designation"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("|"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Healthcare"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("|"),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Blended")
                    ],
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
                      "Call HR",
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
                      "Chat with HR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              /* Container(
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
              ), */
            ],
          )
        ],
      ),
    );
  }

  Container customRefer() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 2,
            color: Colors.grey.shade200)
      ]),
      child: Theme(
        data: ThemeData(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
        child: ExpansionTile(
          leading: CircleAvatar(
              radius: 25.r,
              backgroundImage: const NetworkImage(
                "https://cdn.stocksnap.io/img-thumbs/280h/oldman-portrait_TTOM5R7SFF.jpg",
              )),
          title: const Text("User Name"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              const Text("8546558845"),
              const Text("Graduate")
            ],
          ),
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, bottom: 5.h, top: 5.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 0),
                    blurRadius: 5)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Executive",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      const Text("Team Leader")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/proces.png",
                        height: 15.h,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("Healthcare"),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text("|"),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text("Blended")
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
                            size: 17,
                            color: Color.fromARGB(255, 118, 118, 118),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Icon(
                            Icons.currency_rupee,
                            size: 15.h,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          const Icon(
                            Icons.location_pin,
                            size: 17,
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
                                fontSize: 13.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "18000",
                            style: TextStyle(
                                // color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Location",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
