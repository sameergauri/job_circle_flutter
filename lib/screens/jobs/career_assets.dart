import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class CareerAssets extends StatefulWidget {
  const CareerAssets({super.key});

  @override
  State<CareerAssets> createState() => _CareerAssetsState();
}

class _CareerAssetsState extends State<CareerAssets>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);
  int? cutTab;
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Career Assets",
          style: GoogleFonts.varela(
              color: Colors.black, fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: TabBar(
            labelPadding: const EdgeInsets.only(left: 5, right: 5),
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(50),
            //indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            indicatorPadding:
                EdgeInsets.only(top: 4.5.h, bottom: 8.h, left: 3.w, right: 3.w),
            indicator: BoxDecoration(
                color: Constants.borderColor,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Constants.borderColor) // Creates border
                ),
            onTap: (value) {
              setState(() {
                cutTab = value;
                //isSelect = !isSelect;
              });
            },
            isScrollable: true,
            tabs: [
              Tab(
                child: customTab("Experience", 0),
              ),
              Tab(
                child: customTab("Education", 1),
              ),
              Tab(
                child: customTab("Bank Document", 2),
              ),
              Tab(
                child: customTab("Resume", 3),
              ),
            ]),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            experiencePage(),
            educationPage(),
            bankDocument(),
            resume()
          ]),
    );
  }

  Widget customTab(String title, int select) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 9.5.h, horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: Constants.borderColor, width: 1)),
        child: cutTab == select
            ? Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    "assets/images/check.png",
                    height: 13.h,
                  )
                ],
              )
            : Text(
                title,
              ));
  }

  experiencePage() {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              childrenPadding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 20),
              leading: CircleAvatar(
                child: Image.asset("assets/images/logo.png"),
              ),
              title: Text(
                "Job Circle",
                style: GoogleFonts.varela(
                    fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              children: [
                customDocument("Offer Letter"),
                customDocument("Salary Slip")
              ],
            ),
          ],
        ),
      ),
    );
  }

  educationPage() {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              childrenPadding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 20),
              leading: CircleAvatar(
                child: Image.asset("assets/images/logo.png"),
              ),
              title: Text(
                "Job Circle Jr College",
                style: GoogleFonts.varela(
                    fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              children: [
                customDocument("Passing Certificate"),
                customDocument("Marksheet")
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container customDocument(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          SizedBox(
            child: Row(
              children: [
                const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 20,
                ),
                SizedBox(
                  width: 10.w,
                ),
                const Icon(
                  Icons.download,
                  size: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bankDocument() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customDocument("PassBook"),
            customDocument("Account statement")
          ],
        ),
      ),
    );
  }

  resume() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customDocument("Resume one"),
            customDocument("resume two")
          ],
        ),
      ),
    );
  }
}
