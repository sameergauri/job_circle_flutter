// providers/invoice_provider.dart
import 'package:flutter/foundation.dart';
import 'package:job_circle/src/model/referal_program/joiners_model.dart';
import 'package:job_circle/src/model/referal_program/submit_invoice_model.dart';
import 'package:job_circle/src/services/referal_program/referal_program_service.dart';

class InvoiceProvider with ChangeNotifier {

  InvoiceState _state = InvoiceState();

  InvoiceState get state => _state;

  void initializeData(List<JoinerData> joinersdata) {
    final invoiceNumber = _generateInvoiceNumber(
      joinersdata.isNotEmpty
          ? joinersdata.first.referralId!.toString()
          : '0000',
    );

    final organizationList = _extractOrganizations(joinersdata);

    _state = InvoiceState(
      joinersData: joinersdata,
      filteredJoiners: joinersdata,
      organizationList: organizationList,
      invoiceNumber: invoiceNumber,
      isLoading: false,
    );

    notifyListeners();
  }

  void filterByOrganization(String? orgId) {
    if (orgId == null) {
      _state = _state.copyWith(
        filteredJoiners: _state.joinersData,
        selectedOrganization: null,
      );
    } else {
      final org = _state.organizationList.firstWhere((org) => org.id == orgId);
      final filtered = _state.joinersData
          .where((joiner) => joiner.organizationId == int.tryParse(orgId))
          .toList();

      _state = _state.copyWith(
        filteredJoiners: filtered,
        selectedOrganization: org,
      );
    }

    notifyListeners();
  }

  void setTermsCondition(bool value) {
    _state = _state.copyWith(termsAccepted: value);
    notifyListeners();
  }

  Future<void> submitInvoice() async {
    try {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      if (_state.selectedOrganization == null) {
        throw Exception('Please select an organization');
      }

      if (!_state.termsAccepted) {
        throw Exception('Please accept the terms and conditions');
      }

      final invoiceData = SubmitInvoiceModel(
        invoiceAmount: _calculateTotalAmount(),
        invoiceDate: DateTime.now(),
        invoiceNumber: _state.invoiceNumber,
        leadId: _state.filteredJoiners
            .map((e) => e.id)
            .whereType<int>()
            .toSet()
            .toList(),
        orgId: int.tryParse(_state.selectedOrganization!.id) ?? 0,
        status: 'invoicesent',
      );

      final success = await ReferalProgramService.submitInvoice(invoiceData);

      if (success) {
        _state = _state.copyWith(
          isLoading: false,
          submissionSuccess: true,
          error: null,
        );
      } else {
        throw Exception('Failed to submit invoice');
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
        submissionSuccess: false,
      );
    }

    notifyListeners();
  }

  void resetState() {
    _state = InvoiceState(
      joinersData: _state.joinersData,
      filteredJoiners: _state.joinersData,
      organizationList: _state.organizationList,
      invoiceNumber: _state.invoiceNumber,
      isLoading: false,
    );
    notifyListeners();
  }

  int _calculateTotalAmount() {
    return _state.filteredJoiners.fold(0, (sum, joiner) {
      return sum + (joiner.partnerPayout ?? 0.0).toInt();
    });
  }

  String _generateInvoiceNumber(String userId) {
    final datePart = _formatDate(DateTime.now(), 'ddMM');
    final randomCode = 1000 + DateTime.now().millisecond % 9000;
    return '$datePart/$userId/$randomCode';
  }

  String _formatDate(DateTime date, String format) {
    // Simplified date formatting
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return format.replaceAll('dd', day).replaceAll('MM', month);
  }

  List<OrganizationInfo> _extractOrganizations(List<JoinerData> joiners) {
    final uniqueOrgs = <String, OrganizationInfo>{};

    for (var joiner in joiners) {
      final String orgId = (joiner.organizationId ?? '').toString();
      final orgName = joiner.organizationName ?? '';
      final orgAddress = joiner.organizationFullAddress ?? '';

      if (orgId.isNotEmpty && !uniqueOrgs.containsKey(orgId)) {
        uniqueOrgs[orgId] = OrganizationInfo(
          id: orgId,
          name: orgName,
          address: orgAddress,
        );
      }
    }

    return uniqueOrgs.values.toList();
  }
}

class InvoiceState {
  final List<JoinerData> joinersData;
  final List<JoinerData> filteredJoiners;
  final List<OrganizationInfo> organizationList;
  final OrganizationInfo? selectedOrganization;
  final String invoiceNumber;
  final bool termsAccepted;
  final bool isLoading;
  final bool submissionSuccess;
  final String? error;

  InvoiceState({
    this.joinersData = const [],
    this.filteredJoiners = const [],
    this.organizationList = const [],
    this.selectedOrganization,
    this.invoiceNumber = '',
    this.termsAccepted = false,
    this.isLoading = false,
    this.submissionSuccess = false,
    this.error,
  });

  InvoiceState copyWith({
    List<JoinerData>? joinersData,
    List<JoinerData>? filteredJoiners,
    List<OrganizationInfo>? organizationList,
    OrganizationInfo? selectedOrganization,
    String? invoiceNumber,
    bool? termsAccepted,
    bool? isLoading,
    bool? submissionSuccess,
    String? error,
  }) {
    return InvoiceState(
      joinersData: joinersData ?? this.joinersData,
      filteredJoiners: filteredJoiners ?? this.filteredJoiners,
      organizationList: organizationList ?? this.organizationList,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isLoading: isLoading ?? this.isLoading,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      error: error ?? this.error,
    );
  }

  int get totalAmount {
    return filteredJoiners.fold(0, (sum, joiner) {
      return sum + (joiner.partnerPayout ?? 0.0).toInt();
    });
  }
}

class OrganizationInfo {
  final String id;
  final String name;
  final String address;

  OrganizationInfo({
    required this.id,
    required this.name,
    required this.address,
  });
}
