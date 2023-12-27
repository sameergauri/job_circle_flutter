// ignore_for_file: file_names

import 'dart:developer';

import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/fav_job_model.dart';
import 'package:job_circle/service/ServiceBase.dart';

class JobSearchService extends ServiceBase {
  Future getJobSearch(Map<String, dynamic> params) {
    return callGetLocal(GlobalConstants.API_jobs_v1_search,
        param: params.cast<String, String>());
  }

  Future getcompany(Map<String, String> params) {
    return callGetLocal(GlobalConstants.API_company_name_v1, param: params);
  }

  Future<FavJobModel?> getFavoriteJob(int jobId) async {
    try {
      //on click pe job add to ho rahi hai
      var response = await callGetLocal("favjob/v1", param: {});
      if (response.statusCode == 200) {
        return FavJobModel.fromRawJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  getAppliedJobSearch() {
    return callGetLocal(
      GlobalConstants.API_jobs_v2,
    );
  }

  getJobDetails(Map<String, String> params) {
    return callGetLocal(GlobalConstants.API_jobs_v1_getJobDetailsById,
        param: params);
  } //old

  //new made by me
  getJobDetails1(Map<String, String> params) {
    return callGet(GlobalConstants.API_jobs_v1_getJobDetailsById,
        param: params);
  }

  getDistinctProcessAndLevels(Map<String, String> params) {
    return callGet(GlobalConstants.API_jobs_v1_getDistinctProcessAndLevels,
        param: params);
  }
}
