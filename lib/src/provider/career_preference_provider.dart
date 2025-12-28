// ignore_for_file: avoid_print, prefer_final_fields, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/career_preference_model.dart';
import 'package:job_circle/src/services/career_preference/career_preference_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class CareerPreferenceProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  CareerPreferenceModel _model = CareerPreferenceModel();

  bool _isLoading = false;
  bool _jobPrefEnable = false;

  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController preferredLocationController =
      TextEditingController();
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController industriesController = TextEditingController();

  FocusNode jobRoleFocusNode = FocusNode();
  FocusNode preferredLocationFocusNode = FocusNode();
  FocusNode noticePeriodFocusNode = FocusNode();
  FocusNode industriesFocusNode = FocusNode();

  List<String> selectedIndustries = [];
  List<String> selectedJobRole = [];
  List<String> preferredLocations = [];

  bool _day = false, _night = false, _rotational = false, _flexible = false;

  RangeValues salaryRange = const RangeValues(0, 0);

  bool openToRelocation = false;
  bool immediateJoiner = false;

  bool fullTime = false;
  bool partTime = false;
  bool contractJob = false;
  bool freelance = false;
  bool internship = false;
  bool flexible = false;

  bool fifteenDays = false;
  bool thirtyDays = false;
  bool fortyFiveDays = false;
  bool sixtyDays = false;
  bool ninetyDays = false;

  bool workFromOffice = false;
  bool workFromHome = false;
  bool hybrid = false;

  bool hasExistingData = false; // 👈 IMPORTANT FLAG

  String? _shiftTime;

  //Getter

  bool get isLoading => _isLoading;
  CareerPreferenceModel get model => _model;
  bool get jobPrefEnable => _jobPrefEnable;

  bool? get day => _day;
  bool? get night => _night;
  bool? get rotational => _rotational;
  bool? get flexibleShift => _flexible;
  String? get shiftTime => _shiftTime;

  FocusNode get getJobRoleFocusNode => jobRoleFocusNode;
  FocusNode get getPreferredLocationFocusNode => preferredLocationFocusNode;
  FocusNode get getNoticePeriodFocusNode => noticePeriodFocusNode;
  FocusNode get getIndustriesFocusNode => industriesFocusNode;

  //----------------------------
  // UPDATE FUNCTIONS
  //----------------------------
  void setShiftTime(String value) {
    _day = value == "day";
    _night = value == "night";
    _rotational = value == "rotational";
    _flexible = value == "flexible";
    if (_day)
      _shiftTime = "day";
    else if (_night)
      _shiftTime = "night";
    else if (_rotational)
      _shiftTime = "rotational";
    else if (_flexible)
      _shiftTime = "flexible";
    notifyListeners();
  }

  void updateJobPrefEnable(bool value) {
    _jobPrefEnable = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateIndustry(List<String> skills) {
    selectedIndustries = skills;
    notifyListeners();
  }

  void updateJobRole(List<String> skills) {
    selectedJobRole = skills;
    notifyListeners();
  }

  void updatePreferredLocation(List<String> skills) {
    preferredLocations = skills;
    notifyListeners();
  }

  void updateSalaryRange(RangeValues values) {
    salaryRange = values;
    notifyListeners();
  }

  void updateRelocation(bool value) {
    openToRelocation = value;
    notifyListeners();
  }

  /* void updateImmediateJoiner(bool value) {
    immediateJoiner = value;
    if (value) {
      fifteenDays = false;
      thirtyDays = false;
      fortyFiveDays = false;
      sixtyDays = false;
      ninetyDays = false;
    }
    notifyListeners();
  } */

  // Select only one employment type at a time
  void selectEmploymentType(String type) {
    fullTime = type == "fullTime";
    partTime = type == "partTime";
    contractJob = type == "contract";
    freelance = type == "freelance";
    internship = type == "internship";
    flexible = type == "flexible";
    notifyListeners();
  }

  void selectNoticePeriod(String type) {
    immediateJoiner = type == "immediate";
    fifteenDays = type == "fifteenDays";
    thirtyDays = type == "thirtyDays";
    fortyFiveDays = type == "fortyFiveDays";
    sixtyDays = type == "sixtyDays";
    ninetyDays = type == "ninetyDays";
    notifyListeners();
  }

  // Multiple selection allowed for work mode
  void toggleWorkMode(String mode) {
    if (mode == "office") workFromOffice = !workFromOffice;
    if (mode == "home") workFromHome = !workFromHome;
    if (mode == "hybrid") hybrid = !hybrid;
    notifyListeners();
  }

  //----------------------------
  // FETCH API
  //----------------------------

  // ----------------------------
  // FETCH DATA
  // ----------------------------
  Future<void> fetchCareerPreference(bool isFromDrawer) async {
    setLoading(true);

    int userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    CareerPreferenceModel? data =
        await CareerPreferenceService.fetchCareerPreference(userId);

    if (data != null) {
      _model = data;
      hasExistingData = true;

      // noticePeriodController.text = _model.noticePeriod ?? "";
      selectedIndustries = _model.industry ?? [];
      selectedJobRole = _model.role ?? [];
      preferredLocations = _model.location ?? [];
      if (isFromDrawer) {
        _jobPrefEnable = _model.enable ?? false;
      }
      salaryRange = RangeValues(
        double.tryParse(_model.startSalary ?? "0") ?? 0,
        double.tryParse(_model.endSalary ?? "0") ?? 0,
      );

      openToRelocation = _model.openToRelocate ?? false;
      // immediateJoiner = _model.immediateJoiner ?? false;

      _applyEmploymentType(_model.empType);
      _applyWorkModes(_model.workMode);
      _applyNoticePeriod(_model.noticePeriod);
      _applyShitTime(_model.shiftTime);

      notifyListeners();
    } else {
      hasExistingData = false;
      _model = CareerPreferenceModel();
      clearAll();
    }
    setLoading(false);
  }

  // ----------------------------
  // SAVE OR UPDATE DATA
  // ----------------------------
  Future<void> savePreferences(
    BuildContext context, {
    required bool isFromDrawer,
  }) async {
    // if (!formKey.currentState!.validate()) return;

    setLoading(true);

    CareerPreferenceModel model = CareerPreferenceModel(
      enable: _jobPrefEnable,
      id: hasExistingData ? _model.id : null,
      industry: selectedIndustries,
      role: selectedJobRole,
      location: preferredLocations,
      startSalary: salaryRange.start.toString(),
      endSalary: salaryRange.end.toString(),
      // noticePeriod: noticePeriodController.text,
      openToRelocate: openToRelocation,
      // immediateJoiner: immediateJoiner,
      noticePeriod: _selectedNoticePeriod(),
      empType: _selectedEmploymentType(),
      workMode: _selectedWorkModes(),
      shiftTime: _shiftTime,
      userId: SharedPrefsHelper.getInt(ESharedPreferences.user_id),
    );

    bool success = hasExistingData
        ? await CareerPreferenceService.updateJobPreference(model)
        : await CareerPreferenceService.saveJobPreference(model);

    setLoading(false);

    if (success) {
      await fetchCareerPreference(isFromDrawer);
      if (isFromDrawer && _model.enable == true) {
        updateJobPrefEnable(true);
      }}
  }

  // ----------------------------
  // DELETE
  // ----------------------------
  Future<bool> deletePreference() async {
    if (!hasExistingData || _model.id == null) {
      print("No existing data to delete.");
      return false;
    } else {
      var done = await CareerPreferenceService.deleteJobPreference(_model.id!);
      if (done) {
        clearAll();
        hasExistingData = false;
        updateJobPrefEnable(false);
        _model = CareerPreferenceModel();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  //----------------------------
  // HELPER FUNCTIONS
  //----------------------------
  String _selectedEmploymentType() {
    if (fullTime) return "fullTime";
    if (partTime) return "partTime";
    if (contractJob) return "contract";
    if (freelance) return "freelance";
    if (internship) return "internship";
    if (flexible) return "flexible";
    return "";
  }

  String _selectedNoticePeriod() {
    if (immediateJoiner) return "immediate";
    if (fifteenDays) return "fifteenDays";
    if (thirtyDays) return "thirtyDays";
    if (fortyFiveDays) return "fortyFiveDays";
    if (sixtyDays) return "sixtyDays";
    if (ninetyDays) return "ninetyDays";
    return "";
  }

  void _applyEmploymentType(String? type) {
    fullTime = type == "fullTime";
    partTime = type == "partTime";
    contractJob = type == "contract";
    freelance = type == "freelance";
    internship = type == "internship";
    flexible = type == "flexible";
  }

  void _applyShitTime(String? type) {
    _day = type == "day";
    _night = type == "night";
    _rotational = type == "rotational";
    _flexible = type == "flexible";
    if (_day)
      _shiftTime = "day";
    else if (_night)
      _shiftTime = "night";
    else if (_rotational)
      _shiftTime = "rotational";
    else if (_flexible)
      _shiftTime = "flexible";
  }

  void _applyNoticePeriod(String? period) {
    immediateJoiner = period == "immediate";
    fifteenDays = period == "fifteenDays";
    thirtyDays = period == "thirtyDays";
    fortyFiveDays = period == "fortyFiveDays";
    sixtyDays = period == "sixtyDays";
    ninetyDays = period == "ninetyDays";
  }

  List<String> _selectedWorkModes() {
    List<String> list = [];
    if (workFromOffice) list.add("office");
    if (workFromHome) list.add("home");
    if (hybrid) list.add("hybrid");
    return list;
  }

  void _applyWorkModes(List<String>? modes) {
    workFromOffice = modes?.contains("office") ?? false;
    workFromHome = modes?.contains("home") ?? false;
    hybrid = modes?.contains("hybrid") ?? false;
  }

  void clearAll() {
    jobRoleController.clear();
    preferredLocationController.clear();
    noticePeriodController.clear();
    industriesController.clear();
    selectedIndustries.clear();
    selectedJobRole.clear();
    preferredLocations.clear();
    salaryRange = const RangeValues(0, 0);
    openToRelocation = false;
    immediateJoiner = false;
    fullTime = false;
    flexible = false;
    partTime = false;
    contractJob = false;
    freelance = false;
    internship = false;
    workFromOffice = false;
    workFromHome = false;
    hybrid = false;
    hasExistingData = false;
    _day = false;
    _night = false;
    _rotational = false;
    _flexible = false;
    _shiftTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    jobRoleController.dispose();
    preferredLocationController.dispose();
    noticePeriodController.dispose();
    industriesController.dispose();
    jobRoleFocusNode.dispose();
    preferredLocationFocusNode.dispose();
    noticePeriodFocusNode.dispose();
    industriesFocusNode.dispose();
    hasExistingData = false;

    super.dispose();
  }
}
