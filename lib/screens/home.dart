import 'package:flutter/material.dart';
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
            items: const <BottomNavigationBarItem>[
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.roofing_outlined),
              //     activeIcon: Icon(Icons.roofing),
              //     label: 'Home',
              //     backgroundColor: Color.fromARGB(255, 255, 255, 255)),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_customize_outlined),
                activeIcon: Icon(Icons.dashboard_customize_rounded),
                label: 'Jobs',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                
                icon: Icon(Icons.handshake_outlined),
                activeIcon: Icon(Icons.handshake_outlined),
                label: 'Partner',
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
            currentIndex: selectedIndex,
            unselectedItemColor: Colors.black45,
            selectedItemColor: Theme.of(context).primaryColor,
            iconSize: 30,
            onTap: onNavigationChange,
            elevation: 100),
      ),
    );
  }

  void onNavigationChange(int value) {
    if (value == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Screen1()));
      return;
    }

    if (value == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BusinessPartner()));
      return;
    }
    setState(() {
      selectedIndex = value;
    });
    pageController.jumpToPage(value);
  }
}
