import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class CompanyService extends ServiceBase {
  Future<Response> getCompanies(Map<String, String> params) {
    return callGet(GlobalConstants.API_company_v1_all, param: params);
  }
}
