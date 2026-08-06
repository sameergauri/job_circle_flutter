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
  final int likeCount;
  final int dislikeCount;
  final bool userLiked;
  final bool userDisliked;

  FaqItem({
    required this.id,
    required this.category,
    required this.appType,
    required this.question,
    required this.answer,
    required this.dislikeCount,
    required this.likeCount,
    required this.userDisliked,
    required this.userLiked,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] ?? 0,
      category: FaqCategory.fromJson(json['category'] ?? {}),
      appType: json['appType'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      dislikeCount: json['dislikeCount'],
      likeCount: json['likeCount'],
      userDisliked: json['userDisliked'],
      userLiked: json['userLiked'],
    );
  }
  FaqItem copyWith({
    int? id,
    FaqCategory? category,
    String? appType,
    String? question,
    String? answer,
    int? likeCount,
    int? dislikeCount,
    bool? userLiked,
    bool? userDisliked,
  }) {
    return FaqItem(
      id: id ?? this.id,
      category: category ?? this.category,
      appType: appType ?? this.appType,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      userLiked: userLiked ?? this.userLiked,
      userDisliked: userDisliked ?? this.userDisliked,
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
