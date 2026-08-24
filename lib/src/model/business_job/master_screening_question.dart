class MasterScreeningQuestion {
  final int id;
  final int questionBankId;
  final String questionText;
  final String questionCategory;
  final String questionType;
  final String? questionHeading;
  final String createdAt;
  final String updatedAt;

  MasterScreeningQuestion({
    required this.id,
    required this.questionBankId,
    required this.questionText,
    required this.questionCategory,
    required this.questionType,
    this.questionHeading,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MasterScreeningQuestion.fromJson(Map<String, dynamic> json) {
    return MasterScreeningQuestion(
      id: json['id'] ?? 0,
      questionBankId: json['questionBankId'] ?? 0,
      questionText: json['questionText'] ?? '',
      questionCategory: json['questionCategory'] ?? '',
      questionType: json['questionType'] ?? '',
      questionHeading: json['questionHeading'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionBankId': questionBankId,
      'questionText': questionText,
      'questionCategory': questionCategory,
      'questionType': questionType,
      'questionHeading': questionHeading,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
