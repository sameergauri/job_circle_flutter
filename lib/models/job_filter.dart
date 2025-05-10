class JobfilterModel {
  final List<String>? companies;
  final List<String>? roles;
  final List<String>? processes;
  final List<String>? locations;
  final List<String>? shiftTimes;
  final List<String>? languages;
  final List<String>? cities;
  final List<String>? functionalAreas;

  JobfilterModel({
    this.companies,
    this.roles,
    this.processes,
    this.locations,
    this.shiftTimes,
    this.languages,
    this.cities,
    this.functionalAreas,
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
    );
  }
}
