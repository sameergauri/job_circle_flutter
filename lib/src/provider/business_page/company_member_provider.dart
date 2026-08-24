import 'package:flutter/material.dart';
import 'package:job_circle/src/model/business_page/company_memeber_model.dart';
import 'package:job_circle/src/services/business_page/comapny_member_service.dart';


class CompanyMembershipProvider extends ChangeNotifier {
  final CompanyMembershipService _service = CompanyMembershipService();

  List<CompanyMembershipModel> _memberships = [];
  List<CompanyMembershipModel> get memberships => _memberships;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMembershipSummary({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _memberships = await _service.fetchMembershipSummary(userId: userId);
    } catch (e) {
      _errorMessage = e.toString();
      _memberships = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _memberships = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
