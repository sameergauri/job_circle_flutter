// providers/job_detail_provider.dart

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
  List<JobDetailScreeningQuestion> screeningQuestions = [];
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
      screeningQuestions = [];
      notifyListeners();

      final url =
          "${GlobalConstants.getJobDetailUrl}jobId=$jobId&userId=$userId";

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['resultKey'] == 'SUCCESS') {
          final resultData = jsonData['resultData'];
          jobDetail = JobDetailPageModel.fromJson(resultData['jobDetails']);
          screeningQuestions =
              (resultData['screeningQuestions'] as List<dynamic>? ?? [])
                  .map(
                    (q) => JobDetailScreeningQuestion.fromJson(
                      q as Map<String, dynamic>,
                    ),
                  )
                  .toList();
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

  // apply with screening questions
  // providers/job_detail_provider.dart mein yeh states aur methods add karo

  // ⚡ User ke live answers save rakhne ke liye maps (Key = Question ID)
  final Map<int, List<String>> _selectedOptionsMap = {};
  final Map<int, int> _numericAnswersMap = {};
  int _resetCounter = 0;
  int get resetCounter => _resetCounter;

  Map<int, List<String>> get selectedOptionsMap => _selectedOptionsMap;
  Map<int, int> get numericAnswersMap => _numericAnswersMap;

  // Answers update karne ke functions (Form UI isko call karega)
  void updateOptionAnswer(
    int questionId,
    List<String> options, {
    bool isMultiple = false,
  }) {
    if (isMultiple) {
      _selectedOptionsMap[questionId] = options;
    } else {
      _selectedOptionsMap[questionId] = options.take(1).toList();
    }
    notifyListeners();
  }

  void updateNumericAnswer(int questionId, int val) {
    _numericAnswersMap[questionId] = val;
    notifyListeners();
  }

  // ⚡ BACKEND AS PER YOUR SPECIFIC JSON FORMAT PAYLOAD GENERATOR
  List<Map<String, dynamic>> getFinalAnswersPayload() {
    return screeningQuestions.map((q) {
      final qId = q.id ?? 0;
      return {
        "numericAnswer": _numericAnswersMap[qId] ?? 0,
        "screeningQuestionId": qId,
        "selectedOptions": _selectedOptionsMap[qId] ?? [],
      };
    }).toList();
  }

  bool isEligible() {
    for (final q in screeningQuestions) {
      if (q.allowToLead != true) continue;

      final qId = q.id ?? 0;

      if (q.questionType == "NUMERIC") {
        final userAnswer = _numericAnswersMap[qId] ?? 0;
        final threshold = q.numericOption ?? 0;
        if (userAnswer <= threshold) return false;
      } else {
        final userSelected = _selectedOptionsMap[qId] ?? [];
        final correct = q.correctOptions ?? [];
        final allCorrect = correct.every((c) => userSelected.contains(c));
        if (!allCorrect) return false;
      }
    }
    return true;
  }

  Future<void> submitApplicationWithScreening(
    int jobId,
    int userId,
    BuildContext context,
    bool isEligible,
    int? refid,
  ) async {
    _applyLoading = true;
    notifyListeners();

    // ⚡ Agar sawal hain toh payload banao, nahi toh khali list [] bhejo
    final answersPayload = screeningQuestions.isNotEmpty
        ? getFinalAnswersPayload()
        : <Map<String, dynamic>>[];
    print("🚀 Payload sending to Backend: ${jsonEncode(answersPayload)}");

    try {
      String message = await AddResumeAndApplyService.postJobApply(
        jobId: jobId,
        userId: userId,
        screeningAnswers: answersPayload,
        isEligible: isEligible,
        refid: refid,
      );
      if (message.contains("Successfully") && context.mounted) {
        isEligible
            ? showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => CustomDialogueForApply(
                  success: true,
                  onClose: () {
                    NavigationService.popUntil((p0) => p0.isFirst);
                    _applyLoading = false;
                    notifyListeners();
                  },
                  title: message,
                  subtitle: "",
                ),
              )
            : showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => CustomDialogueForApply(
                  success: false,
                  title: "Screening Criteria Not Met",
                  onClose: () {
                    NavigationService.popUntil((p0) => p0.isFirst);
                    _applyLoading = false;
                    notifyListeners();
                  },
                  subtitle:
                      "Thank you for your interest in this opportunity. Based on your screening responses, you have not been shortlisted for this position. We appreciate your interest and wish you success in your job search.",
                ),
              );
      } else {
        CustomSnackbar.show(message, true);
        NavigationService.popUntil((p0) => p0.isFirst);
      }
    } catch (e) {
      CustomSnackbar.show("Unexpected error: $e", true);
    } finally {
      _applyLoading = false;
      notifyListeners();
    }
  }

  /*   Future<void> applyJob(int jobId, int userId, BuildContext context) async {
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
  } */

  void clearAnswers() {
    _selectedOptionsMap.clear();
    _numericAnswersMap.clear();
    _resetCounter++;
    notifyListeners();
  }

  void setLoading(bool value) {
    _applyLoading = value;
    notifyListeners();
  }

  void clearJobDetails() {
    jobDetail = null;
    notifyListeners();
  }

  /// Share Job Function (Provider mein)
  Future<Map<String, dynamic>> shareJob({
    required int jobId,
    String shareMedium = 'others',
  }) async {
    try {
      // Get current user id from Shared Preferences
      final int currentUserId = SharedPrefsHelper.getInt(
        ESharedPreferences.user_id,
      );

      final Map<String, dynamic> requestBody = {
        "jobId": jobId,
        "userId": currentUserId,
        "shareMedium": shareMedium,
      };
      final response = await http.post(
        Uri.parse(GlobalConstants.sharejob),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final bool resultKey = jsonData["success"] ?? "ERROR";

        if (resultKey == true) {
          return {
            "success": true,
            "shareCode": jsonData['shareCode'] ?? "",
            "shareUrl": jsonData['shareUrl'] ?? "",
            "message": "Job shared successfully!",
          };
        } else {
          return {"success": false, "message": "Failed to share job"};
        }
      } else {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}",
        };
      }
    } catch (e) {
      print("Error in shareJob: $e");
      return {
        "success": false,
        "message": "Something went wrong while sharing",
      };
    }
  }
}
