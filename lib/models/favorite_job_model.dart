class JobModel {
  final String resultKey;
  final List<JobData> resultData;
  final String code;
  final String errorMessage;

  JobModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      resultKey: json['resultKey'],
      resultData: List<JobData>.from(
          json['resultData'].map((data) => JobData.fromJson(data))),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }

  /*  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      resultKey: json['resultKey'],
      resultData: List<JobData>.from(
          json['resultData'].map((data) => JobData.fromJson(data))),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  } */
}

class JobData {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFav;
  final JobDetails jobDetails;

  JobData({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isFav,
    required this.jobDetails,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['id'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isFav: json['isFav'],
      jobDetails: JobDetails.fromJson(json['jobDetails']),
    );
  }
}

class JobDetails {
  final int id;
  final String location;
  final String? minExperience;
  final String? maxExperience;
  final int minCtc;
  final int maxCtc;
  final String companyName;
  final String process;
  final String roleName;
  final List<String>? skills;
  final String natureOfWork;

  JobDetails({
    required this.id,
    required this.location,
    required this.minExperience,
    required this.maxExperience,
    required this.minCtc,
    required this.maxCtc,
    required this.companyName,
    required this.process,
    required this.roleName,
    required this.skills,
    required this.natureOfWork,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      id: json['id'],
      location: json['location'],
      minExperience: json['minexperience'],
      maxExperience: json['maxexperience'],
      minCtc: json['minctc']?.toDouble(),
      maxCtc: json['maxctc']?.toDouble(),
      companyName: json['companyname'],
      process: json['process'],
      roleName: json['rolename'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      natureOfWork: json['naturofwork'],
    );
  }
}
