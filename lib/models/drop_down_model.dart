// ignore_for_file: non_constant_identifier_names

class DropDownModel {
  final String resultKey;
  final DropDownModelContent resultData;
  final String code;
  final String errorMessage;

  DropDownModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory DropDownModel.fromJson(Map<String, dynamic> json) {
    return DropDownModel(
      resultKey: json['resultKey'] ?? '',
      resultData: DropDownModelContent.fromJson(json['resultData'] ?? {}),
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class DropDownModelContent {
  final List<DropDownItem> content;
  final int pageNumber;
  final int pageSize;
  final int total;

  DropDownModelContent({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.total,
  });

  factory DropDownModelContent.fromJson(Map<String, dynamic> json) {
    return DropDownModelContent(
      content: List<DropDownItem>.from(
        (json['content'] as List<dynamic>? ?? []).map(
          (item) => DropDownItem.fromJson(item as Map<String, dynamic>),
        ),
      ),
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class DropDownItem {
  final String? subStatus;
  final String status;
  final String? statusDd;
  final int? secStatusId;
  final int? priStatusId;
  final int isDd;
  final String? secStatus;
  final int? isSec;
  final int? statusId;
  final int id;
  final String? primaryStatus;
  final int? statusDdId;
  final int? isPri;
  final int? subStatusId;
  final int? parentId;
  final int? status_dd_remark;
  final int? sec_status_remark;
  final int? pri_status_remark;

  DropDownItem({
    required this.subStatus,
    required this.status,
    required this.statusDd,
    required this.secStatusId,
    required this.priStatusId,
    required this.isDd,
    required this.secStatus,
    required this.isSec,
    required this.statusId,
    required this.id,
    required this.primaryStatus,
    required this.statusDdId,
    required this.isPri,
    required this.subStatusId,
    required this.parentId,
    required this.pri_status_remark,
    required this.sec_status_remark,
    required this.status_dd_remark,
  });

  factory DropDownItem.fromJson(Map<String, dynamic> json) {
    return DropDownItem(
        subStatus: json['sub_status'] ?? '',
        status: json['status'] ?? '',
        statusDd: json['status_dd'] ?? '',
        secStatusId: json['sec_status_id'] ?? 0,
        priStatusId: json['pri_status_id'] ?? 0,
        isDd: json['is_dd'] ?? 0,
        secStatus: json['sec_status'] ?? '',
        isSec: json['is_sec'] ?? 0,
        statusId: json['status_id'] ?? 0,
        id: json['id'] ?? 0,
        primaryStatus: json['primary_status'] ?? '',
        statusDdId: json['status_dd_id'] ?? 0,
        isPri: json['is_pri'] ?? 0,
        subStatusId: json['sub_status_id'] ?? 0,
        parentId: json['parentid'] ?? 0,
        pri_status_remark: json['pri_status_remark'] ?? 0,
        sec_status_remark: json['sec_status_remark'] ?? 0,
        status_dd_remark: json['status_dd_remark'] ?? 0,
        );
  }
}
