// ignore_for_file: file_names

import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/service/ServiceBase.dart';

class ApplicationService extends ServiceBase {
  saveApplication(dynamic params) {
    return callPostLocal(GlobalConstants.API_jobs_v2_jobs_13_apply, params);
  }
}
