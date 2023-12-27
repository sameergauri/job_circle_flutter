// ignore_for_file: file_names

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

  Future<Response> getPartnerUser(int id) {
    return callGet(GlobalConstants.API_partner_v1_user + id.toString());
  }
}
