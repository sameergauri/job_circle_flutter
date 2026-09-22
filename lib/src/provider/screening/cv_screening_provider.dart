import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/src/model/screening/cv_match_response_model.dart';
import 'package:job_circle/src/services/master_data/master_data_service.dart';
import 'package:job_circle/src/services/screening/cv_screening_service.dart';

enum ScreeningState { initial, extracting, extracted, matching, success, error }

class CvScreeningProvider extends ChangeNotifier {
  final CvScreeningService _service = CvScreeningService();

  ScreeningState _state = ScreeningState.initial;
  ScreeningState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _selectedFileName;
  String? get selectedFileName => _selectedFileName;

  CvProfileData? _extractedProfile;
  CvProfileData? get extractedProfile => _extractedProfile;

  List<CvJobMatchItem> _matchedJobs = [];
  List<CvJobMatchItem> get matchedJobs => _matchedJobs;

  List<String> _language = [];
  final List<String> _selectedLanguage = [];
  bool _isLoadingLanguages = false;
  String? _languageError;

  List<String> get language => _language;
  List<String> get selectedLanguages => _selectedLanguage;
  bool get isLoadingLanguage => _isLoadingLanguages;
  String? get languageError => _languageError;

  // Active Jobs & Selection State
  List<ActiveJobItem> _activeJobs = [];
  List<ActiveJobItem> get activeJobs => _activeJobs;
  bool _isLoadingActiveJobs = false;
  bool get isLoadingActiveJobs => _isLoadingActiveJobs;
  final List<int> _selectedJobIds = [];
  List<int> get selectedJobIds => _selectedJobIds;

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final cityController = TextEditingController();
  final pincode = TextEditingController();
  final localityController = TextEditingController();

  // Experience Controllers (2 Digit Numeric)
  final expYearsController = TextEditingController();
  final expMonthsController = TextEditingController();

  // Education list management
  List<EducationItem> _educationList = [];
  List<EducationItem> get educationList => _educationList;
  int get educationCount => _educationList.length;

  String? selectedGender;
  String? selectedEducation; // Strictly "Graduate" or "Under_Graduate"
  String selectedExperienceLevel = 'Fresher'; // "Fresher" or "Experience"
  List<String> candidateSkills = [];

  // ================= EDUCATION MANAGEMENT =================
  void addEducation(EducationItem item) {
    _educationList.insert(0, item);
    notifyListeners();
  }

  void updateEducationAt(int index, EducationItem item) {
    if (index >= 0 && index < _educationList.length) {
      _educationList[index] = item;
      notifyListeners();
    }
  }

  void removeEducationAt(int index) {
    if (index >= 0 && index < _educationList.length) {
      _educationList.removeAt(index);
      notifyListeners();
    }
  }
  // Experience,
  // Work History State
  List<WorkHistoryItem> _workHistoryList = [];
  List<WorkHistoryItem> get workHistoryList => _workHistoryList;
  int get workHistoryCount => _workHistoryList.length;

  void addWorkHistory(WorkHistoryItem item) {
    _workHistoryList.insert(0, item);
    _recalculateTotalTenure();
    notifyListeners();
  }

  void updateWorkHistoryAt(int index, WorkHistoryItem item) {
    if (index >= 0 && index < _workHistoryList.length) {
      _workHistoryList[index] = item;
      _recalculateTotalTenure();
      notifyListeners();
    }
  }

  void removeWorkHistoryAt(int index) {
    if (index >= 0 && index < _workHistoryList.length) {
      _workHistoryList.removeAt(index);
      _recalculateTotalTenure();
      notifyListeners();
    }
  }

  void _recalculateTotalTenure() {
    int totalValidMonths = 0;
    for (var w in _workHistoryList) {
      if (!w.disqualified && w.durationMonths >= 6) {
        totalValidMonths += w.durationMonths;
      }
    }
    if (totalValidMonths >= 6) {
      selectedExperienceLevel = 'Experience';
      expYearsController.text = (totalValidMonths ~/ 12).toString();
      expMonthsController.text = (totalValidMonths % 12).toString();
    }
  }



  // Active Jobs fetching
  Future<void> fetchActiveJobs() async {
    if (_activeJobs.isNotEmpty) return;
    _isLoadingActiveJobs = true;
    notifyListeners();
    try {
      final response = await _service.getActiveJobs();
      _activeJobs = response.resultData;
    } catch (e) {
      debugPrint('Error fetching active jobs: $e');
    } finally {
      _isLoadingActiveJobs = false;
      notifyListeners();
    }
  }

  void toggleJobSelection(int jobId) {
    if (_selectedJobIds.contains(jobId)) {
      _selectedJobIds.remove(jobId);
    } else {
      _selectedJobIds.add(jobId);
    }
    notifyListeners();
  }

  void resetSelectedJobs() {
    _selectedJobIds.clear();
    notifyListeners();
  }

  // STEP 1: Select CV & Extract structured data
  Future<bool> pickAndExtractCv() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );
      if (result.single.path == null) {
        return false;
      }
      _selectedFileName = result.single.name;
      _state = ScreeningState.extracting;
      _errorMessage = null;
      notifyListeners();

      await fetchLanguages();

      final response = await _service.extractCvData(result.single.path!);
      if (response.resultData == null) {
        throw Exception(
          response.errorMessage ?? 'Failed to parse resume details.',
        );
      }
      _extractedProfile = response.resultData;
      _populateControllers(_extractedProfile!);
      _state = ScreeningState.extracted;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = ScreeningState.error;
      notifyListeners();
      return false;
    }
  }

void _populateControllers(CvProfileData profile) {
    nameController.text = profile.name;
    emailController.text = profile.email;
    dobController.text = profile.dateOfBirth ?? '';
    cityController.text = profile.locationCity ?? '';
    pincode.text = profile.pincode ?? '';
    localityController.text = profile.locationLocality ?? '';
    selectedGender = profile.gender;

    // Work History assignment
    _workHistoryList = List<WorkHistoryItem>.from(profile.workHistory);

    // Education assignment
    _educationList = List<EducationItem>.from(profile.education);

    final combinedEdu = [
      ...profile.educationText,
      ...profile.education.map(
        (e) => '${e.courseName ?? ''} ${e.fieldOfStudy ?? ''}',
      ),
    ].join(' ').toLowerCase();

    if (combinedEdu.contains('post') ||
        combinedEdu.contains('graduate') ||
        combinedEdu.contains('bachelor') ||
        combinedEdu.contains('b.com') ||
        combinedEdu.contains('b.tech') ||
        combinedEdu.contains('degree')) {
      selectedEducation = 'Graduate';
    } else {
      selectedEducation = 'Under_Graduate';
    }

    _selectedLanguage.clear();
    for (var lang in profile.languages) {
      final normalized = lang.trim();
      if (normalized.isNotEmpty && !_selectedLanguage.contains(normalized)) {
        _selectedLanguage.add(normalized);
      }
    }

    final totalMonths = profile.validExperienceMonths;
    if (totalMonths >= 6) {
      selectedExperienceLevel = 'Experience';
      final years = totalMonths ~/ 12;
      final months = totalMonths % 12;
      expYearsController.text = years.toString();
      expMonthsController.text = months.toString();
    } else {
      selectedExperienceLevel = 'Fresher';
      expYearsController.text = '0';
      expMonthsController.text = '0';
    }
    notifyListeners();
  }

  void updateGender(String? gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void updateEducation(String? edu) {
    selectedEducation = edu;
    notifyListeners();
  }

  void updateExperienceLevel(String? level) {
    if (level == null) return;
    selectedExperienceLevel = level;
    if (level == 'Fresher') {
      expYearsController.text = '0';
      expMonthsController.text = '0';
    } else {
      if (expYearsController.text.trim().isEmpty &&
          expMonthsController.text.trim().isEmpty) {
        expYearsController.text = '0';
        expMonthsController.text = '6';
      }
    }
    notifyListeners();
  }

  Future<void> fetchLanguages() async {
    if (_language.isNotEmpty) return;
    _isLoadingLanguages = true;
    _languageError = null;
    notifyListeners();
    try {
      _language = await MasterDataService.getSuggestions('Language');
      for (var sel in _selectedLanguage) {
        if (!_language.contains(sel)) {
          _language.insert(0, sel);
        }
      }
    } catch (e) {
      _languageError = 'Failed to load languages: $e';
    } finally {
      _isLoadingLanguages = false;
      notifyListeners();
    }
  }

  void toggleLanguage(String lang) {
    final normalized = lang.trim();
    if (_selectedLanguage.contains(normalized)) {
      _selectedLanguage.remove(normalized);
    } else {
      _selectedLanguage.add(normalized);
    }
    notifyListeners();
  }

  // STEP 2: Submit edited profile & retrieve matches
 Future<bool> submitAndGetRecommendations() async {
    if (_extractedProfile == null) return false;
    try {
      _state = ScreeningState.matching;
      _errorMessage = null;
      notifyListeners();

      _extractedProfile!.name = nameController.text.trim();
      _extractedProfile!.email = emailController.text.trim();
      _extractedProfile!.dateOfBirth = dobController.text.trim().isEmpty
          ? null
          : dobController.text.trim();
      _extractedProfile!.locationCity = cityController.text.trim().isEmpty
          ? null
          : cityController.text.trim();
      _extractedProfile!.pincode = pincode.text.trim().isEmpty
          ? null
          : pincode.text.trim();
      _extractedProfile!.locationLocality =
          localityController.text.trim().isEmpty
          ? null
          : localityController.text.trim();
      _extractedProfile!.gender = selectedGender;
      _extractedProfile!.educationText = [
        selectedEducation ?? 'Under_Graduate',
      ];
      _extractedProfile!.languages = List<String>.from(_selectedLanguage);

      _extractedProfile!.jobIds = _selectedJobIds.isNotEmpty
          ? List<int>.from(_selectedJobIds)
          : null;

      _extractedProfile!.education = List<EducationItem>.from(_educationList);
      _extractedProfile!.workHistory = List<WorkHistoryItem>.from(
        _workHistoryList,
      );

      if (selectedExperienceLevel == 'Experience') {
        final years = int.tryParse(expYearsController.text.trim()) ?? 0;
        final months = int.tryParse(expMonthsController.text.trim()) ?? 0;
        final computedTotalMonths = (years * 12) + months;
        _extractedProfile!.validExperienceMonths = computedTotalMonths;
        _extractedProfile!.track = 'EXPERIENCED';
      } else {
        _extractedProfile!.validExperienceMonths = 0;
        _extractedProfile!.track = 'FRESHER';
      }

      final response = await _service.getRecommendations(_extractedProfile!);
      _matchedJobs = response.resultData;
      _state = ScreeningState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = ScreeningState.error;
      notifyListeners();
      return false;
    }
  }

 void reset() {
    _state = ScreeningState.initial;
    _errorMessage = null;
    _selectedFileName = null;
    _extractedProfile = null;
    _matchedJobs = [];
    nameController.clear();
    emailController.clear();
    dobController.clear();
    cityController.clear();
    pincode.clear();
    localityController.clear();
    expYearsController.clear();
    expMonthsController.clear();
    candidateSkills.clear();
    _selectedLanguage.clear();
    _selectedJobIds.clear();
    _educationList.clear();
    _workHistoryList.clear();
    selectedEducation = null;
    selectedGender = null;
    selectedExperienceLevel = 'Fresher';
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    cityController.dispose();
    pincode.dispose();
    localityController.dispose();
    expYearsController.dispose();
    expMonthsController.dispose();
    super.dispose();
  }
}
