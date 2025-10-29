// ignore_for_file: unnecessary_null_comparison, unused_element, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_filter_model.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/screen/Jobs/job_detail_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/button/custom_full_size_button.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/job/custom_job_card.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_dynamic_text_field.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class JobHomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState>
  scaffoldKey; // Add the scaffoldKey as a parameter
  const JobHomePage({super.key, required this.scaffoldKey});

  @override
  State<JobHomePage> createState() => _JobHomePageState();
}

class _JobHomePageState extends State<JobHomePage> {
  String selectedTab = '';
  String? selectedCity;
  bool showCityDropdown = false;

  @override
  void initState() {
    super.initState();
    _initializeCity();
    /*   WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).fetchRecomendJob();
    }); */
  }

  Future<void> _initializeCity() async {
    final initialCity = SharedPrefsHelper.getString(
      ESharedPreferences.user_selected_lcoation,
    );
    if (initialCity != null && initialCity.isNotEmpty) {
      setState(() {
        selectedCity = initialCity;
      });
      Provider.of<JobProvider>(
        context,
        listen: false,
      ).updateCityFilter(initialCity);
    }
  }

  void clearCityFilter() async {
    setState(() {
      selectedCity = null;
    });
    SharedPrefsHelper.setPreference(
      ESharedPreferences.user_selected_lcoation,
      '',
    );
    Provider.of<JobProvider>(context, listen: false).updateCityFilter(null);
  }

  void toggleTab(String tab) {
    setState(() {
      selectedTab = selectedTab == tab ? '' : tab;
    });
    if (selectedTab == "Recommended Jobs") {
      final provider = Provider.of<JobProvider>(context, listen: false);
      if (provider.recommendedJob?.data?.recommendations?.isEmpty ?? true) {
        provider.fetchRecomendJob();
      }
    }
  }

  List<JobContent> filterJobs(List<JobContent> jobs) {
    if (selectedTab.isEmpty) return jobs;

    switch (selectedTab) {
      case 'Fresher':
        return jobs
            .where(
              (job) =>
                  job.experienceRequired?.toLowerCase().contains('fresher') ??
                  false,
            )
            .toSet()
            .toList();
      case 'Linguistic':
        return jobs
            .where(
              (job) =>
                  job.languages != null &&
                  job.languages!.isNotEmpty &&
                  job.languages != '[]',
            )
            .toSet()
            .toList();
      case 'Leadership':
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
    if (jobs.any(
      (job) =>
          job.experienceRequired?.toLowerCase().contains('fresher') ?? false,
    )) {
      tabs.add('Fresher');
    }
    if (jobs.any(
      (job) =>
          job.languages != null &&
          job.languages!.isNotEmpty &&
          job.languages != '[]',
    )) {
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
    return Consumer<JobProvider>(
      builder: (context, jobProvider, child) {
        final jobs = jobProvider.jobs;
        final filteredJobs = filterJobs(jobs);
        final isLoading = jobProvider.isLoading;
        final selectedCityFromProvider = jobProvider.selectedCity;
        final userData = jobProvider.userData;
        final availableTabs = ["Recommended Jobs", ...getAvailableTabs(jobs)];
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Constants.white,
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: () {
                    widget.scaffoldKey.currentState?.openDrawer();
                  },
                  icon: /* jobProvider.isLoading
                      ? CircularProgressIndicator(
                          color: Constants.darkBlue,
                          strokeWidth: 0.5,
                        )
                      : */ CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.white,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Constants.borderColor,
                      backgroundImage:
                          userData?.userProfilePic != null &&
                              userData?.userProfilePic != " " &&
                              userData!.userProfilePic != "" &&
                              userData.userProfilePic != "null"
                          ? NetworkImage(
                              "${GlobalConstants.Image_url}${userData.userProfilePic}",
                            )
                          : userData?.userGender == "Male"
                          ? const AssetImage(CustomAssetUrl.maleicon)
                                as ImageProvider
                          : userData?.userGender == "Female"
                          ? const AssetImage(CustomAssetUrl.femalicon)
                                as ImageProvider
                          : NetworkImage(CustomIconUrl.usericon),
                    ),
                  ),
                ),
                title: DynamicHintTextField(
                  focusNode: jobProvider.searchBarFocusNode,
                  isGmail: true,
                  onChanged: (value) {
                    jobProvider.updateSearchQuery(value);
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
                      padding: const EdgeInsets.only(
                        top: 0, // No top padding
                        right: 15,
                        left: 10,
                      ),
                      child: customText(
                        color: Constants.darkBlue,
                        fontWeight: FontWeight.bold,
                        title:
                            selectedCityFromProvider != null &&
                                selectedCityFromProvider != ""
                            ? selectedCityFromProvider == "Maharashtra"
                                  ? "WFH / Remote"
                                  : selectedCityFromProvider
                            : "Select City",
                      ),
                    ),
                  ),
                ],
              ),
              body:
                  selectedCityFromProvider == null ||
                      selectedCityFromProvider == '' ||
                      selectedCityFromProvider == ' '
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
                              imageUrl: CustomIconUrl.locationicon,
                              defaultIcon: Icons.error_outline,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            _showCityBottomSheet();
                          },
                          child: const customText(
                            title: "Select City",
                            fontSize: 16,
                            color: Constants.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        if (availableTabs.isNotEmpty)
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              children: availableTabs
                                  .map(
                                    (tab) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: CustomToggleButton(
                                        isSelect: selectedTab == tab,
                                        title: tab,
                                        onTap: () {
                                          toggleTab(tab);
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              if (selectedTab == "Recommended Jobs") {
                                await jobProvider.fetchRecomendJob();
                              } else {
                                await jobProvider.fetchJobs(
                                  isRefresh: true,
                                  applyCityFilter: true,
                                );
                              }
                            },
                            color: Constants.darkBlue,
                            backgroundColor: Constants.white,
                            child: selectedTab == "Recommended Jobs"
                                ? _buildRecommendedJobsList(
                                    jobProvider,
                                    userData,
                                  )
                                : _buildRegularJobsList(
                                    filteredJobs,
                                    // filterJobs(jobs),
                                    isLoading,
                                    userData,
                                  ),
                          ),
                        ),
                      ],
                    ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: Constants.darkBlue),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRegularJobsList(
    List<JobContent> filteredJobs,
    bool isLoading,
    UserData? userData,
  ) {
    return filteredJobs.isEmpty && !isLoading
        ? const Center(child: Text('No jobs found'))
        : ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
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
                      NavigationService.push(
                        JobDetailPage(
                          resume: userData!.cv_link,
                          jobId: job.id!,
                          fromWhere: FromWhere.homePage,
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(thickness: 1.0),
                    ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
  }

  Widget _buildRecommendedJobsList(
    JobProvider jobProvider,
    UserData? userData,
  ) {
    final recommendedJobs =
        jobProvider.recommendedJob?.data?.recommendations ?? [];
    final isLoading = jobProvider.recommendLoading;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Constants.darkBlue),
      );
    }

    if (recommendedJobs.isEmpty) {
      return const Center(child: Text('No recommended jobs found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: recommendedJobs.length,
      itemBuilder: (context, index) {
        final job = recommendedJobs[index];
        List<String> myList = job.skills != null
            ? List<String>.from(job.skills!)
            : [];
        return Column(
          children: [
            InkWell(
              onTap: () {
                NavigationService.push(
                  JobDetailPage(
                    resume: userData!.cv_link,
                    jobId: job.id!,
                    fromWhere: FromWhere.homePage,
                  ),
                );
              },
              child: CustomRecommendJobcard(
                job: job,
                skills: myList,
                onLastFavoriteRemoved: () {},
              ),
            ),
            if (index != recommendedJobs.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(thickness: 1.0),
              ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  TextEditingController locationController = TextEditingController();
  List<String> filteredCities = [];

  Future<void> _showCityBottomSheet() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final availableCities = jobProvider.availableCities ?? [];
    filteredCities = List.from(
      availableCities.where(
        (city) => city != null && city.toString().trim().isNotEmpty,
      ),
    );
    locationController.clear();

    await showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Constants.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7, // 👈 half screen height initially
          minChildSize: 0.3, // 👈 smallest it can be dragged down to
          maxChildSize: 0.7, // 👈 maximum scroll height
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
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
                              NavigationService.pop();
                            },
                            child: Image.network(
                              CustomIconUrl.cancelicon,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ],
                      ),
                      const customText(
                        title: 'Jobs are shown based on your selected city',
                      ),
                      const SizedBox(height: 16),
                      CustomTextFieldforAll(
                        onChanged: (value) {
                          setState(() {
                            filteredCities = availableCities
                                .where(
                                  (city) => city.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                                )
                                .toList();
                          });
                        },
                        controller: locationController,
                        hint: "Type to search location",
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: filteredCities.isEmpty
                            ? const customText(
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
                                          : Constants.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      title: customText(
                                        title: city == "Maharashtra"
                                            ? "WFH / Remote"
                                            : city,
                                      ),
                                      trailing: selectedCity == city
                                          ? CustomNetworkImage(
                                              imageUrl: CustomIconUrl.locicon,
                                              defaultIcon:
                                                  Icons.location_on_outlined,
                                            )
                                          : null,
                                      onTap: () async {
                                        SharedPrefsHelper.setPreference(
                                          ESharedPreferences
                                              .user_selected_lcoation,
                                          city,
                                        );
                                        setState(() {
                                          selectedCity = city;
                                        });
                                        jobProvider.updateCityFilter(city);
                                        NavigationService.pop();
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilterCategory(
    String title, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Constants.white,
          boxShadow: [
            BoxShadow(
              color: isSelected ? Constants.white : Colors.transparent,
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
        child: customText(
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
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final availableFilters = jobProvider.availableFilters;
    final activeFilters = jobProvider.activeFilters;

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
      backgroundColor: Constants.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const customText(
                        title: 'Filter',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Constants.darkBlue,
                      ),
                      InkWell(
                        onTap: () => NavigationService.pop(),
                        child: CustomNetworkImage(
                          imageUrl: CustomIconUrl.cancelicon,
                          defaultIcon: Icons.close,
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
                                isSelected:
                                    selectedCategory == 'Functional Area',
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
                                            selectedFunctionalAreas.contains(
                                              area,
                                            );
                                        return CheckboxListTile(
                                          activeColor: Constants.darkBlue,
                                          title: Text(area),
                                          value: isSelected,
                                          onChanged: (selected) {
                                            setState(() {
                                              if (selected!) {
                                                selectedFunctionalAreas.add(
                                                  area,
                                                );
                                              } else {
                                                selectedFunctionalAreas.remove(
                                                  area,
                                                );
                                              }
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        );
                                      }),
                                ],
                                if (selectedCategory == 'Language') ...[
                                  ...(availableFilters?.languages ?? []).map((
                                    language,
                                  ) {
                                    final isSelected = selectedLanguages
                                        .contains(language);
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
                            buttonColor: Constants.white,
                            buttonText: "Reset",
                            onTap: () {
                              jobProvider.clearAllFilters();
                              NavigationService.pop();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: CustomButtonForJobPosting(
                            buttonText: "Apply",
                            onTap: () {
                              jobProvider.applySelectedFilters(
                                functionalAreas: selectedFunctionalAreas,
                                languages: selectedLanguages,
                              );
                              NavigationService.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
