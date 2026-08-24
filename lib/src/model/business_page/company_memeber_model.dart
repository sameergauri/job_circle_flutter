class CompanyMembershipResponse {
  final String resultKey;
  final List<CompanyMembershipModel> resultData;
  final String code;
  final String errorMessage;

  CompanyMembershipResponse({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory CompanyMembershipResponse.fromJson(Map<String, dynamic> json) {
    return CompanyMembershipResponse(
      resultKey: json['resultKey']?.toString() ?? '',
      resultData: json['resultData'] != null && json['resultData'] is List
          ? (json['resultData'] as List)
                .map(
                  (e) => CompanyMembershipModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      code: json['code']?.toString() ?? '',
      errorMessage: json['errorMessage']?.toString() ?? '',
    );
  }
}

class CompanyMembershipModel {
  final int? companyId;
  final String? memberRole;
  final String? companyType;
  final String? approvalStatus;

  CompanyMembershipModel({
    this.companyId,
    this.memberRole,
    this.companyType,
    this.approvalStatus,
  });

  factory CompanyMembershipModel.fromJson(Map<String, dynamic> json) {
    return CompanyMembershipModel(
      companyId: json['companyId'] as int?,
      memberRole: json['memberRole']?.toString(),
      companyType: json['companyType']?.toString(),
      approvalStatus: json['approvalStatus']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'memberRole': memberRole,
      'companyType': companyType,
      'approvalStatus': approvalStatus,
    };
  }
}
