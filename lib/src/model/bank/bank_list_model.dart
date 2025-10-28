class BankModel {
  final int? id;
  final String? address;
  final String? shortCode;
  final int? isBank;
  final dynamic documents;
  final String? isResumeId;
  final String? city;
  final int? addressId;
  final int? active;
  final int? isSalary;
  final int? userActive;
  final String? icon;
  final int? isGender;
  final String? location;
  final int? isClient;
  final String? name;
  final int? isWorkstatus;

  BankModel({
    this.id,
    this.address,
    this.shortCode,
    this.isBank,
    this.documents,
    this.isResumeId,
    this.city,
    this.addressId,
    this.active,
    this.isSalary,
    this.userActive,
    this.icon,
    this.isGender,
    this.location,
    this.isClient,
    this.name,
    this.isWorkstatus,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse('${json['id']}') : null),
      address: json['address'] as String?,
      shortCode: json['short_code'] as String?,
      isBank: json['is_bank'] is int
          ? json['is_bank'] as int
          : (json['is_bank'] != null
                ? int.tryParse('${json['is_bank']}')
                : null),
      documents: json['documents'],
      isResumeId: json['is_resume_id'] as String?,
      city: json['city'] as String?,
      addressId: json['address_id'] is int
          ? json['address_id'] as int
          : (json['address_id'] != null
                ? int.tryParse('${json['address_id']}')
                : null),
      active: json['active'] is int
          ? json['active'] as int
          : (json['active'] != null ? int.tryParse('${json['active']}') : null),
      isSalary: json['is_salary'] is int
          ? json['is_salary'] as int
          : (json['is_salary'] != null
                ? int.tryParse('${json['is_salary']}')
                : null),
      userActive: json['user_active'] is int
          ? json['user_active'] as int
          : (json['user_active'] != null
                ? int.tryParse('${json['user_active']}')
                : null),
      icon: json['icon'] as String?,
      isGender: json['is_gender'] is int
          ? json['is_gender'] as int
          : (json['is_gender'] != null
                ? int.tryParse('${json['is_gender']}')
                : null),
      location: json['location'] as String?,
      isClient: json['is_client'] is int
          ? json['is_client'] as int
          : (json['is_client'] != null
                ? int.tryParse('${json['is_client']}')
                : null),
      name: json['name'] as String?,
      isWorkstatus: json['is_workstatus'] is int
          ? json['is_workstatus'] as int
          : (json['is_workstatus'] != null
                ? int.tryParse('${json['is_workstatus']}')
                : null),
    );
  }
}
