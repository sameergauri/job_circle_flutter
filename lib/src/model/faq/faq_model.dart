class FaqCategory {
  final int id;
  final String name;

  FaqCategory({required this.id, required this.name});

  factory FaqCategory.fromJson(Map<String, dynamic> json) {
    return FaqCategory(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class FaqItem {
  final int id;
  final FaqCategory category;
  final String appType;
  final String question;
  final String answer;

  FaqItem({
    required this.id,
    required this.category,
    required this.appType,
    required this.question,
    required this.answer,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] ?? 0,
      category: FaqCategory.fromJson(json['category'] ?? {}),
      appType: json['appType'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class FaqResponse {
  final String resultKey;
  final List<FaqItem> resultData;
  final String code;
  final String errorMessage;

  FaqResponse({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    var list = json['resultData'] as List? ?? [];
    List<FaqItem> faqList = list.map((i) => FaqItem.fromJson(i)).toList();

    return FaqResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: faqList,
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}
