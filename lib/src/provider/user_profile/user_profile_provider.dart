// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names, unused_local_variable, prefer_final_fields, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_responsibility_model.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/model/user_profile/refer_cv_parse_model.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/login_and_signup_services/resume_service.dart';
import 'package:job_circle/src/services/master_data/master_data_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/services/user_services/user_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/utils/age_calculater.dart';
import 'package:job_circle/src/utils/date_formater.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_confirmation.dart';

class ProfileProvider with ChangeNotifier {
  // Awards & Achievements
  TextEditingController awardTitleController = TextEditingController();
  TextEditingController awardDescriptionController = TextEditingController();
  final List<AwardsAndAchievementsModel> _awardsAchievementsModel = [];
  int? _editingAwardIndex;
  bool _showAwardForm = false;

  List<AwardsAndAchievementsModel> get awardsAchievementsModel =>
      _awardsAchievementsModel;
  bool get showAwardForm => _showAwardForm;
  int? get editingAwardIndex => _editingAwardIndex;
  bool get isEditingAward => _editingAwardIndex != null;

  ReferResumeParseModel? _cvParseModel;
  String? _error;

  ReferResumeParseModel? get cvParseModel => _cvParseModel;
  String? get error => _error;

  void setLoading(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  Future<void> fetchParseData(
    File pdfFile,
    String cvLink,
    BuildContext context,
    ProfileModel currentProfile,
  ) async {
    _isLoading = true;
    _error = null;
    _cvParseModel = null;
    notifyListeners();
    try {
      _cvParseModel = await ResumeService.referAddResumeCVParsing(
        pdfFile: pdfFile,
      );
      if ((_cvParseModel != null &&
              _cvParseModel!.contactNumber != null &&
              _cvParseModel!.contactNumber != "" &&
              _cvParseModel!.contactNumber != "null" &&
              _cvParseModel!.contactNumber != " ") &&
          (_cvParseModel!.contactNumber == currentProfile.mobile.toString())) {
        updateResume(currentProfile, cvLink);
      } else {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => CustomDialogForConfirmation(
            title: 'Error',
            subtitle: "Upload a valid resume with correct mobile number.",
            button1text: 'Ok',
            onlysinglebutton: true,
            onYes: () {
              NavigationService.pop();
            },
          ),
        );
      }
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
              ? "Mobile number in Resume does not match the number you entered."
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

  void setShowAwardForm(bool value) {
    _showAwardForm = value;
    notifyListeners();
  }

  void clearAwardForm() {
    awardTitleController.clear();
    awardDescriptionController.clear();
    _editingAwardIndex = null;
    notifyListeners();
  }

  void addOrUpdateAward() async {
    final award = AwardsAndAchievementsModel(
      title: awardTitleController.text,
      description: awardDescriptionController.text,
    );
    if (_editingAwardIndex != null &&
        _editingAwardIndex! >= 0 &&
        _editingAwardIndex! < _awardsAchievementsModel.length) {
      _awardsAchievementsModel[_editingAwardIndex!] = award;
    } else {
      _awardsAchievementsModel.add(award);
    }
    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(
        userId: _userid,
        skills: _profile!.allSkills,
        alternateNo: _profile!.alternateNo,
      ),
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
      awardsAndAchievementsRequest: _awardsAchievementsModel,
    );
    clearAwardForm();
    setShowAwardForm(false);
    _editingAwardIndex = null;
    notifyListeners();
    try {
      // ... your logic ...
      bool done = await UserServices.postUserInfo(_createNewUserModel!);
      if (done) {
        await fetchProfile(); // Wait for fresh data
        CustomSnackbar.show("Updated!", false);
      }
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        // This flag will hide the loader after 2 sec
        _isUpdating = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void editAward(int index) {
    if (index < 0 || index >= _awardsAchievementsModel.length) return;
    final award = _awardsAchievementsModel[index];
    awardTitleController.text = award.title ?? '';
    awardDescriptionController.text = award.description ?? '';
    _editingAwardIndex = index;
    setShowAwardForm(true);
    notifyListeners();
  }

  void removeAward(int index) async {
    int awardId = _awardsAchievementsModel[index].id!;
    bool done = await UserServices.DeleteExpEduCertProj(awardId, 'award');
    if (done) {
      fetchProfile();
      CustomSnackbar.show("Data Updated Successfully", false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    if (_awardsAchievementsModel.isEmpty) {
      setShowAwardForm(true);
    }
    notifyListeners();
  }

  /* void removeAward(int index) {
    if (index < 0 || index >= _awardsAchievementsModel.length) return;
    _awardsAchievementsModel.removeAt(index);
    if (_editingAwardIndex == index) {
      clearAwardForm();
      _editingAwardIndex = null;
    } else if (_editingAwardIndex != null && _editingAwardIndex! > index) {
      _editingAwardIndex = _editingAwardIndex! - 1;
    }
    if (_awardsAchievementsModel.isEmpty) {
      setShowAwardForm(true);
    }
    notifyListeners();
  } */

  void cancelAwardEdit() {
    clearAwardForm();
    _editingAwardIndex = null;
    if (_awardsAchievementsModel.isNotEmpty) {
      setShowAwardForm(false);
    }
    notifyListeners();
  }

  // Add to clearAllProfileData and dispose
  int _userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
  ProfileModel? _profile;
  CreateNewUserModel? _createNewUserModel;
  ResponsibilityAiModel? _responsibilityAiModel;
  ProfileSummaryModel? _profileSummaryModel;
  bool _isFetching = false;
  bool _isUpdating = false;
  bool _isLoading = false;

  ProfileModel? get profile => _profile;
  bool get isFetching => _isFetching;
  bool get isUpdating => _isUpdating;
  bool get isLoading => _isLoading;

  // Basic Profile Variables
  TextEditingController firstname = TextEditingController();
  TextEditingController middlename = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController contactno = TextEditingController();
  TextEditingController alternateno = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController dateofbirth = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController locality = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController profileHeadline = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController technicalSkillController = TextEditingController();
  TextEditingController linkdinUrl = TextEditingController();
  TextEditingController profileRole = TextEditingController();
  List<String> _language = [];
  final List<String> _selectedLanguage = [];
  bool _isLoadingLanguages = false,
      _male = false,
      _female = false,
      _vaccinated = false;
  bool _skillsLoading = false;
  String? _languageError, _skillError;
  String _vaccinationcertificate = 'null';
  String? _age;
  List<String> _tempSelectedSkill = [];
  List<String> _tempTechSkill = [];
  final List<String> _selectedSkills = [];
  List<String> _apifetchSkills = [];
  bool _isSummaryLoading = false, _isSummaryGenereted = false;
  final List<String> _selectedTechnicalSkill = [];

  List<String> get language => _language;
  List<String> get selectedLanguages => _selectedLanguage;
  bool get isLoadingLanguage => _isLoadingLanguages;
  String? get languageError => _languageError;
  bool get male => _male;
  bool get female => _female;
  bool get vaccinated => _vaccinated;
  String? get vaccinationCertificate => _vaccinationcertificate;
  bool get skillLoading => _skillsLoading;
  String? get skillError => _skillError;
  String? get age => _age;
  List<String> get selectedSkills => _selectedSkills;
  List<String> get tempSelectedSkills => _tempSelectedSkill;
  List<String> get apifetchSkills => _apifetchSkills;
  bool get isSummaryLoading => _isSummaryLoading;
  bool get isSummaryGenereted => _isSummaryGenereted;
  List<String> get selectedTechnicalSkills => _selectedTechnicalSkill;
  List<String> get tempSelectedTechnicalSkills => _tempTechSkill;

  Future<void> fetchSummaryUsingAi() async {
    if (_isSummaryLoading) return;
    _isSummaryLoading = true;
    notifyListeners();
    try {
      _profileSummaryModel =
          await ResumeService.generateSummaryUsingAi() ?? ProfileSummaryModel();
      if (_profileSummaryModel!.profileResponse != null) {
        summary.text = _profileSummaryModel!.profileResponse!;
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

  void clearSummary() {
    summary.clear();
    _isSummaryGenereted = false;
    notifyListeners();
  }

  void initializeController(String number) {
    contactno.text = number;
    fetchLanguages();
    notifyListeners();
    fetchSkills();
    if (_profile!.dob != null) {
      setage(AgeCalculator.calculateAge((_profile!.dob ?? ''))!);
    }
  }

  void clearskill() {
    _tempSelectedSkill.clear();
    notifyListeners();
  }

  void clearTechnicalSkill() {
    _tempTechSkill.clear();
    notifyListeners();
  }

  void assignSkillsToSelectedSkillList(List<String> skill) {
    _tempSelectedSkill = List<String>.from(skill);
    notifyListeners();
  }

  void assignTechnicalSkillsToSelectedSkillList(List<String> skill) {
    _tempTechSkill = List<String>.from(skill);
    notifyListeners();
  }

  void setage(String age) {
    _age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    _male = gender.toLowerCase() == 'male';
    _female = gender.toLowerCase() == 'female';
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

  void toggleSkill(String lang) {
    final normalized = lang.trim();
    if (_tempSelectedSkill.contains(normalized)) {
      _tempSelectedSkill.remove(normalized);
    } else {
      _tempSelectedSkill.add(normalized);
    }
    notifyListeners();
  }

  void toggleTechnicalSkill(String lang) {
    final normalized = lang.trim();
    if (_tempTechSkill.contains(normalized)) {
      _tempTechSkill.remove(normalized);
    } else {
      _tempTechSkill.add(normalized);
    }
    notifyListeners();
  }

  void setVaccination(bool value) {
    _vaccinated = value;
    if (!value) _vaccinationcertificate = 'null';
    notifyListeners();
  }

  void setVaccinationCertificate(String? certificate) {
    _vaccinationcertificate = certificate!;
    notifyListeners();
  }

  void assignDataFromModelToController() {
    if (_profile == null) return;

    firstname.text = _profile!.firstName ?? "";
    middlename.text = _profile!.middleName ?? "";
    lastname.text = _profile!.lastName ?? "";
    contactno.text = _profile!.mobile?.toString() ?? "";
    alternateno.text =
        _profile!.alternateNo != null && _profile!.alternateNo != 0
        ? _profile!.alternateNo?.toString() ?? ""
        : "";
    emailid.text = _profile!.gmail ?? "";
    dateofbirth.text =
        CvParseExpDateFormatter.formatDate(_profile!.dob, false) ?? "";
    location.text = _profile!.userLocation ?? "";
    locality.text = _profile!.userLocality ?? '';
    pincode.text = _profile!.pinCode ?? "";
    profileHeadline.text =
        (_profile!.profileHeadline != null &&
            _profile!.profileHeadline != 'null')
        ? _profile!.profileHeadline!
        : '';

    if (_profile!.gender != null) {
      setGender(_profile!.gender!);
    }

    _selectedLanguage.clear();
    if (_profile!.languagesKnown != null &&
        _profile!.languagesKnown!.isNotEmpty) {
      _selectedLanguage.addAll(_profile!.languagesKnown!);
    }

    _vaccinated = _profile!.vaccination ?? false;
    _vaccinationcertificate =
        _profile!.vaccinationCertificate != null &&
            _profile!.vaccinationCertificate != 'null'
        ? _profile!.vaccinationCertificate
        : 'null';
    profileRole.text = _profile!.profileRole ?? '';
    linkdinUrl.text = _profile!.linkdlnUrl ?? '';

    notifyListeners();
  }

  void updateProfileModelForBasicInfo() async {
    if (_profile == null) return;

    final updatedUserRequest = UserRequest(
      userId: _userid,
      firstName: firstname.text.isNotEmpty ? firstname.text : null,
      middleName: middlename.text.isNotEmpty ? middlename.text : null,
      lastName: lastname.text.isNotEmpty ? lastname.text : null,
      mobile: int.tryParse(contactno.text),
      alternateNo: int.tryParse(alternateno.text),
      userLocation: location.text.isNotEmpty ? location.text : null,
      userLocality: locality.text.isNotEmpty ? locality.text : null,
      pinCode: pincode.text.isNotEmpty ? pincode.text : null,
      email: emailid.text.isNotEmpty ? emailid.text : null,
      gender: _male
          ? 'Male'
          : _female
          ? 'Female'
          : null,
      dateOfBirth: dateofbirth.text.isNotEmpty
          ? CvParseDateToApiFormat.formatDate(dateofbirth.text)
          : null,
      languages: _selectedLanguage.isNotEmpty ? _selectedLanguage : null,
      vaccination: _vaccinated,
      vaccinationCertificate: _vaccinationcertificate,
      profileHeadline: profileHeadline.text.isNotEmpty
          ? profileHeadline.text
          : 'null',
      skills: _profile?.allSkills,
      linkdlnUrl: linkdinUrl.text.isNotEmpty ? linkdinUrl.text : null,
      profileRole: profileRole.text.isNotEmpty ? profileRole.text : null,
    );
    _createNewUserModel = CreateNewUserModel(
      userRequest: updatedUserRequest,
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
    );
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      CustomSnackbar.show("Awesome! Your profile is all updated 🚀", false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
  }

  void updateAndSaveSkills() async {
    if (_profile == null) return;

    final updatedUserRequest = UserRequest(
      userId: _userid,
      skills: _tempSelectedSkill,
      alternateNo: _profile!.alternateNo,
    );
    _createNewUserModel = CreateNewUserModel(
      userRequest: updatedUserRequest,
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
    );
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      clearBasicProfile();
      CustomSnackbar.show("⚡ Skill details updated. Great work!", false);
    } else {
      CustomSnackbar.show("Getting error while updating skills", true);
    }
    notifyListeners();
  }

  void updateAndSaveTechSkills() async {
    if (_profile == null) return;

    final updatedUserRequest = UserRequest(
      userId: _userid,
      technicalSkills: _tempTechSkill,
      alternateNo: _profile!.alternateNo,
    );
    _createNewUserModel = CreateNewUserModel(
      userRequest: updatedUserRequest,
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
    );
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      clearBasicProfile();
      CustomSnackbar.show(
        "⚡ Technical Skill details updated. Great work!",
        false,
      );
    } else {
      CustomSnackbar.show(
        "Getting error while updating technical skills",
        true,
      );
    }
    notifyListeners();
  }

  void clearBasicProfile() {
    firstname.clear();
    middlename.clear();
    lastname.clear();
    contactno.clear();
    alternateno.clear();
    emailid.clear();
    dateofbirth.clear();
    location.clear();
    locality.clear();
    pincode.clear();
    linkdinUrl.clear();
    profileRole.clear();
    profileHeadline.clear();
    _male = false;
    _female = false;
    _selectedLanguage.clear();
    _vaccinated = false;
    _vaccinationcertificate = 'null';
    _age = null;
    _tempSelectedSkill.clear();
    _selectedTechnicalSkill.clear();
    _selectedSkills.clear();
    _apifetchSkills.clear();
    _selectedSkills.clear();
    notifyListeners();
  }

  // Summary
  TextEditingController summary = TextEditingController();

  void assignSummaryToController() {
    if (_profile == null) return;
    summary.text = _profile!.bio != null && profile!.bio != 'null'
        ? _profile!.bio!
        : '';
    notifyListeners();
  }

  void updateProfileModelForSummary() async {
    if (_profile == null) return;

    final updatedUserRequest = UserRequest(
      skills: _profile!.allSkills,
      alternateNo: _profile!.alternateNo,
      userId: _userid,
      bio: summary.text.isNotEmpty ? summary.text : 'null',
    );
    _createNewUserModel = CreateNewUserModel(
      userRequest: updatedUserRequest,
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
    );
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      if (summary.text.isEmpty) {
        CustomSnackbar.show(
          "⚡ Summary deleted — you can add a new one anytime",
          false,
        );
      } else {
        CustomSnackbar.show("Profile Summary Updated Successfully", false);
      }
      fetchProfile();
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
  }

  // Experience
  TextEditingController jobrole = TextEditingController();
  TextEditingController companyname = TextEditingController();
  TextEditingController industry = TextEditingController();
  TextEditingController functionalArea = TextEditingController();
  TextEditingController anualSalary = TextEditingController();
  TextEditingController jobResponsibility = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController lastWorkingDate = TextEditingController();
  TextEditingController jobtitle = TextEditingController();

  FocusNode jobTitleFocusNode = FocusNode();
  FocusNode companyNameFocusNode = FocusNode();
  FocusNode industryFocusNode = FocusNode();
  FocusNode functionalAreaFocusNode = FocusNode();
  FocusNode jobRoleFocusNode = FocusNode();
  FocusNode salaryFocusNode = FocusNode();
  FocusNode startDateFocusNode = FocusNode();
  FocusNode lastDateFocusNode = FocusNode();
  //

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
  String? _offerLetter;
  String? _appointmentLetter;
  String? _salarySlip;
  String? _incrementLetter;
  String? _experienceLetter;
  int? _editingIndex;
  bool _showExperienceForm = false;
  bool _selfemployee = false;
  bool _isResponsebilityLoading = false;
  bool _isResponsebilityGenerated = false;

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
  int? get isEditExperienceIndex => _editingIndex;
  bool get showExperienceForm => _showExperienceForm;
  bool get isResponsibilityLoading => _isResponsebilityLoading;
  bool get isResponsibilityGenerated => _isResponsebilityGenerated;
  ResponsibilityAiModel? get responsibilityAiModel => _responsibilityAiModel;

  bool get selfemployee => _selfemployee;

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
        if (_responsibilityAiModel!.skills != null &&
            _responsibilityAiModel!.skills!.isNotEmpty) {
          _skills.addAll(List<String>.from(_responsibilityAiModel!.skills!));
        }
        _isResponsebilityGenerated = true;
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

  void clearResponsibility() {
    jobrole.clear();
    _isResponsebilityGenerated = false;
    notifyListeners();
  }

  void setShowExperienceForm(bool value) {
    _showExperienceForm = value;
    notifyListeners();
  }

  void setCurrentlyWorking(bool value) {
    _currentlyWorking = value;
    if (!value) lastWorkingDate.clear();
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

  void assignSkillsToExperience(List<String> skill) {
    _skills = List<String>.from(skill);
    notifyListeners();
  }

  void setEmpType(String input) {
    _fulltime = false;
    _partTime = false;
    _contractual = false;
    _freelancer = false;
    _internship = false;
    _selfemployee = false;

    switch (input.toLowerCase()) {
      case 'full time':
      case 'fulltime':
        _fulltime = true;
        break;
      case 'part time':
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
      case 'Self Employee':
        _selfemployee = true;
    }
    notifyListeners();
  }

  void addOrUpdateExperience() async {
    _isUpdating = true; // Lock UI
    notifyListeners();
    var snackMessage = '';
    final experience = ExperienceRequest(
      userId: _userid,
      jobTitle: jobtitle.text.isNotEmpty ? jobtitle.text : null,
      companyName: companyname.text.isNotEmpty ? companyname.text : null,
      industry: industry.text.isNotEmpty ? industry.text : null,
      functionalArea: functionalArea.text.isNotEmpty
          ? functionalArea.text
          : null,
      jobRole: jobrole.text.isNotEmpty
          ? addBulletPointBeforSaving.addBulletsToEachLine(jobrole.text)
          : null,
      joiningDate: startDate.text.isNotEmpty
          ? CvParseDateToApiFormat.formatDate(startDate.text)
          : null,
      lastWorkingDate: _currentlyWorking || lastWorkingDate.text.isEmpty
          ? null
          : CvParseDateToApiFormat.formatDate(lastWorkingDate.text),
      salary: anualSalary.text.isNotEmpty ? anualSalary.text : null,
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
          : _selfemployee
          ? 'Self Employee'
          : null,
      workType: _onsite
          ? "OnSite"
          : _hybrid
          ? "Hybrid"
          : _remote
          ? "Remote"
          : null,
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
      skillsExp: _skills.isNotEmpty ? List<String>.from(_skills) : null,
    );

    if (_editingIndex != null &&
        _editingIndex! >= 0 &&
        _editingIndex! < _experiencesModel.length) {
      _experiencesModel[_editingIndex!] = experience.copyWith(
        id: _experiencesModel[_editingIndex!].id,
      );
      snackMessage = 'Experience updated successfully.';
    } else {
      snackMessage = '🎉 Experience added successfully!';
      _experiencesModel.add(experience);
    }

    final formattedExperiences = _experiencesModel.map((exp) {
      return exp.copyWith(
        joiningDate: CvParseDateToApiFormat.formatDate(exp.joiningDate),
        lastWorkingDate:
            exp.lastWorkingDate != null && exp.lastWorkingDate != "N/A"
            ? CvParseDateToApiFormat.formatDate(exp.lastWorkingDate)
            : "",
      );
    }).toList();

    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(
        userId: _userid,
        profileHeadline: profileHeadline.text.isNotEmpty
            ? profileHeadline.text
            : 'null',
        alternateNo: _profile!.alternateNo,
      ),
      experienceRequest: formattedExperiences,
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
    );
    clearExperienceForm();
    _editingIndex = null;
    setShowExperienceForm(false);
    try {
      // ... your logic ...
      bool done = await UserServices.postUserInfo(_createNewUserModel!);
      if (done) {
        await fetchProfile(); // Wait for fresh data
        CustomSnackbar.show("Updated!", false);
      }
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        // This flag will hide the loader after 2 sec
        _isUpdating = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void editExperience(int index) {
    if (index < 0 || index >= _profile!.experiences!.length) return;

    final exp = _profile!.experiences![index];
    jobtitle.text = exp.jobTitle ?? '';
    companyname.text = exp.companyName ?? '';
    industry.text = exp.industry ?? '';
    functionalArea.text = exp.functionalArea ?? '';
    jobrole.text = exp.jobRole != null
        ? DataAssignToNextLine.formatWithBullets(exp.jobRole.toString())
        : '';
    startDate.text = exp.joiningDate != null && exp.joiningDate!.isNotEmpty
        ? CvParseExpDateFormatter.formatDate(exp.joiningDate, false)!
        : '';
    lastWorkingDate.text =
        exp.lastWorkingDate != null &&
            exp.lastWorkingDate!.isNotEmpty &&
            exp.lastWorkingDate != 'N/A'
        ? CvParseExpDateFormatter.formatDate(exp.lastWorkingDate, false)!
        : '';
    anualSalary.text = exp.salary ?? '';
    _currentlyWorking = exp.isCurrent == 1;
    _offerLetter = exp.offerletter;
    _appointmentLetter = exp.appointmentLetter;
    _salarySlip = exp.salarySlip;
    _incrementLetter = exp.increamentLetter;
    _experienceLetter = exp.expLetter;
    _skills = exp.skillsExp!.isNotEmpty ? exp.skillsExp! : [];

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
    _experiencesModel[index] = ExperienceRequest(
      id: exp.id,
      userId: _userid,
      jobTitle: exp.jobTitle,
      companyName: exp.companyName,
      companyId: exp.companyId,
      jobRole: exp.jobRole,
      workType: exp.workType,
      salary: exp.salary,
      joiningDate: exp.joiningDate,
      lastWorkingDate: exp.lastWorkingDate,
      empType: exp.empType,
      isCurrent: exp.isCurrent,
      jobLocation: exp.jobLocation,
      offerLetter: exp.offerletter,
      experienceLettter: exp.expLetter,
      incrementLetter: exp.increamentLetter,
      appointmentLetter: exp.appointmentLetter,
      salarySlip: exp.salarySlip,
      industry: exp.industry,
      functionalArea: exp.functionalArea,
      skillsExp: exp.skillsExp,
    );

    setShowExperienceForm(true);
    notifyListeners();
  }

  void removeExperience(int index) async {
    int expId = _experiencesModel[index].id!;
    bool done = await UserServices.DeleteExpEduCertProj(expId, 'experience');
    if (done) {
      fetchProfile();
      CustomSnackbar.show("Data Updated Successfully", false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
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
    _skills.clear();
    _selfemployee = false;
    clearResponsibility();
    notifyListeners();
  }

  // Education
  TextEditingController schoolCollegeName = TextEditingController();
  TextEditingController universityBoardName = TextEditingController();
  TextEditingController degree = TextEditingController();
  TextEditingController fieldOfStudy = TextEditingController();
  TextEditingController startmonth = TextEditingController();
  TextEditingController startyear = TextEditingController();
  TextEditingController endmonth = TextEditingController();
  TextEditingController endyear = TextEditingController();
  //
  FocusNode schoolCollegeNameFocusNode = FocusNode();
  FocusNode universityBoardNameFocusNode = FocusNode();
  FocusNode degreeFocusNode = FocusNode();
  FocusNode fieldOfStudyFocusNode = FocusNode();
  //
  String? _markSheet;
  bool _currentlyStudying = false;
  bool _degreeCertificate = false;
  bool _allEducationDocs = false;
  final List<EducationRequest> _educationModel = [];
  bool _showEducationForm = false;
  int? _editingEducationIndex;
  int? _editingEducationId;
  bool _isRemote = false;
  bool _fullTimeCourse = false,
      _partTimeCourse = false,
      _distanceLearning = false;

  bool get currentlyStudying => _currentlyStudying;
  String? get markSheet => _markSheet;
  List<EducationRequest> get educationModel => _educationModel;
  bool get isEducationRemote => _isRemote;
  bool get degreeCertificateUploaded => _degreeCertificate;
  bool get allEducationDocsUploaded => _allEducationDocs;
  bool get isEditingEducation => _editingEducationIndex != null;
  int? get isEditEducationIndex => _editingEducationIndex;
  int? get editingEducationId => _editingEducationId;
  bool get isRemote => _isRemote;
  bool get showEducationForm => _showEducationForm;
  bool get fullTimeCourse => _fullTimeCourse;
  bool get partTimeCourse => _partTimeCourse;
  bool get distanceLearning => _distanceLearning;

  void setShowEducationForm(bool value) {
    _showEducationForm = value;
    notifyListeners();
  }

  void setCurrentlyStudying(bool value) {
    _currentlyStudying = value;
    if (!value) {
      endmonth.clear();
      endyear.clear();
    }
    notifyListeners();
  }

  void setMarkSheet(String value) {
    _markSheet = value;
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

  void setCourseType(String input) {
    _fullTimeCourse = false;
    _partTimeCourse = false;
    _distanceLearning = false;

    switch (input.toLowerCase()) {
      case 'fulltime':
        _fullTimeCourse = true;
        break;
      case 'parttime':
        _partTimeCourse = true;
        break;
      case 'distance learning':
        _distanceLearning = true;
        break;
    }
    notifyListeners();
  }

  void addOrUpdateEducation() async {
    // 1. Prevent Double Clicks / Race Conditions
    if (_isUpdating) return;

    _isUpdating = true;
    notifyListeners();

    var snackMessage = '';

    // Month Mapping
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

    // 2. Create Request Object
    final education = EducationRequest(
      userId: _userid,
      schoolOrCollegeName: schoolCollegeName.text.isNotEmpty
          ? schoolCollegeName.text
          : null,
      isRemote: _isRemote ? 1 : 0,
      university: universityBoardName.text.isNotEmpty
          ? universityBoardName.text
          : null,
      degreeSpc: degree.text.isNotEmpty ? degree.text : null,
      fieldOfStudy: fieldOfStudy.text.isNotEmpty ? fieldOfStudy.text : null,
      firstYear: int.tryParse(startyear.text.trim()),
      startMonth: startMonthInt,
      passingYear: _currentlyStudying
          ? null
          : int.tryParse(endyear.text.trim()),
      endMonth: _currentlyStudying ? null : endMonthInt,
      isCurrent: _currentlyStudying ? 1 : 0,
      marksheet: _markSheet,
      courseType: _fullTimeCourse
          ? "Fulltime"
          : _partTimeCourse
          ? "Parttime"
          : _distanceLearning
          ? "Distance Learning"
          : null,
    );

    // 3. Logic: Match by ID if editing, else Add new
    // We check if we are editing an existing ID
    bool isEditing = _editingEducationId != null;

    // Attempt to find the index of the item with this ID in the model
    int foundIndex = -1;
    if (isEditing) {
      foundIndex = _educationModel.indexWhere(
        (element) => element.id == _editingEducationId,
      );
    }

    if (isEditing && foundIndex != -1) {
      // UPDATE: We found the correct item by ID. Update it safely.
      _educationModel[foundIndex] = education.copyWith(
        id: _editingEducationId, // Preserve the ID
      );
      snackMessage = '🌟 Education details updated. Great going!';
    } else {
      // ADD: No ID, or ID not found. Treat as new.
      _educationModel.add(education);
      snackMessage = '✅ Nice! Your education profile just got stronger.';
    }

    // 4. Prepare Payload
    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(
        userId: _userid,
        alternateNo: _profile!.alternateNo,
      ),
      experienceRequest: [],
      educationRequest: _educationModel, // Sending the updated list
      certificationsRequest: [],
      userProjectRequest: [],
    );

    // 5. Cleanup UI immediately
    clearEducationForm();
    setShowEducationForm(false);

    // 6. API Call
    try {
      bool done = await UserServices.postUserInfo(_createNewUserModel!);
      if (done) {
        await fetchProfile(); // Wait for fresh data from backend
        CustomSnackbar.show(snackMessage, false);
      } else {
        CustomSnackbar.show("Failed to update education.", true);
      }
    } catch (e) {
      CustomSnackbar.show("Error: $e", true);
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        // This flag will hide the loader after 2 sec
        _isUpdating = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void editEducation(int originalIndex) {
    // Safety check
    if (originalIndex < 0 ||
        originalIndex >= _profile!.educationDetails!.length) {
      return;
    }

    final edu = _profile!.educationDetails![originalIndex];

    // Populate UI Controllers
    schoolCollegeName.text = edu.schoolOrCollegeName ?? '';
    _isRemote = edu.isRemote == 1;
    universityBoardName.text = edu.university ?? '';
    degree.text = edu.degreeSpc ?? '';
    fieldOfStudy.text = edu.fieldOfStudy ?? '';
    startmonth.text = _monthIntToName(edu.startMonth);
    startyear.text = edu.firstYear?.toString() ?? '';
    endmonth.text = _monthIntToName(edu.endMonth);
    endyear.text = edu.passingYear?.toString() ?? '';
    _currentlyStudying = edu.isCurrent == 1;
    _markSheet = edu.marksheet;
    _fullTimeCourse = edu.courseType == "Fulltime";
    _partTimeCourse = edu.courseType == "Parttime";
    _distanceLearning = edu.courseType == "Distance Learning";
    // CRITICAL FIX: Track the ID, not just the index
    _editingEducationId = edu.id;
    _editingEducationIndex =
        originalIndex; // Keep this for UI "Delete" button visibility if needed

    // Optional: Sync the specific model item to ensure clean state before edit
    // We find the item in _educationModel that matches this ID
    int modelIndex = _educationModel.indexWhere((e) => e.id == edu.id);
    if (modelIndex != -1) {
      _educationModel[modelIndex] = EducationRequest(
        id: edu.id,
        userId: _userid,
        schoolOrCollegeName: edu.schoolOrCollegeName,
        isRemote: edu.isRemote,
        university: edu.university,
        degreeSpc: edu.degreeSpc,
        fieldOfStudy: edu.fieldOfStudy,
        firstYear: edu.firstYear,
        startMonth: _monthNameToInt(edu.startMonth),
        passingYear: edu.passingYear,
        endMonth: _monthNameToInt(edu.endMonth),
        isCurrent: edu.isCurrent,
        marksheet: edu.marksheet,
        courseType: edu.courseType,
      );
    }

    setShowEducationForm(true);
    notifyListeners();
  }

  void removeEducation(int index) async {
    int eduId = _educationModel[index].id!;
    bool done = await UserServices.DeleteExpEduCertProj(eduId, 'education');
    if (done) {
      fetchProfile();
      CustomSnackbar.show("Data Updated Successfully", false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
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
    fieldOfStudy.clear();
    startmonth.clear();
    startyear.clear();
    endyear.clear();
    endmonth.clear();
    _currentlyStudying = false;
    _markSheet = null;
    _degreeCertificate = false;
    _allEducationDocs = false;
    _isRemote = false;
    _fullTimeCourse = false;
    _partTimeCourse = false;
    _distanceLearning = false;
    // Reset editing trackers
    _editingEducationIndex = null;
    _editingEducationId = null; // Important!

    notifyListeners();
  }

  // Certificate
  TextEditingController certificateName = TextEditingController();
  TextEditingController organizationName = TextEditingController();
  TextEditingController credentialId = TextEditingController();
  TextEditingController credentialUrl = TextEditingController();
  TextEditingController issuemonth = TextEditingController();
  TextEditingController issueyear = TextEditingController();
  TextEditingController validmonth = TextEditingController();
  TextEditingController validyear = TextEditingController();
  //
  FocusNode certificateNameFocusNode = FocusNode();
  FocusNode organizationNameFocusNode = FocusNode();
  //
  String? _certificate;
  bool _certificateNoExpiration = false;
  bool _certificateDocument = false;
  bool _allCertificateDocs = false;
  final List<CertificationRequest> _certificateModel = [];
  bool _showCertificateForm = false;
  int? _editingCertificateIndex;
  bool _certDontHaveExpiry = false;

  String? get certificateFile => _certificate;
  List<CertificationRequest> get certificateModel => _certificateModel;
  bool get certificateNoExpiration => _certificateNoExpiration;
  bool get certificateDocumentUploaded => _certificateDocument;
  bool get allCertificateDocsUploaded => _allCertificateDocs;
  bool get isEditingCertificate => _editingCertificateIndex != null;
  int? get isEditCertificateIndex => _editingCertificateIndex;
  bool get showCertificateForm => _showCertificateForm;
  bool get certDontHaveExpiry => _certDontHaveExpiry;

  int? _editingCertificateId;

  void setShowCertificateForm(bool value) {
    _showCertificateForm = value;
    notifyListeners();
  }

  void setCertificateDontHaveExpiry(bool value) {
    _certDontHaveExpiry = value;
    if (value) {
      validmonth.clear();
      validyear.clear();
    }
    notifyListeners();
  }

  void setCertificateDocument(String value) {
    _certificate = value;
    notifyListeners();
  }

  void setCertificateDocumentUploaded(bool value) {
    _certificateDocument = value;
    _allCertificateDocs = false;
    notifyListeners();
  }

  void setAllCertificateDocs(bool value) {
    _allCertificateDocs = value;
    _certificateDocument = false;
    notifyListeners();
  }

  void addOrUpdateCertificate() async {
    // 1. Prevent Double Clicks / Race Conditions
    if (_isUpdating) return;

    _isUpdating = true; // Lock UI
    notifyListeners();

    var snackMessage = '';

    // 2. Create Request Object
    final certificate = CertificationRequest(
      userId: _userid,
      certificationName: certificateName.text.isNotEmpty
          ? certificateName.text
          : null,
      issuingOrganization: organizationName.text.isNotEmpty
          ? organizationName.text
          : null,
      credentialId: credentialId.text.isNotEmpty ? credentialId.text : null,
      credentialUrl: credentialUrl.text.isNotEmpty ? credentialUrl.text : null,
      startMonth: issuemonth.text.isNotEmpty ? issuemonth.text : null,
      startYear: int.tryParse(issueyear.text),
      endMonth: _certificateNoExpiration
          ? null
          : validmonth.text.isNotEmpty
          ? validmonth.text
          : null,
      endYear: _certificateNoExpiration ? null : int.tryParse(validyear.text),
      certificate: _certificate,
      isLifetime: _certDontHaveExpiry ? true : false,
    );

    // 3. Logic: Match by ID if editing, else Add new
    bool isEditing = _editingCertificateId != null;

    // Attempt to find the index of the item with this ID in the model
    int foundIndex = -1;
    if (isEditing) {
      foundIndex = _certificateModel.indexWhere(
        (element) => element.id == _editingCertificateId,
      );
    }

    if (isEditing && foundIndex != -1) {
      // UPDATE: We found the correct item by ID. Update it safely.
      _certificateModel[foundIndex] = certificate.copyWith(
        id: _editingCertificateId, // Preserve the ID
      );
      snackMessage = '🌟 Certificate updated successfully.';
    } else {
      // ADD: No ID, or ID not found. Treat as new.
      _certificateModel.add(certificate);
      snackMessage = '🎉 Certificate added successfully!';
    }

    // 4. Prepare Payload
    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(
        userId: _userid,
        alternateNo: _profile!.alternateNo,
      ),
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: _certificateModel, // Sending the updated list
      userProjectRequest: [],
    );

    // 5. Cleanup UI immediately
    clearCertificateForm();
    setShowCertificateForm(false);

    // 6. API Call
    try {
      bool done = await UserServices.postUserInfo(_createNewUserModel!);
      if (done) {
        await fetchProfile(); // Wait for fresh data from backend
        CustomSnackbar.show(snackMessage, false);
      } else {
        CustomSnackbar.show("Failed to update certificate.", true);
      }
    } catch (e) {
      CustomSnackbar.show("Error: $e", true);
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        // This flag will hide the loader after 2 sec
        _isUpdating = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void editCertificate(int originalIndex) {
    // Safety check: Use index directly from profile list
    if (originalIndex < 0 ||
        originalIndex >= _profile!.certifications!.length) {
      debugPrint('Invalid certificate index $originalIndex');
      return;
    }

    final cert = _profile!.certifications![originalIndex];

    // Populate form fields
    certificateName.text = cert.certificationName ?? '';
    organizationName.text = cert.issuingOrganization ?? '';
    credentialId.text = cert.credentialId ?? '';
    credentialUrl.text = cert.credentialUrl ?? '';
    issuemonth.text = cert.startMonth ?? '';
    issueyear.text = cert.startYear?.toString() ?? '';
    validmonth.text = cert.endMonth ?? '';
    validyear.text = cert.endYear?.toString() ?? '';
    _certificate = cert.certificate;
    _certificateNoExpiration = cert.endYear == null && cert.endMonth == null;
    _certDontHaveExpiry = cert.isLifetime ?? false;
    // CRITICAL FIX: Track the ID
    _editingCertificateId = cert.id;
    _editingCertificateIndex = originalIndex; // Keep for UI references

    // Optional: Sync the specific model item to ensure clean state before edit
    int modelIndex = _certificateModel.indexWhere((c) => c.id == cert.id);
    if (modelIndex != -1) {
      _certificateModel[modelIndex] = CertificationRequest(
        id: cert.id,
        userId: _userid,
        certificationName: cert.certificationName,
        issuingOrganization: cert.issuingOrganization,
        credentialId: cert.credentialId,
        credentialUrl: cert.credentialUrl,
        startMonth: cert.startMonth,
        startYear: cert.startYear,
        endMonth: cert.endMonth,
        endYear: cert.endYear,
        certificate: cert.certificate,
        isLifetime: cert.isLifetime ?? false,
        issueDate: cert.issueDate,
        expirationDate: cert.expirationDate,
      );
    }

    setShowCertificateForm(true);
    notifyListeners();
  }

  void removeCertificate(int index) async {
    int certId = _certificateModel[index].id!;
    bool done = await UserServices.DeleteExpEduCertProj(certId, 'certificate');
    if (done) {
      fetchProfile();
      CustomSnackbar.show("Data Updated Successfully", false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
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
    _editingCertificateIndex = null;
    _editingCertificateId = null;
    _certDontHaveExpiry = false;
    notifyListeners();
  }

  //
  //
  //
  //
  // Projects
  TextEditingController project_title = TextEditingController();
  TextEditingController project_description = TextEditingController();
  TextEditingController project_role = TextEditingController();
  TextEditingController project_url = TextEditingController();
  TextEditingController proj_startMonth = TextEditingController();
  TextEditingController proj_startYear = TextEditingController();
  TextEditingController proj_endMonth = TextEditingController();
  TextEditingController proj_endYear = TextEditingController();
  TextEditingController proj_skillController = TextEditingController();
  String? _project_duration;
  List<String> _project_technology_used = [];
  List<String> _project_it_skills = [];
  bool _showProjectForm = false;
  int? _editProjectIndex;
  final List<UserProjectRequest> _projectModel = [];

  String? get projectDuration => _project_duration;
  List<String> get projectTechnologyUsed => _project_technology_used;
  List<String> get projectItSkills => _project_it_skills;
  bool get showProjectForm => _showProjectForm;
  int? get editProjectIndex => _editProjectIndex;
  List<UserProjectRequest> get projectModel => _projectModel;
  bool get isEditProject => _editProjectIndex != null;
  int? get isEditProjectIndex => _editProjectIndex;
  bool get hasProjectData =>
      project_title.text.isNotEmpty || project_description.text.isNotEmpty;

  void setupProjectListeners() {
    project_title.addListener(() {
      notifyListeners();
    });

    project_description.addListener(() {
      notifyListeners();
    });
  }

  void setShowProjectForm(bool value) {
    _showProjectForm = value;
    notifyListeners();
  }

  void assignSkillsToProjects(List<String> skill) {
    _project_it_skills = List<String>.from(skill);
    notifyListeners();
  }

  void setProjectNoDuration(bool value) {
    _certificateNoExpiration = value;
    if (value) {
      proj_startMonth.clear();
      startyear.clear();
      proj_endMonth.clear();
      proj_endYear.clear();
    }
    notifyListeners();
  }

  void addUpdateProjects() async {
    _isUpdating = true; // Lock UI
    notifyListeners();
    var snackMessage = '';
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
      description: project_description.text,
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

    bool isProjEditing =
        _editProjectIndex != null &&
        _editProjectIndex! >= 0 &&
        _editProjectIndex! < _projectModel.length &&
        _projectModel[_editProjectIndex!].id != null;

    if (isProjEditing) {
      _projectModel[_editProjectIndex!] = project.copyWith(
        id: _projectModel[_editProjectIndex!].id,
      );
      snackMessage = '✨ Project updated successfully!';
    } else {
      _projectModel.add(project);
      snackMessage = '🚀 Project added successfully!';
    }

    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(
        userId: _userid,
        alternateNo: _profile!.alternateNo,
      ),
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: _projectModel,
    );

    clearProjectForm();
    _editProjectIndex = null;
    setShowProjectForm(false);
    try {
      bool done = await UserServices.postUserInfo(_createNewUserModel!);
      if (done) {
        await fetchProfile(); // Wait for fresh data
        CustomSnackbar.show(snackMessage, false);
      }
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        // This flag will hide the loader after 2 sec
        _isUpdating = false;
        notifyListeners();
      });
      notifyListeners();
    }
    notifyListeners();
  }

  void editProject(int originalIndex) {
    // FIX: Use index directly instead of ID
    if (originalIndex < 0 || originalIndex >= _profile!.projects!.length) {
      debugPrint('Invalid project index $originalIndex');
      return;
    }

    final proj = _profile!.projects![originalIndex];

    // Populate form fields
    project_title.text = proj.projectTitle ?? '';
    project_description.text = proj.description ?? '';
    project_role.text = proj.role ?? '';
    project_url.text = (proj.url != null && proj.url!.isNotEmpty)
        ? proj.url!.join(', ')
        : '';

    if (proj.duration != null) {
      parseAndAssignProjectDuration(proj.duration!);
    }

    _project_technology_used = proj.technologiesUsed ?? [];
    _project_it_skills =
        proj.itSkillsByProject != null && proj.itSkillsByProject!.isNotEmpty
        ? proj.itSkillsByProject!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : [];

    // Set editing index to originalIndex
    _editProjectIndex = originalIndex;

    // Update _projectModel at originalIndex
    _projectModel[originalIndex] = UserProjectRequest(
      id: proj.id,
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

  void removeProjects(int index) async {
    int projId = _projectModel[index].id!;
    bool done = await UserServices.DeleteExpEduCertProj(projId, 'project');
    if (done) {
      fetchProfile();
      CustomSnackbar.show("Data Updated Successfully", false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    if (_projectModel.isEmpty) {
      setShowProjectForm(true);
    }
    notifyListeners();
  }

  void cancelProjectEdit() {
    clearProjectForm();
    _editProjectIndex = null;
    if (_projectModel.isNotEmpty) {
      setShowProjectForm(false);
    }
    notifyListeners();
  }

  void clearProjectForm() {
    project_title.clear();
    project_description.clear();
    project_role.clear();
    project_url.clear();
    proj_startMonth.clear();
    proj_startYear.clear();
    proj_endMonth.clear();
    proj_endYear.clear();
    proj_skillController.clear();
    _project_duration = null;
    _project_technology_used.clear();
    _project_it_skills.clear();
    _editProjectIndex = null;
    notifyListeners();
  }
  //
  //
  //
  //

  // Fetch and Update Functions
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

  Future<void> fetchProfile() async {
    if (_isFetching) return;
    _isFetching = true;
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await UserServices.getUserDetailById();
      if (_profile != null) {
        assignDataFromModelToController();
        assignSummaryToController();
        _experiencesModel.clear();
        if (_profile!.experiences != null) {
          _experiencesModel.addAll(
            _profile!.experiences!.map(
              (exp) => ExperienceRequest(
                id: exp.id,
                userId: _userid,
                jobTitle: exp.jobTitle,
                companyName: exp.companyName,
                companyId: exp.companyId,
                jobRole: exp.jobRole,
                workType: exp.workType,
                salary: exp.salary,
                joiningDate: CvParseExpDateFormatter.formatDate(
                  exp.joiningDate,
                  false,
                ),
                lastWorkingDate: CvParseExpDateFormatter.formatDate(
                  exp.lastWorkingDate,
                  false,
                ),
                empType: exp.empType,
                isCurrent: exp.isCurrent,
                jobLocation: exp.jobLocation,
                offerLetter: exp.offerletter,
                experienceLettter: exp.expLetter,
                incrementLetter: exp.increamentLetter,
                appointmentLetter: exp.appointmentLetter,
                salarySlip: exp.salarySlip,
                industry: exp.industry,
                functionalArea: exp.functionalArea,
                skillsExp: exp.skillsExp,
              ),
            ),
          );
        }
        _educationModel.clear();
        if (_profile!.educationDetails != null) {
          _educationModel.addAll(
            _profile!.educationDetails!.map((edu) {
              return EducationRequest(
                id: edu.id,
                userId: _userid,
                schoolOrCollegeName: edu.schoolOrCollegeName,
                isRemote: edu.isRemote,
                university: edu.university,
                degreeSpc: edu.degreeSpc,
                fieldOfStudy: edu.fieldOfStudy,
                firstYear: edu.firstYear,
                // Use helper to convert month representations (string/int) to int
                startMonth: _monthNameToInt(edu.startMonth),
                passingYear: edu.passingYear,
                endMonth: _monthNameToInt(edu.endMonth),
                isCurrent: edu.isCurrent,
                marksheet: edu.marksheet,
              );
            }),
          );
        }
        _certificateModel.clear();
        if (_profile!.certifications != null) {
          _certificateModel.addAll(
            _profile!.certifications!.map(
              (cert) => CertificationRequest(
                id: cert.id,
                userId: _userid,
                certificationName: cert.certificationName,
                issuingOrganization: cert.issuingOrganization,
                credentialId: cert.credentialId,
                credentialUrl: cert.credentialUrl,
                startMonth: cert.startMonth,
                startYear: cert.startYear,
                endMonth: cert.endMonth,
                endYear: cert.endYear,
                certificate: cert.certificate,
                issueDate: cert.issueDate,
                expirationDate: cert.expirationDate,
              ),
            ),
          );
        }
        _projectModel.clear();
        if (_profile!.projects != null) {
          _projectModel.addAll(
            _profile!.projects!.map(
              (proj) => UserProjectRequest(
                id: proj.id,
                projectTitle: proj.projectTitle,
                description: proj.description,
                duration: proj.duration,
                itSkillsByProject: proj.itSkillsByProject,
                role: proj.role,
                technologiesUsed: proj.technologiesUsed,
                url: proj.url,
              ),
            ),
          );
        }
        _awardsAchievementsModel.clear();
        if (_profile!.awardsAndAchievements != null) {
          _awardsAchievementsModel.addAll(
            _profile!.awardsAndAchievements!.map(
              (award) => AwardsAndAchievementsModel(
                id: award.id,
                title: award.title,
                description: award.description,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      _isFetching = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateResume(
    ProfileModel currentProfile,
    String? newResume,
  ) async {
    if (_isUpdating) return;
    _isUpdating = true;
    notifyListeners();

    try {
      if (currentProfile.resume != null &&
          currentProfile.resume != " " &&
          currentProfile.resume != 'null' &&
          newResume != null) {
        await FileUploadService().deleteSingleFile(currentProfile.resume!);
      }

      _createNewUserModel = CreateNewUserModel(
        userRequest: UserRequest(
          alternateNo: currentProfile.alternateNo,
          userId: currentProfile.id,
          skills: currentProfile.allSkills,
          cvLink: newResume ?? " ",
        ),
        experienceRequest: [],
        educationRequest: [],
        certificationsRequest: [],
        userProjectRequest: [],
      );

      await UserServices.postUserInfo(_createNewUserModel!);
      await fetchProfile();
    } catch (e) {
      debugPrint('Error updating resume: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePic(
    ProfileModel currentProfile,
    String? newProfilePic,
  ) async {
    if (_isUpdating) return;
    _isUpdating = true;
    notifyListeners();

    try {
      if (currentProfile.profilePic != null &&
          currentProfile.profilePic != " " &&
          newProfilePic != null) {
        await FileUploadService().deleteSingleFile(currentProfile.profilePic!);
      }

      _createNewUserModel = CreateNewUserModel(
        userRequest: UserRequest(
          alternateNo: currentProfile.alternateNo,
          userId: currentProfile.id,
          profilePic: newProfilePic ?? " ",
          skills: currentProfile.allSkills,
        ),
        experienceRequest: [],
        educationRequest: [],
        certificationsRequest: [],
        userProjectRequest: [],
      );

      await UserServices.postUserInfo(_createNewUserModel!);
      await fetchProfile();
    } catch (e) {
      debugPrint('Error updating profile pic: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfilePic(ProfileModel currentProfile) async {
    if (_isUpdating) return;
    _isUpdating = true;
    notifyListeners();

    try {
      if (currentProfile.profilePic != null &&
          currentProfile.profilePic != " ") {
        await FileUploadService().deleteSingleFile(currentProfile.profilePic!);
      }

      _createNewUserModel = CreateNewUserModel(
        userRequest: UserRequest(
          alternateNo: currentProfile.alternateNo,
          userId: currentProfile.id,
          skills: currentProfile.allSkills,
          profilePic: "null",
        ),
        experienceRequest: [],
        educationRequest: [],
        certificationsRequest: [],
        userProjectRequest: [],
      );

      await UserServices.postUserInfo(_createNewUserModel!);
      await fetchProfile();
    } catch (e) {
      debugPrint('Error deleting profile pic: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Clear and Dispose
  void clearAllProfileData() {
    clearBasicProfile();
    clearSummary();
    clearExperienceForm();
    clearProjectForm();
    _experiencesModel.clear();
    _editingIndex = null;
    _showExperienceForm = false;
    clearEducationForm();
    _educationModel.clear();
    _editingEducationIndex = null;
    _showEducationForm = false;
    clearCertificateForm();
    _certificateModel.clear();
    _editingCertificateIndex = null;
    _showCertificateForm = false;
    _profile = null;
    _createNewUserModel = null;
    technicalSkillController.clear();
    clearAwardForm();
    _awardsAchievementsModel.clear();
    _editingAwardIndex = null;
    _showAwardForm = false;
    notifyListeners();
  }

  @override
  void dispose() {
    firstname.dispose();
    middlename.dispose();
    lastname.dispose();
    contactno.dispose();
    alternateno.dispose();
    emailid.dispose();
    dateofbirth.dispose();
    location.dispose();
    locality.dispose();
    pincode.dispose();
    profileHeadline.dispose();
    summary.dispose();
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
    fieldOfStudy.dispose();
    startmonth.dispose();
    startyear.dispose();
    endyear.dispose();
    endmonth.dispose();
    certificateName.dispose();
    organizationName.dispose();
    credentialId.dispose();
    credentialUrl.dispose();
    issuemonth.dispose();
    linkdinUrl.dispose();
    profileRole.dispose();
    issueyear.dispose();
    validmonth.dispose();
    validyear.dispose();
    project_title.dispose();
    project_description.dispose();
    project_role.dispose();
    project_url.dispose();
    proj_skillController.dispose();
    proj_startMonth.dispose();
    proj_startYear.dispose();
    proj_endMonth.dispose();
    proj_endYear.dispose();
    project_title.removeListener(() {});
    project_description.removeListener(() {});
    skillController.dispose();
    technicalSkillController.dispose();
    awardTitleController.dispose();
    awardDescriptionController.dispose();
    super.dispose();
  }

  // Helper for month mapping
  Map<String, int> get monthMap => {
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

  // Convert various month formats (int, numeric string, month name) to int (1-12)
  int? _monthNameToInt(dynamic m) {
    if (m == null) return null;
    if (m is int) return m;
    if (m is String) {
      final s = m.trim();
      if (s.isEmpty) return null;
      final parsed = int.tryParse(s);
      if (parsed != null) return parsed;
      final map = {
        "january": 1,
        "february": 2,
        "march": 3,
        "april": 4,
        "may": 5,
        "june": 6,
        "july": 7,
        "august": 8,
        "september": 9,
        "october": 10,
        "november": 11,
        "december": 12,
      };
      return map[s.toLowerCase()];
    }
    return null;
  }

  // Convert month int to standard month name for display ('' when null)
  String _monthIntToName(dynamic m) {
    final i = _monthNameToInt(m);
    if (i == null) return '';
    const names = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };
    return names[i] ?? '';
  }
}
