// ignore_for_file: unused_import
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Manager/manager_piepline.dart';
import 'package:job_circle/screens/Manager/manager_team.dart';
import 'package:job_circle/screens/jobs/cc_my_team.dart';
import 'package:job_circle/screens/jobs/interview_bay_cc_new.dart';
import 'package:job_circle/screens/jobs/interview_bay_executive.dart';
import 'package:job_circle/screens/jobs/talent_pool.dart';
import 'package:job_circle/screens/new_jobs/new_jobs_v1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  // PageController pageController = PageController();
  int selectedIndex = 0;
  dynamic userType;
  String userName = "";
  String userEmail = "";
  String role = "";
  int id = 0;
  List<BottomNavigationBarItem> bottomTabItems = [];

  @override
  void initState() {
    super.initState();
    getData();
    // bindBottomTabs();
  }

  getData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences pref = await Utils.getSharedPreferences();
      userType = await Utils.getPreferencesValue(
          pref, ESharedPreferences.user_type.name);

      String userRaw = await Utils.getPreferencesValue(
          pref, ESharedPreferences.user_rawData.name);
      dynamic userRawData = jsonDecode(userRaw);
      userName = userRawData['firstName'] + " " + userRawData['lastName'];
      userEmail = userRawData['email'];
      role = userRawData['role'];
      id = userRawData['id'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [NewJobsV1(), ManagerPipeLine(), ManagerMyTeam()],
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
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/jobs.png",
                height: 15.h,
              ),
              activeIcon: Image.asset(
                "assets/images/jobs.png",
                height: 25.h,
              ),
              label: 'Hiring',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/recruitz.png",
                height: 20.h,
              ),
              activeIcon: Image.asset(
                "assets/images/recruitz.png",
                height: 25.h,
              ),
              label: 'Manager PipeLine',
              //'Recruitz',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/user-group.png",
                height: 20.h,
              ),
              activeIcon: Image.asset(
                "assets/images/user-group.png",
                height: 25.h,
              ),
              label: "Team",
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.black,
          selectedFontSize: 14,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          backgroundColor: Colors.white,
          selectedIconTheme: const IconThemeData(size: 36),
          unselectedIconTheme: const IconThemeData(size: 30),
        ),
      ),
    );
  }
}
