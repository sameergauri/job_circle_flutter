import 'package:flutter/material.dart';
import 'package:job_circle/src/model/ats/ats_applied_page_model.dart';
import 'package:job_circle/src/services/ats_services/ats_services.dart';


class AppliedPageProvider with ChangeNotifier {
  AppliedJobModel? _atsData;
  bool _isLoading = false;
  String? _error;

  AppliedJobModel? get atsData => _atsData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAppliedJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _atsData = await ATSServices.fetchAppliedJobs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchAppliedJobs();
  }
}
