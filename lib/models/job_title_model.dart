class JobTitleModel {
  final String id;
  final String name;

  JobTitleModel({required this.id, required this.name});

  /* factory JobTitleModel.fromJson(Map<String, dynamic> json) {
    return JobTitleModel(
      id: json['id'].toString(),
      value: json['value'].toString(),
    );
  } */
  factory JobTitleModel.fromJson(Map<String, dynamic> json) {
    return JobTitleModel(
      id: json['id'].toString(),
      name: json['name'].toString(),
    );
  }
  @override
  String toString() {
    return 'JobTitleModel{id: $id, name: $name}';
  }
}

class JobTitleModel1 {
  final int? id;
  final String? groupName;
  final String? code;
  final String? value;
  final int? active;
  final int? deleted;
  final String? urlSlug;
  final int? parentId;
  final String? parentName;
  final int? orderNo;
  final dynamic? extra;

  JobTitleModel1({
    required this.id,
    required this.groupName,
    required this.code,
    required this.value,
    required this.active,
    required this.deleted,
    required this.urlSlug,
    required this.parentId,
    required this.parentName,
    required this.orderNo,
    required this.extra,
  });

  factory JobTitleModel1.fromJson(Map<String, dynamic> json) {
    return JobTitleModel1(
      id: json['id'],
      groupName: json['group_name'],
      code: json['code'],
      value: json['value'],
      active: json['active'],
      deleted: json['deleted'],
      urlSlug: json['url_slug'],
      parentId: json['parentid'],
      parentName: json['parentname'],
      orderNo: json['orderno'],
      extra: json['extra'],
    );
  }
  @override
  String toString() {
    return 'JobTitleModel{id: $id, groupName: $groupName, code: $code, value: $value, active: $active, deleted: $deleted, urlSlug: $urlSlug, parentId: $parentId, parentName: $parentName, orderNo: $orderNo, extra: $extra}';
  }
}

