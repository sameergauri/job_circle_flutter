class JoinersResponseModel {
  final String? resultKey;
  final ResultData? resultData;
  final String? code;
  final String? errorMessage;

  JoinersResponseModel({
    this.resultKey,
    this.resultData,
    this.code,
    this.errorMessage,
  });

  factory JoinersResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinersResponseModel(
      resultKey: json['resultKey'] as String?,
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
      code: json['code'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

class ResultData {
  final Map<String, List<JoinerData>>? joiners;
  final Map<String, List<JoinerData>>? pending;
  final Map<String, List<JoinerData>>? payable;
  final Map<String, List<JoinerData>>? notPayable;
  final double? totalPayable;

  ResultData({
    this.joiners,
    this.pending,
    this.payable,
    this.notPayable,
    this.totalPayable,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      joiners: (json['joiners'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => JoinerData.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      pending: (json['pending'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => JoinerData.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      payable: (json['payable'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => JoinerData.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      notPayable: (json['notPayable'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => JoinerData.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      totalPayable: json['totalPayable'] as double?,
    );
  }
}

class JoinerData {
  final int? id;
  final String? candidateName;
  final int? companyId;
  final String? companyShortName;
  final String? companyName;
  final String? companyLogo;
  final String? process;
  final String? designation;
  final String? dateOfJoining;
  final String? attrStatus;
  final String? remark;
  final String? profilePic;
  final String? gender;
  final int? isBankDetailsAdded;
  final String? organizationName;
  final int? organizationId;
  final double? partnerPayout;
  final int? clientPayout;
  final int? referralId;
  final String? referralSource;
  final String? partnerPayoutMode;
  final String? leadGenerationDate;
  final String? sourceName;
  final int? sourceId;
  final String? empId;
  final String? salary;
  final int? jobId;
  final String? natureOfwork;
  final int? crpfId;
  final String? bankName;
  final String? accountType;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? organizationFullAddress;

  JoinerData({
    this.id,
    this.candidateName,
    this.companyId,
    this.companyShortName,
    this.companyName,
    this.companyLogo,
    this.process,
    this.designation,
    this.dateOfJoining,
    this.attrStatus,
    this.remark,
    this.profilePic,
    this.gender,
    this.isBankDetailsAdded,
    this.organizationName,
    this.organizationId,
    this.partnerPayout,
    this.clientPayout,
    this.referralId,
    this.referralSource,
    this.partnerPayoutMode,
    this.leadGenerationDate,
    this.sourceName,
    this.sourceId,
    this.empId,
    this.salary,
    this.jobId,
    this.natureOfwork,
    this.crpfId,
    this.accountHolderName,
    this.accountNumber,
    this.accountType,
    this.bankName,
    this.ifscCode,
    this.organizationFullAddress,
  });

  factory JoinerData.fromJson(Map<String, dynamic> json) {
    return JoinerData(
      id: json['id'] as int?,
      candidateName: json['candidateName'] as String?,
      companyId: json['companyId'] as int?,
      companyShortName: json['companyShortName'] as String?,
      companyName: json['companyName'] as String?,
      companyLogo: json['companyLogo'] as String?,
      process: json['process'] as String?,
      designation: json['designation'] as String?,
      dateOfJoining: json['dateOfJoining'] as String?,
      attrStatus: json['attrStatus'] as String?,
      remark: json['remark'] as String?,
      profilePic: json['profilePic'] as String?,
      gender: json['gender'] as String?,
      isBankDetailsAdded: json['isBankDetailsAdded'] as int?,
      organizationName: json['organizationName'] as String?,
      organizationId: json['organizationId'] as int?,
      partnerPayout: json['partnerPayout'] as double?,
      clientPayout: json['clientPayout'] as int?,
      referralId: json['referralId'] as int?,
      referralSource: json['referralSource'] as String?,
      partnerPayoutMode: json['partnerPayoutMode'] as String?,
      leadGenerationDate: json['leadGenerationDate'] as String?,
      sourceName: json['sourceName'] as String?,
      sourceId: json['sourceId'] as int?,
      empId: json['empId'] as String?,
      salary: json['salary'] as String?,
      jobId: json['jobId'] as int?,
      natureOfwork: json['natureOfwork'] as String?,
      crpfId: json['crpfId'] as int?,
      accountHolderName: json['accountHolderName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountType: json['accountType'] as String?,
      bankName: json['bankName'] as String?,
      ifscCode: json['ifscCode'] as String?,
      organizationFullAddress: json['organizationFullAddress'] as String?,
    );
  }
}
