enum AnswerType { yesNo, singleChoice, multipleChoice, numeric }

class TempScreeningQuestions {
  String id;
  String questionText;
  AnswerType answerType;
  List<String> options;
  List<String> idealAnswers; // Holds multiple if type is multipleChoice
  bool isMustHave;

  TempScreeningQuestions({
    required this.id,
    required this.questionText,
    required this.answerType,
    required this.options,
    required this.idealAnswers,
    this.isMustHave = false,
  });
}
