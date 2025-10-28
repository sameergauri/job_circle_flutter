// providers/generate_invoice_provider.dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/src/model/referal_program/joiners_model.dart';
import 'package:job_circle/src/services/referal_program/referal_program_service.dart';

class GenerateInvoiceProvider with ChangeNotifier {

  GenerateInvoiceState _state = GenerateInvoiceState();

  GenerateInvoiceState get state => _state;

  Future<void> fetchJoinersData() async {
    try {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      final response = await ReferalProgramService.fetchJoinersData();

      if (response == null) {
        throw Exception('No data received from service');
      }

      if (response.resultData == null) {
        throw Exception('Invalid response: resultData is null');
      } 

      _state = GenerateInvoiceState(
        joinersResponse: response,
        filteredResponse: response,
        selectedMonth: null,
        selectedYear: null,
        searchQuery: '',
        isLoading: false,
      );
    } catch (e) {
      _state = _state.copyWith(error: e.toString(), isLoading: false);
    }

    notifyListeners();
  }

  void filterJoiners(String query) {
    _state = _state.copyWith(searchQuery: query.toLowerCase());
    _applyFilters();
  }

  void filterByDate(String? month, String? year) {
    if (month == null && year == null) {
      _state = _state.copyWith(selectedMonth: null, selectedYear: null);
    } else {
      _state = _state.copyWith(selectedMonth: month, selectedYear: year);
    }
    _applyFilters();
  }

  void resetFilters() {
    _state = GenerateInvoiceState(
      joinersResponse: _state.joinersResponse,
      filteredResponse: _state.joinersResponse,
      searchQuery: '',
      selectedMonth: null,
      selectedYear: null,
      isLoading: false,
    );
    notifyListeners();
  }

  void _applyFilters() {
    if (_state.joinersResponse == null) {
      _state = _state.copyWith(filteredResponse: null);
      notifyListeners();
      return;
    }

    final resultData = _state.joinersResponse!.resultData;
    if (resultData == null) {
      _state = _state.copyWith(filteredResponse: _state.joinersResponse);
      notifyListeners();
      return;
    }

    final filteredJoiners = _filterMapByDateAndQuery(resultData.joiners);
    final filteredPending = _filterMapByDateAndQuery(resultData.pending);
    final filteredPayable = _filterMapByDateAndQuery(resultData.payable);
    final filteredNotPayable = _filterMapByDateAndQuery(resultData.notPayable);

    _state = _state.copyWith(
      filteredResponse: JoinersResponseModel(
        resultKey: _state.joinersResponse!.resultKey,
        resultData: ResultData(
          joiners: filteredJoiners,
          pending: filteredPending,
          payable: filteredPayable,
          notPayable: filteredNotPayable,
          totalPayable: resultData.totalPayable,
        ),
        code: _state.joinersResponse!.code,
        errorMessage: _state.joinersResponse!.errorMessage,
      ),
    );

    notifyListeners();
  }

  Map<String, List<JoinerData>>? _filterMapByDateAndQuery(
    Map<String, List<JoinerData>>? map,
  ) {
    if (map == null) return null;

    return map.map(
      (key, value) => MapEntry(
        key,
        value.where((joiner) {
          bool matchesQuery =
              _state.searchQuery.isEmpty ||
              (joiner.candidateName?.toLowerCase().contains(
                    _state.searchQuery,
                  ) ??
                  false);

          bool matchesDate = true;
          if (_state.selectedMonth != null || _state.selectedYear != null) {
            if (joiner.dateOfJoining != null) {
              try {
                final date = DateFormat(
                  'dd MMM yyyy',
                ).parse(joiner.dateOfJoining!);
                final month = DateFormat('MM').format(date);
                final year = DateFormat('yyyy').format(date);
                matchesDate =
                    (_state.selectedMonth == null ||
                        month == _state.selectedMonth) &&
                    (_state.selectedYear == null ||
                        year == _state.selectedYear);
              } catch (_) {
                matchesDate = false;
              }
            } else {
              matchesDate = false;
            }
          }

          return matchesQuery && matchesDate;
        }).toList(),
      ),
    );
  }
}

class GenerateInvoiceState {
  final JoinersResponseModel? joinersResponse;
  final JoinersResponseModel? filteredResponse;
  final String searchQuery;
  final String? selectedMonth;
  final String? selectedYear;
  final bool isLoading;
  final String? error;

  GenerateInvoiceState({
    this.joinersResponse,
    this.filteredResponse,
    this.searchQuery = '',
    this.selectedMonth,
    this.selectedYear,
    this.isLoading = false,
    this.error,
  });

  GenerateInvoiceState copyWith({
    JoinersResponseModel? joinersResponse,
    JoinersResponseModel? filteredResponse,
    String? searchQuery,
    String? selectedMonth,
    String? selectedYear,
    bool? isLoading,
    String? error,
  }) {
    return GenerateInvoiceState(
      joinersResponse: joinersResponse ?? this.joinersResponse,
      filteredResponse: filteredResponse ?? this.filteredResponse,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  double getTotalPayable() {
    final payableJoiners =
        filteredResponse?.resultData?.payable?.values
            .expand((list) => list)
            .toList() ??
        [];
    return payableJoiners.fold(
      0.0,
      (sum, joiner) => sum + (joiner.clientPayout?.toDouble() ?? 0.0),
    );
  }

  List<String> get statusCategories {
    final categories = <String>[];
    final resultData =
        (searchQuery.isNotEmpty ||
            selectedMonth != null ||
            selectedYear != null)
        ? filteredResponse?.resultData
        : filteredResponse?.resultData;

    if (resultData?.joiners?.values.any((list) => list.isNotEmpty) ?? false) {
      categories.add('Joiners');
    }
    if (resultData?.pending?.values.any((list) => list.isNotEmpty) ?? false) {
      categories.add('Pending');
    }
    if (resultData?.payable?.values.any((list) => list.isNotEmpty) ?? false) {
      categories.add('Payable');
    }
    if (resultData?.notPayable?.values.any((list) => list.isNotEmpty) ??
        false) {
      categories.add('Not Payable');
    }

    return categories;
  }

  List<JoinerData>? getJoinersByStatus(String status) {
    final data =
        searchQuery.isEmpty && selectedMonth == null && selectedYear == null
        ? joinersResponse
        : filteredResponse;
    final resultData = data?.resultData;

    switch (status) {
      case 'Joiners':
        return resultData?.joiners?.values.expand((list) => list).toList();
      case 'Pending':
        return resultData?.pending?.values.expand((list) => list).toList();
      case 'Payable':
        return resultData?.payable?.values.expand((list) => list).toList();
      case 'Not Payable':
        return resultData?.notPayable?.values.expand((list) => list).toList();
      default:
        return null;
    }
  }
}
