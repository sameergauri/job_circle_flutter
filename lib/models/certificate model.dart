import 'dart:convert';

class CertificateModel {
  String? certificate;
  String? certificationName;
  DateTime? expirationDate;
  int? id;
  DateTime? issueDate;
  String? issuingOrganization;
  int? userId;

  CertificateModel({
    this.certificate,
    this.certificationName,
    this.expirationDate,
    this.id,
    this.issueDate,
    this.issuingOrganization,
    this.userId,
  });

  // Factory method to create an instance from JSON
  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      certificate: json['certificate'] as String?,
      certificationName: json['certificationName'] as String?,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      id: json['id'] as int?,
      issueDate:
          json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
      issuingOrganization: json['issuingOrganization'] as String?,
      userId: json['userId'] as int?,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'certificate': certificate,
      'certificationName': certificationName,
      'expirationDate': expirationDate?.toIso8601String(),
      'id': id,
      'issueDate': issueDate?.toIso8601String(),
      'issuingOrganization': issuingOrganization,
      'userId': userId,
    };
  }

  // Method to create a JSON string from the model
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Factory method to create an instance from a JSON string
  factory CertificateModel.fromJsonString(String jsonString) {
    return CertificateModel.fromJson(jsonDecode(jsonString));
  }
}
