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

  void toggleNoDomainEmail(bool value) {
    _isNoDomainEmail = value;
    notifyListeners();
  }

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
    super.dispose();
  }
}
