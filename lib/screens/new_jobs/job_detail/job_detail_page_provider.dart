// providers/job_detail_provider.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/job_detail/job_detail_page_model.dart';

final jobDetailProvider =
    StateNotifierProvider<JobDetailNotifier, JobDetailState>((ref) {
  return JobDetailNotifier();
});

class JobDetailState {
  final JobDetailPageModel? jobDetail;
  final bool isLoading;
  final String? error;

  JobDetailState({
    this.jobDetail,
    this.isLoading = false,
    this.error,
  });

  JobDetailState copyWith({
    JobDetailPageModel? jobDetail,
    bool? isLoading,
    String? error,
  }) {
    return JobDetailState(
      jobDetail: jobDetail ?? this.jobDetail,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class JobDetailNotifier extends StateNotifier<JobDetailState> {
  JobDetailNotifier() : super(JobDetailState());

  Future<void> fetchJobDetails(int jobId) async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);

    try {
      // Reset jobDetail to null before loading
      state = JobDetailState(isLoading: true);

      final url =
          "http://${GlobalConstants.API_Host_one}/api/jobs/v1/getJobDetailsByJobId?jobId=$jobId&userId=$userid";

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['resultKey'] == 'SUCCESS') {
          final jobData = jsonData['resultData']['jobDetails'];
          final jobDetail = JobDetailPageModel.fromJson(jobData);
          state = state.copyWith(jobDetail: jobDetail, isLoading: false);
        } else {
          state = JobDetailState(
            error: jsonData['errorMessage'] ?? 'Failed to load job details',
          );
        }
      } else {
        state = JobDetailState(
          error: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = JobDetailState(error: 'An error occurred: ${e.toString()}');
    }
  }

  void clearJobDetails() {
    state = state.copyWith(jobDetail: null);
  }
}
