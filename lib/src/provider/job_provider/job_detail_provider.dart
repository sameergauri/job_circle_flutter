// providers/job_detail_provider.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/widgets/dialogue/custom_dialogue_for_add_resume.dart';

class JobDetailProvider extends ChangeNotifier {
  JobDetailPageModel? jobDetail;
  bool _isLoading = false;
  bool _applyLoading = false;
  String? error;

  bool get isLoading => _isLoading;
  bool get applyLoading => _applyLoading;

  Future<void> fetchJobDetails(int jobId) async {
    var userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);

    try {
      // Reset state before loading
      _isLoading = true;
      error = null;
      jobDetail = null;
      notifyListeners();

      final url =
          "${GlobalConstants.getJobDetailUrl}jobId=$jobId&userId=$userId";

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['resultKey'] == 'SUCCESS') {
          final jobData = jsonData['resultData']['jobDetails'];
          jobDetail = JobDetailPageModel.fromJson(jobData);
          _isLoading = false;
          notifyListeners();
        } else {
          error = jsonData['errorMessage'] ?? 'Failed to load job details';
          _isLoading = false;
          notifyListeners();
        }
      } else {
        error = 'Request failed with status: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      error = 'An error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyJob(int jobId, int userId, BuildContext context) async {
    _applyLoading = true;
    notifyListeners();

    try {
      final message = await AddResumeAndApplyService.postJobApply(
        jobId: jobId,
        userId: userId,
      );

      if (message.contains("Successfully")) {
        // ✅ Success dialogue
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialogueForAddResume(
              error: false,
              onClose: () {
               NavigationService.pop();
                _applyLoading = false;
                notifyListeners();
              },
              subtitle: message,
            );
          },
        );
      } else {
        // ❌ Error snackbar
        CustomSnackbar.show(message, true);
        _applyLoading = false;
        notifyListeners();
      }
    } catch (e) {
      CustomSnackbar.show("Unexpected error: $e", true);
      _applyLoading = false;
      notifyListeners();
    } finally {
      // ✅ Always reset loading
      _applyLoading = false;
      notifyListeners();
    }
  }

  void clearJobDetails() {
    jobDetail = null;
    notifyListeners();
  }
}
