import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/business_job/business_job_model.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart'
    show JobDetailScreeningQuestion;
import 'package:job_circle/src/model/job_responsibility_model.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/services/business_job/business_job_service.dart';

class BusinessJobProvider extends ChangeNotifier {
  final BusinessJobService _service = BusinessJobService();

  String selectedReasonOption = '';

  void selectReasonNotShowOption(String option) {
    selectedReasonOption = option;
    if (option != "Other") {
      reasonForNotshowToCandidate.text = option;
    } else {
      reasonForNotshowToCandidate.clear();
    }
    notifyListeners();
  }

  // ====================================================================
  // ========================== Close Job ===============================
  // ====================================================================

  Future<void> closeJob(int id, BuildContext context) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _service.closeJob(id);
      notifyListeners();
      // Navigate to the home screen before showing the Snackbar
      Navigator.popUntil(context, (route) => route.isFirst);

      // Show success Snackbar after navigating
      CustomSnackbar.show("Hiring Closed Successfully", false);
    } catch (e) {
      // Show error Snackbar
      CustomSnackbar.show("Error closing hiring: $e", true);
      rethrow; // Rethrow the error to handle it in the UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // ======================= Fetch job detail ===========================
  // ====================================================================

  /// Fetch and load existing Job for View / Edit Mode
  Future<void> fetchAndLoadJobDetails({required int jobId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedJob = await _service.getJobDetailById(jobId);

      if (fetchedJob != null) {
        _editingJobId = jobId;
        _jobPost = fetchedJob;

        // 1. Populate all controllers and state flags
        _populateFieldsFromModel(fetchedJob);

        // 2. Hydrate Screening Questions in ScreeningQuestionProvider
        /*   if (context.mounted &&
            fetchedJob.screeningQuestions != null &&
            fetchedJob.screeningQuestions!.isNotEmpty) {
          context.read<ScreeningQuestionProvider>().loadFromJobDetail(
            fetchedJob.screeningQuestions!,
          );
        } */
      }
    } catch (e) {
      _errorMessage = e.toString();
      CustomSnackbar.show("Failed to fetch job details: $e", true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // ======================= 1. GENERAL STATE & STEP =====================
  // ====================================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _currentStep = 1;
  int get currentStep => _currentStep;

  int? _editingJobId;
  bool get isEditMode => _editingJobId != null;

  int _selectedCompanyId = 0;
  int get selectedCompanyId => _selectedCompanyId;

  bool _shouldShowToCandidate = false;
  bool get shouldShowToCandidate => _shouldShowToCandidate;

  BusinessJobPostModel _jobPost = BusinessJobPostModel();
  BusinessJobPostModel get jobPost => _jobPost;

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void setSelectedCompanyId(int id) {
    _selectedCompanyId = id;
    notifyListeners();
  }

  void setShouldShowToCandidate(bool value) {
    _shouldShowToCandidate = value;
    notifyListeners();
  }

  // ====================================================================
  // ======================= 2. CONTrollers =============================
  // ====================================================================

  final jobHeadlineController = TextEditingController();
  final industryController = TextEditingController();
  final noOfVacancyController = TextEditingController();
  final minSalController = TextEditingController();
  final maxSalController = TextEditingController();
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  final minYearController = TextEditingController();
  final maxYearController = TextEditingController();
  final keyResponsibilitiesController = TextEditingController();
  final boundaryController = TextEditingController();
  final skillsSearchController = TextEditingController();
  final certificateSearchController = TextEditingController();
  final eligibilityController = TextEditingController();
  final jobSummaryController = TextEditingController();
  final additionalDetailsController = TextEditingController();
  final suggestionSelectedFirmController = TextEditingController();
  final hiringFor = TextEditingController();
  final reasonForNotshowToCandidate = TextEditingController();
  final roleForBusinessHiiringController = TextEditingController();
  final functioonalAreaForBusinessHiringController = TextEditingController();

  // ====================================================================
  // ======================= 3. FORM FLAGS & MASTER DATA ================
  // ====================================================================

  String levelOfHiring = '';
  String empType = '';
  String workMode = '';
  String shiftTime = '';
  String weekOff = '';
  String qualification = '';
  String englishCommsRating = '';
  String genderPreference = '';
  String experienceRequired = '';

  bool isPerMonth = true;
  bool showAndAbove = true;
  bool isAndAbove = false;
  bool isUndergradWithExperience = false;
  bool isRelevantBackgroundRequired = false;

  List<String> availableBenefits = [];
  List<String> selectedBenefits = [];
  List<String> availableShiftTimes = [];
  List<String> availableWeekOffs = [];
  List<String> availableLanguages = [];
  List<String> selectedLanguages = [];

  List<String> fullSkillsList = [];
  List<String> filteredSkills = [];
  List<String> selectedSkills = [];

  List<CertificateModel> fullCertificatesList = [];
  List<CertificateModel> filteredCertificates = [];
  List<CertificateModel> selectedCertificates = [];

  List<LocationData> onsiteLocations = [];
  List<LocationData> hybridLocations = [];
  List<LocationData> remoteLocations = [];

  List<String> autoEligibilityList = [];

  // ====================================================================
  // ======================= 4. WORK MODE & LOCATIONS ===================
  // ====================================================================

  bool isOnsite = false;
  bool isHybrid = false;
  bool isRemote = false;

  List<LocationData> jobLocationListOnsite = [];
  List<LocationData> jobLocationListHybrid = [];
  List<LocationData> jobLocationListRemote = [];

  void selectOnsiteLocations(List<LocationData> selectedItems) {
    jobLocationListOnsite = selectedItems;
    jobLocationListHybrid.clear();
    jobLocationListRemote.clear();
    isOnsite = true;
    isHybrid = false;
    isRemote = false;
    workMode = "OnSite";
    notifyListeners();
  }

  void selectHybridLocations(List<LocationData> selectedItems) {
    jobLocationListHybrid = selectedItems;
    jobLocationListOnsite.clear();
    jobLocationListRemote.clear();
    isOnsite = false;
    isHybrid = true;
    isRemote = false;
    workMode = "Hybrid";
    notifyListeners();
  }

  void selectRemoteLocation(LocationData selectedItem) {
    jobLocationListRemote.clear();
    jobLocationListRemote.add(selectedItem);
    jobLocationListOnsite.clear();
    jobLocationListHybrid.clear();
    isOnsite = false;
    isHybrid = false;
    isRemote = true;
    workMode = "Remote";
    notifyListeners();
  }

  void removeOnsiteLocation(LocationData item) {
    jobLocationListOnsite.remove(item);
    if (jobLocationListOnsite.isEmpty) {
      isOnsite = false;
      workMode = "";
    }
    notifyListeners();
  }

  void removeHybridLocation(LocationData item) {
    jobLocationListHybrid.remove(item);
    if (jobLocationListHybrid.isEmpty) {
      isHybrid = false;
      workMode = "";
    }
    notifyListeners();
  }

  // ====================================================================
  // ======================= 5. PAGE SELECTION MUTATORS =================
  // ====================================================================

  void selectLevelOfHiring(String val) {
    levelOfHiring = val;
    notifyListeners();
  }

  void selectEmpType(String val) {
    empType = val;
    notifyListeners();
  }

  void toggleBenefit(String benefit) {
    if (selectedBenefits.contains(benefit)) {
      selectedBenefits.remove(benefit);
    } else {
      selectedBenefits.add(benefit);
    }
    notifyListeners();
  }

  void selectWorkMode(String mode) {
    workMode = mode;
    notifyListeners();
  }

  void selectShiftTime(String val) {
    shiftTime = val;
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void selectWeekOff(String val) {
    weekOff = val;
    notifyListeners();
  }

  void toggleSalaryType(bool monthly) {
    isPerMonth = monthly;
    notifyListeners();
  }

  void selectQualification(String val) {
    qualification = val;
    if (val != "Graduate or above") {
      isUndergradWithExperience = false;
    }
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void toggleUndergradWithExperience(bool? value) {
    isUndergradWithExperience = value ?? false;
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void selectGenderPreference(String gender) {
    if (genderPreference == gender) {
      genderPreference = '';
    } else {
      genderPreference = gender;
    }
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void toggleRelevantBackgroundRequired(bool? value) {
    isRelevantBackgroundRequired = value ?? false;
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void selectExperienceRequired(String exp) {
    experienceRequired = exp;
    if (exp != "OTHERS") {
      minYearController.clear();
      maxYearController.clear();
      isAndAbove = false;
    }
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void toggleAndAbove() {
    isAndAbove = !isAndAbove;
    if (isAndAbove) {
      maxYearController.clear();
    }
    notifyListeners();
  }

  void toggleLanguage(String lang) {
    if (selectedLanguages.contains(lang)) {
      selectedLanguages.remove(lang);
    } else {
      selectedLanguages.add(lang);
    }
    updateAutoEligibilityRules();
    notifyListeners();
  }

  void selectEnglishRating(String val) {
    englishCommsRating = val;
    updateAutoEligibilityRules();
    notifyListeners();
  }

  // ====================================================================
  // ======================= 6. AI RESPONSIBILITIES & SKILLS ============
  // ====================================================================

  bool _isRespGenerated = false;
  bool get isRespGenereted => _isRespGenerated;

  ResponsibilityAiModel responsibilityAiModel = ResponsibilityAiModel();
  List<String> aiSuggestedSkills = [];

  Future<void> generateKeyResponsibilitiesWithAI() async {
    if (jobHeadlineController.text.trim().isEmpty) {
      CustomSnackbar.show("Please enter Job Headline first", true);
      return;
    }

    _isLoading = true;
    _isRespGenerated = true;
    notifyListeners();

    try {
      final result = await _service.generateResponsibilitiesUsingAI(
        industry: industryController.text.trim(),
        jobTitle: jobHeadlineController.text.trim(),
        levelOfHiring: levelOfHiring,
      );

      if (result != null) {
        responsibilityAiModel = result;

        if (result.responsibilities != null &&
            result.responsibilities!.isNotEmpty) {
          keyResponsibilitiesController.text = result.responsibilities!
              .map((e) => '• ${e.trim()}')
              .join('\n');
        }

        if (result.skills != null && result.skills!.isNotEmpty) {
          aiSuggestedSkills = List.from(result.skills!);
        }

        CustomSnackbar.show(
          "Responsibilities & Skills generated successfully",
          false,
        );
      }
    } catch (e) {
      CustomSnackbar.show("Error generating responsibilities: $e", true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearKeyResponsibilities() {
    keyResponsibilitiesController.clear();
    _isRespGenerated = false;
    notifyListeners();
  }

  void filterSkills(String query) {
    if (query.isEmpty) {
      filteredSkills = [];
    } else {
      filteredSkills = fullSkillsList
          .where(
            (skill) =>
                skill.toLowerCase().contains(query.toLowerCase()) &&
                !selectedSkills.contains(skill),
          )
          .toList();
    }
    notifyListeners();
  }

  void addSkill(String skill) {
    if (!selectedSkills.contains(skill)) {
      selectedSkills.add(skill);
      skillsSearchController.clear();
      filterSkills('');
    }
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
    filterSkills(skillsSearchController.text);
    notifyListeners();
  }

  // ====================================================================
  // ======================= 7. CERTIFICATES ============================
  // ====================================================================

  void filterCertificates(String query) {
    if (query.trim().isEmpty) {
      filteredCertificates = List.from(fullCertificatesList);
    } else {
      filteredCertificates = fullCertificatesList
          .where(
            (cert) =>
                cert.value != null &&
                cert.value!.toLowerCase().contains(
                  query.trim().toLowerCase(),
                ) &&
                !selectedCertificates.any((sc) => sc.id == cert.id),
          )
          .toList();
    }
    notifyListeners();
  }

  void addCertificate(CertificateModel cert) {
    final exists = selectedCertificates.any(
      (sc) =>
          sc.id == cert.id ||
          (sc.value != null &&
              cert.value != null &&
              sc.value!.toLowerCase() == cert.value!.toLowerCase()),
    );

    if (!exists) {
      selectedCertificates.add(cert);
      certificateSearchController.clear();
      filterCertificates('');
    }
  }

  void addCustomCertificate() {
    final text = certificateSearchController.text.trim();
    if (text.isEmpty) return;

    final alreadyExists = selectedCertificates.any(
      (sc) => sc.value != null && sc.value!.toLowerCase() == text.toLowerCase(),
    );

    if (!alreadyExists) {
      final newCert = CertificateModel(id: 0, value: text, mandatory: 0);
      selectedCertificates.add(newCert);
      certificateSearchController.clear();
      filterCertificates('');
    }
  }

  void removeCertificate(int index) {
    selectedCertificates.removeAt(index);
    filterCertificates(certificateSearchController.text);
    notifyListeners();
  }

  void toggleCertificateMandatory(int index) {
    final cert = selectedCertificates[index];
    selectedCertificates[index] = CertificateModel(
      id: cert.id,
      value: cert.value,
      mandatory: cert.mandatory == 1 ? 0 : 1,
    );
    notifyListeners();
  }

  // ====================================================================
  // ======================= 8. AUTO-ELIGIBILITY RULES & SUMMARY ========
  // ====================================================================

  void updateAutoEligibilityRules() {
    final Set<String> rules = {};

    if (shiftTime == "Day Rotational") {
      rules.add(
        "Candidates should be comfortable working in a day rotational shift.",
      );
    }

    if (qualification == "Graduate or above" && isUndergradWithExperience) {
      rules.add("Under Graduate with relevant experience can apply.");
    }

    if (selectedLanguages.length > 1) {
      rules.add(
        "Proficiency in English, Hindi, and any one Regional Language ${selectedLanguages.join(', ')} Required.",
      );
    } else if (selectedLanguages.length == 1) {
      rules.add(
        "Compulsory Proficiency in English, Hindi, and ${selectedLanguages.first}.",
      );
    }

    if (englishCommsRating == "Average") {
      rules.add(
        "A basic level of English proficiency is expected for communication in this job.",
      );
    } else if (englishCommsRating == "Excellent") {
      rules.add(
        "Excellent English written & verbal Communication skills required.",
      );
    } else if (englishCommsRating == "Very Good") {
      rules.add(
        "Good English communication skills are required for effective interaction with customers.",
      );
    }

    if (genderPreference == "Female") {
      rules.add("This position is exclusively open to female candidates.");
    } else if (genderPreference == "Male") {
      rules.add("This role is exclusively for male candidates.");
    } else if (genderPreference == "Female Preferred") {
      rules.add(
        "All candidates are encouraged to apply, and we have a preference for female applicants as part of our diversity initiative.",
      );
    }

    if (experienceRequired != "FRESHER" && isRelevantBackgroundRequired) {
      rules.add("Candidate should be from relevant experience background.");
    }

    if (minAgeController.text.isNotEmpty && maxAgeController.text.isNotEmpty) {
      rules.add(
        "Candidate age should be in between ${minAgeController.text} - ${maxAgeController.text} yrs.",
      );
    }

    autoEligibilityList = rules.toList();
    notifyListeners();
  }

  bool _isSummaryGenerated = false;
  bool get isSummaryGenereted => _isSummaryGenerated;

  void needSummary() async {
    final isGenderEmpty = genderPreference.trim().isEmpty;
    final isCertAgeGenderEmpty = selectedCertificates.isEmpty && isGenderEmpty;

    if (jobSummaryController.text.isNotEmpty) {
      if (!isCertAgeGenderEmpty) {
        jobSummaryController.clear();
        _isSummaryGenerated = false;
        notifyListeners();
      }
      return;
    }

    if (isCertAgeGenderEmpty) {
      await generateJobSummaryWithAI();
    }
  }

  Future<void> generateJobSummaryWithAI() async {
    List<String> responsibilitiesList = parseBulletTextToList(
      keyResponsibilitiesController.text,
    );

    if (responsibilitiesList.isEmpty) {
      CustomSnackbar.show(
        "Please enter Key Responsibilities before generating summary",
        true,
      );
      return;
    }

    _isLoading = true;
    _isSummaryGenerated = true;
    notifyListeners();

    try {
      final summary = await _service.generateJobSummaryUsingAI(
        responsibilities: responsibilitiesList,
      );

      if (summary != null && summary.isNotEmpty) {
        jobSummaryController.text = summary;
        CustomSnackbar.show("Job Summary generated successfully", false);
      } else {
        CustomSnackbar.show("Failed to generate summary", true);
      }
    } catch (e) {
      CustomSnackbar.show("Error while generating Job Summary: $e", true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearJobSummary() {
    jobSummaryController.clear();
    _isSummaryGenerated = false;
    notifyListeners();
  }

  // ====================================================================
  // ======================= 9. BULLET TEXT CONVERTERS ==================
  // ====================================================================

  String formatListToBulletText(List<String>? list) {
    if (list == null || list.isEmpty) return '';
    return list
        .where((e) => e.trim().isNotEmpty)
        .map((e) => '• ${e.trim()}')
        .join('\n');
  }

  List<String> parseBulletTextToList(String input) {
    if (input.trim().isEmpty) return [];
    return input
        .trim()
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line != '•' && line != '• ')
        .map((line) => line.replaceFirst('• ', '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  // ====================================================================
  // ======================= 10. FORM INIT & VALIDATION & SUBMIT ========
  // ====================================================================

  Future<void> initJobForm({
    required bool isEdit,
    BusinessJobPostModel? existingJob,
    int? jobId,
  }) async {
    _isLoading = true;
    _editingJobId = isEdit ? jobId : null;
    _currentStep = 1;
    notifyListeners();

    try {
      availableBenefits = await _service.fetchMasterByGroup('job_benifits');
      availableShiftTimes = await _service.fetchMasterByGroup('shifttime');
      availableWeekOffs = await _service.fetchMasterByGroup('shiftdesc');
      availableLanguages = await _service.fetchMasterByGroup('language');
      fullSkillsList = await _service.fetchMasterSkills();
      filteredSkills = List.from(fullSkillsList);
      fullCertificatesList = await _service.fetchMasterCertificates();
      filteredCertificates = List.from(fullCertificatesList);

      if (isEdit && existingJob != null) {
        _jobPost = existingJob;
        _populateFieldsFromModel(existingJob);
      } else {
        _jobPost = BusinessJobPostModel();
        _clearFormFields();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _populateFieldsFromModel(BusinessJobPostModel model) {
    jobHeadlineController.text = model.jobHeadline ?? '';
    industryController.text = model.industry ?? '';
    noOfVacancyController.text = model.noOfVacancy?.toString() ?? '';
    levelOfHiring = model.levelOfHiring ?? '';
    empType = model.empType ?? '';
    workMode = model.workMode ?? '';
    shiftTime = model.shiftTime ?? '';
    weekOff = model.weekOff ?? '';
    minSalController.text =
        model.minSalary?.toString().replaceAll('.0', '') ?? '';
    maxSalController.text =
        model.maxSalary?.toString().replaceAll('.0', '') ?? '';
    isPerMonth = model.perMonth == "1";
    qualification = model.qualifications ?? '';
    englishCommsRating = model.englishComsRating ?? '';
    genderPreference = model.genderPreference ?? '';
    minAgeController.text = model.minAge?.toString() ?? '';
    maxAgeController.text = model.maxAge?.toString() ?? '';
    experienceRequired = model.experienceRequired ?? '';
    minYearController.text = model.minexperience ?? '';
    maxYearController.text = model.maxexperience ?? '';
    isAndAbove = model.maxexperience == "& above";
    selectedBenefits = List.from(model.jobBenifits ?? []);
    selectedLanguages = List.from(model.languageRequired ?? []);
    selectedSkills = List.from(model.skills ?? []);
    jobSummaryController.text = model.jobSummary ?? '';

    // Bullet Lists
    keyResponsibilitiesController.text = formatListToBulletText(
      model.keyResponsibities,
    );
    boundaryController.text = formatListToBulletText(model.boundryLimits);
    eligibilityController.text = formatListToBulletText(model.eligibility);
    additionalDetailsController.text = formatListToBulletText(
      model.additionalDetails,
    );

    // Auto Eligibility rules
    if (model.eligibility2 != null && model.eligibility2!.isNotEmpty) {
      autoEligibilityList = List.from(model.eligibility2!);
    } else {
      updateAutoEligibilityRules();
    }

    // Company / Hiring Details
    _selectedCompanyId = model.businessCompanyId ?? 0;
    _shouldShowToCandidate = !(model.showHiringForToCandidate ?? true);
    hiringFor.text = model.hiringFor ?? '';
    reasonForNotshowToCandidate.text = model.reasonNotShowHiringFor ?? '';
    roleForBusinessHiiringController.text = model.roleForBusinessHiring ?? '';
    functioonalAreaForBusinessHiringController.text =
        model.functionalAreaForBusinessHiring ?? '';

    // Work Mode Selection Flag
    isOnsite = model.workMode == "OnSite";
    isHybrid = model.workMode == "Hybrid";
    isRemote = model.workMode == "Remote";
    // 1. Convert List<String> and List<int> into List<LocationData>
    final int length =
        (model.jobLocationString?.length ?? 0) <
            (model.jobLocationInt?.length ?? 0)
        ? (model.jobLocationString?.length ?? 0)
        : (model.jobLocationInt?.length ?? 0);

    final List<LocationData> locationsList = List.generate(length, (index) {
      return LocationData(
        id: model.jobLocationInt![index],
        formateData: model.jobLocationString![index],
      );
    });
    // 2. Pass single object for Remote, and full list for Onsite / Hybrid
    if (locationsList.isNotEmpty) {
      if (isRemote) {
        selectRemoteLocation(locationsList.first);
      } else if (isOnsite) {
        selectOnsiteLocations(locationsList);
      } else if (isHybrid) {
        selectHybridLocations(locationsList);
      }
    }
  }

  bool validateHringForPage() {
    if (hiringFor.text.isEmpty) {
      CustomSnackbar.show("Enter Hiring for", true);
      return false;
    }
    if (industryController.text.isEmpty) {
      CustomSnackbar.show("Enter Job Industry", true);
      return false;
    }
    if (_shouldShowToCandidate && reasonForNotshowToCandidate.text.isEmpty) {
      CustomSnackbar.show("Enter reason for not show to the candidate", true);
      return false;
    }
    return true;
  }

  bool validateAndSavePage1() {
    /* if (suggestionSelectedFirmController.text.isEmpty) {
      CustomSnackbar.show("Enter Company Name", true);
      return false;
    }
    if (hiringFor.text.isEmpty) {
      CustomSnackbar.show("Enter Hiring For", true);
      return false;
    }
    if (_shouldShowToCandidate && reasonForNotshowToCandidate.text.isEmpty) {
      CustomSnackbar.show("Enter reason for not show to the candidate", true);
      return false;
    } */
    if (roleForBusinessHiiringController.text.isEmpty) {
      CustomSnackbar.show("Enter Job Role", true);
      return false;
    }
    if (functioonalAreaForBusinessHiringController.text.isEmpty) {
      CustomSnackbar.show("Enter functional area", true);
      return false;
    }
    /*  if (industryController.text.isEmpty) {
      CustomSnackbar.show("Enter Job Industry", true);
      return false;
    } */
    if (jobHeadlineController.text.isEmpty) {
      CustomSnackbar.show("Enter Job Headline", true);
      return false;
    }
    if (noOfVacancyController.text.isEmpty) {
      CustomSnackbar.show("Enter Number of Vacancy", true);
      return false;
    }
    if (levelOfHiring.isEmpty) {
      CustomSnackbar.show("Select Level of Hiring", true);
      return false;
    }
    if (empType.isEmpty) {
      CustomSnackbar.show("Select Employment type", true);
      return false;
    }
    if (selectedBenefits.isEmpty) {
      CustomSnackbar.show("Select Job Benefits", true);
      return false;
    }
    if (workMode.isEmpty) {
      CustomSnackbar.show("Select Work Mode", true);
      return false;
    }
    if (shiftTime.isEmpty) {
      CustomSnackbar.show("Select Shift Timing", true);
      return false;
    }
    return true;
  }

  bool validateAndSavePage2() {
    int minsalcheck = int.tryParse(minSalController.text) ?? 0;
    int maxsalcheck = int.tryParse(maxSalController.text) ?? 0;
    int minagecheck = int.tryParse(minAgeController.text) ?? 0;
    int maxagecheck = int.tryParse(maxAgeController.text) ?? 0;

    if (weekOff.isEmpty) {
      CustomSnackbar.show("Select Week Off", true);
      return false;
    }
    if (qualification.isEmpty) {
      CustomSnackbar.show("Select Education Type", true);
      return false;
    }
    if (minSalController.text.isEmpty) {
      CustomSnackbar.show("Enter Salary", true);
      return false;
    }
    if (minsalcheck < 1000 ||
        (maxSalController.text.isNotEmpty && maxsalcheck < 1000)) {
      CustomSnackbar.show("Salary cannot be less than Rs: 1000", true);
      return false;
    }
    if (experienceRequired.isEmpty) {
      CustomSnackbar.show("Select Experience", true);
      return false;
    }
    if (englishCommsRating.isEmpty) {
      CustomSnackbar.show("Select English Communication Rating", true);
      return false;
    }
    if (minAgeController.text.isNotEmpty && minagecheck < 18) {
      CustomSnackbar.show("Min Age should not be less than 18", true);
      return false;
    }
    if (maxAgeController.text.isNotEmpty && maxagecheck > 60) {
      CustomSnackbar.show("Max Age should not be greater than 60", true);
      return false;
    }

    return true;
  }

  Future<bool> submitFinalJob({
    required int userId,
    required List<JobDetailScreeningQuestion> ScreeningQuestion,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    updateAutoEligibilityRules();

    _jobPost = BusinessJobPostModel(
      jobHeadline: jobHeadlineController.text.trim(),
      industry: industryController.text.trim(),
      noOfVacancy: int.tryParse(noOfVacancyController.text.trim()),
      levelOfHiring: levelOfHiring,
      empType: empType,
      jobBenifits: selectedBenefits,
      workMode: workMode,
      shiftTime: shiftTime,
      weekOff: weekOff,
      minSalary: double.tryParse(minSalController.text.trim()),
      maxSalary: double.tryParse(maxSalController.text.trim()) ?? 0,
      perMonth: isPerMonth ? "1" : "0",
      qualifications: qualification,
      languageRequired: selectedLanguages,
      englishComsRating: englishCommsRating,
      genderPreference: genderPreference,
      minAge: int.tryParse(minAgeController.text.trim()),
      maxAge: int.tryParse(maxAgeController.text.trim()),
      experienceRequired: experienceRequired,
      minexperience: experienceRequired == "OTHERS"
          ? minYearController.text
          : null,
      maxexperience: experienceRequired == "OTHERS"
          ? (isAndAbove ? "& above" : maxYearController.text)
          : null,
      skills: selectedSkills,
      jobSummary: jobSummaryController.text.trim(),
      businessCompanyId: selectedCompanyId,
      showHiringForToCandidate: !_shouldShowToCandidate,
      functionalAreaForBusinessHiring:
          functioonalAreaForBusinessHiringController.text,
      hiringFor: hiringFor.text,
      roleForBusinessHiring: roleForBusinessHiiringController.text,
      reasonNotShowHiringFor: reasonForNotshowToCandidate.text,
      keyResponsibities: parseBulletTextToList(
        keyResponsibilitiesController.text,
      ),
      boundryLimits: parseBulletTextToList(boundaryController.text),
      eligibility: parseBulletTextToList(eligibilityController.text),
      additionalDetails: parseBulletTextToList(
        additionalDetailsController.text,
      ),
      eligibility2: autoEligibilityList,
      jobLocationInt: isRemote
          ? [jobLocationListRemote.first.id!]
          : isHybrid
          ? jobLocationListHybrid.map((e) => e.id!).toList()
          : jobLocationListOnsite.map((e) => e.id!).toList(),
      screeningQuestions: ScreeningQuestion,
    );

    try {
      bool isSuccess;
      if (isEditMode) {
        isSuccess = await _service.updateJob(
          jobId: _editingJobId!,
          userId: userId,
          jobData: _jobPost,
        );
      } else {
        isSuccess = await _service.createJob(userId: userId, jobData: _jobPost);
      }
      return isSuccess;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // ======================= 11. CLEAR & DISPOSE ========================
  // ====================================================================

  void _clearFormFields() {
    jobHeadlineController.clear();
    industryController.clear();
    noOfVacancyController.clear();
    minSalController.clear();
    maxSalController.clear();
    minAgeController.clear();
    maxAgeController.clear();
    minYearController.clear();
    maxYearController.clear();
    keyResponsibilitiesController.clear();
    boundaryController.clear();
    skillsSearchController.clear();
    certificateSearchController.clear();
    eligibilityController.clear();
    jobSummaryController.clear();
    additionalDetailsController.clear();
    suggestionSelectedFirmController.clear();
    hiringFor.clear();
    reasonForNotshowToCandidate.clear();
    roleForBusinessHiiringController.clear();
    functioonalAreaForBusinessHiringController.clear();

    levelOfHiring = '';
    empType = '';
    workMode = '';
    shiftTime = '';
    weekOff = '';
    qualification = '';
    englishCommsRating = '';
    genderPreference = '';
    experienceRequired = '';
    selectedReasonOption = '';
    _selectedCompanyId = 0;

    isPerMonth = true;
    showAndAbove = true;
    isAndAbove = false;
    isUndergradWithExperience = false;
    isRelevantBackgroundRequired = false;
    _shouldShowToCandidate = false;

    _isRespGenerated = false;
    _isSummaryGenerated = false;

    isOnsite = false;
    isHybrid = false;
    isRemote = false;

    selectedBenefits.clear();
    selectedLanguages.clear();
    selectedSkills.clear();
    selectedCertificates.clear();
    onsiteLocations.clear();
    hybridLocations.clear();
    remoteLocations.clear();
    jobLocationListOnsite.clear();
    jobLocationListHybrid.clear();
    jobLocationListRemote.clear();
    autoEligibilityList.clear();
    aiSuggestedSkills.clear();

    responsibilityAiModel = ResponsibilityAiModel();
  }

  @override
  void dispose() {
    jobHeadlineController.dispose();
    industryController.dispose();
    noOfVacancyController.dispose();
    minSalController.dispose();
    maxSalController.dispose();
    minAgeController.dispose();
    maxAgeController.dispose();
    minYearController.dispose();
    maxYearController.dispose();
    keyResponsibilitiesController.dispose();
    boundaryController.dispose();
    skillsSearchController.dispose();
    certificateSearchController.dispose();
    eligibilityController.dispose();
    jobSummaryController.dispose();
    additionalDetailsController.dispose();
    suggestionSelectedFirmController.dispose();
    hiringFor.dispose();
    reasonForNotshowToCandidate.dispose();
    roleForBusinessHiiringController.dispose();
    functioonalAreaForBusinessHiringController.dispose();
    super.dispose();
  }
}
