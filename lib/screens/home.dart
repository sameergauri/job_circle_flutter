import 'package:flutter/material.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/jobs/jobs.dart';
import 'package:job_circle/screens/profile/businesspartner.dart';
import 'package:job_circle/screens/profile/profile.dart';
import 'package:job_circle/screens/profile/screen1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  int selectedIndex = 0;
  dynamic userType;
  List<BottomNavigationBarItem> bottomTabItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userType = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_type.name);
      bindBottomTabs();
      setState(() {});
    });
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
      icon: Icon(Icons.dashboard_customize_outlined),
      activeIcon: Icon(Icons.dashboard_customize_rounded),
      label: 'Jobs',
      backgroundColor: Colors.blue,
    ));

    if (userType == EUserType.businessPartner.value.toString()) {
      bottomTabItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.handshake_outlined),
        activeIcon: Icon(Icons.handshake_outlined),
        label: 'Partner',
        backgroundColor: Colors.blue,
      ));
    }
    bottomTabItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle_rounded),
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
      case "Profile":
        Navigator.pushNamed(context, ERoute.profile_summary.name);
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

    setState(() {
      selectedIndex = value;
    });
    pageController.jumpToPage(value);
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
