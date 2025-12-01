// ignore_for_file: must_be_immutable, use_build_context_synchronously, deprecated_member_use, avoid_print, prefer_const_constructors_in_immutables
// ignore_for_file: todo

import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/screen/Jobs/job_home_page.dart';
import 'package:job_circle/src/screen/ats/ats_home_page.dart';
import 'package:job_circle/src/services/cache_clear_and_app_version/cache_clear_and_app_version_service.dart';
import 'package:job_circle/src/widgets/custom_drawer.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CacheClearAppVersionService.checkAppVersion(context);
  }

  final PageController pageController = PageController();
  int currentIndex = 0;

  late final List<Widget> pages = [
    JobHomePage(scaffoldKey: _scaffoldKey), // new job page as per new api
    const ATSHomePage(),
    //  ELearingHomePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        scaffoldKey: _scaffoldKey,
        onClose: () => _scaffoldKey.currentState?.closeDrawer(),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Constants.borderColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(CustomAssetUrl.homepageicon, "JOBS", 0),
            navItem(CustomAssetUrl.atsicon, "ATS", 1),
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
        CacheClearAppVersionService.checkAppVersion(context);
        setState(() => currentIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Constants.darkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(
              img,
              height: isSelected ? 20 : 24,
              color: isSelected ? Constants.white : Constants.subtitleclr,
            ),
            /* Icon(icon,
                color: isSelected ? Colors.white : Constants.subtitleclr), */
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: customText(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  title: label,
                  color: Constants.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
