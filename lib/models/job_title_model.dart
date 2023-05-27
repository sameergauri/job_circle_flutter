class JobTitleModel {
  final String id;
  final String value;

  JobTitleModel({required this.id, required this.value});

  factory JobTitleModel.fromJson(Map<String, dynamic> json) {
    return JobTitleModel(
      id: json['id'].toString(),
      value: json['value'].toString(),
    );
  }
}