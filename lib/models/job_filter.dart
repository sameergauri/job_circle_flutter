class JobfilterModel {
  final List<String>? companies;
  final List<String>? roles;
  final List<String>? processes;
  final List<String>? locations;
  final List<String>? shiftTimes;
  final List<String>? languages;
  final List<String>? cities;
  final List<String>? functionalAreas;
  final UserData? userData;

  JobfilterModel({
    this.companies,
    this.roles,
    this.processes,
    this.locations,
    this.shiftTimes,
    this.languages,
    this.cities,
    this.functionalAreas,
    this.userData,
  });

  factory JobfilterModel.fromJson(Map<String, dynamic> json) {
    return JobfilterModel(
      companies: json['companiesFilter'] != null
          ? List<String>.from(json['companiesFilter'])
          : null,
      roles: json['rolesFilter'] != null
          ? List<String>.from(json['rolesFilter'])
          : null,
      processes: json['processesFilter'] != null
          ? List<String>.from(json['processesFilter'])
          : null,
      locations: json['locationsFilter'] != null
          ? List<String>.from(json['locationsFilter'])
          : null,
      shiftTimes: json['shiftTimesFilter'] != null
          ? List<String>.from(json['shiftTimesFilter'])
          : null,
      languages: json['languagesFilter'] != null
          ? List<String>.from(json['languagesFilter'])
          : null,
      cities: json['citiesFilter'] != null
          ? List<String>.from(json['citiesFilter'])
          : null,
      functionalAreas: json['functionalAreasFilter'] != null
          ? List<String>.from(json['functionalAreasFilter'])
          : null,
      userData:
          json['userData'] != null ? UserData.fromJson(json['userData']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companiesFilter': companies,
      'rolesFilter': roles,
      'processesFilter': processes,
      'locationsFilter': locations,
      'shiftTimesFilter': shiftTimes,
      'languagesFilter': languages,
      'citiesFilter': cities,
      'functionalAreasFilter': functionalAreas,
      'userData': userData,
    };
  }

  JobfilterModel copyWith({
    List<String>? companies,
    List<String>? roles,
    List<String>? processes,
    List<String>? locations,
    List<String>? shiftTimes,
    List<String>? languages,
    List<String>? cities,
    List<String>? functionalAreas,
    UserData? userData,
  }) {
    return JobfilterModel(
      companies: companies ?? this.companies,
      roles: roles ?? this.roles,
      processes: processes ?? this.processes,
      locations: locations ?? this.locations,
      shiftTimes: shiftTimes ?? this.shiftTimes,
      languages: languages ?? this.languages,
      cities: cities ?? this.cities,
      functionalAreas: functionalAreas ?? this.functionalAreas,
      userData: userData ?? this.userData,
    );
  }
}

class UserData {
  final String userProfilePic;
  final String userGender;
  final String userName;
  final String userLocation;
  final String cv_link;

  UserData({
    required this.userProfilePic,
    required this.userGender,
    required this.userName,
    required this.userLocation,
    required this.cv_link,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userProfilePic: json['userProfilePic'] ?? '',
      userGender: json['userGender'] ?? '',
      userName: json['userName'] ?? '',
      userLocation: json['userLocation'] ?? '',
      cv_link: json['cv_link'] ?? '',
    );
  }
}
