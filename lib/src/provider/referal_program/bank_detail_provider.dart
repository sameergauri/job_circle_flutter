// providers/banking_provider.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/bank/bank_post_model.dart';
import 'package:job_circle/src/model/bank/fetch_bank_detail_model.dart';
import 'package:job_circle/src/services/referal_program/referal_program_service.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class BankingProvider with ChangeNotifier {
  List<FetchBankDetailModel>? _fetchBankDetailModel;

  // Form controllers
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController acNoController = TextEditingController();
  final TextEditingController acNoVerifyController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();

  // Form state
  int _selectedBankId = 0;
  String _selectedBankName = "";
  String _cancelChequePath = "";
  bool _isSavingAccount = false;
  bool _isCurrentAccount = false;
  bool _obscureAccountNumber = true;
  bool _isLoading = false;

  int get selectedBankId => _selectedBankId;
  String get selectedBankName => _selectedBankName;
  String get cancelChequePath => _cancelChequePath;
  bool get isSavingAccount => _isSavingAccount;
  bool get isCurrentAccount => _isCurrentAccount;
  bool get obscureAccountNumber => _obscureAccountNumber;
  bool get isLoading => _isLoading;
  List<FetchBankDetailModel>? get fetchBankDetail => _fetchBankDetailModel;

  @override
  void dispose() {
    accountHolderNameController.dispose();
    bankNameController.dispose();
    acNoController.dispose();
    acNoVerifyController.dispose();
    ifscCodeController.dispose();
    super.dispose();
  }

  void setAccountHolderName(String name) {
    clearForm();
    accountHolderNameController.text = name;
    notifyListeners();
  }

  void setSelectedBankId(int id) {
    _selectedBankId = id;
    _selectedBankName = bankNameController.text;
    notifyListeners();
  }

  void setCancelChequePath(String path) {
    _cancelChequePath = path;
    notifyListeners();
  }

  void selectSavingAccount() {
    _isSavingAccount = true;
    _isCurrentAccount = false;
    notifyListeners();
  }

  void selectCurrentAccount() {
    _isSavingAccount = false;
    _isCurrentAccount = true;
    notifyListeners();
  }

  void showAccountNumber() {
    _obscureAccountNumber = false;
    notifyListeners();
  }

  void hideAccountNumber() {
    _obscureAccountNumber = true;
    notifyListeners();
  }

  void clearForm() {
    accountHolderNameController.clear();
    bankNameController.clear();
    acNoController.clear();
    acNoVerifyController.clear();
    ifscCodeController.clear();
    _selectedBankId = 0;
    _selectedBankName = "";
    _cancelChequePath = "";
    _isSavingAccount = false;
    _isCurrentAccount = false;
    _obscureAccountNumber = true;
    notifyListeners();
  }

  Future<void> fetchBankingData() async {
    try {
      _fetchBankDetailModel = [];
      _isLoading = true;
      notifyListeners();
      _fetchBankDetailModel = await ReferalProgramService.fetchBankingData();
    } catch (e) {
      _isLoading = false;
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> submitBankingDetails() async {
    _isLoading = true;
    notifyListeners();
    try {
      int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
      PostBankDetailModel postBankDetailModel = PostBankDetailModel(
        uid: userid,
        accountNumber: int.tryParse(acNoController.text),
        accountType: _isSavingAccount ? "Saving" : "Current",
        bankName: bankNameController.text,
        bankId: _selectedBankId,
        ifscCode: ifscCodeController.text,
        cancleCheque: _cancelChequePath,
        updatedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      var result = await ReferalProgramService.addBankingDetails(
        postBankDetailModel,
      );
      if (result) {
        await fetchBankingData();
        CustomSnackbar.show("Banking Detail added Successfully", false);
        clearForm();
      } else {
        CustomSnackbar.show("Getting error while saving bank detail", true);
      }
    } catch (e) {
      _isLoading = false;
      CustomSnackbar.show("Getting exception while saving bank detail", true);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
