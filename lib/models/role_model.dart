class RoleModel {
  int? id;
  String? groupName;
  String? code;
  String? value;
  int? active;
  int? deleted;
  String? urlSlug;
  int? orderno;

  RoleModel({
    this.id,
    this.groupName,
    this.code,
    this.value,
    this.active,
    this.deleted,
    this.urlSlug,
    this.orderno,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] ?? 0,
      groupName: json['group_name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? '',
      active: json['active'] ?? 0,
      deleted: json['deleted'] ?? 0,
      urlSlug: json['url_slug'] ?? '',
      orderno: json['orderno'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
      'code': code,
      'value': value,
      'active': active,
      'deleted': deleted,
      'url_slug': urlSlug,
      'orderno': orderno,
    };
  }
}
