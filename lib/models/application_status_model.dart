// ignore_for_file: non_constant_identifier_names

class ApplicationStatusModel {
  final String? resultKey;
  final ResultData? resultData;
  final String? code;
  final String? errorMessage;

  ApplicationStatusModel({
    this.resultKey,
    this.resultData,
    this.code,
    this.errorMessage,
  });

  factory ApplicationStatusModel.fromJson(Map<String, dynamic> json) {
    return ApplicationStatusModel(
      resultKey: json['resultKey'] as String?,
      resultData: ResultData.fromJson(json['resultData']),
      code: json['code'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

class ResultData {
  final List<Application>? content;
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
      content: (json['content'] as List<dynamic>?)
          ?.map((data) => Application.fromJson(data))
          .toList(),
      pageNumber: json['pageNumber'] as int?,
      pageSize: json['pageSize'] as int?,
      total: json['total'] as int?,
    );
  }
}

class Application {
  final int? id;
  final String? groupName;
  final String? code;
  final String? value;
  final int? active;
  final int? deleted;
  final String? urlSlug;
  final int? parentid;
  final String? parentname;
  final int? parent_id;
  final String? parent_name;
  final int? orderno;
  final dynamic extra;
  final String? icon;
  final String? sub_value;

  Application({
    this.id,
    this.groupName,
    this.code,
    this.value,
    this.active,
    this.deleted,
    this.urlSlug,
    this.parentid,
    this.parentname,
    this.parent_id,
    this.parent_name,
    this.orderno,
    this.extra,
    this.icon,
    this.sub_value,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as int?,
      groupName: json['group_name'] as String?,
      code: json['code'] as String?,
      value: json['value'] as String?,
      active: json['active'] as int?,
      deleted: json['deleted'] as int?,
      urlSlug: json['url_slug'] as String?,
      parentid: json['parentid'] as int?,
      parentname: json['parentname'] as String?,
      parent_id: json['parent_id'] as int?,
      parent_name: json['parent_name'] as String?,
      orderno: json['orderno'] as int?,
      extra: json['extra'],
      icon: json['icon'] as String?,
      sub_value: json['sub_value'] as String?,
    );
  }
}
