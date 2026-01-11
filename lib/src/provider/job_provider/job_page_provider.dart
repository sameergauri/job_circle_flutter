// ignore_for_file: avoid_print

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

    _applyLocalFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> fetchRecomendJob() async {
    _recommendLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _careerPreferenceProvider?.fetchCareerPreference(false);
      notifyListeners();
    });
    try {
      _recommendedJob = await _jobServices.fetchRecomendJob(
        userId: SharedPrefsHelper.getInt(ESharedPreferences.user_id),
        locations:
            _careerPreferenceProvider!.model.location != null &&
                _careerPreferenceProvider!.model.location!.isNotEmpty == true
            ? _careerPreferenceProvider?.preferredLocations
            : null,
        industries:
            _careerPreferenceProvider!.model.industry != null &&
                _careerPreferenceProvider!.model.industry!.isNotEmpty == true
            ? _careerPreferenceProvider?.model.industry
            : null,
        workTypes:
            _careerPreferenceProvider?.model.workMode != null &&
                _careerPreferenceProvider!.model.workMode!.isNotEmpty == true
            ? _careerPreferenceProvider?.model.workMode
            : null,
        salaryMin:
            _careerPreferenceProvider?.model.startSalary != null &&
                _careerPreferenceProvider!.model.startSalary!.isNotEmpty == true
            ? _careerPreferenceProvider?.model.startSalary
            : null,
        salaryMax:
            _careerPreferenceProvider?.model.endSalary != null &&
                _careerPreferenceProvider!.model.endSalary!.isNotEmpty == true
            ? _careerPreferenceProvider?.model.endSalary
            : null,
      );
    } catch (e, stackTrace) {
      print('Error fetching recommended job: $e');
      print(stackTrace);
      _recommendedJob = null;
    } finally {
      _recommendLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
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
