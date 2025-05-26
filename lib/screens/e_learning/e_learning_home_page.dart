// ignore_for_file: camel_case_types, must_be_immutable

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/constants/e_learning/custom_course_card.dart';
import 'package:job_circle/models/e_learning/univerrsity_course_model.dart';
import 'package:job_circle/riverpod_provider/e_learning/e_learning_home_provider.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/e_learning/course_detail_page.dart';
import 'package:job_circle/themes/colors.dart';

class ELearingHomePage extends ConsumerStatefulWidget {
  const ELearingHomePage({super.key});

  @override
  ConsumerState<ELearingHomePage> createState() => _ELearingHomePageState();
}

class _ELearingHomePageState extends ConsumerState<ELearingHomePage> {
  late ScrollController _scrollController;
  late Timer _timer;

  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = 2.0;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + delta,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: coursesAsync.when(
            data: (courses) {
              // Extract unique course names from the courses list
              final courseNames =
                  courses.map((course) => course.courseName).toSet().toList();

              // Add 'All' as the first filter option
              final filterOptions = ['All', ...courseNames];

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                      title: "Select Filter",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 16),
                    // Dynamically generate filter options
                    ...filterOptions.map(
                        (filter) => _buildFilterOption(context, ref, filter)),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            ),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
      BuildContext context, WidgetRef ref, String filter) {
    final currentFilter = ref.watch(courseFilterProvider);
    return ListTile(
      title: customTextForWeather(
        title: filter,
        fontSize: 16,
        fontWeight:
            currentFilter == filter ? FontWeight.w700 : FontWeight.normal,
        color: currentFilter == filter ? Constants.darkBlue : Constants.black,
      ),
      onTap: () {
        ref.read(courseFilterProvider.notifier).state = filter;
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(courseProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                customTextForWeather(
                    title: "JC", fontSize: 20, fontWeight: FontWeight.w700),
                customTextForWeather(
                    title: "Education",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              ],
            ),
            customTextForWeather(
                title: "Get online degree from a top university", fontSize: 14),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Constants.darkBlue),
            onPressed: () => _showFilterBottomSheet(context, ref),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _buildBody(coursesAsync),
    );
  }

  Widget _buildBody(AsyncValue<List<UniversityCourse>> coursesAsync) {
    final currentFilter = ref.watch(courseFilterProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 10),
            height: 175,
            child: coursesAsync.when(
              data: (courses) {
                final bannerUrls =
                    courses.map((course) => course.imageUrl).toSet().toList();

                if (bannerUrls.isEmpty) {
                  return const Center(child: Text('No banners available'));
                }

                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CarouselSlider(
                      items: bannerUrls.map((url) {
                        final index = bannerUrls.indexOf(url);
                        final isCurrentPage = _currentBannerIndex == index;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isCurrentPage ? 0.2 : 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              url,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 175,
                        viewportFraction: 0.8,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                        autoPlayCurve: Curves.easeInOut,
                        scrollPhysics: const BouncingScrollPhysics(),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bannerUrls.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentBannerIndex == index
                                  ? Constants.darkBlue
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Constants.darkBlue),
              ),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 50,
            color: Constants.lightdull,
            child: coursesAsync.when(
              data: (courses) {
                final List<String> logoUrls =
                    courses.map((course) => course.logoUrl).toSet().toList();

                if (logoUrls.isEmpty) {
                  return const Center(child: Text('No logos available'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: logoUrls.length * 1000,
                  itemBuilder: (context, index) {
                    final itemIndex = index % logoUrls.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            logoUrls[itemIndex],
                            width: 100,
                            height: 50,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(
                color: Constants.darkBlue,
              )),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildCourseList(currentFilter, coursesAsync),
              Container(
                margin: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const customTextForWeather(
                      title: "What makes online degrees a smarter choice",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 20),
                    customListTile(
                      img: "assets/images/verified.png",
                      title: "UGC-approved, ",
                      subtitle: "equal to on-campus degrees",
                      titlebold: true,
                      subtitlebold: false,
                    ),
                    const SizedBox(height: 10),
                    customListTile(
                      img: "assets/images/wallet.png",
                      title: "3x more salary, ",
                      subtitle: "unlock job promotions faster",
                      titlebold: true,
                      subtitlebold: false,
                    ),
                    const SizedBox(height: 10),
                    customListTile(
                      img: "assets/images/exp_bag.png",
                      title: "Study while you work - ",
                      subtitle: "100% flexible",
                      titlebold: false,
                      subtitlebold: true,
                    ),
                    const SizedBox(height: 10),
                    customListTile(
                      img: "assets/images/certifcate.png",
                      title: "Top university degrees at ",
                      subtitle: "70% lower cost",
                      titlebold: false,
                      subtitlebold: true,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 10, right: 10),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customTextForWeather(
                            title: "Frequently Asked Questions(FAQ)",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          Divider(
                            color: Constants.orange,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      dense: true,
                      title: customTextForWeather(
                        title:
                            "Are online degrees better than on-campus degrees?",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        customText(
                          fontSize: 12,
                          title:
                              "An online degree from a NAAC A+ accredited university carries equal recognition as a regular on-campus program, with extra advantages like flexibility, cost-effectiveness, and ease of access. Learn from anywhere, at your own pace, and save up to 70% compared to traditional education. With diverse course options and opportunities for global connections, online education cuts down on travel and campus-related costs while enhancing career prospects. Whether you're a student, recent graduate, or working professional, choosing an online degree is a smart move for career advancement.",
                        ),
                      ],
                    ),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      dense: true,
                      title: customTextForWeather(
                        title: "How much does JC Education cost?",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        customText(
                          fontSize: 12,
                          title:
                              "JC Education comes absolutely free when you enroll in an online degree through our platform. We also provide flexible EMI options to make your learning journey budget-friendly. Sign up today to discover the payment plan that suits you best!",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Constants.subtitleclr,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 4,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(
      String filter, AsyncValue<List<UniversityCourse>> coursesAsync) {
    return coursesAsync.when(
      data: (courses) {
        final filteredCourses = filter == 'All'
            ? courses
            : courses
                .where(
                    (c) => c.courseName.toLowerCase() == filter.toLowerCase())
                .toList();

        if (filteredCourses.isEmpty) {
          return Center(child: Text('No $filter courses available'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(
                      courseName: filteredCourses[index].courseName,
                      url: filteredCourses[index].detail_url,
                    ),
                  ),
                );
              },
              child: UniversityCard(course: filteredCourses[index]),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Constants.darkBlue,
        ),
      ),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

class customListTile extends StatelessWidget {
  String img, title, subtitle;
  bool titlebold, subtitlebold;
  customListTile({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
    required this.titlebold,
    required this.subtitlebold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            height: 20,
            width: 20,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: GoogleFonts.merriweather(
                      fontWeight:
                          titlebold ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: subtitle,
                    style: GoogleFonts.merriweather(
                      fontSize: 14,
                      fontWeight:
                          subtitlebold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
