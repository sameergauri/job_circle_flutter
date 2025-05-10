// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/custom_drawer.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_filter.dart';
import 'package:job_circle/models/job_home_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/new_jobs/custom_job_card.dart';
import 'package:job_circle/screens/new_jobs/job_detail/job_detail_page.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class JobHomePage extends ConsumerStatefulWidget {
  const JobHomePage({super.key});

  @override
  ConsumerState<JobHomePage> createState() => _JobHomePageState();
}

class _JobHomePageState extends ConsumerState<JobHomePage> {
  String selectedTab = '';
  String? selectedCity;
  bool showCityDropdown = false;

  @override
  void initState() {
    super.initState();
    ref.read(jobListProvider.notifier).fetchJobs();
    _initializeCity();
  }

  Future<void> _initializeCity() async {
    // Get the initial city from shared preferences or any other storage
    final initialCity = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_selected_lcoation.name);

    if (initialCity != null && initialCity.isNotEmpty) {
      setState(() {
        selectedCity = initialCity;
      });
      ref.read(jobListProvider.notifier).updateCityFilter(initialCity);
    }
  }

  void clearCityFilter() {
    setState(() {
      selectedCity = null;
    });
    ref.read(jobListProvider.notifier).updateCityFilter(null);
  }

  void toggleTab(String tab) {
    setState(() {
      if (selectedTab == tab) {
        selectedTab = '';
      } else {
        selectedTab = tab;
      }
    });
  }

  List<JobContent> filterJobs(List<JobContent> jobs) {
    if (selectedTab.isEmpty) return jobs;

    switch (selectedTab) {
      case 'Fresher':
        return jobs
            .where((job) =>
                job.experienceRequired?.toLowerCase() == 'fresher can apply')
            .toSet()
            .toList();
      case 'Linguistic':
        return jobs
            .where((job) =>
                job.languages != null &&
                job.languages!.isNotEmpty &&
                job.languages != '[]')
            .toSet()
            .toList();
      case 'Lateral':
        return jobs.where((job) => job.isCampus == 1).toSet().toList();
      case 'Saved':
        return jobs.where((job) => job.isFavorite == true).toSet().toList();
      default:
        return jobs;
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final jobs = ref.watch(jobListProvider);
    final filteredJobs = filterJobs(jobs);

    final jobLoadingProvider = Provider<bool>((ref) {
      final jobNotifier = ref.watch(jobListProvider.notifier);
      return jobNotifier.isLoading;
    });

    final jobFilterProvider = Provider<JobfilterModel?>((ref) {
      final jobNotifier = ref.watch(jobListProvider.notifier);
      return jobNotifier.filters;
    });

    final filters = ref.watch(jobFilterProvider);

    final companies = filters?.companies;
    final roles = filters?.roles;
    final processes = filters?.processes;
    final locations = filters?.locations;
    final shiftTimes = filters?.shiftTimes;
    final languages = filters?.languages;
    final cities = filters?.cities;

    // Use as needed in dropdowns or filters

    final isLoading = ref.watch(jobLoadingProvider);

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawer(
            onClose: () {
              _scaffoldKey.currentState?.closeDrawer();
            },
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Constants.bgColorWhite,
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
                // constDrawer()
              },
              icon: const CircleAvatar(
                // radius: 16,
                backgroundColor: Constants.lightdull,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Constants.darkBlue,
                ),
              ),
            ),
            title: Expanded(
                child: CustomTextFieldforAll(
              onTabOutside: (PointerDownEvent event) async {
                FocusScope.of(context).requestFocus(FocusNode());
                searchController.clear();
                ref
                    .read(jobListProvider.notifier)
                    .updateSearchQuery(searchController.text);
                ref.read(jobListProvider.notifier).fetchJobs();
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                searchController.clear();
                ref
                    .read(jobListProvider.notifier)
                    .updateSearchQuery(searchController.text);
                ref.read(jobListProvider.notifier).fetchJobs();
              },
              onChanged: (value) =>
                  ref.read(jobListProvider.notifier).updateSearchQuery(value),
              controller: searchController,
              hint: 'Search Jobs by role, process, or Company',
            )),
            actions: [
              InkWell(
                  onTap: () {
                    _showCityBottomSheet();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 10),
                    child: customTextForWeather(
                        color: Constants.darkBlue,
                        fontWeight: FontWeight.bold,
                        title: selectedCity != null
                            ? selectedCity.toString()
                            : "Select City"),
                  )),
            ],
          ),
          body: Column(
            children: [
              // Banner
              /*  Container(  //TODO:: Banner
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade50,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/256/6658/6658091.png',
                    ),
                  ),
                ),
              ), */

              // Tab Bar
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _showFilterBottomSheet();
                      },
                      icon: const Icon(Icons.filter_list,
                          color: Constants.darkBlue),
                    ),
                    /*  ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: ['Fresher', 'Linguistic', 'Lateral', 'Saved']
                          .map(
                            (tab) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                label: customTextForWeather(title: tab),
                                selected: selectedTab == tab,
                                onSelected: (_) => toggleTab(tab),
                                selectedColor: Colors.blue.shade100,
                                backgroundColor: Colors.grey.shade200,
                                labelStyle: GoogleFonts.merriweather(
                                  fontSize: 12,
                                  color: selectedTab == tab
                                      ? Constants.black
                                      : Constants.subtitleclr,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ), */
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Job List
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  //  controller: _scrollController,
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    List<String> myList = job.skills != null
                        ? List<String>.from(jsonDecode(job.skills!))
                        : [];
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JobDetailPage(
                                          jobId: job.id!,
                                        )),
                              );
                            },
                            child: CustomJobCard(job: job, skills: myList)),
                        if (index !=
                            filteredJobs.length -
                                1) // ✅ Add Divider except last item
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(thickness: 1.0),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (isLoading) // Show loading indicator if loading
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Blur Effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.2), // Semi-transparent overlay
                  ),
                ),
                // Circular Progress Indicator
                const CircularProgressIndicator(
                  color: Constants.darkBlue,
                ),
              ],
            ),
          ),
      ],
    );
  }

  TextEditingController locationController = TextEditingController();
  List<String> filteredCities = [];

  Future<void> _showCityBottomSheet() async {
    final filters = ref.read(jobListProvider.notifier).filters;
    final cities = filters?.cities ?? [];
    filteredCities = List.from(cities); // initialize filteredCities
    locationController.clear();

    await showModalBottomSheet(
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Constants.bgColorWhite,
      //    isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            //  height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Job Location',
                      style: GoogleFonts.merriweather(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Constants.darkBlue,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          locationController.clear();
                          Navigator.pop(context);
                        },
                        child: Image.network(
                          "https://cdn-icons-png.flaticon.com/128/607/607863.png",
                          height: 20,
                          width: 20,
                        )),
                  ],
                ),
                const customTextForWeather(
                  title: 'Jobs are shown based on your selected city',
                ),
                const SizedBox(height: 16),
                CustomTextFieldforAll(
                    onChanged: (value) {
                      setState(() {
                        filteredCities = cities
                            .where((city) => city
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    controller: locationController,
                    hint: "Type to search location"),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredCities.isEmpty
                      ? const customTextForWeather(
                          title: "No city found",
                          fontSize: 14,
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCities.length,
                          itemBuilder: (context, index) {
                            final city = filteredCities[index];
                            final isEven = index % 2 == 0;
                            return Container(
                              decoration: BoxDecoration(
                                color: isEven
                                    ? Constants.borderColor
                                    : Constants.bgColorWhite,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                title: customTextForWeather(title: city),
                                trailing: selectedCity == city
                                    ? Image.network(
                                        "https://cdn-icons-png.flaticon.com/128/7794/7794658.png",
                                        height: 20,
                                        width: 20,
                                        color: Constants.darkBlue,
                                      )
                                    : null,
                                onTap: () async {
                                  locationController.clear();
                                  SharedPreferences pres =
                                      await Utils.getSharedPreferences();
                                  await Utils.setPreference(
                                    pres,
                                    ESharedPreferences
                                        .user_selected_lcoation.name,
                                    city,
                                  );
                                  setState(() {
                                    selectedCity = city;
                                  });
                                  ref
                                      .read(jobListProvider.notifier)
                                      .updateCityFilter(city);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildFilterCategory(String title,
      {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Constants.bgColorWhite,
          boxShadow: [
            BoxShadow(
              color: isSelected ? Constants.bgColorWhite : Colors.transparent,
              blurRadius: 4,
              spreadRadius: 8,
            ),
          ],
          border: Border(
            left: BorderSide(
              color: isSelected ? Constants.orange : Colors.transparent,
              width: 3,
            ),
            top: BorderSide(
              color: isSelected ? Constants.lightdull : Colors.transparent,
              width: 3,
            ),
            bottom: BorderSide(
              color: isSelected ? Constants.lightdull : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: customTextForWeather(
          title: title,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: Constants.black,
        ),
      ),
    );
  }

  List<String> selectedFunctionalAreas = [];
  List<String> selectedLanguages = [];
  Future<void> _showFilterBottomSheet() async {
    final filters = ref.read(jobListProvider.notifier).filters;
    final functionalAreas = filters?.functionalAreas ?? [];
    final languages = filters?.languages ?? [];

    // Track which category is currently selected
    String selectedCategory = 'Functional Area';

    await showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Constants.bgColorWhite,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const customTextForWeather(
                      title: 'Filter',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Constants.darkBlue,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/128/607/607863.png",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      // Left side - Filter categories
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListView(
                          children: [
                            _buildFilterCategory(
                              'Functional Area',
                              isSelected: selectedCategory == 'Functional Area',
                              onTap: () {
                                setState(() {
                                  selectedCategory = 'Functional Area';
                                });
                              },
                            ),
                            _buildFilterCategory(
                              'Language',
                              isSelected: selectedCategory == 'Language',
                              onTap: () {
                                setState(() {
                                  selectedCategory = 'Language';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      // Right side - Filter options
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView(
                            children: [
                              if (selectedCategory == 'Functional Area') ...[
                                ...functionalAreas.map((area) {
                                  final isSelected =
                                      selectedFunctionalAreas.contains(area);
                                  return CheckboxListTile(
                                    activeColor: Constants.darkBlue,
                                    title: Text(area),
                                    value: isSelected,
                                    onChanged: (selected) {
                                      setState(() {
                                        if (selected!) {
                                          selectedFunctionalAreas.add(area);
                                        } else {
                                          selectedFunctionalAreas.remove(area);
                                        }
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  );
                                }),
                              ],
                              if (selectedCategory == 'Language') ...[
                                ...languages.map((language) {
                                  final isSelected =
                                      selectedLanguages.contains(language);
                                  return CheckboxListTile(
                                    activeColor: Constants.darkBlue,
                                    title: Text(language),
                                    value: isSelected,
                                    onChanged: (selected) {
                                      setState(() {
                                        if (selected!) {
                                          selectedLanguages.add(language);
                                        } else {
                                          selectedLanguages.remove(language);
                                        }
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: CustomButtonForJobPosting(
                            textColor: Constants.darkBlue,
                            buttonColor: Constants.bgColorWhite,
                            buttonText: "Reset",
                            onTap: () {
                              setState(() {
                                selectedFunctionalAreas.clear();
                                selectedLanguages.clear();
                              });
                              ref.read(jobListProvider.notifier).clearFilters();
                            }),
                      ),
                      SizedBox(
                        width: 200,
                        child: CustomButtonForJobPosting(
                            buttonText: "Apply",
                            onTap: () {
                              ref.read(jobListProvider.notifier).updateFilters(
                                    functionalAreas: selectedFunctionalAreas,
                                    languages: selectedLanguages,
                                  );
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
