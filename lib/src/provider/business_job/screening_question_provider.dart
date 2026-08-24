import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/model/business_job/business_job_model.dart';
import 'package:job_circle/src/model/business_job/master_screening_question.dart';
import 'package:job_circle/src/model/business_job/temp_screening_question_model.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';

class ScreeningQuestionProvider extends ChangeNotifier {
  final List<TempScreeningQuestions> _savedQuestions = [];
  List<TempScreeningQuestions> get savedQuestions => _savedQuestions;

  int _idCounter = 0;

  final TextEditingController questionController = TextEditingController();
  final TextEditingController numericController = TextEditingController();
  final TextEditingController inlineOptionController = TextEditingController();

  AnswerType _selectedAnswerType = AnswerType.yesNo;
  AnswerType get selectedAnswerType => _selectedAnswerType;

  List<String> _currentOptions = ['Yes', 'No'];
  List<String> get currentOptions => _currentOptions;

  int _editingOptionIndex = -1;
  int get editingOptionIndex => _editingOptionIndex;

  bool _isAddingNewOption = false;
  bool get isAddingNewOption => _isAddingNewOption;

  List<String> _selectedIdealAnswers = ['Yes'];
  List<String> get selectedIdealAnswers => _selectedIdealAnswers;

  bool _isMustHave = false;
  bool get isMustHave => _isMustHave;

  String? _editingQuestionId;
  bool get isEditing => _editingQuestionId != null;

  void changeAnswerType(AnswerType type) {
    _selectedAnswerType = type;
    _currentOptions.clear();
    _selectedIdealAnswers.clear();
    _isAddingNewOption = false;
    _editingOptionIndex = -1;
    inlineOptionController.clear();

    if (type == AnswerType.yesNo) {
      _currentOptions = ['Yes', 'No'];
      _selectedIdealAnswers = ['Yes'];
    }
    notifyListeners();
  }

  void showNewOptionField() {
    _editingOptionIndex = -1;
    _isAddingNewOption = true;
    inlineOptionController.clear();
    notifyListeners();
  }

  void startEditingOption(int index) {
    _isAddingNewOption = false;
    _editingOptionIndex = index;
    inlineOptionController.text = _currentOptions[index];
    notifyListeners();
  }

  void submitInlineOption() {
    String text = inlineOptionController.text.trim();
    if (text.isEmpty) {
      cancelInlineEditing();
      return;
    }

    if (_isAddingNewOption) {
      if (!_currentOptions.contains(text)) {
        _currentOptions.add(text);
      }
      _isAddingNewOption = false;
    } else if (_editingOptionIndex != -1) {
      String oldVal = _currentOptions[_editingOptionIndex];
      _currentOptions[_editingOptionIndex] = text;

      int idealIdx = _selectedIdealAnswers.indexOf(oldVal);
      if (idealIdx != -1) _selectedIdealAnswers[idealIdx] = text;

      _editingOptionIndex = -1;
    }

    inlineOptionController.clear();
    notifyListeners();
  }

  void cancelInlineEditing() {
    _isAddingNewOption = false;
    _editingOptionIndex = -1;
    inlineOptionController.clear();
    notifyListeners();
  }

  void removeOption(int index) {
    String optionRemoved = _currentOptions[index];
    _currentOptions.removeAt(index);
    _selectedIdealAnswers.remove(optionRemoved);
    if (_editingOptionIndex == index) _editingOptionIndex = -1;
    notifyListeners();
  }

  void toggleIdealMultipleChoiceAnswer(String value) {
    if (_selectedIdealAnswers.contains(value)) {
      _selectedIdealAnswers.remove(value);
    } else {
      _selectedIdealAnswers.add(value);
    }
    notifyListeners();
  }

  void setSingleIdealAnswer(String value) {
    _selectedIdealAnswers = [value];
    notifyListeners();
  }

  void toggleMustHave(bool? value) {
    _isMustHave = value ?? false;
    notifyListeners();
  }

  void loadFromMaster(MasterScreeningQuestion master) {
    _editingQuestionId = null;
    questionController.text = master.questionText;

    if (master.questionType == "YES_NO") {
      _selectedAnswerType = AnswerType.yesNo;
      _currentOptions = ['Yes', 'No'];
      _selectedIdealAnswers = ['Yes'];
    } else {
      _selectedAnswerType = AnswerType.singleChoice;
      _currentOptions = [];
      _selectedIdealAnswers = [];
    }

    _isMustHave = false;
    _isAddingNewOption = false;
    _editingOptionIndex = -1;
    inlineOptionController.clear();
    numericController.clear();

    notifyListeners();
  }

  void saveQuestion(BuildContext context, {VoidCallback? afterSave}) {
    if (questionController.text.trim().isEmpty) {
      CustomSnackbar.show("Question text is required", true);
      return;
    }

    List<String> finalIdeal = [];
    if (_selectedAnswerType == AnswerType.numeric) {
      finalIdeal = [numericController.text.trim()];
    } else {
      finalIdeal = List.from(_selectedIdealAnswers);
    }

    final newQuestion = TempScreeningQuestions(
      id: isEditing
          ? _editingQuestionId!
          : '${DateTime.now().millisecondsSinceEpoch}_${++_idCounter}',
      questionText: questionController.text.trim(),
      answerType: _selectedAnswerType,
      options: List.from(_currentOptions),
      idealAnswers: finalIdeal,
      isMustHave: _isMustHave,
    );

    if (isEditing) {
      int index = _savedQuestions.indexWhere((q) => q.id == _editingQuestionId);
      if (index != -1) {
        _savedQuestions[index] = newQuestion;
      }
    } else {
      _savedQuestions.add(newQuestion);
    }

    notifyListeners();
    clearForm();
    if (afterSave != null) {
      afterSave();
    } else {
      NavigationService.pop();
    }
  }

  void loadQuestionForEdit(TempScreeningQuestions question) {
    _editingQuestionId = question.id;
    questionController.text = question.questionText.toString();
    _selectedAnswerType = question.answerType;
    _currentOptions = List.from(question.options);
    _isMustHave = question.isMustHave;
    _isAddingNewOption = false;
    _editingOptionIndex = -1;

    if (question.answerType == AnswerType.numeric) {
      numericController.text = question.idealAnswers.isNotEmpty
          ? question.idealAnswers[0]
          : '';
      _selectedIdealAnswers = [];
    } else {
      _selectedIdealAnswers = List.from(question.idealAnswers);
      numericController.clear();
    }

    notifyListeners();
  }

  void deleteQuestion(String id) {
    _savedQuestions.removeWhere((q) => q.id == id);
    notifyListeners();
  }

  void loadFromJobDetail(List<JobDetailScreeningQuestion> questions) {
    _savedQuestions.clear();

    final letterMap = {
      'A': 0,
      'B': 1,
      'C': 2,
      'D': 3,
      'E': 4,
      'F': 5,
      'G': 6,
      'H': 7,
    };

    for (final q in questions) {
      final opts = [
        q.optionA,
        q.optionB,
        q.optionC,
        q.optionD,
        q.optionE,
        q.optionF,
        q.optionG,
        q.optionH,
      ].whereType<String>().toList();

      AnswerType answerType;
      switch (q.questionType) {
        case 'YES_NO':
          answerType = AnswerType.yesNo;
          break;
        case 'MULTIPLE_SELECT':
          answerType = AnswerType.multipleChoice;
          break;
        case 'NUMERIC':
          answerType = AnswerType.numeric;
          break;
        default:
          answerType = AnswerType.singleChoice;
      }

      List<String> idealAnswers;
      if (answerType == AnswerType.numeric) {
        final numOpt = q.numericOption;
        idealAnswers = (numOpt != null && numOpt.toString().isNotEmpty)
            ? <String>[numOpt.toString().replaceAll(".0", "")]
            : <String>[];
      } else {
        idealAnswers = (q.correctOptions ?? []).map((letter) {
          final idx = letterMap[letter.toUpperCase()];
          return (idx != null && idx < opts.length) ? opts[idx] : letter;
        }).toList();
      }

      _savedQuestions.add(
        TempScreeningQuestions(
          id:
              q.id?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          questionText: q.questionText ?? '',
          answerType: answerType,
          options: opts,
          idealAnswers: idealAnswers,
          isMustHave: q.required ?? false,
        ),
      );
    }
    notifyListeners();
  }

  void clearForm() {
    questionController.clear();
    numericController.clear();
    inlineOptionController.clear();
    _selectedAnswerType = AnswerType.yesNo;
    _currentOptions = ['Yes', 'No'];
    _selectedIdealAnswers = ['Yes'];
    _isMustHave = false;
    _editingQuestionId = null;
    _isAddingNewOption = false;
    _editingOptionIndex = -1;
  }
}
