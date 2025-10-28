import 'package:flutter/material.dart';

import 'package:job_circle/src/model/ats/ats_referal_page_model.dart';
import 'package:job_circle/src/services/ats_services/ats_services.dart';

class ReferalPageProvider with ChangeNotifier {
  ATSReferalPageModel? _atsData;
  bool _isLoading = false;
  String? _error;

  ATSReferalPageModel? get atsData => _atsData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReleralJob() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _atsData = await ATSServices.fetchReferalJobs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchReleralJob();
  }
}
