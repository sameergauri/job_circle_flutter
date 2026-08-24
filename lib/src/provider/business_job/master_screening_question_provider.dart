import 'package:flutter/material.dart';
import 'package:job_circle/src/model/business_job/master_screening_question.dart';
import 'package:job_circle/src/services/business_job/master_screening_question_service.dart';


class MasterScreeningQuestionProvider extends ChangeNotifier {
  final MasterScreeningQuestionService _service =
      MasterScreeningQuestionService();

  List<MasterScreeningQuestion> _questions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MasterScreeningQuestion> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllMasterQuestions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _service.getAllMasterQuestions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _questions = [];
    _errorMessage = null;
    notifyListeners();
  }
}
