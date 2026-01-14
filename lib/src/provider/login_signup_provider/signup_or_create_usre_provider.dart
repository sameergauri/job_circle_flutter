// ignore_for_file: todo, non_constant_identifier_names, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_responsibility_model.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/model/user_profile/onboarding_cv_parse_model.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/cv_parse_user_profile.dart';
import 'package:job_circle/src/services/login_and_signup_services/resume_service.dart';
import 'package:job_circle/src/services/login_and_signup_services/signup_service.dart';
import 'package:job_circle/src/services/master_data/master_data_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/utils/date_formater.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_confirmation.dart';

class SignupCreateUserProvider with ChangeNotifier {
  // Models
  CreateNewUserModel? _userModel;
  CreateNewUserModel? _profileModel; // For CV parsed profile
  OnBoardCvParseModel? _cvParseModel;
  ResponsibilityAiModel? _responsibilityAiModel;

  // Basic Profile Controllers
  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController contactno = TextEditingController();
  TextEditingController alternnateno = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController locality = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController profileHeadline = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController linkedInUrl = TextEditingController();
  TextEditingController profileRole = TextEditingController();

  // Experience Controllers
  TextEditingController jobrole = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController industry = TextEditingController();
  TextEditingController functionalArea = TextEditingController();
  TextEditingController anualSalary = TextEditingController();
  TextEditingController jobResponsibility = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController lastWorkingDate = TextEditingController();
  TextEditingController jobtitle = TextEditingController();
  //
  FocusNode jobRoleFocusNode = FocusNode();
  FocusNode companyNameFocusNode = FocusNode();
  FocusNode industryFocusNode = FocusNode();
  FocusNode functionalAreaFocusNode = FocusNode();
  FocusNode annualSalaryFocusNode = FocusNode();
  FocusNode startDateFocusNode = FocusNode();
  FocusNode lastWorkingDateFocusNode = FocusNode();
  FocusNode jobTitleFocusNode = FocusNode();
  //
  // Education Controllers
  TextEditingController schoolCollegeName = TextEditingController();
  TextEditingController universityBoardName = TextEditingController();
  TextEditingController degree = TextEditingController();
  TextEditingController fieldOFStudy = TextEditingController();
  TextEditingController startmonth = TextEditingController();
  TextEditingController startyear = TextEditingController();
  TextEditingController endyear = TextEditingController();
  TextEditingController endmonth = TextEditingController();

  FocusNode schoolCollegeNameFocusNode = FocusNode();
  FocusNode universityBoardNameFocusNode = FocusNode();
  FocusNode degreeFocusNode = FocusNode();
  FocusNode fieldOFStudyFocusNode = FocusNode();
  FocusNode startMonthFocusNode = FocusNode();
  FocusNode startYearFocusNode = FocusNode();
  FocusNode endMonthFocusNode = FocusNode();
  FocusNode endYearFocusNode = FocusNode();
  //

  // Certificate Controllers
  TextEditingController certificateName = TextEditingController();
  TextEditingController organizationName = TextEditingController();
  TextEditingController credentialId = TextEditingController();
  TextEditingController credentialUrl = TextEditingController();
  TextEditingController issuemonth = TextEditingController();
  TextEditingController issueyear = TextEditingController();
  TextEditingController validmonth = TextEditingController();
  TextEditingController validyear = TextEditingController();

  FocusNode certificateNameFocusNode = FocusNode();
  FocusNode organizationNameFocusNode = FocusNode();
  FocusNode credentialIdFocusNode = FocusNode();
  FocusNode credentialUrlFocusNode = FocusNode();
  //

  // Projects
  TextEditingController project_title = TextEditingController();
  TextEditingController project_decription = TextEditingController();
  TextEditingController project_role = TextEditingController();
  TextEditingController project_url = TextEditingController();
  TextEditingController project_skill_controller = TextEditingController();
  //
  TextEditingController proj_startMonth = TextEditingController();
  TextEditingController proj_startYear = TextEditingController();
  TextEditingController proj_endMonth = TextEditingController();
  TextEditingController proj_endYear = TextEditingController();

  FocusNode projectTitleFocusNode = FocusNode();
  FocusNode projectDescriptionFocusNode = FocusNode();
  FocusNode projectRoleFocusNode = FocusNode();
  FocusNode projectSkillFocusNode = FocusNode();
  FocusNode projectUrlFocusNode = FocusNode();
  //

  // rewards and achievment.
  TextEditingController awards_title = TextEditingController();
  TextEditingController awards_description = TextEditingController();

  FocusNode awardsTitleFocusNode = FocusNode();
  FocusNode awardsDescriptionFocusNode = FocusNode();
  //

  // Basic Profile States
  bool _male = false;
  bool _female = false;
  bool _vaccinated = false;
  bool _fresher = false;
  bool _experience = false;
  bool _graduate = false;
  bool _undergraduate = false;
  bool _isLoading = false;
  int? _isexperience;
  int? _iseducation;
  String? _vaccinationcertificate;
  String? _resume;
  String? _profilePic;
  List<String> _selectedLanguage = [];
  String? _age;
  bool _skillsLoading = false;
  String? _skillError;
  List<String> _apifetchSkills = [];
  List<String> _tempSelectedSkills = [];
  final List<String> _selectedSkills = [];
  final List<String> _selectedTechnicalSkills = [];
  final List<String> _tempSelectedTechSkill = [];

  // Experience States
  String? _empType;
  String? _workMode;
  String? _workLocation;
  bool _currentlyWorking = false;
  List<String> _skills = [];
  final List<ExperienceRequest> _experiencesModel = [];
  bool _onsite = false;
  bool _hybrid = false;
  bool _remote = false;
  LocationData? _onsiteLocations;
  LocationData? _hybridLocations;
  LocationData? _remoteLocation;
  bool _fulltime = false;
  bool _partTime = false;
  bool _contractual = false;
  bool _freelancer = false;
  bool _internship = false;
  bool _selfemploye = false;
  String? _offerLetter;
  String? _appointmentLetter;
  String? _salarySlip;
  String? _incrementLetter;
  String? _experienceLetter;
  int? _editingIndex;
  bool _showExperienceForm = false;
  bool _isResponsebilityLoading = false;
  bool _isResponsebilityGenerated = false;

  // Education States
  String? _markSheet;
  bool _currentlyStudy = false;
  bool _degreeCertificate = false;
  bool _allEducationDocs = false;
  final List<EducationRequest> _educationModel = [];
  bool _showEducationForm = false;
  int? _editingEducationIndex;
  bool _isRemote = false;
  bool _fullimecourse = false,
      _parttimecourse = false,
      _distancelearning = false,
      _correspondence = false;

  // Certificate States
  String? _certificate;
  bool _certificateNoExpiration = false;
  bool _certificateDocument = false;
  bool _allCertificateDocs = false;
  final List<CertificationRequest> _certificateModel = [];
  bool _showCertificateForm = false;
  int? _editingCertificateIndex;
  bool _dontHaveExpiry = false;

  // Language States
  List<String> _language = [];
  bool _isLoadingLanguages = false;
  String? _languageError;

  // Project states
  String? _project_duration;
  List<String> _project_technology_used = [];
  List<String> _project_it_skills = [];
  bool _showProjectForm = false;
  int? _editProjectIndex;
  final List<UserProjectRequest> _projectModel = [];

  // awards and achievment states
  bool _showAwardsForm = false;
  int? _editAwardIndex;
  final List<AwardsAndAchievementsModel> _awardsModel = [];

  // Errors
  String? _error;

  // Getters
  CreateNewUserModel? get userModel => _userModel;
  CreateNewUserModel? get profileModel => _profileModel;
  OnBoardCvParseModel? get cvParseModel => _cvParseModel;
  bool get fresher => _fresher;
  bool get experience => _experience;
  bool get graduate => _graduate;
  bool get undergraduate => _undergraduate;
  String? get profilePic => _profilePic;
  bool get male => _male;
  bool get female => _female;
  bool get vaccinated => _vaccinated;
  bool get isLoading => _isLoading;
  int? get isExperience => _isexperience;
  int? get isEducation => _iseducation;
  String? get vaccinationCertificate => _vaccinationcertificate;
  String? get resume => _resume;
  List<String>? get selectedLanguages => _selectedLanguage;
  List<String> get languages => _language;
  bool get isLoadingLanguages => _isLoadingLanguages;
  String? get languageError => _languageError;
  String? get error => _error;
  bool get showExperienceForm => _showExperienceForm;
  bool get showEducationForm => _showEducationForm;
  bool get showCertificateForm => _showCertificateForm;
  String? get age => _age;
  bool get skillLoading => _skillsLoading;
  String get skillError => _skillError ?? '';
  List<String> get apiFetchSkills => _apifetchSkills;
  List<String> get tempSelectedSkills => _tempSelectedSkills;
  List<String> get selectedSkills => _selectedSkills;
  List<String> get selectedTechnicalSkills => _selectedTechnicalSkills;
  List<String> get tempSelectedTechSkill => _tempSelectedTechSkill;

  // Experience Getters
  String? get empType => _empType;
  String? get workMode => _workMode;
  String? get workLocation => _workLocation;
  bool get currentlyWorking => _currentlyWorking;
  List<String> get skills => _skills;
  List<ExperienceRequest> get experiencesModel => _experiencesModel;
  bool get onSite => _onsite;
  bool get hybrid => _hybrid;
  bool get remote => _remote;
  LocationData? get onSiteLocation => _onsiteLocations;
  LocationData? get hybridLocation => _hybridLocations;
  LocationData? get remoteLocation => _remoteLocation;
  bool get fullTime => _fulltime;
  bool get partTime => _partTime;
  bool get contractual => _contractual;
  bool get freelancer => _freelancer;
  bool get internship => _internship;
  String? get offerLetter => _offerLetter;
  String? get appointmentLetter => _appointmentLetter;
  String? get salarySlip => _salarySlip;
  String? get incrementLetter => _incrementLetter;
  String? get experienceLetter => _experienceLetter;
  bool get isEditingExperience => _editingIndex != null;
  int? get experienceEditIndex => _editingIndex;
  bool get selfEmployed => _selfemploye;
  bool get isResponsibilityLoading => _isResponsebilityLoading;
  bool get isResponsibilityGenerated => _isResponsebilityGenerated;
  ResponsibilityAiModel? get responsibilityAiModel => _responsibilityAiModel;

  // Education Getters
  bool get currentlyStudying => _currentlyStudy;
  String? get markSheet => _markSheet;
  List<EducationRequest> get educationModel => _educationModel;
  bool get isEducationRemote => _isRemote;
  bool get degreeCertificateUploaded => _degreeCertificate;
  bool get allEducationDocsUploaded => _allEducationDocs;
  bool get isEditingEducation => _editingEducationIndex != null;
  int? get educationEditIndex => _editingEducationIndex;
  bool get isRemote => _isRemote;
  bool get fullTimeCourse => _fullimecourse;
  bool get partTimeCourse => _parttimecourse;
  bool get distanceLearning => _distancelearning;
  bool get correspondenceCourse => _correspondence;

  // Certificate Getters
  String? get certificateFile => _certificate;
  List<CertificationRequest> get certificateModel => _certificateModel;
  bool get certificateNoExpiration => _certificateNoExpiration;
  bool get certificateDocumentUploaded => _certificateDocument;
  bool get allCertificateDocsUploaded => _allCertificateDocs;
  bool get isEditingCertificate => _editingCertificateIndex != null;
  int? get certifiEditIndex => _editingCertificateIndex;
  bool get hasCertData =>
      certificateName.text.isNotEmpty || organizationName.text.isNotEmpty;
  bool get dontHaveExpiry => _dontHaveExpiry;

  // Project getter.
  String? get projectDuration => _project_duration;
  List<String> get projectTechnologyUsed => _project_technology_used;
  List<String> get projectItSkills => _project_it_skills;
  bool get showProjectForm => _showProjectForm;
  bool get isEditingProject => _editProjectIndex != null;
  int? get editProjectIndex => _editProjectIndex;
  List<UserProjectRequest> get projectModel => _projectModel;
  bool get hasProjectData =>
      project_title.text.isNotEmpty || project_decription.text.isNotEmpty;

  // Awards and Achievment getter
  bool get showAwardsForm => _showAwardsForm;
  bool get isEditingAward => _editAwardIndex != null;
  int? get editAwardIndex => _editAwardIndex;
  List<AwardsAndAchievementsModel> get awardsModel => _awardsModel;
  bool get hasAwardsData =>
      awards_title.text.isNotEmpty || awards_description.text.isNotEmpty;

  // Basic Profile Setters
  void setFresher(bool value) {
    _fresher = value;
    _experience = !value;
    notifyListeners();
  }

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  void setExperienceStatus(bool value) {
    _experience = value;
    _fresher = !value;
    notifyListeners();
  }

  void setGraduate(bool value) {
    _graduate = value;
    _undergraduate = !value;
    notifyListeners();
  }

  void setUndergraduate(bool value) {
    _undergraduate = value;
    _graduate = !value;
    notifyListeners();
  }

  void setProfilePic(String value) {
    _profilePic = value;
    notifyListeners();
  }

  void setResume(String value) {
    _resume = value;
    notifyListeners();
  }

  void setGender(String gender) {
    _male = gender.toLowerCase() == 'male';
    _female = gender.toLowerCase() == 'female';
    notifyListeners();
  }

  void setVaccination(bool value) {
    _vaccinated = value;
    if (!value) _vaccinationcertificate = null;
    notifyListeners();
  }

  void setVaccinationCertificate(String? certificate) {
    _vaccinationcertificate = certificate;
    notifyListeners();
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

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void initializeController(String number) {
    contactno.text = number;
    fetchLanguages();
    notifyListeners();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    _skillsLoading = true;
    _skillError = null;
    notifyListeners();

    try {
      _apifetchSkills = await MasterDataService.getSuggestions('skills');
    } catch (e) {
      _skillError = 'Failed to load languages: $e';
    } finally {
      _skillsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLanguages() async {
    _isLoadingLanguages = true;
    _languageError = null;
    notifyListeners();

    try {
      _language = await MasterDataService.getSuggestions('Language');
    } catch (e) {
      _languageError = 'Failed to load languages: $e';
    } finally {
      _isLoadingLanguages = false;
      notifyListeners();
    }
  }

  void clearskill() {
    _tempSelectedSkills.clear();
    notifyListeners();
  }

  void assignSkillsToSelectedSkillList(List<String> skill) {
    _tempSelectedSkills = List<String>.from(skill);
    notifyListeners();
  }

  void toggleTechnicalSkill(String lang) {
    final normalized = lang.trim();
    if (_tempSelectedTechSkill.contains(normalized)) {
      _tempSelectedTechSkill.remove(normalized);
    } else {
      _tempSelectedTechSkill.add(normalized);
    }
    notifyListeners();
  }

  void toggleSkill(String lang) {
    final normalized = lang.trim();
    if (_tempSelectedSkills.contains(normalized)) {
      _tempSelectedSkills.remove(normalized);
    } else {
      _tempSelectedSkills.add(normalized);
    }
    notifyListeners();
  }

  void updateAndSaveSkills() {
    if (_profileModel == null) return;

    // Update user request from controllers
    final updatedUserRequest = _profileModel!.userRequest!.copyWith(
      skills: List<String>.from(_tempSelectedSkills),
    );

    _profileModel = _profileModel!.copyWith(userRequest: updatedUserRequest);
    notifyListeners();
  }

  void clearbasicDetail() {
    firstname.clear();
    bio.clear();
    lastname.clear();
    middlename.clear();
    contactno.clear();
    alternnateno.clear();
    dateofbirth.clear();
    emailid.clear();
    location.clear();
    locality.clear();
    pincode.clear();
    profileHeadline.clear();
    linkedInUrl.clear();
    profileRole.clear();
    _male = false;
    _female = false;
    _vaccinated = false;
    _vaccinationcertificate = null;
    _selectedLanguage.clear();
    _age = null;
    _selectedTechnicalSkills.clear();
    notifyListeners();
  }

  // Experience Setters and Functions

  void clearResponsibility() {
    jobrole.clear();
    _isResponsebilityGenerated = false;
  }

  Future<void> fetchResponsibilityUsingAi() async {
    if (_isResponsebilityLoading) return;
    _isResponsebilityLoading = true;
    notifyListeners();
    try {
      _responsibilityAiModel =
          await ResumeService.generateResponsibilitiesUsingAI(
            functionalArea: functionalArea.text,
            industry: industry.text,
            jobTitle: jobtitle.text,
            levelOfHiring: '',
          ) ??
          ResponsibilityAiModel();
      if (_responsibilityAiModel!.responsibilities != null &&
          _responsibilityAiModel!.responsibilities!.isNotEmpty) {
        jobrole.text = _responsibilityAiModel!.responsibilities!.join('\n');
        _isResponsebilityGenerated = true;
        if (_responsibilityAiModel!.skills != null &&
            _responsibilityAiModel!.skills!.isNotEmpty) {
          _skills.addAll(List<String>.from(_responsibilityAiModel!.skills!));
        }
      }
      notifyListeners();
      CustomSnackbar.show(
        "Responsibilities & Skill added with AI magic 🪄",
        false,
      );
    } catch (e) {
      // Show error Snackbar
      CustomSnackbar.show("Error while generating responsibility: $e", true);
      rethrow; // Rethrow the error to handle it in the UI
    } finally {
      _isResponsebilityLoading = false;
      notifyListeners();
    }
  }

  void setShowExperienceForm(bool value) {
    _showExperienceForm = value;
    notifyListeners();
  }

  void setCurrentlyWorking(bool value) {
    _currentlyWorking = value;
    notifyListeners();
  }

  void setStartDate(String date) {
    startDate.text = date;
    notifyListeners();
  }

  void setLastDate(String date) {
    lastWorkingDate.text = date;
    notifyListeners();
  }

  void setOfferLetter(String value) {
    _offerLetter = value;
    notifyListeners();
  }

  void setAppointmentLetter(String value) {
    _appointmentLetter = value;
    notifyListeners();
  }

  void setSalarySlip(String value) {
    _salarySlip = value;
    notifyListeners();
  }

  void setIncrementLetter(String value) {
    _incrementLetter = value;
    notifyListeners();
  }

  void setExperienceLetter(String value) {
    _experienceLetter = value;
    notifyListeners();
  }

  void assignSkillsToExperience(List<String> skills) {
    _skills = List<String>.from(skills);
    notifyListeners();
  }

  void assignSkillsToProjects(List<String> skills) {
    _project_it_skills = List<String>.from(skills);
    notifyListeners();
  }

  void setWorkType(int workType, LocationData? selectedLocations) {
    _onsite = false;
    _hybrid = false;
    _remote = false;
    _onsiteLocations = null;
    _hybridLocations = null;
    _remoteLocation = null;

    if (workType == 1) {
      _onsite = true;
      _onsiteLocations = selectedLocations;
    } else if (workType == 2) {
      _hybrid = true;
      _hybridLocations = selectedLocations;
    } else if (workType == 3) {
      _remote = true;
      _remoteLocation = selectedLocations;
    }

    notifyListeners();
  }

  void setEmpType(String input) {
    _fulltime = false;
    _partTime = false;
    _contractual = false;
    _freelancer = false;
    _internship = false;
    _selfemploye = false;

    switch (input.toLowerCase()) {
      case 'full time':
      case 'full-time':
      case 'fulltime':
        _fulltime = true;
        break;
      case 'part time':
      case 'part-time':
        _partTime = true;
        break;
      case 'contractual':
        _contractual = true;
        break;
      case 'freelancer':
        _freelancer = true;
        break;
      case 'internship':
        _internship = true;
        break;
      case 'self employed':
      case 'self-employed':
        _selfemploye = true;
        break;
    }
    notifyListeners();
  }

  void addOrUpdateExperience() {
    final experience = ExperienceRequest(
      jobTitle: jobtitle.text,
      companyName: companyname.text,
      industry: industry.text,
      functionalArea: functionalArea.text,
      jobRole: jobrole.text.isNotEmpty
          ? addBulletPointBeforSaving.addBulletsToEachLine(jobrole.text)
          : null,
      joiningDate: startDate.text.isNotEmpty
          ? CvParseDateToApiFormat.formatDate(startDate.text)
          : null,
      lastWorkingDate: _currentlyWorking || lastWorkingDate.text.isEmpty
          ? null
          : CvParseDateToApiFormat.formatDate(lastWorkingDate.text),
      salary: anualSalary.text,
      isCurrent: _currentlyWorking ? 1 : 0,
      empType: _fulltime
          ? "Full Time"
          : _partTime
          ? "Part Time"
          : _contractual
          ? "Contractual"
          : _freelancer
          ? "Freelancer"
          : _internship
          ? "Internship"
          : "",
      workType: _onsite
          ? "OnSite"
          : _hybrid
          ? "Hybrid"
          : _remote
          ? "Remote"
          : "",
      jobLocation: _onsite
          ? _onsiteLocations?.formateData
          : _hybrid
          ? _hybridLocations?.formateData
          : _remote
          ? _remoteLocation?.formateData
          : null,
      offerLetter: _offerLetter,
      appointmentLetter: _appointmentLetter,
      experienceLettter: _experienceLetter,
      incrementLetter: _incrementLetter,
      salarySlip: _salarySlip,
      skillsExp: _skills.isNotEmpty
          ? List<String>.from(_skills)
          : null, // Deep copy
    );

    if (_editingIndex != null) {
      _experiencesModel[_editingIndex!] = experience;
    } else {
      _experiencesModel.add(experience);
    }

    clearExperienceForm();
    _editingIndex = null;
    setShowExperienceForm(false);
    notifyListeners();
  }

  void editExperience(int index) {
    if (index < 0 || index >= _experiencesModel.length) return;

    final exp = _experiencesModel[index];
    jobtitle.text = exp.jobTitle ?? '';
    companyname.text = exp.companyName ?? '';
    industry.text = exp.industry ?? '';
    functionalArea.text = exp.functionalArea ?? '';
    jobrole.text = exp.jobRole != null
        ? DataAssignToNextLine.formatWithBullets(exp.jobRole.toString())
        : '';
    startDate.text =
        CvParseExpDateFormatter.formatDate(exp.joiningDate, false) ?? '';
    lastWorkingDate.text =
        CvParseExpDateFormatter.formatDate(exp.lastWorkingDate, false) ?? '';
    anualSalary.text = exp.salary ?? '';
    _currentlyWorking = exp.isCurrent == 1;
    _offerLetter = exp.offerLetter;
    _appointmentLetter = exp.appointmentLetter;
    _salarySlip = exp.salarySlip;
    _incrementLetter = exp.incrementLetter;
    _experienceLetter = exp.experienceLettter;
    _skills = exp.skillsExp != null ? List<String>.from(exp.skillsExp!) : [];
    print("editExperience: skillsExp = ${exp.skillsExp}, _skills = $_skills");

    if (exp.empType != null) setEmpType(exp.empType!);
    if (exp.workType != null) {
      LocationData selectedLocation = LocationData(
        formateData: exp.jobLocation ?? '',
      );
      int workType = exp.workType == "OnSite"
          ? 1
          : exp.workType == "Hybrid"
          ? 2
          : exp.workType == "Remote"
          ? 3
          : 0;
      setWorkType(workType, selectedLocation);
    }

    _editingIndex = index;
    setShowExperienceForm(true);
    notifyListeners();
  }

  void removeExperience(int index) {
    if (index < 0 || index >= _experiencesModel.length) return;

    _experiencesModel.removeAt(index);
    if (_editingIndex == index) {
      clearExperienceForm();
      _editingIndex = null;
    } else if (_editingIndex != null && _editingIndex! > index) {
      _editingIndex = _editingIndex! - 1;
    }
    if (_experiencesModel.isEmpty) {
      setShowExperienceForm(true);
    }
    notifyListeners();
  }

  void cancelExperienceEdit() {
    clearExperienceForm();
    _editingIndex = null;
    if (_experiencesModel.isNotEmpty) {
      setShowExperienceForm(false);
    }
    notifyListeners();
  }

  void clearExperienceForm() {
    jobtitle.clear();
    jobrole.clear();
    companyname.clear();
    industry.clear();
    functionalArea.clear();
    startDate.clear();
    lastWorkingDate.clear();
    anualSalary.clear();
    jobResponsibility.clear();
    _empType = null;
    _workMode = null;
    _workLocation = null;
    _currentlyWorking = false;
    _hybrid = false;
    _onsite = false;
    _remote = false;
    _fulltime = false;
    _partTime = false;
    _contractual = false;
    _freelancer = false;
    _internship = false;
    _hybridLocations = null;
    _onsiteLocations = null;
    _remoteLocation = null;
    _offerLetter = null;
    _appointmentLetter = null;
    _salarySlip = null;
    _incrementLetter = null;
    _experienceLetter = null;
    _selfemploye = false;
    clearResponsibility();
    _skills.clear();
  }

  // Education Setters and Functions
  void setShowEducationForm(bool value) {
    _showEducationForm = value;
    notifyListeners();
  }

  void setCurrentlyStudying(bool value) {
    _currentlyStudy = value;
    notifyListeners();
  }

  void setMarkSheet(String value) {
    _markSheet = value;
    notifyListeners();
  }

  void setCourseType(String input) {
    _fullimecourse = false;
    _parttimecourse = false;
    _distancelearning = false;
    _correspondence = false;

    switch (input.toLowerCase()) {
      case 'fulltime':
        _fullimecourse = true;
        break;
      case 'parttime':
        _parttimecourse = true;
        break;
      case 'distance learning':
        _distancelearning = true;
        break;
      case 'correspondence':
        _correspondence = true;
        break;
    }
    notifyListeners();
  }

  void setDegreeCertificate(bool value) {
    _degreeCertificate = value;
    _allEducationDocs = false;
    notifyListeners();
  }

  void setAllEducationDocs(bool value) {
    _allEducationDocs = value;
    _degreeCertificate = false;
    notifyListeners();
  }

  void setIsRemote(bool value) {
    _isRemote = value;
    if (value) schoolCollegeName.clear();
    notifyListeners();
  }

  void addOrUpdateEducation() {
    Map<String, int> monthMap = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    int startMonthInt = monthMap[startmonth.text.trim()] ?? 1;
    int endMonthInt = monthMap[endmonth.text.trim()] ?? 1;

    final education = EducationRequest(
      schoolOrCollegeName: schoolCollegeName.text,
      isRemote: _isRemote ? 1 : 0,
      university: universityBoardName.text,
      degreeSpc: degree.text,
      fieldOfStudy: fieldOFStudy.text,
      firstYear: int.tryParse(startyear.text.trim()),
      startMonth: startMonthInt,
      passingYear: int.tryParse(endyear.text.trim()),
      endMonth: endMonthInt,
      isCurrent: _currentlyStudy ? 1 : 0,
      marksheet: _markSheet,
      courseType: _fullimecourse
          ? "Fulltime"
          : _parttimecourse
          ? "Parttime"
          : _distancelearning
          ? "Distance Learning"
          : _correspondence
          ? "Correspondence"
          : "",
    );

    if (_editingEducationIndex != null) {
      _educationModel[_editingEducationIndex!] = education;
    } else {
      _educationModel.add(education);
    }

    clearEducationForm();
    _editingEducationIndex = null;
    setShowEducationForm(false);
    notifyListeners();
  }

  void editEducation(int index) {
    if (index < 0 || index >= _educationModel.length) return;

    Map<int, String> monthIntToString = {
      1: "January",
      2: "February",
      3: "March",
      4: "April",
      5: "May",
      6: "June",
      7: "July",
      8: "August",
      9: "September",
      10: "October",
      11: "November",
      12: "December",
    };

    final edu = _educationModel[index];
    schoolCollegeName.text = edu.schoolOrCollegeName ?? '';
    _isRemote = edu.isRemote == 1;
    universityBoardName.text = edu.university ?? '';
    degree.text = edu.degreeSpc ?? '';
    fieldOFStudy.text = edu.fieldOfStudy ?? '';
    startmonth.text = monthIntToString[edu.startMonth] ?? '';
    startyear.text = edu.firstYear?.toString() ?? '';
    endmonth.text = monthIntToString[edu.endMonth] ?? '';
    endyear.text = edu.passingYear?.toString() ?? '';
    _currentlyStudy = edu.isCurrent == 1;
    _markSheet = edu.marksheet;
    if (edu.courseType != null) setCourseType(edu.courseType!);
    _editingEducationIndex = index;
    setShowEducationForm(true);
    notifyListeners();
  }

  void removeEducation(int index) {
    if (index < 0 || index >= _educationModel.length) return;

    _educationModel.removeAt(index);
    if (_editingEducationIndex == index) {
      clearEducationForm();
      _editingEducationIndex = null;
    } else if (_editingEducationIndex != null &&
        _editingEducationIndex! > index) {
      _editingEducationIndex = _editingEducationIndex! - 1;
    }
    if (_educationModel.isEmpty) {
      setShowEducationForm(true);
    }
    notifyListeners();
  }

  void cancelEducationEdit() {
    clearEducationForm();
    _editingEducationIndex = null;
    if (_educationModel.isNotEmpty) {
      setShowEducationForm(false);
    }
    notifyListeners();
  }

  void clearEducationForm() {
    schoolCollegeName.clear();
    universityBoardName.clear();
    degree.clear();
    fieldOFStudy.clear();
    startmonth.clear();
    startyear.clear();
    endyear.clear();
    endmonth.clear();
    _currentlyStudy = false;
    _markSheet = null;
    _degreeCertificate = false;
    _allEducationDocs = false;
    _isRemote = false;
    _fullimecourse = false;
    _parttimecourse = false;
    _distancelearning = false;
    _correspondence = false;
  }

  // Certificate Setters and Functions
  void setShowCertificateForm(bool value) {
    _showCertificateForm = value;
    notifyListeners();
  }

  void setCertificateDocument(String value) {
    _certificate = value;
    notifyListeners();
  }

  void addOrUpdateCertificate() {
    final certificate = CertificationRequest(
      certificationName: certificateName.text,
      issuingOrganization: organizationName.text,
      credentialId: credentialId.text.isNotEmpty ? credentialId.text : null,
      credentialUrl: credentialUrl.text.isNotEmpty ? credentialUrl.text : null,
      startYear: int.tryParse(issueyear.text),
      startMonth: issuemonth.text,
      endYear: int.tryParse(validyear.text),
      endMonth: validmonth.text,
      certificate: _certificate,
      isLifetime: _dontHaveExpiry ? true : false,
    );

    if (_editingCertificateIndex != null) {
      _certificateModel[_editingCertificateIndex!] = certificate;
    } else {
      _certificateModel.add(certificate);
    }

    clearCertificateForm();
    _editingCertificateIndex = null;
    setShowCertificateForm(false);
    notifyListeners();
  }

  void editCertificate(int index) {
    if (index < 0 || index >= _certificateModel.length) return;

    final cert = _certificateModel[index];
    certificateName.text = cert.certificationName ?? '';
    organizationName.text = cert.issuingOrganization ?? '';
    credentialId.text = cert.credentialId ?? '';
    credentialUrl.text = cert.credentialUrl ?? '';
    issuemonth.text = cert.startMonth ?? '';
    issueyear.text = cert.startYear?.toString() ?? '';
    validmonth.text = cert.endMonth ?? '';
    validyear.text = cert.endYear?.toString() ?? '';
    _certificate = cert.certificate;
    _dontHaveExpiry = cert.isLifetime ?? false;
    _editingCertificateIndex = index;
    setShowCertificateForm(true);
    notifyListeners();
  }

  void removeCertificate(int index) {
    if (index < 0 || index >= _certificateModel.length) return;

    _certificateModel.removeAt(index);
    if (_editingCertificateIndex == index) {
      clearCertificateForm();
      _editingCertificateIndex = null;
    } else if (_editingCertificateIndex != null &&
        _editingCertificateIndex! > index) {
      _editingCertificateIndex = _editingCertificateIndex! - 1;
    }
    if (_certificateModel.isEmpty) {
      setShowCertificateForm(true);
    }
    notifyListeners();
  }

  void cancelCertificateEdit() {
    clearCertificateForm();
    _editingCertificateIndex = null;
    if (_certificateModel.isNotEmpty) {
      setShowCertificateForm(false);
    }
    notifyListeners();
  }

  void setupCertificateListeners() {
    certificateName.addListener(() {
      notifyListeners();
    });

    organizationName.addListener(() {
      notifyListeners();
    });
  }

  void SetDontHaveExpiry(bool value) {
    _dontHaveExpiry = value;
    if (value) {
      validmonth.clear();
      validyear.clear();
    }
    notifyListeners();
  }

  void clearCertificateForm() {
    certificateName.clear();
    organizationName.clear();
    credentialId.clear();
    credentialUrl.clear();
    issuemonth.clear();
    issueyear.clear();
    validmonth.clear();
    validyear.clear();
    _certificateNoExpiration = false;
    _certificateDocument = false;
    _allCertificateDocs = false;
    _certificate = null;
    _dontHaveExpiry = false;
  }

  /*  // Skills Update (Assuming skills are part of experience or separate; here treating as list)
  void updateSkills(List<String> newSkills) {
    _skills = newSkills;
    notifyListeners();
  } */

  // Project Setters and Functions

  void setupProjectListeners() {
    project_title.addListener(() {
      notifyListeners();
    });

    project_decription.addListener(() {
      notifyListeners();
    });
  }

  void setShowProjectForm(bool value) {
    _showProjectForm = value;
    notifyListeners();
  }

  void addOrUpdateProject() {
    if (proj_startMonth.text.isNotEmpty &&
        proj_startYear.text.isNotEmpty &&
        proj_endMonth.text.isNotEmpty &&
        proj_endYear.text.isNotEmpty) {
      _project_duration =
          '${proj_startMonth.text} ${proj_startYear.text} to ${proj_endMonth.text} ${proj_endYear.text}';
    } else if (proj_startMonth.text.isNotEmpty &&
        proj_startYear.text.isNotEmpty) {
      _project_duration = '${proj_startMonth.text} ${proj_startYear.text}';
    } else if (proj_endMonth.text.isNotEmpty && proj_endYear.text.isNotEmpty) {
      _project_duration = '${proj_endMonth.text} ${proj_endYear.text}';
    }
    final project = UserProjectRequest(
      projectTitle: project_title.text,
      description: project_decription.text,
      role: project_role.text,
      url: project_url.text.isNotEmpty
          ? project_url.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : [],
      duration: _project_duration,
      technologiesUsed: _project_technology_used,
      itSkillsByProject: _project_it_skills.join(','),
    );

    if (_editProjectIndex != null) {
      _projectModel[_editProjectIndex!] = project;
    } else {
      _projectModel.add(project);
    }

    clearProjectFoorm();
    _editProjectIndex = null;
    setShowProjectForm(false);
    notifyListeners();
  }

  void editProject(int index) {
    if (index < 0 || index >= _projectModel.length) return;

    final cert = _projectModel[index];
    project_title.text = cert.projectTitle ?? '';
    project_decription.text = cert.description ?? '';
    project_role.text = cert.role ?? '';
    project_url.text = (cert.url != null && cert.url!.isNotEmpty)
        ? cert.url!.join(', ')
        : '';
    if (cert.duration != null) {
      parseAndAssignProjectDuration(cert.duration!);
    }
    _project_technology_used = cert.technologiesUsed!;
    _project_it_skills =
        cert.itSkillsByProject != null && cert.itSkillsByProject!.isNotEmpty
        ? cert.itSkillsByProject!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : [];

    _editProjectIndex = index;
    setShowProjectForm(true);
    notifyListeners();
  }

  void parseAndAssignProjectDuration(String duration) {
    // Trim to avoid extra spaces
    duration = duration.trim();

    // Split based on 'to'
    List<String> parts = duration.split(
      RegExp(r'\s+to\s+', caseSensitive: false),
    );

    String start = parts[0].trim();
    String? end = parts.length > 1 ? parts[1].trim() : null;

    // Function to extract month and year from a string
    Map<String, String> extractMonthYear(String input) {
      final parts = input
          .split(RegExp(r'[\s-]+'))
          .where((e) => e.isNotEmpty)
          .toList();

      if (parts.length == 2) {
        return {'month': parts[0], 'year': parts[1]};
      } else if (parts.length == 1) {
        // e.g. "Dec-22" or "January"
        if (RegExp(r'\d{2,4}').hasMatch(parts[0])) {
          return {'month': '', 'year': parts[0]};
        } else {
          return {'month': parts[0], 'year': ''};
        }
      } else {
        return {'month': '', 'year': ''};
      }
    }

    // Extract start date info
    final startData = extractMonthYear(start);

    // Assign start month/year
    proj_startMonth.text = startData['month'] ?? '';
    proj_startYear.text = startData['year'] ?? '';

    // Handle end date
    if (end != null &&
        end.isNotEmpty &&
        !end.toLowerCase().contains('present')) {
      final endData = extractMonthYear(end);
      proj_endMonth.text = endData['month'] ?? '';
      proj_endYear.text = endData['year'] ?? '';
    } else if (end != null && end.toLowerCase().contains('present')) {
      proj_endMonth.text = 'Present';
      proj_endYear.text = '';
    } else {
      proj_endMonth.text = '';
      proj_endYear.text = '';
    }
  }

  void removeProject(int index) {
    if (index < 0 || index >= _projectModel.length) return;

    _projectModel.removeAt(index);
    if (_editProjectIndex == index) {
      clearProjectFoorm();
      _editProjectIndex = null;
    } else if (_editProjectIndex != null && _editProjectIndex! > index) {
      _editProjectIndex = _editProjectIndex! - 1;
    }
    if (_projectModel.isEmpty) {
      setShowProjectForm(true);
    }
    notifyListeners();
  }

  void cancelProjectEdit() {
    clearProjectFoorm();
    _editProjectIndex = null;
    if (_projectModel.isNotEmpty) {
      setShowProjectForm(false);
    }
    notifyListeners();
  }

  void clearProjectFoorm() {
    project_title.clear();
    project_decription.clear();
    project_role.clear();
    project_url.clear();
    proj_startMonth.clear();
    proj_startYear.clear();
    proj_endMonth.clear();
    proj_endYear.clear();
    project_skill_controller.clear();
    _project_duration = null;
    _project_technology_used.clear();
    _project_it_skills.clear();
  }

  //
  //
  //
  //
  //

  void steUpAwardListner() {
    awards_title.addListener(() {
      notifyListeners();
    });

    awards_description.addListener(() {
      notifyListeners();
    });
  }

  void setShowAwardsForm(bool value) {
    _showAwardsForm = value;
    notifyListeners();
  }

  void addOrUpdateAwards() {
    final project = AwardsAndAchievementsModel(
      title: awards_title.text,
      description: awards_description.text,
    );

    if (_editAwardIndex != null) {
      _awardsModel[_editAwardIndex!] = project;
    } else {
      _awardsModel.add(project);
    }

    clearAwardsForm();
    _editAwardIndex = null;
    setShowAwardsForm(false);
    notifyListeners();
  }

  void editAwards(int index) {
    if (index < 0 || index >= _awardsModel.length) return;
    final cert = _awardsModel[index];
    awards_title.text = cert.title ?? '';
    awards_description.text = cert.description ?? '';
    _editAwardIndex = index;
    setShowAwardsForm(true);
    notifyListeners();
  }

  void removeAwards(int index) {
    if (index < 0 || index >= _awardsModel.length) return;
    _awardsModel.removeAt(index);
    if (_editAwardIndex == index) {
      clearAwardsForm();
      _editAwardIndex = null;
    } else if (_editAwardIndex != null && _editAwardIndex! > index) {
      _editAwardIndex = _editAwardIndex! - 1;
    }
    if (_awardsModel.isEmpty) {
      setShowAwardsForm(true);
    }
    notifyListeners();
  }

  void cancelAwardsEdit() {
    clearAwardsForm();
    _editAwardIndex = null;
    if (_awardsModel.isNotEmpty) {
      setShowAwardsForm(false);
    }
    notifyListeners();
  }

  void clearAwardsForm() {
    awards_title.clear();
    awards_description.clear();
    notifyListeners();
  }

  //
  //
  //
  //
  //
  //

  // profile Summary...

  bool _isSummaryLoading = false;
  bool get isSummaryLoading => _isSummaryLoading;
  ProfileSummaryModel? _profileSummaryModel;
  ProfileSummaryModel? get profileSummaryModel => _profileSummaryModel;
  bool _isSummaryGenereted = false;
  bool get isSummaryGenereted => _isSummaryGenereted;

  void clearProfileSummary() {
    bio.clear();
    notifyListeners();
  }

  /*  void updateProfileModelForSummary() {
    final updatedUserRequest = profileModel!.userRequest!.copyWith(
      bio: bio.text,
    );

    _profileModel = profileModel!.copyWith(userRequest: updatedUserRequest);
    notifyListeners();
  } */

  Future<void> fetchSummaryUsingAi() async {
    if (_isSummaryLoading) return;
    _isSummaryLoading = true;
    notifyListeners();
    try {
      _profileSummaryModel =
          await ResumeService.generateSummaryUsingAi() ?? ProfileSummaryModel();
      if (_profileSummaryModel!.profileResponse != null) {
        bio.text = _profileSummaryModel!.profileResponse!;
        _isSummaryGenereted = true;
      }
      notifyListeners();
      CustomSnackbar.show("Profile Summary added with AI magic 🪄", false);
    } catch (e) {
      // Show error Snackbar
      CustomSnackbar.show("Error while generating Summary: $e", true);
      rethrow; // Rethrow the error to handle it in the UI
    } finally {
      _isSummaryLoading = false;
      notifyListeners();
    }
  }

  //
  // Build Model
  CreateNewUserModel buildModel() {
    final updatedExperiences = _experiencesModel.map((exp) {
      return exp.copyWith(
        joiningDate: CvParseDateToApiFormat.formatDate(exp.joiningDate),
        lastWorkingDate: CvParseDateToApiFormat.formatDate(exp.lastWorkingDate),
      );
    }).toList();
    return CreateNewUserModel(
      educationRequest: _educationModel,
      experienceRequest: updatedExperiences,
      certificationsRequest: _certificateModel,
      userProjectRequest: _projectModel,
      awardsAndAchievementsRequest: _awardsModel,
      userRequest: UserRequest(
        cvLink: _resume,
        experience: _experience ? 1 : 0,
        education: _graduate ? 1 : 0,
        firstName: firstname.text,
        middleName: middlename.text,
        lastName: lastname.text,
        mobile: int.tryParse(contactno.text),
        alternateNo: int.tryParse(alternnateno.text),
        userLocation: location.text,
        userLocality: locality.text,
        pinCode: pincode.text,
        email: emailid.text,
        bio: bio.text,
        gender: _male
            ? 'Male'
            : _female
            ? 'Female'
            : null,
        dateOfBirth: CvParseDateToApiFormat.formatDate(dateofbirth.text),
        languages: _selectedLanguage,
        vaccination: _vaccinated,
        vaccinationCertificate: _vaccinationcertificate,
        profileHeadline: profileHeadline.text,
        profileRole: profileRole.text,
        linkdlnUrl: linkedInUrl.text,
      ),
    );
  }

  Future<bool> setDataToModel() {
    try {
      _userModel = buildModel();
      return Future.value(true);
    } catch (e) {
      CustomSnackbar.show('Failed to set data to model: $e', true);
      return Future.value(false);
    }
  }

  // Save and Update Functions
  Future<bool> saveUserData() async {
    final token = SharedPrefsHelper.getString(ESharedPreferences.user_token);
    _isLoading = true;
    notifyListeners();
    try {
      final model = buildModel();
      final result = await SignupService.saveUserData(model, token);
      if (result) {
        _userModel = model;
        clearAll();
        CustomSnackbar.show(
          '🤝 Welcome to Job Circle — where talent meets opportunity.',
          false,
        );
      }
      return result;
    } catch (e) {
      CustomSnackbar.show('Failed to save data: $e', true);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBasicInfo() async {
    return await saveUserData(); // Since buildModel includes everything, but focuses on basic
  }

  Future<bool> updateExperience() async {
    return await saveUserData();
  }

  Future<bool> updateEducation() async {
    return await saveUserData();
  }

  Future<bool> updateCertificates() async {
    return await saveUserData();
  }

  Future<bool> updateSkillsAndSave() async {
    return await saveUserData();
  }

  // CV Parsing
  Future<void> fetchParseData(
    File pdfFile,
    String cvLink,
    BuildContext context,
  ) async {
    _isLoading = true;
    _error = null;
    _cvParseModel = null;
    _profileModel = null;
    clearAll();
    notifyListeners();

    try {
      _cvParseModel = await ResumeService.onboardingCvParse(pdfFile: pdfFile);
      setResume(cvLink);
      _profileModel = CreateNewUserModel(
        userRequest: UserRequest(
          skills: _cvParseModel!.skills != null
              ? List<String>.from((_cvParseModel!.skills!.softSkills ?? [])) +
                    List<String>.from(
                      (_cvParseModel!.skills!.toolsKnowledgeSkills ?? []),
                    ) +
                    List<String>.from((_cvParseModel!.skills!.itSkill ?? []))
              : [],
          education: _cvParseModel!.educationLevel != "Graduate" ? 0 : 1,
          firstName: _cvParseModel?.firstName,
          middleName: _cvParseModel?.middleName,
          lastName: _cvParseModel?.lastName,
          mobile: _cvParseModel?.mobileNumber != null
              ? int.tryParse(_cvParseModel!.mobileNumber!)
              : null,
          alternateNo: _cvParseModel?.alternateNumber != null
              ? int.tryParse(_cvParseModel!.alternateNumber!)
              : null,
          userLocation: _cvParseModel?.locationCity,
          userLocality: _cvParseModel?.locationLocality,
          pinCode: _cvParseModel!.pinCode,
          email: _cvParseModel?.email,
          gender: _cvParseModel?.gender,
          dateOfBirth: CvParseExpDateFormatter.formatDate(
            _cvParseModel?.dateOfBirth,
            false,
          ),
          bio: _cvParseModel!.summary,
          languages: _cvParseModel!.languages!.regionalLanguages ?? [],
          vaccination: null,
          vaccinationCertificate: null,
          profileHeadline: null,
          profileRole: null,
          linkdlnUrl: null,
        ),
        experienceRequest: mapExperiences(_cvParseModel!.experience),
        educationRequest: mapEducations(_cvParseModel!.education),
        certificationsRequest: mapCertificate(_cvParseModel!.certifications),
        userProjectRequest: mapPojects(_cvParseModel!.projects),
      );
      // Assign CV parsed data to controllers and internal models
      assignCvParseDataToControllers();
      NavigationService.push(CvParseUserProfile());
    } catch (e) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => CustomDialogForConfirmation(
          title: 'Error',
          subtitle:
              e.toString().contains(
                    "Mobile number in CV does not match the provided mobile number",
                  ) ||
                  e.toString().contains("Mobile number")
              ? "Mobile number in Resume does not match the number which you have used for login"
              : "Something went wrong try again",
          button1text: 'Ok',
          onlysinglebutton: true,
          onYes: () {
            NavigationService.pop();
          },
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Assign CV parsed data to controllers and internal models
  void assignCvParseDataToControllers() {
    if (_profileModel == null) return;

    final userRequest = _profileModel!.userRequest;
    if (userRequest != null) {
      // Assign basic info to controllers
      firstname.text = userRequest.firstName ?? '';
      middlename.text = userRequest.middleName ?? '';
      lastname.text = userRequest.lastName ?? '';
      contactno.text = userRequest.mobile?.toString() ?? '';
      alternnateno.text = userRequest.alternateNo?.toString() ?? '';
      emailid.text = userRequest.email ?? '';
      location.text = userRequest.userLocation ?? '';
      locality.text = userRequest.userLocality ?? '';
      pincode.text = userRequest.pinCode ?? '';
      dateofbirth.text = userRequest.dateOfBirth ?? '';
      profileHeadline.text = userRequest.profileHeadline ?? '';
      bio.text = userRequest.bio ?? '';
      profileRole.text = userRequest.profileRole ?? '';
      linkedInUrl.text = userRequest.linkdlnUrl ?? '';
      _tempSelectedSkills = List<String>.from(userRequest.skills!);

      // Set gender
      if (userRequest.gender != null) {
        setGender(userRequest.gender!);
      }

      // Set languages
      if (userRequest.languages != null) {
        _selectedLanguage = List<String>.from(userRequest.languages!);
      }

      // Set vaccination
      _vaccinated = userRequest.vaccination ?? false;
      _vaccinationcertificate = userRequest.vaccinationCertificate;
    }

    // Assign experiences to internal model
    if (_profileModel!.experienceRequest != null) {
      _experiencesModel.clear();
      _experiencesModel.addAll(_profileModel!.experienceRequest!);
    }

    // Assign education to internal model
    if (_profileModel!.educationRequest != null) {
      _educationModel.clear();
      _educationModel.addAll(_profileModel!.educationRequest!);
    }

    // Assign certificate to internal model
    if (_profileModel!.certificationsRequest != null) {
      _certificateModel.clear();
      _certificateModel.addAll(_profileModel!.certificationsRequest!);
    }

    // Assign projects to internal model
    if (_profileModel!.userProjectRequest != null) {
      _projectModel.clear();
      _projectModel.addAll(_profileModel!.userProjectRequest!);
    }

    notifyListeners();
  }

  List<ExperienceRequest> mapExperiences(
    List<OnBoardCvParseExperience>? oldList,
  ) {
    if (oldList == null) return [];

    return oldList.map((exp) {
      String? start, end;
      bool current = false;

      if (exp.startDate != null) {
        // Normalize dashes (–, — → -)
        start = CvParseExpDateFormatter.formatDate(
          exp.startDate!.trim(),
          false,
        );
      }
      if (exp.endDate != null) {
        if (exp.endDate == "Present") {
          current = true;
        } else {
          end = CvParseExpDateFormatter.formatDate(exp.endDate!.trim(), false);
        }
      }

      return ExperienceRequest(
        empType: exp.empType?.replaceAll('-', ' '),
        companyName: exp.companyName,
        jobTitle: exp.jobTitle,
        joiningDate: start,
        isCurrent: current ? 1 : 0,
        lastWorkingDate: end,
        jobRole: exp.responsibilities?.join(' • '),
        skillsExp: exp.skills,
      );
    }).toList();
  }

  List<EducationRequest> mapEducations(List<OnBoardCvParseEducation>? oldList) {
    if (oldList == null) return [];

    return oldList.map((edu) {
      String? passingYearStr = edu.passingYear;
      return EducationRequest(
        degreeSpc: edu.courseName,
        university: edu.universityInstitute,
        passingYear: int.tryParse(passingYearStr ?? ''),
        fieldOfStudy: edu.specialization,
      );
    }).toList();
  }

  List<CertificationRequest> mapCertificate(
    List<OnBoardCvParseCertification>? oldList,
  ) {
    if (oldList == null) return [];

    return oldList.map((cert) {
      String? passingYearStr = cert.validTill;
      return CertificationRequest(
        certificationName: cert.certificateName,
        issuingOrganization: cert.organization,
        endYear: int.tryParse(passingYearStr ?? ''),
      );
    }).toList();
  }

  List<UserProjectRequest> mapPojects(List<OnBoardCvParseProject>? oldList) {
    if (oldList == null) return [];

    return oldList.map((proj) {
      return UserProjectRequest(
        projectTitle: proj.projectTitle,
        description: proj.description,
        role: proj.role,
        url: proj.url is List<String>
            ? List<String>.from(proj.url as List)
            : (proj.url != null &&
                      proj.url != "null" &&
                      proj.url != '' &&
                      proj.url != ' '
                  ? [proj.url.toString()]
                  : <String>[]),
        duration: proj.duration,
        technologiesUsed: proj.technologiesUsed,
        itSkillsByProject: proj.itSkillsByProject,
      );
    }).toList();
  }

  void EditParseExperience(ExperienceRequest exp) {
    jobtitle.text = exp.jobTitle ?? '';
    companyname.text = exp.companyName ?? '';
    industry.text = exp.industry ?? '';
    functionalArea.text = exp.functionalArea ?? '';
    jobrole.text = exp.jobRole ?? '';
    startDate.text = exp.joiningDate ?? '';
    lastWorkingDate.text = exp.lastWorkingDate ?? '';
    anualSalary.text = exp.salary ?? '';
    _currentlyWorking = exp.isCurrent == 1;
    _offerLetter = exp.offerLetter;
    _appointmentLetter = exp.appointmentLetter;
    _salarySlip = exp.salarySlip;
    _incrementLetter = exp.incrementLetter;
    _experienceLetter = exp.experienceLettter;

    if (exp.empType != null) setEmpType(exp.empType!);
    if (exp.workType != null) {
      LocationData selectedLocation = LocationData(
        formateData: exp.jobLocation ?? '',
      );
      int workType = exp.workType == "OnSite"
          ? 1
          : exp.workType == "Hybrid"
          ? 2
          : exp.workType == "Remote"
          ? 3
          : 0;
      setWorkType(workType, selectedLocation);
    }

    notifyListeners();
  }

  // Update profile model when editing experiences
  void updateProfileModelFromControllers() {
    if (_profileModel == null) return;

    /* final updateusermodel = _userModel!.userRequest!.copyWith(
      profilePic: _profilePic,
      cvLink: _resume,
      dateOfBirth: CvParseDateToApiFormat.formatDate(dateofbirth.text)
    ); */

    // Update user request from controllers
    final updatedUserRequest = UserRequest(
      bio: bio.text,
      profilePic: _profilePic,
      cvLink: _resume,
      firstName: firstname.text,
      middleName: middlename.text,
      lastName: lastname.text,
      mobile: int.tryParse(contactno.text),
      alternateNo: int.tryParse(alternnateno.text),
      userLocation: location.text,
      userLocality: locality.text,
      pinCode: pincode.text,
      email: emailid.text,
      gender: _male
          ? 'Male'
          : _female
          ? 'Female'
          : null,
      dateOfBirth: CvParseDateToApiFormat.formatDate(dateofbirth.text),
      languages: _selectedLanguage,
      vaccination: _vaccinated,
      vaccinationCertificate: _vaccinationcertificate,
      profileHeadline: profileHeadline.text,
      experience: _experience ? 1 : 0,
      education: _graduate ? 1 : 0,
      skills: tempSelectedSkills,
      profileRole: profileRole.text,
      linkdlnUrl: linkedInUrl.text,
    );

    // Update profile model
    final updatedExperiences = _experiencesModel.map((exp) {
      return exp.copyWith(
        joiningDate: CvParseDateToApiFormat.formatDate(exp.joiningDate),
        lastWorkingDate: CvParseDateToApiFormat.formatDate(exp.lastWorkingDate),
      );
    }).toList();

    _profileModel = _profileModel!.copyWith(
      userRequest: updatedUserRequest,
      experienceRequest: updatedExperiences,
      educationRequest: _profileModel!.educationRequest ?? [],
      certificationsRequest: _profileModel!.certificationsRequest ?? [],
      userProjectRequest: _profileModel!.userProjectRequest ?? [],
    );
    notifyListeners();
  }

  void updateSummaryFromControllerToModel(CreateNewUserModel profileModel) {
    // if (_profileModel == null) return;

    // Update user request from controllers
    final updatedUserRequest = profileModel.userRequest!.copyWith(
      bio: bio.text,
    );

    _profileModel = profileModel.copyWith(userRequest: updatedUserRequest);
    notifyListeners();
  }

  // Save CV parse profile data
  Future<bool> saveCvParseProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Update profile model from current controllers and internal data
      updateProfileModelFromControllers();

      // Save the profile model
      final token = SharedPrefsHelper.getString(ESharedPreferences.user_token);
      final result = await SignupService.saveUserData(_profileModel!, token);

      if (result) {
        CustomSnackbar.show(
          '🤝 Welcome to Job Circle — where talent meets opportunity.',
          false,
        );
        // Update user model as well
        _userModel = _profileModel;
      } else {
        CustomSnackbar.show('Failed to save profile', true);
      }

      return result;
    } catch (e) {
      CustomSnackbar.show('Failed to save profile: $e', true);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear All
  void clearAll() {
    clearExperienceForm();
    clearEducationForm();
    clearCertificateForm();
    clearProjectFoorm();
    clearbasicDetail();
    clearAwardsForm();
    _empType = null;
    _workLocation = null;
    _workMode = null;
    _currentlyWorking = false;
    _currentlyStudy = false;
    _markSheet = null;
    _degreeCertificate = false;
    _allEducationDocs = false;
    _certificateNoExpiration = false;
    _certificateDocument = false;
    _allCertificateDocs = false;
    _certificate = null;
    _fresher = false;
    _experience = false;
    _graduate = false;
    _undergraduate = false;
    _experiencesModel.clear();
    _educationModel.clear();
    _certificateModel.clear();
    _awardsModel.clear();
    _projectModel.clear();
    _resume = null;
    _profilePic = null;
  }

  @override
  void dispose() {
    bio.dispose();
    firstname.dispose();
    middlename.dispose();
    lastname.dispose();
    contactno.dispose();
    alternnateno.dispose();
    dateofbirth.dispose();
    emailid.dispose();
    location.dispose();
    locality.dispose();
    pincode.dispose();
    profileHeadline.dispose();
    jobrole.dispose();
    companyname.dispose();
    industry.dispose();
    functionalArea.dispose();
    anualSalary.dispose();
    jobResponsibility.dispose();
    startDate.dispose();
    lastWorkingDate.dispose();
    jobtitle.dispose();
    schoolCollegeName.dispose();
    universityBoardName.dispose();
    degree.dispose();
    fieldOFStudy.dispose();
    startmonth.dispose();
    startyear.dispose();
    endmonth.dispose();
    endyear.dispose();
    certificateName.dispose();
    organizationName.dispose();
    credentialId.dispose();
    credentialUrl.dispose();
    issuemonth.dispose();
    issueyear.dispose();
    validmonth.dispose();
    validyear.dispose();
    project_title.dispose();
    project_decription.dispose();
    project_role.dispose();
    project_url.dispose();
    project_skill_controller.dispose();
    proj_startMonth.dispose();
    proj_startYear.dispose();
    proj_endMonth.dispose();
    proj_endYear.dispose();
    linkedInUrl.dispose();
    profileRole.dispose();
    project_title.removeListener(() {});
    project_decription.removeListener(() {});
    certificateName.removeListener(() {});
    organizationName.removeListener(() {});
    awards_title.dispose();
    awards_description.dispose();
    super.dispose();
  }

  // TODO:: specially for resume builder......

  ProfileModel buildProfileModelFromProvider(
    SignupCreateUserProvider provider,
  ) {
    return ProfileModel(
      firstName: provider.firstname.text,
      middleName: provider.middlename.text,
      lastName: provider.lastname.text,
      gmail: provider.emailid.text,
      mobile: int.tryParse(provider.contactno.text),
      alternateNo: int.tryParse(provider.alternnateno.text),
      dob: provider.dateofbirth.text,
      bio: provider.bio.text,
      userLocation: provider.location.text,
      userLocality: provider.locality.text,
      pinCode: provider.pincode.text,
      linkdlnUrl: provider.linkedInUrl.text,
      profileHeadline: provider.profileHeadline.text,
      profileRole: provider.profileRole.text,
      userFullLocation:
          '${provider.locality.text}, ${provider.location.text}, ${provider.pincode.text}',
      gender: provider._male
          ? 'Male'
          : provider._female
          ? 'Female'
          : null,
      certifications: provider.certificateModel
          .map(
            (cert) => CertificationDetailModel(
              certificationName: cert.certificationName,
              issuingOrganization: cert.issuingOrganization,
              credentialId: cert.credentialId,
              credentialUrl: cert.credentialUrl,
              startYear: cert.startYear,
              startMonth: cert.startMonth,
              endYear: cert.endYear,
              endMonth: cert.endMonth,
              isLifetime: cert.isLifetime,
            ),
          )
          .toList(),
      experiences: provider.experiencesModel
          .map(
            (exp) => Experience(
              empType: exp.empType,
              companyName: exp.companyName,
              jobTitle: exp.jobTitle,
              joiningDate: exp.joiningDate,
              isCurrent: exp.isCurrent,
              lastWorkingDate: exp.lastWorkingDate,
              jobRole: exp.jobRole,
              skillsExp: exp.skillsExp,
            ),
          )
          .toList(),
      educationDetails: provider.educationModel
          .map(
            (edu) => EducationDetail(
              degreeSpc: edu.degreeSpc,
              university: edu.university,
              passingYear: edu.passingYear,
              fieldOfStudy: edu.fieldOfStudy,
              startMonth: edu.startMonth.toString(),
              endMonth: edu.endMonth.toString(),
              firstYear: edu.firstYear,
              isCurrent: edu.isCurrent,
              courseType: edu.courseType,
            ),
          )
          .toList(),
      projects: provider.projectModel
          .map(
            (proj) => ProjectModel(
              projectTitle: proj.projectTitle,
              description: proj.description,
              role: proj.role,
              url: proj.url,
              duration: proj.duration,
              technologiesUsed: proj.technologiesUsed,
              itSkillsByProject: proj.itSkillsByProject,
            ),
          )
          .toList(),
      awardsAndAchievements: provider.awardsModel
          .map(
            (award) => AwardsAndAchievementsModel(
              title: award.title,
              description: award.description,
            ),
          )
          .toList(),
    );
  }
}
