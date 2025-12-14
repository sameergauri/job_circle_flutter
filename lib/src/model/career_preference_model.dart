class CareerPreferenceModel {
  int? id;
  String? empType;
  String? endSalary;
  bool? immediateJoiner;
  List<String>? industry;
  List<String>? location;
  String? noticePeriod;
  bool? openToRelocate;
  List<String>? role;
  String? startSalary;
  int? userId;
  List<String>? workMode;
  String? shiftTime;
  bool? enable;

  CareerPreferenceModel({
    this.id,
    this.empType,
    this.endSalary,
    this.immediateJoiner,
    this.industry,
    this.location,
    this.noticePeriod,
    this.openToRelocate,
    this.role,
    this.startSalary,
    this.userId,
    this.workMode,
    this.shiftTime,
    this.enable,
  });

  // -------------------------
  // FROM JSON
  // -------------------------
  factory CareerPreferenceModel.fromJson(Map<String, dynamic> json) {
    return CareerPreferenceModel(
      id: json["id"],
      empType: json["empType"],
      endSalary: json["endSalary"],
      immediateJoiner: json["immediateJoiner"],
      industry: json["industry"] != null
          ? List<String>.from(json["industry"])
          : null,
      location: json["location"] != null
          ? List<String>.from(json["location"])
          : null,
      noticePeriod: json["noticePeriod"],
      openToRelocate: json["openToRelocate"],
      role: json["role"] != null ? List<String>.from(json["role"]) : null,
      startSalary: json["startSalary"],
      userId: json["userId"],
      workMode: json["workMode"] != null
          ? List<String>.from(json["workMode"])
          : null,
      shiftTime: json["shiftTime"],
      enable: json["enable"],
    );
  }

  // -------------------------
  // TO JSON
  // -------------------------
  Map<String, dynamic> toJson() {
    return {
      // ❌ userId removed here
      "empType": empType,
      "endSalary": endSalary,
      "immediateJoiner": immediateJoiner,
      "industry": industry,
      "location": location,
      "noticePeriod": noticePeriod,
      "openToRelocate": openToRelocate,
      "role": role,
      "startSalary": startSalary,
      "userId": userId,
      "workMode": workMode,
      "shiftTime": shiftTime,
      "enable": enable,
    };
  }

  // -------------------------
  // UPDATE API JSON
  // -------------------------
  Map<String, dynamic> toJsonForUpdate() {
    return {
      "id": id, // IF backend requires id
      "empType": empType,
      "endSalary": endSalary,
      "immediateJoiner": immediateJoiner,
      "industry": industry,
      "location": location,
      "noticePeriod": noticePeriod,
      "openToRelocate": openToRelocate,
      "role": role,
      "startSalary": startSalary,
      // ❌ userId removed here
      "workMode": workMode,
      "shiftTime": shiftTime,
      "enable": enable,
    };
  }
}
