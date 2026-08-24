import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/model/business_ats/update_ats_model.dart';
import 'package:job_circle/src/services/business_ats/business_ats_service.dart';

class AtsProvider extends ChangeNotifier {
  final AtsService _service = AtsService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AtsResultData? _atsData;
  AtsResultData? get atsData => _atsData;

  String _selectedStatus = '';
  String get selectedStatus => _selectedStatus;

  final TextEditingController remark = TextEditingController();

  Future<void> loadAtsData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.fetchAtsData();
      if (response.resultKey == 'SUCCESS' && response.resultData != null) {
        _atsData = response.resultData;

        // Auto-select the first tab that has candidates
        _autoSelectActiveTab();
      } else {
        _errorMessage = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'No data available';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _autoSelectActiveTab() {
    if (_atsData == null || _atsData!.atsData.isEmpty) {
      _selectedStatus = '';
      return;
    }

    // Pick first status with available applicants
    for (final entry in _atsData!.atsData.entries) {
      if (entry.value.isNotEmpty) {
        _selectedStatus = entry.key;
        return;
      }
    }

    _selectedStatus = _atsData!.atsData.keys.first;
  }

  void selectStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  List<AtsApplicant> get currentApplicants {
    if (_atsData == null) return [];

    // If no tab selected, combine all applicants across all tabs
    if (_selectedStatus.isEmpty) {
      return _atsData!.atsData.values
          .expand((applicants) => applicants)
          .toList();
    }

    return _atsData!.atsData[_selectedStatus] ?? [];
  }

  Future<void> updateLead(
    BuildContext context,
    UpdateAtsModel leadModel,
    int leadId,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.updateLead(leadModel, leadId);
      await loadAtsData();
      CustomSnackbar.show("Lead Updated Successfully", false);
      remark.clear();
    } catch (e) {
      CustomSnackbar.show("Error while updating lead", true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    remark.dispose();
    super.dispose();
  }
}
