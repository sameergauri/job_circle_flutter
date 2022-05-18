import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class UserDataService extends ServiceBase {
  saveUserStages(dynamic params) {
    return callPost(GlobalConstants.API_Users_v1_saveStages, params);
  }

  // Future<Response> getUser(int id) {
  //   return callGet(GlobalConstants.API_Users_v1_id + id.toString());
  // }

  Future<Response> masterGetByGroup(Map<String,String> params) {
    return callGet(GlobalConstants.API_master_group, param: params);
  }
}
