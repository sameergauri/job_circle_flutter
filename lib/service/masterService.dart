import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class MasterService extends ServiceBase {
  saveMaster(dynamic params) {
    return callPost(GlobalConstants.API_master_v1, params);
  }

  Future<Response> getMaster(Map<String, String> params) {
    return callGet(GlobalConstants.API_master_v1, param: params);
  }
}
