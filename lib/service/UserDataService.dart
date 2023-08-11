import 'package:http/http.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class UserDataService extends ServiceBase {
  saveUserStages(dynamic params) {
    return callPost(GlobalConstants.API_Users_v1_saveStages, params);
  }

  authenticate(dynamic params) {
    return callPost(GlobalConstants.API_Users_v1_authenticate, params);
  }

  verifySession(dynamic params) {
    return callPost(GlobalConstants.API_Users_v1_verifySession, params);
  }

  validateOTP(dynamic params) {
    return callPost(GlobalConstants.API_Users_v1_validateOTP, params);
  }

  // activity(dynamic params) {
  //   return callPut(GlobalConstants.API_Users_v1_activity, params);
  // }

  Future<Response> getUserProfileSummary(int id) {
    return callGet(GlobalConstants.API_Users_v1_profileSummary + id.toString());
  }

  Future<Response> getUserDetails(int id) {
    return callGet(GlobalConstants.API_Users_v1_userDetails + id.toString());
  }

  Future<Response> getAllUserDetails() {
    return callGet(GlobalConstants.API_Users_v1_allUserDetails);
  }

  saveUserExperience(dynamic params) {
    return callPost(GlobalConstants.API_Exp_v1, params);
  }

  saveUserEducation(dynamic params) {
    return callPost(GlobalConstants.API_Edu_v1, params);
  }
}
