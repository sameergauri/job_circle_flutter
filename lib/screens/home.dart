// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/jobs/track_application.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'new_jobs/new_jobs_v1.dart';
// Other imports...

class HomeScreen extends StatefulWidget {
  bool? isFirst;
  HomeScreen({super.key, this.isFirst});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final PageController pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColorWhite,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [NewJobsV1(), TrackApplication()],
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
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
              label: "Hiring",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/interview_bay.png",
                height: 20.h,
              ),
              activeIcon: Image.asset(
                "assets/images/interview_bay.png",
                height: 20.h,
              ),
              label: "Track Application",
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Constants.themeBgColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          iconSize: 30,
          onTap: onNavigationChange,
          elevation: 100,
        ),
      ),
    );
  }

  Future<void> checkAppVersion() async {
    //TODO::: current version is same as pubspec.yaml file
    // Make an HTTP request to your server or a version-check API
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/version/v1/getVersionById?id=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String latestVersion = data['resultData'][
            'version']; //TODO::: latest version is also as yaml file with updated one ...

        const String currentVersion =
            '1.0.16'; // Replace with your app's current version //TODO::: current version is same as pubspec.yaml file . with updated one which you gonna push on play store..

        if (latestVersion.compareTo(currentVersion) > 0) {
          // Display update notification
          showUpdateDialog();
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching data: $e');
    }
  }

  /* final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}version/v1/all?pageNumber=1&pageSize=10'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String latestVersion = data['version'];
      const String currentVersion =
          '1.0.3'; // Replace with your app's current version

      if (latestVersion.compareTo(currentVersion) > 0) {
        // Display update notification
        showUpdateDialog();
      }
    } else {
      // Handle the case when the version check fails
    } */

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: const Text(
              'A new version of the app is available. Please update for the latest features and improvements.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Update Now'),
              onPressed: () {
                _launchURL(
                    'https://play.google.com/store/apps/details?id=com.job_circle_flutter');
                Navigator.pop(context);
                // Redirect users to the app store or a download page
                // Example: launch('https://your-app-store-link');
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onNavigationChange(int value) async {
    setState(() {
      selectedIndex = value;
    });
    pageController.jumpToPage(value);
    await checkAppVersion();
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/screens/jobs/interview_bay.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';

import 'jobs/jobs.dart';
// Other imports...

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: const [Jobs(), InterviewBay(), ReferNow()],
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
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
              label: "Hiring",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/interview_bay.png",
                height: 20.h,
              ),
              activeIcon: Image.asset(
                "assets/images/interview_bay.png",
                height: 20.h,
              ),
              label: "Interview Bay",
              backgroundColor: Colors.blue,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.refresh_outlined),
              activeIcon: Icon(Icons.refresh_outlined),
              label: "Referral",
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Constants.themeBgColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          iconSize: 30,
          onTap: onNavigationChange,
          elevation: 100,
        ),
      ),
    );
  }

  void onNavigationChange(int value) {
    setState(() {
      selectedIndex = value;
    });
    pageController.jumpToPage(value);
  }
}
 */

// Old code Working.

/* import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/jobs/applied_job.dart';
import 'package:job_circle/screens/jobs/jobs.dart';
import 'package:job_circle/screens/refer_now.dart';
import 'package:job_circle/themes/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  int selectedIndex = 0;
  late dynamic userType;
  List<BottomNavigationBarItem> bottomTabItems = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      userType = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
    });
    bindBottomTabs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [Jobs()],
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
            items: bottomTabItems,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.black45,
            selectedItemColor: Constants.themeBgColor,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            //  selectedItemColor: Theme.of(context).primaryColor,
            iconSize: 30,
            onTap: onNavigationChange,
            elevation: 100),
      ),
    );
  }

  void bindBottomTabs() {
    bottomTabItems.add(BottomNavigationBarItem(
      //Icons.dashboard_customize_outlined
      icon: Image.asset(
        "assets/images/jobs.png",
        height: 15.h,
      ),
      activeIcon: Image.asset(
        "assets/images/jobs.png",
        height: 25.h,
      ),
      label: "Hiring",

      backgroundColor: Colors.blue,
    ));
    bottomTabItems.add(const BottomNavigationBarItem(
      //Icons.dashboard_customize_outlined
      icon: Icon(Icons.send_outlined),
      activeIcon: Icon(Icons.send_outlined),
      /* activeIcon: Image.asset(
        "assets/images/jobs.png",
        height: 25.h,
      ), */
      label: "Interview Bay",

      backgroundColor: Colors.blue,
    ));
    bottomTabItems.add(const BottomNavigationBarItem(
      //Icons.dashboard_customize_outlined
      icon: Icon(Icons.refresh_outlined),
      activeIcon: Icon(Icons.refresh_outlined),
      /* activeIcon: Image.asset(
        "assets/images/jobs.png",
        height: 25.h,
      ), */
      label: "Referal",

      backgroundColor: Colors.blue,
    ));

    /* bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.handshake_outlined),
      activeIcon: Icon(Icons.handshake_outlined),
      label: 'Profile',
      backgroundColor: Colors.blue,
    ));*/
  }

  void onNavigationChange(int value) {
    BottomNavigationBarItem item =
        bottomTabItems.getRange(value, value + 1).first;
    switch (item.label) {
      case "Stats":
        Navigator.pushNamed(context, ERoute.stats.name);
        break;

      case "Interview Bay":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AppliedJob()));
        break;

      case "Referal":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ReferNow()));
        break;
      /* case "Profile":
        Navigator.pushNamed(context, ERoute.profile_summary.name);
        break; */

      default:
    }

    // setState(() {
    //   selectedIndex = value;
    // });
    // pageController.jumpToPage(value);
    // if (value == 2) {
    //   Navigator.pushNamed(context, ERoute.profile_summary.name);
    //   return;
    // }

    // if (value == 3) {
    //   Navigator.pushNamed(context, AdminERoute.admin_leads.name);
    //   return;
    // }

    // if (value == 1) {
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const BusinessPartner()));
    //   return;
    // }
  }
}
 */
