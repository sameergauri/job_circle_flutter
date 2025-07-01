import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/models/view_and_generate_model.dart';
import 'package:job_circle/screens/Billing/service/view_and_generate_service.dart';

// Define the provider
final generateInvoiceProvider =
    AsyncNotifierProvider<GenerateInvoiceNotifier, GenerateInvoiceState>(
  () => GenerateInvoiceNotifier(),
);

class GenerateInvoiceState {
  final JoinersResponseModel? joinersResponse;
  final JoinersResponseModel? filteredResponse;
  final String searchQuery;
  final String? selectedMonth;
  final String? selectedYear;

  GenerateInvoiceState({
    this.joinersResponse,
    this.filteredResponse,
    this.searchQuery = '',
    this.selectedMonth,
    this.selectedYear,
  });

  GenerateInvoiceState copyWith({
    JoinersResponseModel? joinersResponse,
    JoinersResponseModel? filteredResponse,
    String? searchQuery,
    String? selectedMonth,
    String? selectedYear,
  }) {
    return GenerateInvoiceState(
      joinersResponse: joinersResponse ?? this.joinersResponse,
      filteredResponse: filteredResponse ?? this.filteredResponse,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  double getTotalPayable() {
    final payableJoiners = filteredResponse?.resultData?.payable?.values
            .expand((list) => list)
            .toList() ??
        [];
    return payableJoiners.fold(
        0.0, (sum, joiner) => sum + (joiner.clientPayout?.toDouble() ?? 0.0));
  }

  List<String> get statusCategories {
    final categories = <String>[];
    final resultData = (searchQuery.isNotEmpty ||
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

class GenerateInvoiceNotifier extends AsyncNotifier<GenerateInvoiceState> {
  final JoinersService _joinersService = JoinersService();

  @override
  Future<GenerateInvoiceState> build() async {
    return GenerateInvoiceState();
  }

  Future<void> fetchJoinersData() async {
    state = const AsyncLoading();
    try {
      final response = await _joinersService.fetchJoinersData();
      if (response == null) {
        developer.log('fetchJoinersData returned null response',
            name: 'GenerateInvoiceNotifier');
        state = AsyncError('No data received from service', StackTrace.current);
        return;
      }
      if (response.resultData == null) {
        developer.log('fetchJoinersData returned null resultData',
            name: 'GenerateInvoiceNotifier');
        state = AsyncError(
            'Invalid response: resultData is null', StackTrace.current);
        return;
      }
      developer.log(
        'fetchJoinersData success: resultKey=${response.resultKey}, joinersCount=${response.resultData?.joiners?.length ?? 0}',
        name: 'GenerateInvoiceNotifier',
      );
      state = AsyncData(GenerateInvoiceState(
        joinersResponse: response,
        filteredResponse: response,
        selectedMonth: null,
        selectedYear: null,
        searchQuery: '',
      ));
    } catch (e, stackTrace) {
      developer.log('fetchJoinersData error: $e',
          name: 'GenerateInvoiceNotifier', stackTrace: stackTrace);
      state = AsyncError(e.toString(), stackTrace);
    }
  }

  void filterJoiners(String query) {
    state = AsyncData(state.value!.copyWith(searchQuery: query.toLowerCase()));
    _applyFilters();
  }

  void filterByDate(String? month, String? year) {
    if (month == null && year == null) {
      state = AsyncData(
          state.value!.copyWith(selectedMonth: null, selectedYear: null));
    } else {
      state = AsyncData(
          state.value!.copyWith(selectedMonth: month, selectedYear: year));
    }
    _applyFilters();
  }

  void resetFilters() {
    final currentState = state.value!;
    state = AsyncData(GenerateInvoiceState(
      joinersResponse: currentState.joinersResponse,
      filteredResponse: currentState.joinersResponse, // Reset to original data
      searchQuery: '',
      selectedMonth: null,
      selectedYear: null,
    ));
  }

  void _applyFilters() {
    final currentState = state.value!;
    print(
        'Applying filters -> month: ${currentState.selectedMonth}, year: ${currentState.selectedYear}, query: ${currentState.searchQuery}');

    if (currentState.joinersResponse == null) {
      print('No data to filter.');
      state = AsyncData(currentState.copyWith(filteredResponse: null));
      return;
    }

    final resultData = currentState.joinersResponse!.resultData;
    if (resultData == null) {
      state = AsyncData(currentState.copyWith(
          filteredResponse: currentState.joinersResponse));
      return;
    }

    final filteredJoiners = _filterMapByDateAndQuery(resultData.joiners);
    final filteredPending = _filterMapByDateAndQuery(resultData.pending);
    final filteredPayable = _filterMapByDateAndQuery(resultData.payable);
    final filteredNotPayable = _filterMapByDateAndQuery(resultData.notPayable);

    state = AsyncData(currentState.copyWith(
      filteredResponse: JoinersResponseModel(
        resultKey: currentState.joinersResponse!.resultKey,
        resultData: ResultData(
          joiners: filteredJoiners,
          pending: filteredPending,
          payable: filteredPayable,
          notPayable: filteredNotPayable,
          totalPayable: resultData.totalPayable,
        ),
        code: currentState.joinersResponse!.code,
        errorMessage: currentState.joinersResponse!.errorMessage,
      ),
    ));
  }

  Map<String, List<JoinerData>>? _filterMapByDateAndQuery(
      Map<String, List<JoinerData>>? map) {
    final currentState = state.value!;
    if (map == null) return null;

    return map.map((key, value) => MapEntry(
        key,
        value.where((joiner) {
          bool matchesQuery = currentState.searchQuery.isEmpty ||
              (joiner.candidateName
                      ?.toLowerCase()
                      .contains(currentState.searchQuery) ??
                  false);

          bool matchesDate = true;
          if (currentState.selectedMonth != null ||
              currentState.selectedYear != null) {
            if (joiner.dateOfJoining != null) {
              try {
                final date =
                    DateFormat('dd MMM yyyy').parse(joiner.dateOfJoining!);
                final month = DateFormat('MM').format(date);
                final year = DateFormat('yyyy').format(date);
                matchesDate = (currentState.selectedMonth == null ||
                        month == currentState.selectedMonth) &&
                    (currentState.selectedYear == null ||
                        year == currentState.selectedYear);
              } catch (_) {
                matchesDate = false;
              }
            } else {
              matchesDate = false;
            }
          }

          return matchesQuery && matchesDate;
        }).toList()));
  }
}
