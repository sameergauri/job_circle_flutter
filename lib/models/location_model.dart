class MyModel {
  final String resultKey;
  final ResultData? resultData;
  final String? code;
  final String? errorMessage;

  MyModel({
    required this.resultKey,
    this.resultData,
    this.code,
    this.errorMessage,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      resultKey: json['resultKey'],
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class ResultData {
  final List<Content>? content;
  final int? pageNumber;
  final int? pageSize;
  final int? total;

  ResultData({
    this.content,
    this.pageNumber,
    this.pageSize,
    this.total,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      content: json['content'] != null
          ? List<Content>.from(json['content'].map((x) => Content.fromJson(x)))
          : null,
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      total: json['total'],
    );
  }
}

class Content {
  final String? name;
  final String? id;

  Content({this.name, this.id});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(name: json['city'], id: json['city_id']);
  }
}
