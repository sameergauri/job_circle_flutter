import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/customButton_for_jobPosting.dart';
import 'package:job_circle/constants/custom_drawer.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_home_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield_for_all.dart';
import 'package:job_circle/screens/new_jobs/custom_job_card.dart';
import 'package:job_circle/screens/new_jobs/job_detail/job_detail_page.dart';
import 'package:job_circle/screens/new_jobs/job_home_provider.dart';
import 'package:job_circle/themes/colors.dart';

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
    _initializeCity();
  }

  Future<void> _initializeCity() async {
    final initialCity = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_selected_lcoation.name);
    if (initialCity != null && initialCity.isNotEmpty) {
      setState(() {
        selectedCity = initialCity;
      });
      ref.read(jobListProvider.notifier).updateCityFilter(initialCity);
    }
  }

  void clearCityFilter() async {
    setState(() {
      selectedCity = null;
    });
    Utils.setPreference(
      await Utils.getSharedPreferences(),
      ESharedPreferences.user_selected_lcoation.name,
      '',
    );
    ref.read(jobListProvider.notifier).updateCityFilter(null);
  }

  void toggleTab(String tab) {
    setState(() {
      selectedTab = selectedTab == tab ? '' : tab;
    });
  }

  List<JobContent> filterJobs(List<JobContent> jobs) {
    if (selectedTab.isEmpty) return jobs;

    switch (selectedTab) {
      case 'Fresher':
        return jobs
            .where((job) =>
                job.experienceRequired?.toLowerCase().contains('fresher') ??
                false)
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
        return jobs
            .where((job) => job.level_of_hiring == "Leader")
            .toSet()
            .toList();
      case 'Saved':
        return jobs.where((job) => job.isFavorite == true).toSet().toList();
      default:
        return jobs;
    }
  }

  List<String> getAvailableTabs(List<JobContent> jobs) {
    final tabs = <String>[];
    if (jobs.any((job) =>
        job.experienceRequired?.toLowerCase().contains('fresher') ?? false)) {
      tabs.add('Fresher');
    }
    if (jobs.any((job) =>
        job.languages != null &&
        job.languages!.isNotEmpty &&
        job.languages != '[]')) {
      tabs.add('Linguistic');
    }
    if (jobs.any((job) => job.level_of_hiring == "Leader")) {
      tabs.add('Leadership');
    }
    if (jobs.any((job) => job.isFavorite == true)) {
      tabs.add('Saved');
    }
    return tabs;
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final jobs = ref.watch(jobListProvider);
    final filteredJobs = filterJobs(jobs);
    final isLoading = ref.watch(jobListProvider.notifier).isLoading;
    final selectedCityFromProvider =
        ref.watch(jobListProvider.notifier).selectedCity;
    final userData = ref.watch(jobListProvider.notifier).userData;
    final availableTabs = getAvailableTabs(jobs);

    return Stack(
      children: [
        Scaffold(
          /*  floatingActionButton: FloatingActionButton( //TODO: Filter..
              backgroundColor: Constants.borderColor,
              onPressed: () {
                _showFilterBottomSheet();
              },
              child: const Icon(Icons.filter_list, color: Constants.darkBlue)), */
          backgroundColor: Colors.white,
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
              },
              icon: CircleAvatar(
                radius: 30,
                backgroundColor: Constants.bgColorWhite,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Constants.borderColor,
                  backgroundImage: userData?.userProfilePic != null &&
                          userData?.userProfilePic != " " &&
                          userData!.userProfilePic != ''
                      ? NetworkImage(
                          "${GlobalConstants.Image_url}${userData.userProfilePic}")
                      : userData?.userGender == "Male"
                          ? const AssetImage("assets/images/leadmale.png")
                              as ImageProvider
                          : const AssetImage("assets/images/leadfemal.png")
                              as ImageProvider,
                ),
              ),
            ),
            title: DynamicHintTextField(
              onChanged: (value) {
                ref.read(jobListProvider.notifier).updateSearchQuery(value);
              },
              controller: searchController,
              hint: 'Search Jobs by Designation, Process, or Company',
            ),
            actions: [
              InkWell(
                onTap: () {
                  _showCityBottomSheet();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 15, left: 10),
                  child: customTextForWeather(
                    color: Constants.darkBlue,
                    fontWeight: FontWeight.bold,
                    title: selectedCityFromProvider ?? "Select City",
                  ),
                ),
              ),
            ],
          ),
          body: selectedCityFromProvider == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomNetworkImage(
                            height: 200,
                            width: 200,
                            imageUrl:
                                "https://cdn-icons-gif.flaticon.com/8112/8112651.gif",
                            defaultIcon: Icons.error_outline),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        _showCityBottomSheet();
                      },
                      child: const customTextForWeather(
                          title: "Select City",
                          fontSize: 16,
                          color: Constants.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Column(
                  children: [
                    // Tab Bar
                    if (availableTabs.isNotEmpty)
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          children: availableTabs
                              .map(
                                (tab) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: FilterChip(
                                    label: customTextForWeather(title: tab),
                                    selected: selectedTab == tab,
                                    onSelected: (_) => toggleTab(tab),
                                    selectedColor: Constants.borderColor,
                                    backgroundColor: Constants.lightdull,
                                    labelStyle: GoogleFonts.merriweather(
                                      fontSize: 12,
                                      fontWeight: selectedTab == tab
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: selectedTab == tab
                                          ? Constants.black
                                          : Constants.subtitleclr,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Job List with Pull-to-Refresh
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await ref.read(jobListProvider.notifier).fetchJobs(
                              isRefresh: true, applyCityFilter: true);
                        },
                        color: Constants.darkBlue,
                        backgroundColor: Constants.bgColorWhite,
                        child: filteredJobs.isEmpty && !isLoading
                            ? const Center(child: Text('No jobs found'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredJobs.length,
                                itemBuilder: (context, index) {
                                  final job = filteredJobs[index];
                                  List<String> myList = job.skills != null
                                      ? List<String>.from(
                                          jsonDecode(job.skills!))
                                      : [];
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  JobDetailPage(
                                                      jobId: job.id!,
                                                      fromWhere:
                                                          FromWhere.homePage),
                                            ),
                                          );
                                        },
                                        child: CustomJobCard(
                                          job: job,
                                          skills: myList,
                                          onLastFavoriteRemoved: () {
                                            if (selectedTab == 'Saved') {
                                              setState(() {
                                                selectedTab = '';
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      if (index != filteredJobs.length - 1)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Divider(thickness: 1.0),
                                        ),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Constants.darkBlue,
            ),
          ),
      ],
    );
  }

  TextEditingController locationController = TextEditingController();
  List<String> filteredCities = [];

  Future<void> _showCityBottomSheet() async {
    final availableCities =
        ref.read(jobListProvider.notifier).availableCities ?? [];
    filteredCities = List.from(availableCities);
    locationController.clear();

    await showModalBottomSheet(
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Constants.bgColorWhite,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(16),
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
                      ),
                    ),
                  ],
                ),
                const customTextForWeather(
                  title: 'Jobs are shown based on your selected city',
                ),
                const SizedBox(height: 16),
                CustomTextFieldforAll(
                  onChanged: (value) {
                    setState(() {
                      filteredCities = availableCities
                          .where((city) =>
                              city.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  controller: locationController,
                  hint: "Type to search location",
                ),
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
                                  final prefs =
                                      await Utils.getSharedPreferences();
                                  await Utils.setPreference(
                                    prefs,
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
    final notifier = ref.read(jobListProvider.notifier);

    final availableFilters = notifier.availableFilters;
    final activeFilters = notifier.activeFilters;

    selectedFunctionalAreas = activeFilters?.functionalAreas ?? [];
    selectedLanguages = activeFilters?.languages ?? [];

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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView(
                            children: [
                              if (selectedCategory == 'Functional Area') ...[
                                ...(availableFilters?.functionalAreas ?? [])
                                    .map((area) {
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
                                ...(availableFilters?.languages ?? [])
                                    .map((language) {
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
                  padding: const EdgeInsets.only(bottom: 16),
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
                            notifier.clearAllFilters();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: CustomButtonForJobPosting(
                          buttonText: "Apply",
                          onTap: () {
                            notifier.applySelectedFilters(
                              functionalAreas: selectedFunctionalAreas,
                              languages: selectedLanguages,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
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
