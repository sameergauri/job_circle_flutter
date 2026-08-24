class BusinessHomeCompanyResponse {
  final String resultKey;
  final List<BusinessCompany> resultData;
  final String code;
  final String errorMessage;

  BusinessHomeCompanyResponse({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory BusinessHomeCompanyResponse.fromJson(Map<String, dynamic> json) {
    return BusinessHomeCompanyResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: (json['resultData'] as List? ?? [])
          .map((e) => BusinessCompany.fromJson(e))
          .toList(),
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class BusinessCompany {
  final int id;
  final String? companyCode;
  final String? firmLegalName;
  final String companyName;
  final String? brandName;
  final String? tagline;
  final String? logoUrl;
  final String? website;
  final String? industryType;
  final String? businessCategory;
  final String? organizationType;
  final String? companyType;
  final String? aboutCompany;
  final String? incorporationYear;
  final String? companySize;
  final String? premisesOfficeNo;
  final String? street;
  final String? landmark;
  final String? locationArea;
  final String? companyCity;
  final String? city;
  final String? state;
  final String? pinCode;
  final String? country;
  final bool isHeadOfficeSame;
  final bool isApproved;
  final String createdAt;
  final String? designation;
  final String? memberRole;
  final String? officialContact;
  final String? officialEmail;
  final bool isNoDomainEmail;
  final String? documentType;
  final String? documentUrl;
  final String? approvalStatus;
  final String? joinedAt;

  BusinessCompany({
    required this.id,
    this.companyCode,
    this.firmLegalName,
    required this.companyName,
    this.brandName,
    this.tagline,
    this.logoUrl,
    this.website,
    this.industryType,
    this.businessCategory,
    this.organizationType,
    this.companyType,
    this.aboutCompany,
    this.incorporationYear,
    this.companySize,
    this.premisesOfficeNo,
    this.street,
    this.landmark,
    this.locationArea,
    this.companyCity,
    this.city,
    this.state,
    this.pinCode,
    this.country,
    this.isHeadOfficeSame = true,
    required this.isApproved,
    required this.createdAt,
    this.designation,
    this.memberRole,
    this.officialContact,
    this.officialEmail,
    this.isNoDomainEmail = false,
    this.documentType,
    this.documentUrl,
    this.approvalStatus,
    this.joinedAt,
  });

  factory BusinessCompany.fromJson(Map<String, dynamic> json) {
    return BusinessCompany(
      id: json['id'] ?? 0,
      companyCode: json['companyCode'],
      firmLegalName: json['firmLegalName'],
      companyName: json['companyName'] ?? '',
      brandName: json['brandName'],
      tagline: json['tagline'],
      logoUrl: json['logoUrl'],
      website: json['website'],
      industryType: json['industryType'],
      businessCategory: json['businessCategory'],
      organizationType: json['organizationType'],
      companyType: json['companyType'],
      aboutCompany: json['aboutCompany'],
      incorporationYear: json['incorporationYear'],
      companySize: json['companySize'],
      premisesOfficeNo: json['premisesOfficeNo'],
      street: json['street'],
      landmark: json['landmark'],
      locationArea: json['locationArea'],
      companyCity: json['companyCity'],
      city: json['city'],
      state: json['state'],
      pinCode: json['pinCode'],
      country: json['country'],
      isHeadOfficeSame: json['isHeadOfficeSame'] ?? true,
      isApproved: json['isApproved'] ?? false,
      createdAt: json['createdAt'] ?? '',
      designation: json['designation'],
      memberRole: json['memberRole'],
      officialContact: json['officialContact'],
      officialEmail: json['officialEmail'],
      isNoDomainEmail: json['isNoDomainEmail'] ?? false,
      documentType: json['documentType'],
      documentUrl: json['documentUrl'],
      approvalStatus: json['approvalStatus'],
      joinedAt: json['joinedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'firmLegalName': firmLegalName,
      'brandName': brandName,
      'tagline': tagline,
      'companyCode': companyCode,
      'website': website,
      'businessCategory': businessCategory,
      'organizationType': organizationType,
      'companyType': companyType,
      'industryType': industryType,
      'aboutCompany': aboutCompany,
      'incorporationYear': incorporationYear,
      'companySize': companySize,
      'logoUrl': logoUrl,
      'premisesOfficeNo': premisesOfficeNo,
      'street': street,
      'landmark': landmark,
      'locationArea': locationArea,
      'companyCity': companyCity,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'country': country,
      'isHeadOfficeSame': isHeadOfficeSame,
      'designation': designation,
      'memberRole': memberRole,
      'officialContact': officialContact,
      'officialEmail': officialEmail,
      'isNoDomainEmail': isNoDomainEmail,
      'documentType': documentType,
      'documentUrl': documentUrl,
    };
  }
}
