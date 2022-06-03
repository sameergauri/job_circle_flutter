import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class ApplicationService extends ServiceBase {
  saveApplication(dynamic params) {
    return callPost(GlobalConstants.API_leads_v1, params);
  }
}