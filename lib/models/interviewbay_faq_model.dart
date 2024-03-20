class InterviewFaqGetModel {
  String? answer;
  String? question;
  String? lastName;
  String? icon;
  int? crpfid;
  String? shortCode;
  String? name;
  String? process;
  String? roleName;
  int? companyId;
  String? firstName;
  int? userId;
  int? id;
  String? natureOfWork;

  InterviewFaqGetModel({
    this.answer,
    this.question,
    this.lastName,
    this.icon,
    this.crpfid,
    this.shortCode,
    this.name,
    this.process,
    this.roleName,
    this.companyId,
    this.firstName,
    this.userId,
    this.id,
    this.natureOfWork,
  });

  factory InterviewFaqGetModel.fromJson(Map<String, dynamic> json) {
    return InterviewFaqGetModel(
      answer: json['answer'],
      question: json['question'],
      lastName: json['last_name'],
      icon: json['icon'],
      crpfid: json['crpfid'],
      shortCode: json['short_code'],
      name: json['companyname'],
      process: json['process'],
      roleName: json['rolename'],
      companyId: json['compnayid'],
      firstName: json['first_name'],
      userId: json['user_id'],
      id: json['id'],
      natureOfWork: json['functional_area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'question': question,
      'last_name': lastName,
      'icon': icon,
      'crpfid': crpfid,
      'short_code': shortCode,
      'name': name,
      'process': process,
      'roleName': roleName,
      'compnayid': companyId,
      'first_name': firstName,
      'user_id': userId,
      'id': id,
      'functional_area': natureOfWork,
    };
  }
}
