import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_circle/src/model/business_page/business_home_page_model.dart';
import 'package:job_circle/src/services/business_page/business_company_service.dart';

class BusinessCompanyProvider extends ChangeNotifier {
  final BusinessCompanyService _service = BusinessCompanyService();

  List<BusinessCompany> _companies = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;

  int _currentPageIndex = 0;
  final List<int> _pageHistory = [];
  int? _editingCompanyId;
  int? _sugeestionCompanyId;
  String _companyLogo = '';

  // Options & Selections
  String? _companyType;
  String? _memberRole;
  String? _organizationType;
  bool _isHeadOfficeSame = false;
  bool _isNoDomainEmail = false;
  String? _selectedDocumentType;
  // page 2 focusNode
  final FocusNode industryFocusNode = FocusNode();
  final FocusNode selectedFirmFocusNode = FocusNode();

  // Page 2 Controllers
  final companyCodeController = TextEditingController();
  final firmLegalNameController = TextEditingController();
  final brandNameController = TextEditingController();
  final taglineController = TextEditingController();
  final websiteController = TextEditingController();
  final industryController = TextEditingController();
  final aboutCompanyController = TextEditingController();
  final incorporationYearController = TextEditingController();
  final companySizeController = TextEditingController();
  final logoUrlController = TextEditingController();

  // Page 3 Controllers (Address)
  final premisesOfficeNoController = TextEditingController();
  final streetController = TextEditingController();
  final landmarkController = TextEditingController();
  final locationAreaController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final countryController = TextEditingController(text: 'India');

  // Page 4 Controllers (Identity)
  final suggestionSelectedFirmController = TextEditingController();
  final designationController = TextEditingController();
  final officialContactController = TextEditingController();
  final officialEmailController = TextEditingController();

  //=======================================================================================
  //============================= Phone Verification part =================================
  //=======================================================================================

  final TextEditingController newContactController = TextEditingController();
  final TextEditingController phoneOtpController = TextEditingController();

  final FocusNode newContactFocusNode = FocusNode();

  bool _isPhoneVerified =
      true; // Initially verified with the user's primary number
  bool get isPhoneVerified => _isPhoneVerified;

  bool _isPhoneOtpSending = false;
  bool get isPhoneOtpSending => _isPhoneOtpSending;

  bool _isPhoneOtpSent = false;
  bool get isPhoneOtpSent => _isPhoneOtpSent;

  bool _isPhoneOtpVerifying = false;
  bool get isPhoneOtpVerifying => _isPhoneOtpVerifying;

  // Phone Countdown Timer (60s or 300s)
  Timer? _phoneTimer;
  int _phoneSecondsRemaining = 60;
  int get phoneSecondsRemaining => _phoneSecondsRemaining;

  bool get canResendPhoneOtp => _isPhoneOtpSent && _phoneSecondsRemaining == 0;

  String get formattedPhoneTimer {
    final minutes = (_phoneSecondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_phoneSecondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Call this on page init/first load to populate default verified number
  void initUserContactNumber(String defaultMobile) {
    if (officialContactController.text.isEmpty && defaultMobile.isNotEmpty) {
      officialContactController.text = defaultMobile;
      _isPhoneVerified = true;
      notifyListeners();
    }
  }

  void onNewContactChanged(String val) {
    if (_isPhoneOtpSent) {
      resetPhoneOtpState();
    }
    notifyListeners();
  }

  void onPhoneOtpChanged(String val) {
    notifyListeners();
  }

  void startPhoneTimer() {
    _phoneTimer?.cancel();
    _phoneSecondsRemaining = 60;
    _phoneTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_phoneSecondsRemaining > 0) {
        _phoneSecondsRemaining--;
        notifyListeners();
      } else {
        _phoneTimer?.cancel();
        notifyListeners();
      }
    });
  }

  void stopPhoneTimer() {
    _phoneTimer?.cancel();
    _phoneTimer = null;
    _phoneSecondsRemaining = 60;
  }

  void resetPhoneOtpState() {
    stopPhoneTimer();
    _isPhoneOtpSent = false;
    phoneOtpController.clear();
    notifyListeners();
  }

  void resetBottomSheetPhoneForm() {
    stopPhoneTimer();
    _isPhoneOtpSent = false;
    _isPhoneOtpSending = false;
    _isPhoneOtpVerifying = false;
    newContactController.clear();
    phoneOtpController.clear();
    notifyListeners();
    // Auto focus request for keyboard popup
    Future.delayed(const Duration(milliseconds: 200), () {
      newContactFocusNode.requestFocus();
    });
  }

  // ----------------------------------------------------
  // DUMMY PHONE API METHODS
  // ----------------------------------------------------
 Future<String?> sendPhoneOtp(String userName) async {
    final phoneStr = newContactController.text.trim();
    if (phoneStr.length != 10) {
      return "Please enter a valid 10-digit mobile number.";
    }

    final mobileNumber = int.tryParse(phoneStr);
    if (mobileNumber == null) {
      return "Invalid mobile number format.";
    }

    _isPhoneOtpSending = true;
    notifyListeners();

    final success = await _service.sendMobileOtp(
      mobile: mobileNumber,
      userName: userName,
    );

    _isPhoneOtpSending = false;
    if (success) {
      _isPhoneOtpSent = true;
      startPhoneTimer();
      notifyListeners();
      return null;
    } else {
      notifyListeners();
      return "Failed to send Mobile OTP. Please try again.";
    }
  }

  // Verify Mobile OTP
  Future<bool> verifyPhoneOtp() async {
    final phoneStr = newContactController.text.trim();
    final otp = phoneOtpController.text.trim();

    if (phoneStr.length != 10 || otp.length != 4) {
      return false;
    }

    final mobileNumber = int.tryParse(phoneStr);
    if (mobileNumber == null) return false;

    _isPhoneOtpVerifying = true;
    notifyListeners();

    final success = await _service.verifyMobileOtp(
      mobile: mobileNumber,
      otp: otp,
    );

    _isPhoneOtpVerifying = false;
    if (success) {
      officialContactController.text = phoneStr;
      _isPhoneVerified = true;
      stopPhoneTimer();
    }
    notifyListeners();
    return success;
  }

  //=======================================================================================

  //=======================================================================================
  //============================= Email Verification part =================================
  //=======================================================================================

  final TextEditingController emailOtpController = TextEditingController();

  bool _isEmailSending = false;
  bool get isEmailSending => _isEmailSending;

  bool _isOtpSent = false;
  bool get isOtpSent => _isOtpSent;

  bool _isEmailVerifying = false;
  bool get isEmailVerifying => _isEmailVerifying;

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  void onOtpChanged(String value) {
    notifyListeners();
  }

  void onEmailChanged(String value) {
    if (_isOtpSent && !_isEmailVerified) {
      resetEmailVerificationState();
    }
    notifyListeners(); // Ensures UI rebuilds as the user types or clears the text
  }

  // ==========================================
  // 5-MINUTE COUNTDOWN TIMER (300 SECONDS)
  // ==========================================
  Timer? _timer;
  int _secondsRemaining = 300;
  int get secondsRemaining => _secondsRemaining;

  bool get canResend => _isOtpSent && _secondsRemaining == 0;

  String get formattedTimer {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _secondsRemaining = 300;
  }

  void resetEmailVerificationState() {
    stopTimer();
    _isOtpSent = false;
    _isEmailVerified = false;
    emailOtpController.clear();
    notifyListeners();
  }

  // Toggled when checkbox "I don't have a company domain Email ID" is changed
  void toggleNoDomainEmail(bool value) {
    _isNoDomainEmail = value;
    if (value) {
      stopTimer();
      _isOtpSent = false;
      _isEmailVerified = false;
      officialEmailController.clear();
      emailOtpController.clear();
    }
    notifyListeners();
  }

  // ==========================================
  // API ACTIONS
  // ==========================================
  Future<String?> sendEmailOtp(String userName) async {
    final email = officialEmailController.text.trim();

    final validationError = validateOfficialEmail(email);
    if (validationError != null) {
      return validationError;
    }

    _isEmailSending = true;
    notifyListeners();

    final success = await _service.sendEmailOtp(
      email: email,
      userName: userName,
    );

    _isEmailSending = false;
    if (success) {
      _isOtpSent = true;
      startTimer();
      notifyListeners();
      return null;
    } else {
      notifyListeners();
      return "Failed to send OTP. Please try again.";
    }
  }

  Future<bool> verifyEmailOtp() async {
    final email = officialEmailController.text.trim();
    final otp = emailOtpController.text.trim();
    if (email.isEmpty || otp.isEmpty) return false;

    _isEmailVerifying = true;
    notifyListeners();

    final success = await _service.verifyEmailOtp(email: email, otp: otp);
    _isEmailVerifying = false;
    if (success) {
      _isEmailVerified = true;
      stopTimer();
    }
    notifyListeners();
    return success;
  }

  // ==========================================
  // RESTRICTED DOMAINS VALIDATION
  // ==========================================
  final List<String> _blockedDomains = [
    'gmail.com',
    'yahoo.com',
    'yahoo.in',
    'yahoo.co.in',
    'outlook.com',
    'hotmail.com',
    'live.com',
    'icloud.com',
    'rediffmail.com',
    'zoho.com',
    'yopmail.com',
    'mail.com',
    'protonmail.com',
    'proton.me',
    'aol.com',
    'ymail.com',
    'gmx.com',
    'gmx.de',
    'xmail.com',
  ];

  String? validateOfficialEmail(String email) {
    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      return "Please enter an official email address.";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(cleanEmail)) {
      return "Please enter a valid email address.";
    }

    final parts = cleanEmail.split('@');
    if (parts.length != 2) {
      return "Invalid email format.";
    }

    final domain = parts[1];

    if (!_isNoDomainEmail && _blockedDomains.contains(domain)) {
      return "Please use your official company domain email (e.g., name@company.com), not a public email provider.";
    }

    return null;
  }

  //=======================================================================================

  // Getters
  List<BusinessCompany> get companies => _companies;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  int get currentPageIndex => _currentPageIndex;
  bool get isEditMode => _editingCompanyId != null;

  String? get companyType => _companyType;
  String? get memberRole => _memberRole;
  String? get organizationType => _organizationType;
  bool get isHeadOfficeSame => _isHeadOfficeSame;
  bool get isNoDomainEmail => _isNoDomainEmail;
  String? get selectedDocumentType => _selectedDocumentType;
  int? get suggestedCompanyId => _sugeestionCompanyId;
  String get companyLogo => _companyLogo;

  void setCompanyLogo(String data) {
    _companyLogo = data;
    notifyListeners();
  }

  void setCompanyId(int id) {
    _sugeestionCompanyId = id;
    notifyListeners();
  }

  /// Set Company Type & trigger BottomSheet logic
  void setCompanyType(
    String type,
    BuildContext context,
    VoidCallback openBottomSheet,
  ) {
    if (_companyType != type) {
      // Reset role if user switches to a different company type
      _companyType = type;
      _memberRole = null;
    }
    notifyListeners();

    // Automatically open BottomSheet when an option is tapped
    openBottomSheet();
  }

  void setMemberRole(String role) {
    _memberRole = role;
    notifyListeners();
  }

  /// Reset selection on initial load if needed
  void clearPage1Selections() {
    _companyType = null;
    _memberRole = null;
    notifyListeners();
  }

  void setOrganizationType(String type) {
    _organizationType = type;
    notifyListeners();
  }

  void toggleHeadOfficeSame(bool value) {
    _isHeadOfficeSame = value;
    notifyListeners();
  }

  /*  void toggleNoDomainEmail(bool value) {
    _isNoDomainEmail = value;
    notifyListeners();
  } */

  void setSelectedDocumentType(String? docType) {
    _selectedDocumentType = docType;
    notifyListeners();
  }

  void setPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void handleNextPage() {
    _pageHistory.add(_currentPageIndex);
    if (_currentPageIndex == 0) {
      if (_memberRole == 'OWNER') {
        _currentPageIndex = 1; // Business Page
      } else {
        _currentPageIndex = 3; // Identity Verification Page
      }
    } else {
      _currentPageIndex++;
    }
    notifyListeners();
  }

  void handlePreviousPage() {
    if (_pageHistory.isNotEmpty) {
      _currentPageIndex = _pageHistory.removeLast();
    } else if (_currentPageIndex > 0) {
      _currentPageIndex--;
    }
    notifyListeners();
  }

  /// Load companies list
  Future<void> loadMyCompanies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companies = await _service.getMyCompanies();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _companies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initialize/Pre-fill for Edit
  void initFormForEdit(BusinessCompany company) {
    _editingCompanyId = company.id;
    _memberRole = company.memberRole;
    _companyType = company.companyType;
    _organizationType = company.organizationType;

    companyCodeController.text = company.companyCode ?? '';
    firmLegalNameController.text = company.firmLegalName ?? company.companyName;
    brandNameController.text = company.brandName ?? '';
    taglineController.text = company.tagline ?? '';
    websiteController.text = company.website ?? '';
    industryController.text = company.industryType ?? '';
    aboutCompanyController.text = company.aboutCompany ?? '';
    incorporationYearController.text = company.incorporationYear ?? '';
    companySizeController.text = company.companySize ?? '';
    logoUrlController.text = company.logoUrl ?? '';

    premisesOfficeNoController.text = company.premisesOfficeNo ?? '';
    streetController.text = company.street ?? '';
    landmarkController.text = company.landmark ?? '';
    locationAreaController.text = company.locationArea ?? '';
    cityController.text = company.city ?? company.companyCity ?? '';
    stateController.text = company.state ?? '';
    pinCodeController.text = company.pinCode ?? '';
    countryController.text = company.country ?? 'India';
    _isHeadOfficeSame = company.isHeadOfficeSame;

    designationController.text = company.designation ?? '';
    officialContactController.text = company.officialContact ?? '';
    officialEmailController.text = company.officialEmail ?? '';
    _isEmailVerified =
        company.isEmailVerified != null && company.isEmailVerified == true
        ? true
        : false;
    _isNoDomainEmail = company.isNoDomainEmail;
    _selectedDocumentType = company.documentType;

    _currentPageIndex = 0;
    _pageHistory.clear();
    notifyListeners();
  }

  void resetForm() {
    _editingCompanyId = null;
    _currentPageIndex = 0;
    _pageHistory.clear();
    _companyType = null;
    _memberRole = null;
    _organizationType = null;
    _isHeadOfficeSame = false;
    _isNoDomainEmail = false;
    _selectedDocumentType = null;
    _sugeestionCompanyId = null;
    _companyLogo = '';

    companyCodeController.clear();
    firmLegalNameController.clear();
    brandNameController.clear();
    taglineController.clear();
    websiteController.clear();
    industryController.clear();
    aboutCompanyController.clear();
    incorporationYearController.clear();
    companySizeController.clear();
    logoUrlController.clear();

    premisesOfficeNoController.clear();
    streetController.clear();
    landmarkController.clear();
    locationAreaController.clear();
    cityController.clear();
    stateController.clear();
    pinCodeController.clear();
    countryController.text = 'India';

    designationController.clear();
    officialContactController.clear();
    officialEmailController.clear();
    _timer?.cancel();
    emailOtpController.clear();
    notifyListeners();
  }

  /// Submit Form
  Future<bool> submitCompanyForm({required int userId}) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    final payload = {
      'memberRole': _memberRole,
      'designation': designationController.text.trim(),
      'officialContact': officialContactController.text.trim(),
      'officialEmail': officialEmailController.text.trim(),
      'isEmailVerified': _isEmailVerified,
      'isNoDomainEmail': _isNoDomainEmail,
      'companyType': _companyType,
      'documentType': _selectedDocumentType,
      'companyName': _editingCompanyId != null && _editingCompanyId != 0
          ? null
          : suggestionSelectedFirmController.text,
      if (_memberRole == 'OWNER') ...{
        'firmLegalName': firmLegalNameController.text.trim(),
        'brandName': brandNameController.text.trim(),
        'tagline': taglineController.text.trim(),
        'companyCode': companyCodeController.text.trim(),
        'website': websiteController.text.trim(),
        'organizationType': _organizationType,
        'industryType': industryController.text.trim(),
        'aboutCompany': aboutCompanyController.text.trim(),
        'incorporationYear': incorporationYearController.text.trim(),
        'companySize': companySizeController.text.trim(),
        'logoUrl': logoUrlController.text.trim(),
        'premisesOfficeNo': premisesOfficeNoController.text.trim(),
        'street': streetController.text.trim(),
        'landmark': landmarkController.text.trim(),
        'locationArea': locationAreaController.text.trim(),
        'city': cityController.text.trim(),
        'companyCity': cityController.text.trim(),
        'state': stateController.text.trim(),
        'pinCode': pinCodeController.text.trim(),
        'country': countryController.text.trim(),
        'isHeadOfficeSame': _isHeadOfficeSame,
      },
    };

    try {
      final success = await _service.saveCompanyPayload(
        userId: userId,
        body: payload,
        companyId: _editingCompanyId,
      );

      if (success) {
        await loadMyCompanies();
        resetForm();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    companyCodeController.dispose();
    firmLegalNameController.dispose();
    brandNameController.dispose();
    taglineController.dispose();
    websiteController.dispose();
    industryController.dispose();
    aboutCompanyController.dispose();
    incorporationYearController.dispose();
    companySizeController.dispose();
    logoUrlController.dispose();
    premisesOfficeNoController.dispose();
    streetController.dispose();
    landmarkController.dispose();
    locationAreaController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    countryController.dispose();
    designationController.dispose();
    officialContactController.dispose();
    officialEmailController.dispose();
    industryFocusNode.dispose();
    selectedFirmFocusNode.dispose();
    suggestionSelectedFirmController.dispose();
    _timer?.cancel();
    officialEmailController.dispose();
    emailOtpController.dispose();
    newContactFocusNode.dispose();
    super.dispose();
  }
}
