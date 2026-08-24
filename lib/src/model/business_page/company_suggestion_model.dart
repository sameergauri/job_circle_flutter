class ApprovedCompanyResponse {
  final String resultKey;
  final List<ApprovedCompany> resultData;
  final String code;
  final String errorMessage;

  ApprovedCompanyResponse({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory ApprovedCompanyResponse.fromJson(Map<String, dynamic> json) {
    return ApprovedCompanyResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: (json['resultData'] as List? ?? [])
          .map((e) => ApprovedCompany.fromJson(e))
          .toList(),
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class ApprovedCompany {
  final int id;
  final String companyName;
  final String? logoUrl;
  final String? companyCity;
  final String? industryType;

  ApprovedCompany({
    required this.id,
    required this.companyName,
    this.logoUrl,
    this.companyCity,
    this.industryType,
  });

  factory ApprovedCompany.fromJson(Map<String, dynamic> json) {
    return ApprovedCompany(
      id: json['id'] ?? 0,
      companyName: json['companyName'] ?? '',
      logoUrl: json['logoUrl'],
      companyCity: json['companyCity'],
      industryType: json['industryType'],
    );
  }
}
