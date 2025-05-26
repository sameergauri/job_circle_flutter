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
  JobNotifier() : super([]) {
    fetchInitialJobs(); // Separate method for initial fetch
  }

  bool _isLoading = false;
  String _searchQuery = '';
  JobfilterModel? _availableFilters; // All available filters from API
  JobfilterModel? _activeFilters; // Currently active filters
  UserData? _userData;
  String? _selectedCity;

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
    await fetchJobs(isRefresh: true, applyFilters: false);
  }

  Future<void> fetchJobs({
    bool isRefresh = false,
    bool applyFilters = true, // Control whether to apply filters or not
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    if (isRefresh) {
      state = [];
    }

    try {
      final userid = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_id.name);

      // Start with basic query params
      final queryParams = {
        'pageNumber': '1',
        'pageSize': '1000',
        'userId': userid.toString(),
      };

      // Only apply filters if explicitly requested
      if (applyFilters) {
        // Add city filter if selected
        if (_selectedCity != null && _selectedCity!.isNotEmpty) {
          queryParams['cities'] = _selectedCity!;
        }

        // Add functional areas if any selected
        if (_activeFilters?.functionalAreas?.isNotEmpty ?? false) {
          queryParams['functionalAreas'] =
              _activeFilters!.functionalAreas!.join(',');
        }

        // Add languages if any selected
        if (_activeFilters?.languages?.isNotEmpty ?? false) {
          queryParams['languages'] = _activeFilters!.languages!.join(',');
        }
      }

      final url = Uri.parse(
              "http://${GlobalConstants.API_Host_one}/api/jobs/v1/getAllJobs")
          .replace(queryParameters: queryParams);

      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = JobHomePageModel.fromJson(jsonData);
        final jobs = model.resultData?.allJobs?.pageResponse?.content ?? [];

        // Store available filters from API (but don't apply them yet)
        _availableFilters =
            JobfilterModel.fromJson(jsonData['resultData']["All Jobs"] ?? {});
        _userData = _availableFilters?.userData;

        // Apply search filter locally
        final filteredJobs = _searchQuery.isNotEmpty
            ? jobs
                .where((job) =>
                    job.rolename
                        ?.toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ??
                    false)
                .toList()
            : jobs;

        state = filteredJobs;
      }
    } finally {
      _isLoading = false;
    }
  }

  // Call this when user explicitly applies filters
  void applySelectedFilters({
    List<String>? functionalAreas,
    List<String>? languages,
  }) {
    _activeFilters = JobfilterModel(
      functionalAreas: functionalAreas,
      languages: languages,
      // Preserve other filter categories
      companies: _availableFilters?.companies,
      cities: _availableFilters?.cities,
      // ... other filter types
    );
    fetchJobs(isRefresh: true, applyFilters: true);
  }

  // Call this to clear all filters
  void clearAllFilters() {
    _activeFilters = null;
    _searchQuery = '';
    fetchJobs(); // Fetch without any filters
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    fetchJobs(isRefresh: true, applyFilters: true);
  }

  void updateCityFilter(String? city) {
    _selectedCity = city;
    fetchJobs(isRefresh: true, applyFilters: true);
  }
}
