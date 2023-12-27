// ignore_for_file: file_names

import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class LeadService extends ServiceBase {
  getLoadCounts(dynamic params) {
    return callPost(GlobalConstants.API_lead_counts, params);
  }

  getAllLeadsAdvanced(dynamic params) {
    return callPost(GlobalConstants.API_leads_v1_getAllLeadsAdvanced, params);
  }
}
