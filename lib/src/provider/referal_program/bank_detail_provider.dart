// providers/banking_provider.dart
import 'package:flutter/foundation.dart';
import 'package:job_circle/src/model/referal_program/banking_model.dart';
import 'package:job_circle/src/services/referal_program/referal_program_service.dart';

class BankingProvider with ChangeNotifier {
 

  BankingState _state = BankingState();

  BankingState get state => _state;

  Future<void> fetchBankingData() async {
    try {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      final data = await ReferalProgramService.fetchBankingData();

      _state = BankingState(bankingData: data, isLoading: false);
    } catch (e) {
      _state = _state.copyWith(error: e.toString(), isLoading: false);
    }

    notifyListeners();
  }

  Future<void> addBankingDetails(Map<String, dynamic> jsonData) async {
    try {
      _state = _state.copyWith(isSaving: true);
      notifyListeners();

      await ReferalProgramService.addBankingDetails(jsonData);

      // Refresh the data after adding new banking details
      await fetchBankingData();

      _state = _state.copyWith(isSaving: false);
    } catch (e) {
      _state = _state.copyWith(error: e.toString(), isSaving: false);
    }

    notifyListeners();
  }

  void resetState() {
    _state = BankingState(
      bankingData: _state.bankingData,
      isLoading: false,
      isSaving: false,
    );
    notifyListeners();
  }
}

class BankingState {
  final List<GetBankingModel> bankingData;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  BankingState({
    this.bankingData = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  BankingState copyWith({
    List<GetBankingModel>? bankingData,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return BankingState(
      bankingData: bankingData ?? this.bankingData,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
    );
  }

  bool get hasActiveBanking {
    return bankingData.any((data) => data.isVerify == 1);
  }

  List<GetBankingModel> get activeBankingData {
    return bankingData.where((data) => data.isVerify == 1).toList();
  }

  List<GetBankingModel> get inactiveBankingData {
    return bankingData.where((data) => data.isVerify == 0).toList();
  }

  List<GetBankingModel> get pendingBankingData {
    return bankingData.where((data) => data.isVerify == null).toList();
  }
}
