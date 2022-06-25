import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class JobSearchService extends ServiceBase {
  getJobSearch(Map<String, String> params) {
    return callGet(GlobalConstants.API_jobs_v1_search, param: params);
  }

  getJobDetails(Map<String, String> params) {
    return callGet(GlobalConstants.API_jobs_v1_getJobDetailsById,
        param: params);
  }

  getDistinctProcessAndLevels(Map<String, String> params) {
    return callGet(GlobalConstants.API_jobs_v1_getDistinctProcessAndLevels,
        param: params);
  }
}
