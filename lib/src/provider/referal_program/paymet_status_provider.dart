// providers/payment_status_provider.dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/services/referal_program/referal_program_service.dart';


class PaymentStatusProvider with ChangeNotifier {


  PaymentStatusState _state = PaymentStatusState();

  PaymentStatusState get state => _state;

  Future<void> fetchInvoices() async {
    try {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      final data = await ReferalProgramService.fetchListOfInvoice();

      _state = PaymentStatusState(
        paymentStatus: data,
        filteredInvoices: data.resultData.invoiceSent,
        filteredPaidData: data.resultData.paidData,
        filteredValidation: data.resultData.validation,
        filteredRejectedData: data.resultData.rejectData,
        searchQuery: '',
        selectedDate: null,
        isLoading: false,
      );
    } catch (e) {
      _state = _state.copyWith(error: e.toString(), isLoading: false);
    }

    notifyListeners();
  }

  void filterInvoices(String query) {
    _state = _state.copyWith(searchQuery: query.toLowerCase());
    _applyFilters();
  }

  void filterByDate(Map<String, String>? date) {
    _state = _state.copyWith(selectedDate: date);
    _applyFilters();
  }

  void resetFilters() {
    _state = PaymentStatusState(
      paymentStatus: _state.paymentStatus,
      filteredInvoices: _state.paymentStatus?.resultData.invoiceSent ?? [],
      filteredPaidData: _state.paymentStatus?.resultData.paidData ?? [],
      filteredValidation: _state.paymentStatus?.resultData.validation ?? [],
      filteredRejectedData: _state.paymentStatus?.resultData.rejectData ?? [],
      searchQuery: '',
      selectedDate: null,
      isLoading: false,
    );
    notifyListeners();
  }

  void _applyFilters() {
    if (_state.paymentStatus == null) {
      notifyListeners();
      return;
    }

    final resultData = _state.paymentStatus!.resultData;

    // Apply search filter
    List<InvoiceSent> searchFilteredInvoices = _filterInvoices(
      resultData.invoiceSent,
      _state.searchQuery,
    );
    List<InvoiceSent> searchFilteredPaidData = _filterInvoices(
      resultData.paidData,
      _state.searchQuery,
    );
    List<InvoiceSent> searchFilteredValidation = _filterInvoices(
      resultData.validation,
      _state.searchQuery,
    );
    List<InvoiceSent> searchFilteredRejectedData = _filterInvoices(
      resultData.rejectData,
      _state.searchQuery,
    );

    // Apply date filter if selected
    if (_state.selectedDate != null) {
      final selectedMonth = _state.selectedDate!['month'];
      final selectedYear = _state.selectedDate!['year'];

      _state = _state.copyWith(
        filteredInvoices: _applyDateFilter(
          searchFilteredInvoices,
          selectedMonth,
          selectedYear,
        ),
        filteredPaidData: _applyDateFilter(
          searchFilteredPaidData,
          selectedMonth,
          selectedYear,
        ),
        filteredValidation: _applyDateFilter(
          searchFilteredValidation,
          selectedMonth,
          selectedYear,
        ),
        filteredRejectedData: _applyDateFilter(
          searchFilteredRejectedData,
          selectedMonth,
          selectedYear,
        ),
      );
    } else {
      _state = _state.copyWith(
        filteredInvoices: searchFilteredInvoices,
        filteredPaidData: searchFilteredPaidData,
        filteredValidation: searchFilteredValidation,
        filteredRejectedData: searchFilteredRejectedData,
      );
    }

    notifyListeners();
  }

  List<InvoiceSent> _filterInvoices(List<InvoiceSent> invoices, String query) {
    if (query.isEmpty) return invoices;
    return invoices.where((invoice) {
      final orgNameMatch = invoice.orgizationName.toLowerCase().contains(query);
      final candidateMatch = invoice.candidates.any(
        (candidate) => candidate.name.toLowerCase().contains(query),
      );
      return orgNameMatch || candidateMatch;
    }).toList();
  }

  List<InvoiceSent> _applyDateFilter(
    List<InvoiceSent> items,
    String? selectedMonth,
    String? selectedYear,
  ) {
    return items.where((item) {
      if (item.invoiceSubmitDate.isNotEmpty) {
        try {
          final date = DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
          return (selectedMonth == null ||
                  DateFormat('MM').format(date) == selectedMonth) &&
              (selectedYear == null ||
                  DateFormat('yyyy').format(date) == selectedYear);
        } catch (e) {
          return false;
        }
      }
      return false;
    }).toList();
  }
}

class PaymentStatusState {
  final PaymentStatusModel? paymentStatus;
  final List<InvoiceSent> filteredInvoices;
  final List<InvoiceSent> filteredPaidData;
  final List<InvoiceSent> filteredValidation;
  final List<InvoiceSent> filteredRejectedData;
  final String searchQuery;
  final Map<String, String>? selectedDate;
  final bool isLoading;
  final String? error;

  PaymentStatusState({
    this.paymentStatus,
    this.filteredInvoices = const [],
    this.filteredPaidData = const [],
    this.filteredValidation = const [],
    this.filteredRejectedData = const [],
    this.searchQuery = '',
    this.selectedDate,
    this.isLoading = false,
    this.error,
  });

  PaymentStatusState copyWith({
    PaymentStatusModel? paymentStatus,
    List<InvoiceSent>? filteredInvoices,
    List<InvoiceSent>? filteredPaidData,
    List<InvoiceSent>? filteredValidation,
    List<InvoiceSent>? filteredRejectedData,
    String? searchQuery,
    Map<String, String>? selectedDate,
    bool? isLoading,
    String? error,
  }) {
    return PaymentStatusState(
      paymentStatus: paymentStatus ?? this.paymentStatus,
      filteredInvoices: filteredInvoices ?? this.filteredInvoices,
      filteredPaidData: filteredPaidData ?? this.filteredPaidData,
      filteredValidation: filteredValidation ?? this.filteredValidation,
      filteredRejectedData: filteredRejectedData ?? this.filteredRejectedData,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<Map<String, dynamic>> get tabData {
    final tabs = <Map<String, dynamic>>[];

    if (filteredInvoices.isNotEmpty) {
      tabs.add({'name': 'Invoices Sent', 'data': filteredInvoices});
    }
    if (filteredValidation.isNotEmpty) {
      tabs.add({'name': 'Validation', 'data': filteredValidation});
    }
    if (filteredPaidData.isNotEmpty) {
      tabs.add({'name': 'Paid Data', 'data': filteredPaidData});
    }
    if (filteredRejectedData.isNotEmpty) {
      tabs.add({'name': 'Not Paid', 'data': filteredRejectedData});
    }

    return tabs;
  }
}
