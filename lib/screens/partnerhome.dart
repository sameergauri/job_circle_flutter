import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/profile/businesspartner.dart';
import 'package:job_circle/screens/statistics/statistic.dart';

class PartnerHomeScreen extends StatefulWidget {
  const PartnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PartnerHomeScreen> createState() => _PartnerHomeScreenState();
}

class _PartnerHomeScreenState extends State<PartnerHomeScreen> {
  final PageController pageController = PageController();
  int selectedIndex = 0;
  dynamic userType;
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
      body: PageView(
        controller: pageController,
        children: const [Statestics()],
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
            iconSize: 30,
            onTap: onNavigationChange,
            elevation: 100),
      ),
    );
  }

  void bindBottomTabs() {
    bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.numbers),
      activeIcon: Icon(Icons.numbers_outlined),
      label: 'Home',
      backgroundColor: Colors.blue,
    ));

    bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_customize_outlined),
      activeIcon: Icon(Icons.dashboard_customize_rounded),
      label: 'Jobs',
      backgroundColor: Colors.blue,
    ));
    if (userType == EUserType.businessPartner.value) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.handshake_outlined),
        activeIcon: Icon(Icons.handshake_outlined),
        label: 'Partner',
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
  }

  void onNavigationChange(int value) {
    BottomNavigationBarItem item =
        bottomTabItems.getRange(value, value + 1).first;
    switch (item.label) {
      case "Jobs":
        Navigator.pushNamed(context, ERoute.jobs.name);
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
      case "Admin":
        Navigator.pushNamed(context, AdminERoute.admin_leads.name);
        break;
      case "Partner":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BusinessPartner()));
        break;
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
