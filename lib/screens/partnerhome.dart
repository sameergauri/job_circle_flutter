import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/jobs/jobs.dart';
import 'package:job_circle/screens/jobs/my_pipe_line.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jobs/Interview_bay_cc.dart';
import 'jobs/my_team.dart';

class PartnerHomeScreen extends StatefulWidget {
  const PartnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PartnerHomeScreen> createState() => _PartnerHomeScreenState();
}

class _PartnerHomeScreenState extends State<PartnerHomeScreen> {
  final PageController pageController = PageController();
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
    bindBottomTabs();
    getData();
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
        children: [
           Jobs(),

          if (role == "3")
            const InterViewBay()
          //CC()
          else
            const MyPipeLine(),
          role == "3"
              ? LeadsTable(
                  id: id,
                )
              : const Placeholder(),
          //Recruitz(),
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
          items: bottomTabItems,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Theme.of(context).primaryColor,
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

  bindBottomTabs() async {
    /* userType = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);

    var partnerRequest = await Utils.getCacheData('partner_request'); */

    //bottomTabItems.clear(); // Clear existing items before adding new ones

    bottomTabItems.add(BottomNavigationBarItem(
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
    ));

    bottomTabItems.add(BottomNavigationBarItem(
      icon: Image.asset(
        "assets/images/recruitz.png",
        height: 20.h,
      ),
      activeIcon: Image.asset(
        "assets/images/recruitz.png",
        height: 25.h,
      ),
      label: 'My PipeLine',
      //'Recruitz',
      backgroundColor: Colors.blue,
    ));

    bottomTabItems.add(
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
    );

    setState(() {});
  }
}

/* class _PartnerHomeScreenState extends State<PartnerHomeScreen> {
  final PageController pageController = PageController();
  int selectedIndex = 0;
  dynamic userType;
  String userName = "";
  String userEmail = "";
  List<BottomNavigationBarItem> bottomTabItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences pref = await Utils.getSharedPreferences();
      userType = await Utils.getPreferencesValue(
          pref, ESharedPreferences.user_type.name);

      String userRaw = await Utils.getPreferencesValue(
          pref, ESharedPreferences.user_rawData.name);
      dynamic userRawData = jsonDecode(userRaw);
      userName = userRawData['firstName'] + " " + userRawData['lastName'];
      userEmail = userRawData['email'];
      setState(() {});
    });
    bindBottomTabs();

    /// WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // if (state == AppLifecycleState.resumed) {
  //   //   print("resumed");
  //   // }
  // }

  @override
  void dispose() {
    //  WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  calldata() async {
    userType = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);
    bindBottomTabs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Dashboard")),
      // drawer: Drawer(
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: [
      //       UserAccountsDrawerHeader(
      //         accountName: Text(userName),
      //         accountEmail: Text(userEmail),
      //         currentAccountPicture: CircleAvatar(
      //           backgroundColor: Colors.orange,
      //           child: Text(
      //             userName.length > 1 ? userName.substring(0, 1) : "-",
      //             style: const TextStyle(fontSize: 40.0),
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.settings),
      //         title: const Text("Performance"),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.pushNamed(context, "performance");
      //         },
      //       ),
      //     ],
      //   ),
      // ),
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
        child: bottomTabItems.length > 1
            ? BottomNavigationBar(
                items: bottomTabItems,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                unselectedItemColor: Colors.black45,
                selectedItemColor: Theme.of(context).primaryColor,
                iconSize: 30,
                onTap: onNavigationChange,
                elevation: 100)
            : null,
      ),
    );
  }

  void bindBottomTabs() async {
    userType = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);

    var partnerRequest = await Utils.getCacheData('partner_request');

    bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_customize_outlined),
      activeIcon: Icon(Icons.dashboard_customize_rounded),
      label: 'Jobs',
      backgroundColor: Colors.blue,
    ));

    if (userType == EUserType.employee.value ||
        (userType == EUserType.businessPartner.value &&
            partnerRequest == EPartnerApproval.approved.value)) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        activeIcon: Icon(Icons.bar_chart_outlined),
        label: 'Recruitz',
        backgroundColor: Colors.blue,
      ));
    }

    if (userType == EUserType.employee.value.toString()) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        activeIcon: Icon(Icons.admin_panel_settings_rounded),
        label: 'Admin',
        backgroundColor: Colors.blue,
      ));
    }
    setState(() {});
  }

/*   void bindBottomTabs() async {
    userType = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_type.name);

    var partnerRequest = await Utils.getCacheData('partner_request');

    bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_customize_outlined),
      activeIcon: Icon(Icons.dashboard_customize_rounded),
      label: 'Jobs',
      backgroundColor: Colors.blue,
    ));

    if (userType == EUserType.employee.value ||
        (userType == EUserType.businessPartner.value &&
            partnerRequest == EPartnerApproval.approved.value)) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.numbers),
        activeIcon: Icon(Icons.numbers_outlined),
        label: 'Dashboard',
        backgroundColor: Colors.blue,
      ));
    }

    if (userType == EUserType.employee.value ||
        (userType == EUserType.businessPartner.value &&
            partnerRequest == EPartnerApproval.approved.value)) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        activeIcon: Icon(Icons.bar_chart_outlined),
        label: 'Performance',
        backgroundColor: Colors.blue,
      ));
    }
    if (userType == EUserType.employee.value ||
        (userType == EUserType.businessPartner.value &&
            partnerRequest == EPartnerApproval.approved.value)) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        activeIcon: Icon(Icons.bar_chart_outlined),
        label: 'Recruitz',
        backgroundColor: Colors.blue,
      ));
    }
    bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      activeIcon: Icon(Icons.person_outline),
      label: 'Profile',
      backgroundColor: Colors.blue,
    ));

    if (userType == EUserType.employee.value.toString()) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        activeIcon: Icon(Icons.admin_panel_settings_rounded),
        label: 'Admin',
        backgroundColor: Colors.blue,
      ));
    }
    setState(() {});
  } */
  void onNavigationChange(int value) {
    BottomNavigationBarItem item =
        bottomTabItems.getRange(value, value + 1).first;
    switch (item.label) {
      case "Jobs":
        // Navigator.pushNamed(context, ERoute.jobs.name);
        break;
      case "Recruitz":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CC(),
            ));
        break;
      case "Admin":
        // Handle admin navigation
        break;
      default:
    }
  }

  /* void onNavigationChange(int value) {
    BottomNavigationBarItem item =
        bottomTabItems.getRange(value, value + 1).first;
    switch (item.label) {
      case "Jobs":
        // Navigator.pushNamed(context, ERoute.jobs.name);
        break;
      case "Stats":
        Navigator.pushNamed(context, ERoute.stats.name);
        break;
      case "Profile":
        if (userType == EUserType.employee.value) {
          Navigator.pushNamed(context, ERoute.profile_summary.name);
        } else if (userType == EUserType.businessPartner.value) {
          Navigator.pushNamed(context, ERoute.profile_summary_partner.name);
        }
        break;
      case "Dashboard":
        Navigator.pushNamed(context, ERoute.stats.value);
        break;
      case "Performance":
        Navigator.pushNamed(context, ERoute.performance.value);
        break;
      case "Recruitz":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CC(),
            ));
        break;
      case "Partner":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BusinessPartner()));
        break;
      default:
    } */

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
 */
