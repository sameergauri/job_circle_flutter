import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_filter.dart';
import 'package:job_circle/models/job_home_page_model.dart';

final jobListProvider =
    StateNotifierProvider<JobNotifier, List<JobContent>>((ref) {
  return JobNotifier();
});

class JobNotifier extends StateNotifier<List<JobContent>> {
  JobNotifier() : super([]);

  bool _isLoading = false;
  String _searchQuery = '';
  JobfilterModel? _filters;
  String? _selectedCity;

  get isLoading => _isLoading;
  JobfilterModel? get filters => _filters;

  Future<void> fetchJobs({bool isRefresh = false}) async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    if (_isLoading) return;

    _isLoading = true;

    // Build URL with optional city filter
    var url =
        "http://${GlobalConstants.API_Host_one}/api/jobs/v1/getAllJobs?pageNumber=1&pageSize=1000&userId=$userid";
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      url += "&cities=$_selectedCity";
    }
    if (_filters?.functionalAreas != null &&
        _filters!.functionalAreas!.isNotEmpty) {
      url += "&functionalAreas=${_filters!.functionalAreas!.join(',')}";
    }
    if (_filters?.languages != null && _filters!.languages!.isNotEmpty) {
      url += "&languages=${_filters!.languages!.join(',')}";
    }

    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = JobHomePageModel.fromJson(jsonData);
        final jobs = model.resultData?.allJobs?.pageResponse?.content ?? [];

        // Parse filters
        _filters = JobfilterModel.fromJson(jsonData['resultData']['All Jobs']);

        if (_searchQuery.isNotEmpty) {
          final filtered = jobs
              .where((job) =>
                  job.rolename
                      ?.toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ??
                  false)
              .toList();
          state = isRefresh ? filtered : [...state, ...filtered];
        } else {
          state = isRefresh ? jobs : [...state, ...jobs];
        }
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
  }

  void updateFilters({
    List<String>? functionalAreas,
    List<String>? languages,
  }) {
    _filters = _filters?.copyWith(
          functionalAreas: functionalAreas,
          languages: languages,
        ) ??
        JobfilterModel(
          functionalAreas: functionalAreas,
          languages: languages,
        );

    // Trigger a refetch with the new filters
    fetchJobs();
  }

  void clearFilters() {
    _filters = _filters?.copyWith(
      functionalAreas: [],
      languages: [],
    );
    fetchJobs();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    fetchJobs(isRefresh: true);
  }

  void updateCityFilter(String? city) {
    _selectedCity = city;
    fetchJobs(isRefresh: true);
  }
}

/*  class JobNotifier extends StateNotifier<List<JobContent>> {
  JobNotifier() : super([]);

  bool _isLoading = false;
  String _searchQuery = '';
  JobfilterModel? _filters;

  get isLoading => _isLoading;
  JobfilterModel? get filters => _filters;

  Future<void> fetchJobs({bool isRefresh = false}) async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    if (_isLoading) return;

    _isLoading = true;
    final url =
        "http://${GlobalConstants.API_Host_one}/api/jobs/v1/getAllJobs?pageNumber=1&pageSize=1000&userId=$userid";

    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = JobHomePageModel.fromJson(jsonData);
        final jobs = model.resultData?.allJobs?.pageResponse?.content ?? [];

        // Parse filters
        _filters = JobfilterModel.fromJson(jsonData);

        if (_searchQuery.isNotEmpty) {
          final filtered = jobs
              .where((job) =>
                  job.rolename
                      ?.toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ??
                  false)
              .toList();
          state = isRefresh ? filtered : [...state, ...filtered];
        } else {
          state = isRefresh ? jobs : [...state, ...jobs];
        }
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
  }
  

  void updateSearchQuery(String query) {
    _searchQuery = query;
    fetchJobs(isRefresh: true);
  }
}

 */