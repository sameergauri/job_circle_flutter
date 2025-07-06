// ignore_for_file: must_be_immutable, use_build_context_synchronously, deprecated_member_use, avoid_print, prefer_const_constructors_in_immutables
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/jobs/track_application.dart';
import 'package:job_circle/screens/new_jobs/job_home_page.dart';
import 'package:job_circle/service/job_post_api_service.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';
// Other imports...

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAppVersion();
  }

  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<Widget> pages = [
    const JobHomePage(), // new job page as per new api
    const TrackApplication(),
    //  ELearingHomePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Constants.borderColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem("assets/images/exp_bag.png", "JOBS", 0),
            navItem("assets/images/ats.png", "ATS", 1),
          ],
        ),
      ),
    );
  }

  Widget navItem(String img, String label, int index) {
    bool isSelected = currentIndex == index;
    return InkWell(
      splashColor: Constants.borderColor,
      onTap: () {
        checkAppVersion();
        setState(() => currentIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding:
            EdgeInsets.symmetric(horizontal: isSelected ? 20 : 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Constants.darkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(img,
                height: isSelected ? 20 : 24,
                color: isSelected
                    ? Constants.bgColorWhite
                    : Constants.subtitleclr),
            /* Icon(icon,
                color: isSelected ? Colors.white : Constants.subtitleclr), */
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: customTextForWeather(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    title: label,
                    color: Constants.bgColorWhite),
              ),
          ],
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
            'version']; //TODO::: latest version is one previous version of the currenct app ...

        const String currentVersion =
            '1.0.26'; // Replace with your app's current version //TODO::: current version is same as pubspec.yaml file . with updated one which you gonna push on play store..

        if (latestVersion.compareTo(currentVersion) > 0) {
          // Display update notification

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                  onWillPop: () async {
                    // Define your custom logic here to determine whether the dialog should close or not.
                    // Return true to allow the dialog to close or false to prevent it from closing.
                    return false; // Change this as needed.
                  },
                  child: const CustomDialog());
            },
          );
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching data: $e');
    }
  }

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
              onPressed: () async {
                _launchURL(
                    'https://play.google.com/store/apps/details?id=com.job_circle_flutter');
                JobPostApiService jobPostApiService = JobPostApiService();
                await jobPostApiService.clearCache();

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
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FutureBuilder(
                future: Future.delayed(const Duration(
                    seconds: 1)), // Simulating image loading delay
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while the image is loading
                    return const CircularProgressIndicator(
                      strokeWidth: 1,
                    );
                  } else {
                    // Image is loaded, display it
                    return Image.asset("assets/images/rocket.jpg");
                  }
                },
              ),
              /* const Text(
                'Update Available',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ), */
              const SizedBox(height: 15),
              Text(
                'A new version of the app is available. Please update for the latest features and improvements.',
                textAlign: TextAlign.center,
                style: GoogleFonts.varela(fontSize: 18),
              ),
              const SizedBox(height: 22),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://play.google.com/store/apps/details?id=com.job_circle_flutter');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Constants.blue,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Text(
                        "Update Now",
                        style: GoogleFonts.varela(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        /*   const Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 40,
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 50,
            ),
          ),
        ), */
      ],
    );
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
