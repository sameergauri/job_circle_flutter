class InterviewFaqPost {
  final String answer;
  final int id;
  final int crpfid;
  final String question;
  final int userId;

  InterviewFaqPost({
    required this.answer,
    required this.id,
    required this.crpfid,
    required this.question,
    required this.userId,
  });

  factory InterviewFaqPost.fromJson(Map<String, dynamic> json) {
    return InterviewFaqPost(
      answer: json['answer'],
      id: json['id'],
      crpfid: json['crpfid'],
      question: json['question'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = answer;
    data['id'] = id;
    data['crpfid'] = crpfid;
    data['question'] = question;
    data['userId'] = userId;
    return data;
  }
}
