// ignore_for_file: avoid_print
// ignore_for_file: todo
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/new_job_model.dart';
import 'package:job_circle/screens/new_jobs/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final jobsProvider = ChangeNotifierProvider((ref) => JobProvider()..init());

final profileSummaryProvider = FutureProvider<ProfileModel>((ref) async {
  final summaryResponse = await JobProvider.bindProfileSummary();
  return ProfileModel.fromJson(summaryResponse);
});

class JobProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Map<String, List<String>> filterData = {};
  Map<String, List<String>> originalFilterData = {};
  String selectedKey = '';
  Map<String, List<String>> selectedData = {};

  String role = '';
  String get getRole => role;
  set setRole(String value) {
    role = value;
    notifyListeners();
  }

  String _selectedLocation = '';
  String get selectedLocation => _selectedLocation;
  set selectedLocation(String value) {
    _selectedLocation = value;
    notifyListeners();
  }

  List<JobsModel> _jobs = [];
  List<JobsModel> get jobs => _jobs;
  set jobs(List<JobsModel> value) {
    _jobs = value;
    locationList = _jobs.map((job) => job.city ?? '').toSet().toList();
    notifyListeners();
  }

  List<JobsModel> _filteredJobs = [];
  List<JobsModel> get filteredJobs => _filteredJobs;
  set filteredJobs(List<JobsModel> value) {
    _filteredJobs = value;
    notifyListeners();
  }

  List<String> locationList = [];

  void init() async {
    isLoading = true;
    role = await Utils.getPreferencesValue(null, ESharedPreferences.role.name);
    await _loadSelectedLocation();
    await bindAllJobs();
    searchController.addListener(_onSearch);
    isLoading = false;
  }

  void applyFilter(ProfileModel model) {
    if (isFavoriteTabSelected) {
      toggleFavoriteJobs(model, unSelectTab: false, jobs: filteredJobs);
    } else if (isMyJobsTabSelected) {
      toggleMyJobsFilter(model, unSelectTab: false, jobs: filteredJobs);
    } else if (isFreshersTabSelected) {
      toggleFreshersFilter(model, unSelectTab: false, jobs: filteredJobs);
    } else if (isLanguilTabSelected) {
      toggleLanguilJobs(model, unSelectTab: false, jobs: filteredJobs);
    }
  }

  bool _isFavoriteTabSelected = false;
  bool get isFavoriteTabSelected => _isFavoriteTabSelected;
  set isFavoriteTabSelected(bool value) {
    _isFavoriteTabSelected = value;
    notifyListeners();
  }

  bool _isFreshersTabSelected = false;
  bool get isFreshersTabSelected => _isFreshersTabSelected;
  set isFreshersTabSelected(bool value) {
    _isFreshersTabSelected = value;
    notifyListeners();
  }

  bool _isMyJobsTabSelected = false;
  bool get isMyJobsTabSelected => _isMyJobsTabSelected;
  set isMyJobsTabSelected(bool value) {
    _isMyJobsTabSelected = value;
    notifyListeners();
  }

  bool _isLanguilTabSelected = false;
  bool get isLanguilTabSelected => _isLanguilTabSelected;
  set isLanguilTabSelected(bool value) {
    _isLanguilTabSelected = value;
    notifyListeners();
  }

  bool _isCompusTabSelected = false;
  bool get isCompusTabSelected => _isCompusTabSelected;
  set isCompusTabSelected(bool value) {
    _isCompusTabSelected = value;
    notifyListeners();
  }

  bool _isSupportStaff = false;
  bool get isSupportStaff => _isSupportStaff;
  set isSupportStaff(bool value) {
    _isSupportStaff = value;
    notifyListeners();
  }

  bool isFilterApplied = false;
  bool contains(dynamic value, dynamic searchTerm) {
    if (value is int && searchTerm is int) {
      return value == searchTerm;
    } else if (value is String && searchTerm is String) {
      return value.toLowerCase().contains(searchTerm.toLowerCase());
    }

    return false;
  }

  //TODO: fav...

  void toggleFavoriteJobs(ProfileModel profileModel,
      {bool unSelectTab = true, List<JobsModel>? jobs}) {
    if (unSelectTab) {
      isFavoriteTabSelected = !isFavoriteTabSelected;
    }
    isFreshersTabSelected = false;
    isMyJobsTabSelected = false;
    isLanguilTabSelected = false;
    isCompusTabSelected = false;
    isSupportStaff = false;
    if (isFavoriteTabSelected) {
      _applyFavFilter(profileModel, jobs);
      toggleLocationFilter(jobs: filteredJobs);
    } else {
      filteredJobs = List.from(jobs ?? this.jobs);
      toggleLocationFilter(jobs: jobs);
    }
  }

  void _applyFavFilter(ProfileModel profileModel, [List<JobsModel>? jobs]) {
    filteredJobs = (jobs ?? this.jobs)
        .where((job) =>
            contains(job.isFav, 1) && contains(job.userId, profileModel.id))
        .toList();

    isFilterApplied = true;
  }
  //TODO: filter foor support staff....

  void toggleSupportStaff(ProfileModel model,
      {bool unSelectedTab = true, List<JobsModel>? jobs}) {
    if (unSelectedTab) {
      isSupportStaff = !isSupportStaff;
    }
    isFreshersTabSelected = false;
    isMyJobsTabSelected = false;
    isLanguilTabSelected = false;
    isCompusTabSelected = false;
    isFavoriteTabSelected = false;

    if (isSupportStaff) {
      filteredJobs = (jobs ?? this.jobs)
          .where((job) => job.is_support_staff == 1)
          .toList();
      toggleLocationFilter(jobs: filteredJobs);
    } else {
      filteredJobs = List.from(jobs ?? this.jobs);
      toggleLocationFilter(jobs: jobs);
    }
  }

  //TODO: filter for compus...

  void toggleCompusJobs(ProfileModel model,
      {bool unSelectTab = true, List<JobsModel>? jobs}) {
    if (unSelectTab) {
      isCompusTabSelected = !isCompusTabSelected;
    }

    isMyJobsTabSelected = false;
    isFavoriteTabSelected = false;
    isFreshersTabSelected = false;
    isLanguilTabSelected = false;
    isSupportStaff = false;
    if (isCompusTabSelected) {
      filteredJobs =
          (jobs ?? this.jobs).where((job) => job.is_campus == 1).toList();
      toggleLocationFilter(jobs: filteredJobs);
    } else {
      filteredJobs = List.from(jobs ?? this.jobs);
      toggleLocationFilter(jobs: jobs);
    }
  }

//TODO filter for linguil....

  void toggleLanguilJobs(ProfileModel model,
      {bool unSelectTab = true, List<JobsModel>? jobs}) {
    if (unSelectTab) {
      isLanguilTabSelected = !isLanguilTabSelected;
    }

    isMyJobsTabSelected = false;
    isFavoriteTabSelected = false;
    isFreshersTabSelected = false;
    isCompusTabSelected = false;
    isSupportStaff = false;
    if (isLanguilTabSelected) {
      filteredJobs = (jobs ?? this.jobs)
          .where((job) => job.languagesKnown!.isNotEmpty)
          .toList();
      toggleLocationFilter(jobs: filteredJobs);
    } else {
      filteredJobs = List.from(jobs ?? this.jobs);
      toggleLocationFilter(jobs: jobs);
    }
  }

  //TODO:: MyJobs

  void toggleMyJobsFilter(ProfileModel profileModel,
      {bool unSelectTab = true, List<JobsModel>? jobs}) {
    if (unSelectTab) {
      isMyJobsTabSelected = !isMyJobsTabSelected;
    }
    isFreshersTabSelected = false;
    isFavoriteTabSelected = false;
    isLanguilTabSelected = false;
    isCompusTabSelected = false;
    isSupportStaff = false;
    if (isMyJobsTabSelected) {
      if (role == "1" && profileModel.usertype == 3) {
        _applySpocFilter(profileModel, jobs);
      } else if (role == "1" || role == "2") {
        _applySpocReportToFilter(profileModel, jobs);
      } else {
        _applySpocFilter(profileModel, jobs);
      }
      toggleLocationFilter(jobs: filteredJobs);
    } else {
      filteredJobs = List.from(jobs ?? this.jobs);
      toggleLocationFilter(jobs: jobs);
    }
  }

  void _applySpocReportToFilter(ProfileModel profileModel,
      [List<JobsModel>? jobs]) {
    filteredJobs = (jobs ?? this.jobs)
        .where((job) => contains(job.spoc, profileModel.reportTo))
        .toList();
    isFilterApplied = true;
  }

  void _applySpocFilter(ProfileModel profileModel, [List<JobsModel>? jobs]) {
    filteredJobs = (jobs ?? this.jobs)
        .where((job) => contains(job.spoc, profileModel.id))
        .toList();
  }

  //TODO: Fresher...

  void toggleFreshersFilter(ProfileModel model,
      {bool unSelectTab = true, List<JobsModel>? jobs}) {
    if (unSelectTab) {
      isFreshersTabSelected = !isFreshersTabSelected;
    }

    isMyJobsTabSelected = false;
    isFavoriteTabSelected = false;
    isLanguilTabSelected = false;
    isCompusTabSelected = false;
    isSupportStaff = false;
    if (isFreshersTabSelected) {
      filteredJobs = (jobs ?? this.jobs)
          .where((job) => job.isFresher == "Fresher")
          .toList();
      toggleLocationFilter(jobs: filteredJobs);
    } else {
      filteredJobs = List.from(jobs ?? this.jobs);
      toggleLocationFilter(jobs: jobs);
    }
  }

  /* void toggleLocationFilter({List<JobsModel>? jobs}) {  //TODO: old one
    filteredJobs = (jobs ?? this.jobs)
        .where((job) => selectedLocation.contains(job.city ?? ''))
        .toList();
    isFilterApplied = true;
  } */

  //TODOD: Location....
  void toggleLocationFilter({List<JobsModel>? jobs}) {
    if (selectedLocation.isEmpty) {
      filteredJobs = [];
    } else {
      filteredJobs = (jobs ?? _jobs).where((job) {
        if (job.city == null) {
          // print('Warning: Job city is null.');
          return false;
        }

        List<String> jobCities = job.city!
            .split(',')
            .map((city) => city.trim().toLowerCase())
            .toList();

        //   print('Selected Location: $selectedLocation');
        // print('Job Cities: $jobCities');

        bool hasMatchingLocation =
            jobCities.contains(selectedLocation.toLowerCase());

        //  print('Has Matching Location: $hasMatchingLocation');

        return hasMatchingLocation;
      }).toList();
    }
    isFilterApplied = true;
  }

  final TextEditingController searchController = TextEditingController();

  void _onSearch() async {
    if (searchController.text.isEmpty) {
      filteredJobs = List.from(jobs);
      return;
    }
    String query = searchController.text.toLowerCase();
    List<String> searchTerms = query.split(',');

    // Filter the profileSummaries based on the search query
    filteredJobs = filteredJobs.where((job) {
      final skillsAsString = job.skills?.join(", ") ?? "";
      final jobInfo = [
        job.companyName!.toLowerCase(),
        job.process!.toLowerCase(),
        job.roleName!.toLowerCase(),
        job.natureOfWork!.toLowerCase(),
        skillsAsString.toLowerCase(),
      ];

      // Check if any of the search terms match any job information
      return searchTerms.any((term) {
        return jobInfo.any((info) => info.contains(term));
      });
    }).toList();

    isFilterApplied = true;
  }

  Future<List<JobsModel>> bindAllJobs() async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/jobs/v1/all?pageNumber=1&pageSize=150'));

    if (response.statusCode == 200) {
      final parsedResponse =
          json.decode(response.body)['resultData']['content'];
      final jobsData = (parsedResponse)
          .map<JobsModel>((item) => JobsModel.fromJson(item))
          .toList();
      jobs = jobsData;
      if (selectedLocation.isNotEmpty) {
        toggleLocationFilter();
      }
      return jobsData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<Map<String, dynamic>> bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    var id =
        await Utils.getPreferencesValue(prefs, ESharedPreferences.user_id.name);
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host_one}/users/v1/profileSummary/$id'));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("resultData")) {
        return parsedResponse["resultData"] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _loadSelectedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLocation = prefs.getString('selectedLocation') ?? '';
  }

  bool _isFavLoading = false;
  bool get isFavLoading => _isFavLoading;
  set isFavLoading(bool value) {
    _isFavLoading = value;
    notifyListeners();
  }

  Future<void> removeFromFav(int favJobId, ProfileModel model) async {
    isFavLoading = true;
    try {
      final response = await http.delete(
        Uri.parse("http://${GlobalConstants.API_Host_one}/favjob/v1/$favJobId"),
        headers: <String, String>{},
      );

      if (response.statusCode == 200) {
        await bindAllJobs();
        if (isFavoriteTabSelected) {
          toggleFavoriteJobs(model, unSelectTab: false, jobs: filteredJobs);
        } else if (isMyJobsTabSelected) {
          toggleMyJobsFilter(model, unSelectTab: false, jobs: filteredJobs);
        } else if (isFreshersTabSelected) {
          toggleFreshersFilter(model, unSelectTab: false, jobs: filteredJobs);
        } else if (isLanguilTabSelected) {
          toggleLanguilJobs(model, unSelectTab: false, jobs: filteredJobs);
        }
      } else {
        print('Error during post request: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isFavLoading = false;
    }
  }

  Future<void> addToFav(int jobId, ProfileModel model) async {
    isFavLoading = true;
    try {
      final response = await http.post(
        Uri.parse(
            "http://${GlobalConstants.API_Host_one}/favjob/v1/${model.id}/$jobId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        await bindAllJobs();
        if (isFavoriteTabSelected) {
          toggleFavoriteJobs(model, unSelectTab: false, jobs: filteredJobs);
        } else if (isMyJobsTabSelected) {
          toggleMyJobsFilter(model, unSelectTab: false, jobs: filteredJobs);
        } else if (isFreshersTabSelected) {
          toggleFreshersFilter(model, unSelectTab: false, jobs: filteredJobs);
        } else if (isLanguilTabSelected) {
          toggleLanguilJobs(model, unSelectTab: false, jobs: filteredJobs);
        }
      } else {
        print('Error during post request: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isFavLoading = false;
    }
  }

  void clear() {
    searchController.clear();
    isFilterApplied = false;
    jobs = [];
    filteredJobs = [];
    selectedLocation = '';
  }
}
