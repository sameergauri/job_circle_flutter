// ignore_for_file: avoid_print, prefer_final_fields, use_build_context_synchronously

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

  List<String> selectedIndustries = [];
  List<String> selectedJobRole = [];
  List<String> preferredLocations = [];

  RangeValues salaryRange = const RangeValues(0, 0);

  bool openToRelocation = false;
  bool immediateJoiner = false;

  bool fullTime = false;
  bool partTime = false;
  bool contractJob = false;
  bool freelance = false;
  bool internship = false;

  bool workFromOffice = false;
  bool workFromHome = false;
  bool hybrid = false;

  bool hasExistingData = false; // 👈 IMPORTANT FLAG

  //Getter

  bool get isLoading => _isLoading;
  CareerPreferenceModel get model => _model;
  bool get jobPrefEnable => _jobPrefEnable;

  //----------------------------
  // UPDATE FUNCTIONS
  //----------------------------

  void updateJobPrefEnable(int value) {
    _jobPrefEnable = value == 0 ? false : true;
    SharedPrefsHelper.setPreference(
      ESharedPreferences.jobpreferenceEnable,
      value,
    );
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

  void updateImmediateJoiner(bool value) {
    immediateJoiner = value;
    if (value) noticePeriodController.clear();
    notifyListeners();
  }

  // Select only one employment type at a time
  void selectEmploymentType(String type) {
    fullTime = type == "fullTime";
    partTime = type == "partTime";
    contractJob = type == "contract";
    freelance = type == "freelance";
    internship = type == "internship";
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
  Future<void> fetchCareerPreference() async {
    setLoading(true);

    int userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    CareerPreferenceModel? data =
        await CareerPreferenceService.fetchCareerPreference(userId);

    if (data != null) {
      _model = data;
      hasExistingData = true;

      noticePeriodController.text = _model.noticePeriod ?? "";
      selectedIndustries = _model.industry ?? [];
      selectedJobRole = _model.role ?? [];
      preferredLocations = _model.location ?? [];

      salaryRange = RangeValues(
        double.tryParse(_model.startSalary ?? "0") ?? 0,
        double.tryParse(_model.endSalary ?? "0") ?? 0,
      );

      openToRelocation = _model.openToRelocate ?? false;
      immediateJoiner = _model.immediateJoiner ?? false;

      _applyEmploymentType(_model.empType);
      _applyWorkModes(_model.workMode);

      notifyListeners();
    }
    setLoading(false);
  }

  // ----------------------------
  // SAVE OR UPDATE DATA
  // ----------------------------
  Future<void> savePreferences(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setLoading(true);

    CareerPreferenceModel model = CareerPreferenceModel(
      id: hasExistingData ? _model.id : null,
      industry: selectedIndustries,
      role: selectedJobRole,
      location: preferredLocations,
      startSalary: salaryRange.start.toString(),
      endSalary: salaryRange.end.toString(),
      noticePeriod: noticePeriodController.text,
      openToRelocate: openToRelocation,
      immediateJoiner: immediateJoiner,
      empType: _selectedEmploymentType(),
      workMode: _selectedWorkModes(),
      userId: SharedPrefsHelper.getInt(ESharedPreferences.user_id),
    );

    bool success = hasExistingData
        ? await CareerPreferenceService.updateJobPreference(model)
        : await CareerPreferenceService.saveJobPreference(model);

    setLoading(false);

    if (success) {
      await fetchCareerPreference();
      updateJobPrefEnable(1);
      Navigator.pop(context);
    }
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
        updateJobPrefEnable(0);
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
    return "";
  }

  void _applyEmploymentType(String? type) {
    fullTime = type == "fullTime";
    partTime = type == "partTime";
    contractJob = type == "contract";
    freelance = type == "freelance";
    internship = type == "internship";
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
    partTime = false;
    contractJob = false;
    freelance = false;
    internship = false;
    workFromOffice = false;
    workFromHome = false;
    hybrid = false;
    hasExistingData = false;
    notifyListeners();
  }

  @override
  void dispose() {
    jobRoleController.dispose();
    preferredLocationController.dispose();
    noticePeriodController.dispose();
    industriesController.dispose();
    super.dispose();
  }
}
