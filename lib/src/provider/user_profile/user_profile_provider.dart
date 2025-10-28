// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:flutter/widgets.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_responsibility_model.dart';
import 'package:job_circle/src/model/location_model.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/services/file_upload_service.dart';
import 'package:job_circle/src/services/login_and_signup_services/resume_service.dart';
import 'package:job_circle/src/services/master_data/master_data_service.dart';
import 'package:job_circle/src/services/user_services/user_services.dart';
import 'package:job_circle/src/utils/add_bullet_point.dart';
import 'package:job_circle/src/utils/age_calculater.dart';
import 'package:job_circle/src/utils/date_formater.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class ProfileProvider with ChangeNotifier {
  final _userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
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
  final List<String> _selectedSkills = [];
  List<String> _apifetchSkills = [];
  bool _isSummaryLoading = false, _isSummaryGenereted = false;

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

  void assignSkillsToSelectedSkillList(List<String> skill) {
    _tempSelectedSkill = List<String>.from(skill);
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
    profileHeadline.clear();
    _male = false;
    _female = false;
    _selectedLanguage.clear();
    _vaccinated = false;
    _vaccinationcertificate = 'null';
    _age = null;
    _tempSelectedSkill.clear();
    _selectedSkills.clear();
    _apifetchSkills.clear();
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
            industry: '',
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
      ),
      experienceRequest: formattedExperiences,
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: [],
    );
    clearExperienceForm();
    _editingIndex = null;
    setShowExperienceForm(false);
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      CustomSnackbar.show(snackMessage, false);
      snackMessage = '';
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
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
  String? _markSheet;
  bool _currentlyStudying = false;
  bool _degreeCertificate = false;
  bool _allEducationDocs = false;
  final List<EducationRequest> _educationModel = [];
  bool _showEducationForm = false;
  int? _editingEducationIndex;
  bool _isRemote = false;

  bool get currentlyStudying => _currentlyStudying;
  String? get markSheet => _markSheet;
  List<EducationRequest> get educationModel => _educationModel;
  bool get isEducationRemote => _isRemote;
  bool get degreeCertificateUploaded => _degreeCertificate;
  bool get allEducationDocsUploaded => _allEducationDocs;
  bool get isEditingEducation => _editingEducationIndex != null;
  int? get isEditEducationIndex => _editingEducationIndex;
  bool get isRemote => _isRemote;
  bool get showEducationForm => _showEducationForm;

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

  /* void addOrUpdateEducation() async {
    var snackMessage = '';
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
    );

    if (_editingEducationIndex != null &&
        _editingEducationIndex! >= 0 &&
        _editingEducationIndex! < _educationModel.length) {
      _educationModel[_editingEducationIndex!] = education.copyWith(
        id: _educationModel[_editingEducationIndex!].id,
      );
      snackMessage = '🌟 Education details updated. Great going!';
    } else {
      _educationModel.add(education);
      snackMessage = '✅ Nice! Your education profile just got stronger.';
    }

    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(userId: _userid),
      experienceRequest: [],
      educationRequest: _educationModel,
      certificationsRequest: [],
      userProjectRequest: [],
    );

    clearEducationForm();
    _editingEducationIndex = null;
    setShowEducationForm(false);
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      CustomSnackbar.show(snackMessage, false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
  } */

  // FIX: Enhanced addOrUpdateEducation with explicit null check and debug
  void addOrUpdateEducation() async {
    var snackMessage = '';
    Map<String, int> monthMap = {
      // FIX: Local for consistency
      "January": 1, "February": 2, "March": 3, "April": 4, "May": 5, "June": 6,
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
    );

    bool isEditing =
        _editingEducationIndex != null &&
        _editingEducationIndex! >= 0 &&
        _editingEducationIndex! < _educationModel.length;
    if (isEditing) {
      _educationModel[_editingEducationIndex!] = education.copyWith(
        id: _educationModel[_editingEducationIndex!].id,
      );
      snackMessage = '🌟 Education details updated. Great going!';
      debugPrint(
        'FIX: Updating education at index $_editingEducationIndex',
      ); // FIX: Debug
    } else {
      _educationModel.add(education);
      snackMessage = '✅ Nice! Your education profile just got stronger.';
      debugPrint('FIX: Adding new education'); // FIX: Debug
    }

    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(userId: _userid),
      experienceRequest: [],
      educationRequest: _educationModel,
      certificationsRequest: [],
      userProjectRequest: [],
    );

    clearEducationForm(); // FIX: Calls updated clear which resets index
    _editingEducationIndex = null; // FIX: Double-reset for safety
    setShowEducationForm(false);
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      await fetchProfile(); // FIX: Await to ensure fresh data
      CustomSnackbar.show(snackMessage, false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
  }

  // FIX: Enhanced editEducation with better bounds check and debug (remove debugPrint in prod)
  void editEducation(int originalIndex) {
    // FIX: Renamed param to clarify it's original index
    if (originalIndex < 0 ||
        originalIndex >= _profile!.educationDetails!.length) {
      debugPrint(
        'FIX: Invalid education index $originalIndex',
      ); // FIX: Debug log
      return;
    }

    Map<String, int> monthMap = {
      // FIX: Local map for clarity (moved from bottom)
      "January": 1, "February": 2, "March": 3, "April": 4, "May": 5, "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };
    Map<int, String> monthIntToString = monthMap.map(
      (k, v) => MapEntry(v, k),
    ); // FIX: Bidirectional for fetch/edit consistency

    final edu = _profile!.educationDetails![originalIndex];
    schoolCollegeName.text = edu.schoolOrCollegeName ?? '';
    _isRemote = edu.isRemote == 1;
    universityBoardName.text = edu.university ?? '';
    degree.text = edu.degreeSpc ?? '';
    fieldOfStudy.text = edu.fieldOfStudy ?? '';

    // FIX: Handle month/year consistently (assume API strings; convert if ints)
    startmonth.text = edu.startMonth != null
        ? (edu.startMonth) ?? ''
        : ''; // FIX: Use converter for display
    startyear.text = edu.firstYear?.toString() ?? '';
    endmonth.text = edu.endMonth != null ? (edu.endMonth) ?? '' : '';
    endyear.text = edu.passingYear?.toString() ?? '';
    _currentlyStudying = edu.isCurrent == 1;
    _markSheet = edu.marksheet;

    _editingEducationIndex = originalIndex; // FIX: Set to original index
    _educationModel[originalIndex] = EducationRequest(
      // FIX: Use originalIndex
      id: edu.id,
      userId: _userid,
      schoolOrCollegeName: edu.schoolOrCollegeName,
      isRemote: edu.isRemote,
      university: edu.university,
      degreeSpc: edu.degreeSpc,
      fieldOfStudy: edu.fieldOfStudy,
      firstYear: edu.firstYear,
      startMonth: monthMap[edu.startMonth] ?? 1, // FIX: Safe mapping
      passingYear: edu.passingYear,
      endMonth: monthMap[edu.endMonth] ?? 1, // FIX: Safe mapping
      isCurrent: edu.isCurrent,
      marksheet: edu.marksheet,
    );

    setShowEducationForm(true);
    notifyListeners();
  }

  /*  void editEducation(int index) {
    if (index < 0 || index >= _profile!.educationDetails!.length) return;

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

    final edu = _profile!.educationDetails![index];
    schoolCollegeName.text = edu.schoolOrCollegeName ?? '';
    _isRemote = edu.isRemote == 1;
    universityBoardName.text = edu.university ?? '';
    degree.text = edu.degreeSpc ?? '';
    fieldOfStudy.text = edu.fieldOfStudy ?? '';
    startmonth.text = edu.startMonth ?? '';
    startyear.text = edu.firstYear?.toString() ?? '';
    endmonth.text = edu.endMonth ?? '';
    endyear.text = edu.passingYear?.toString() ?? '';
    _currentlyStudying = edu.isCurrent == 1;
    _markSheet = edu.marksheet;

    _editingEducationIndex = index;
    _educationModel[index] = EducationRequest(
      id: edu.id,
      userId: _userid,
      schoolOrCollegeName: edu.schoolOrCollegeName,
      isRemote: edu.isRemote,
      university: edu.university,
      degreeSpc: edu.degreeSpc,
      fieldOfStudy: edu.fieldOfStudy,
      firstYear: edu.firstYear,
      startMonth: monthMap[edu.startMonth] ?? 1,
      passingYear: edu.passingYear,
      endMonth: monthMap[edu.endMonth] ?? 1,
      isCurrent: edu.isCurrent,
      marksheet: edu.marksheet,
    );

    setShowEducationForm(true);
    notifyListeners();
  } */

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
    _editingEducationIndex = null;
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
  String? _certificate;
  bool _certificateNoExpiration = false;
  bool _certificateDocument = false;
  bool _allCertificateDocs = false;
  final List<CertificationRequest> _certificateModel = [];
  bool _showCertificateForm = false;
  int? _editingCertificateIndex;

  String? get certificateFile => _certificate;
  List<CertificationRequest> get certificateModel => _certificateModel;
  bool get certificateNoExpiration => _certificateNoExpiration;
  bool get certificateDocumentUploaded => _certificateDocument;
  bool get allCertificateDocsUploaded => _allCertificateDocs;
  bool get isEditingCertificate => _editingCertificateIndex != null;
  int? get isEditCertificateIndex => _editingCertificateIndex;
  bool get showCertificateForm => _showCertificateForm;

  void setShowCertificateForm(bool value) {
    _showCertificateForm = value;
    notifyListeners();
  }

  void setCertificateNoExpiration(bool value) {
    _certificateNoExpiration = value;
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
    var snackMessage = '';
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
      /* issueDate: issuemonth.text.isNotEmpty && issueyear.text.isNotEmpty
          ? "${issuemonth.text} ${issueyear.text}"
          : null, */
      /*   expirationDate: _certificateNoExpiration
          ? null
          : validmonth.text.isNotEmpty && validyear.text.isNotEmpty
          ? "${validmonth.text} ${validyear.text}"
          : null, */
    );

    if (_editingCertificateIndex != null &&
        _editingCertificateIndex! >= 0 &&
        _editingCertificateIndex! < _certificateModel.length) {
      _certificateModel[_editingCertificateIndex!] = certificate.copyWith(
        id: _certificateModel[_editingCertificateIndex!].id,
      );
      snackMessage = '🌟 Certificate updated successfully.';
    } else {
      _certificateModel.add(certificate);
      snackMessage = '🎉 Certificate added successfully!';
    }

    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(userId: _userid),
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: _certificateModel,
      userProjectRequest: [],
    );

    clearCertificateForm();
    _editingCertificateIndex = null;
    setShowCertificateForm(false);
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      CustomSnackbar.show(snackMessage, false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
  }

  void editCertificate(int index) {
    if (index < 0 || index >= _profile!.certifications!.length) return;

    final cert = _profile!.certifications![index];
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

    _editingCertificateIndex = index;
    _certificateModel[index] = CertificationRequest(
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
    );

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
    notifyListeners();
  }

  //
  //
  //
  //
  // Certificate
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
      url: project_url.text,
      duration: _project_duration,
      technologiesUsed: _project_technology_used,
      itSkillsByProject: _project_it_skills.join(','),
    );

    if (_editProjectIndex != null &&
        _editProjectIndex! >= 0 &&
        _editProjectIndex! < _projectModel.length) {
      _projectModel[_editProjectIndex!] = project.copyWith(
        id: _projectModel[_editProjectIndex!].id,
      );
      snackMessage = '✨ Project updated successfully!';
    } else {
      _projectModel.add(project);
      snackMessage = '🚀 Project added successfully!';
    }

    _createNewUserModel = CreateNewUserModel(
      userRequest: UserRequest(userId: _userid),
      experienceRequest: [],
      educationRequest: [],
      certificationsRequest: [],
      userProjectRequest: _projectModel,
    );

    clearProjectForm();
    _editProjectIndex = null;
    setShowProjectForm(false);
    bool done = await UserServices.postUserInfo(_createNewUserModel!);
    if (done) {
      fetchProfile();
      CustomSnackbar.show(snackMessage, false);
    } else {
      CustomSnackbar.show("Getting error while saving data", true);
    }
    notifyListeners();
  }

  void editProject(int index) {
    if (index < 0 || index >= _profile!.projects!.length) return;

    final cert = _profile?.projects![index];
    project_title.text = cert!.projectTitle.toString();
    project_description.text = cert.description.toString();
    project_role.text = cert.role.toString();
    project_url.text = cert.url.toString();
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
    _projectModel[index] = UserProjectRequest(
      id: cert.id,
      projectTitle: cert.projectTitle,
      description: cert.description,
      role: cert.role,
      url: cert.url,
      duration: cert.duration,
      technologiesUsed: cert.technologiesUsed,
      itSkillsByProject: cert.itSkillsByProject,
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
              Map<String, int> monthMap = {/* same as above */};
              return EducationRequest(
                id: edu.id,
                userId: _userid,
                schoolOrCollegeName: edu.schoolOrCollegeName,
                isRemote: edu.isRemote,
                university: edu.university,
                degreeSpc: edu.degreeSpc,
                fieldOfStudy: edu.fieldOfStudy,
                firstYear: edu.firstYear,
                startMonth:
                    monthMap[edu.startMonth] ??
                    0, // FIX: Safe, handles string/int mismatch
                passingYear: edu.passingYear,
                endMonth: monthMap[edu.endMonth] ?? 0,
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
}
