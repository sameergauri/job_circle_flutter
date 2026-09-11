// ignore_for_file: prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_filter_model.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';
import 'package:job_circle/src/model/job_model/recommend_job_model.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/services/job/job_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class JobProvider extends ChangeNotifier {
  CareerPreferenceProvider? _careerPreferenceProvider;
  final JobServices _jobServices = JobServices();
  List<JobContent> _jobs = [];
  List<JobContent> _allJobs = [];
  bool _isLoading = false;
  String _searchQuery = '';
  JobfilterModel? _availableFilters;
  JobfilterModel? _activeFilters;
  RecommendJobModel? _recommendedJob;
  UserData? _userData;
  String? _selectedCity;
  bool _recommendLoading = false;
  final FocusNode _searchBarFocusNode = FocusNode();
  List<JobContent> _recommendedJobs = [];
  bool _isAiOverallEnabled = false;

  

  // Getters
  List<JobContent> get jobs => _jobs;
  List<String>? get availableCities => _availableFilters?.cities;
  bool get isLoading => _isLoading;
  JobfilterModel? get availableFilters => _availableFilters;
  JobfilterModel? get activeFilters => _activeFilters;
  RecommendJobModel? get recommendedJob => _recommendedJob;
  UserData? get userData => _userData;
  String? get selectedCity => _selectedCity;
  bool get recommendLoading => _recommendLoading;
  FocusNode get searchBarFocusNode => _searchBarFocusNode;
  List<JobContent> get recommendedJobs => _recommendedJobs;
    bool get isAiOverallEnabled => _isAiOverallEnabled;

  Future<void> fetchJobs({
    bool isRefresh = false,
    required bool applyCityFilter,
  }) async {
    _selectedCity = SharedPrefsHelper.getString(
      ESharedPreferences.user_selected_lcoation,
    );
    if (_isLoading) {
      print('FetchJobs skipped: Already loading');
      return;
    }

    _isLoading = isRefresh;
    if (isRefresh) {
      _jobs = [];
      _allJobs = [];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final result = await _jobServices.fetchJobs(
      applyCityFilter: applyCityFilter,
     // selectedCity: _selectedCity,
      userId: SharedPrefsHelper.getInt(ESharedPreferences.user_id).toString(),
    );

    _allJobs = result['jobs'] ?? [];
    _availableFilters = result['availableFilters'];
    _userData = result['userData'];
    _isLoading = false;

    await fetchRecomendJob();
    _applyLocalFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

Future<void> fetchRecomendJob() async {
    final userId = SharedPrefsHelper.getInt(
      ESharedPreferences.user_id,
    ).toString();
    if (userId.isEmpty || userId == '0') return;

    _recommendLoading = true;
    notifyListeners();

    try {
      // 1. Pehle Admin Settings check karein
      _isAiOverallEnabled = await _jobServices.checkAiSettings();

      // Agar setting disabled hai, toh aage call nahi karni
      if (!_isAiOverallEnabled) {
        _recommendedJobs = [];
        return;
      }

      // 2. Setting enabled hone par hi Recommendations API call karein
      final List<int> recommendedIds = await _jobServices
          .fetchRecommendedJobIds(userId: userId);

      // 3. Normal jobs ke sath match karein
      if (recommendedIds.isNotEmpty && _allJobs.isNotEmpty) {
        _recommendedJobs = _allJobs.where((job) {
          return job.id != null && recommendedIds.contains(job.id);
        }).toList();
      } else {
        _recommendedJobs = [];
      }
    } catch (e, stackTrace) {
      print('Error mapping recommended jobs: $e');
      print(stackTrace);
      _recommendedJobs = [];
    } finally {
      _recommendLoading = false;
      notifyListeners();
    }
  }

  void _applyLocalFilters() {
    var filteredJobs = _allJobs;

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

    if (_activeFilters != null) {
      if (_activeFilters!.functionalAreas?.isNotEmpty ?? false) {
        filteredJobs = filteredJobs.where((job) {
          return _activeFilters!.functionalAreas!.contains(
            job.functionalArea ?? '',
          );
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
          return _activeFilters!.languages!.any(
            (lang) => jobLanguages.contains(lang.toLowerCase()),
          );
        }).toList();
        print('After language filter: ${filteredJobs.length} jobs');
      }
    }

    _jobs = filteredJobs;
    print('Applied local filters: ${_jobs.length} jobs');
    notifyListeners();
  }

  Future<bool> saveFavoriteJob({
    required int userId,
    required int jobId,
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await _jobServices.saveFavoriteJob(
      userId: userId,
      jobId: jobId,
    );

    _isLoading = false;
    if (success) {
      await fetchJobs(isRefresh: false, applyCityFilter: true);
      await fetchRecomendJob();
    }
    notifyListeners();
    return success;
  }

  Future<Map<String, dynamic>> removeFavoriteJob({required int favId}) async {
    _isLoading = true;
    notifyListeners();

    final success = await _jobServices.removeFavoriteJob(favId: favId);
    final wasLastSavedJob =
        _jobs.where((job) => job.isFavorite == true).length <= 1;

    _isLoading = false;
    await fetchJobs(isRefresh: false, applyCityFilter: true);
    await fetchRecomendJob();
    notifyListeners();
    return {'success': success, 'wasLastSavedJob': wasLastSavedJob};
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
    fetchRecomendJob();
  }
}
