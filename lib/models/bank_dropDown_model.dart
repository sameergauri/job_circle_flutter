class BankDropDownModel {
  final String name;
  final int id;
  final String? address;
  final int? isBank;
  final String? documents;
  final String? city;
  final int? addressId;
  final int? active;
  final int? isSalary;
  final String? icon;
  final int? userActive;
  final String? isResumeId;
  final String? location;
  final int? isClient;
  final String? shortCode;

  BankDropDownModel({
    required this.name,
    required this.id,
    this.address,
    this.isBank,
    this.documents,
    this.city,
    this.addressId,
    this.active,
    this.isSalary,
    this.icon,
    this.userActive,
    this.isResumeId,
    this.location,
    this.isClient,
    this.shortCode,
  });

  factory BankDropDownModel.fromJson(Map<String, dynamic> json) {
    return BankDropDownModel(
      name: json['name'],
      id: json['id'],
      address: json['address'],
      isBank: json['is_bank'],
      documents: json['documents'],
      city: json['city'],
      addressId: json['address_id'],
      active: json['active'],
      isSalary: json['is_salary'],
      icon: json['icon'],
      userActive: json['user_active'],
      isResumeId: json['is_resume_id'],
      location: json['location'],
      isClient: json['is_client'],
      shortCode: json['short_code'],
    );
  }
}
