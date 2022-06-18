import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class PartnerService extends ServiceBase {
  savePartner(dynamic params) {
    return callPost(GlobalConstants.API_partner_v1, params);
  }

  Future<Response> getPartner(int id) {
    return callGet(GlobalConstants.API_partner_get_v1 + id.toString());
  }
}
