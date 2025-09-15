// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_filter.dart';
import 'package:job_circle/models/job_home_page_model.dart';

// Define the provider
final jobListProvider =
    StateNotifierProvider<JobNotifier, List<JobContent>>((ref) {
  return JobNotifier();
});

class JobNotifier extends StateNotifier<List<JobContent>> {
  JobNotifier() : super([]) {
    fetchInitialJobs();
  }

  bool _isLoading = false;
  String _searchQuery = '';
  JobfilterModel? _availableFilters;
  JobfilterModel? _activeFilters;
  UserData? _userData;
  String? _selectedCity;
  List<JobContent> _allJobs = [];

  // Getters
  List<String>? get availableCities => _availableFilters?.cities;
  bool get isLoading => _isLoading;
  JobfilterModel? get availableFilters => _availableFilters;
  JobfilterModel? get activeFilters => _activeFilters;
  UserData? get userData => _userData;
  String? get selectedCity => _selectedCity;

  // Initial fetch without any filters
  Future<void> fetchInitialJobs() async {
    _selectedCity = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_selected_lcoation.name);
    await fetchJobs(isRefresh: true, applyCityFilter: _selectedCity != null);
  }

  Future<void> fetchJobs({
    bool isRefresh = false,
    bool applyCityFilter = true,
  }) async {
    if (_isLoading) {
      print('FetchJobs skipped: Already loading');
      return;
    }

    _isLoading = isRefresh ? true : false;
    if (isRefresh) {
      state = [];
      _allJobs = [];
    }

    try {
      final userid = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_id.name);

      final queryParams = {
        'pageNumber': '1',
        'pageSize': '1000',
        'userId': userid.toString(),
      };

      if (applyCityFilter &&
          _selectedCity != null &&
          _selectedCity!.isNotEmpty) {
        queryParams['cities'] = _selectedCity!;
      }

      final url = Uri.parse(
              "http://${GlobalConstants.API_Host_one}/api/jobs/v1/getAllJobs")
          .replace(queryParameters: queryParams);

      print('Fetching jobs with URL: $url');

      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = JobHomePageModel.fromJson(jsonData);
        final jobs = model.resultData?.allJobs?.pageResponse?.content ?? [];

        _availableFilters =
            JobfilterModel.fromJson(jsonData['resultData']["All Jobs"] ?? {});
        _userData = _availableFilters?.userData;

        _allJobs = jobs;
        print('Fetched ${_allJobs.length} jobs');
        // Log languages for debugging
        for (var job in _allJobs) {
          print('Job ID: ${job.id}, Languages: ${job.languages}');
        }

        _applyLocalFilters();
      } else {
        print(
            'Failed to fetch jobs. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching jobs: $e');
    } finally {
      _isLoading = false;
    }
  }

  void _applyLocalFilters() {
    var filteredJobs = _allJobs;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredJobs = filteredJobs.where((job) {
        return (job.rolename?.toLowerCase().contains(query) ?? false) ||
            (job.companyName?.toLowerCase().contains(query) ?? false) ||
            (job.process?.toLowerCase().contains(query) ?? false) ||
            (job.jobHeadline?.toLowerCase().contains(query) ?? false) ||
            (job.skills?.toLowerCase().contains(query) ?? false);
      }).toList();
      print('After search filter: ${filteredJobs.length} jobs');
    }

    // Apply functional areas and languages filters
    if (_activeFilters != null) {
      if (_activeFilters!.functionalAreas?.isNotEmpty ?? false) {
        filteredJobs = filteredJobs.where((job) {
          return _activeFilters!.functionalAreas!
              .contains(job.functionalArea ?? '');
        }).toList();
        print('After functional area filter: ${filteredJobs.length} jobs');
      }

      if (_activeFilters!.languages?.isNotEmpty ?? false) {
        filteredJobs = filteredJobs.where((job) {
          if (job.languages == null ||
              job.languages!.isEmpty ||
              job.languages == '[]') {
            return false;
          }
          // Handle various language formats
          String langString = job.languages!
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '');
          final jobLanguages = langString
              .split(',')
              .map((e) => e.trim().toLowerCase())
              .where((e) => e.isNotEmpty)
              .toList();
          print('Job ID: ${job.id}, Parsed Languages: $jobLanguages');
          return _activeFilters!.languages!
              .any((lang) => jobLanguages.contains(lang.toLowerCase()));
        }).toList();
        print('After language filter: ${filteredJobs.length} jobs');
      }
    }

    state = filteredJobs;
    print('Applied local filters: ${state.length} jobs');
  }

  Future<bool> saveFavoriteJob({
    required int userId,
    required int jobId,
  }) async {
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/favjob/v1/$userId/$jobId');

    try {
      print('Saving favorite job: userId=$userId, jobId=$jobId');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        print('Favorite job saved successfully');
        await fetchJobs(isRefresh: false, applyCityFilter: true);
        return true;
      } else {
        print(
            'Failed to save job. Status Code: ${response.statusCode}, Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saving job: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> removeFavoriteJob({required int favid}) async {
    final url =
        Uri.parse('http://${GlobalConstants.API_Host_one}/favjob/v1/$favid');

    try {
      print('Removing favorite job: favId=$favid');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Favorite job removed successfully');
        // Check if this was the last saved job before refreshing
        final wasLastSavedJob =
            state.where((job) => job.isFavorite == true).length <= 1;
        await fetchJobs(isRefresh: false, applyCityFilter: true);
        return {'success': true, 'wasLastSavedJob': wasLastSavedJob};
      } else {
        print(
            'Failed to remove job. Status Code: ${response.statusCode}, Response: ${response.body}');
        return {'success': false, 'wasLastSavedJob': false};
      }
    } catch (e) {
      print('Error removing job: $e');
      return {'success': false, 'wasLastSavedJob': false};
    }
  }

  void applySelectedFilters({
    List<String>? functionalAreas,
    List<String>? languages,
  }) {
    _activeFilters = JobfilterModel(
      functionalAreas: functionalAreas,
      languages: languages,
      companies: _availableFilters?.companies,
      cities: _availableFilters?.cities,
    );
    _applyLocalFilters();
  }

  void clearAllFilters() {
    _activeFilters = null;
    _searchQuery = '';
    _applyLocalFilters();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyLocalFilters();
  }

  void updateCityFilter(String? city) {
    _selectedCity = city;
    fetchJobs(isRefresh: true, applyCityFilter: true);
  }
}
