class CareerPreferenceModel {
  final List<String> jobTitles;
  final List<String>? industries;
  final List<String>? functionalAreas;
  final String employmentType;
  final String workMode; // New field for work mode
  final List<String> workModeCities; // Cities selected for the work mode
  final String shiftPreferred;
  final String expectedSalary;
  final String joiningAvailability;

  CareerPreferenceModel({
    required this.jobTitles,
    this.industries,
    this.functionalAreas,
    required this.employmentType,
    required this.workMode,
    required this.workModeCities,
    required this.shiftPreferred,
    required this.expectedSalary,
    required this.joiningAvailability,
  });

  // Convert the model to a JSON map for API submission
  Map<String, dynamic> toJson() {
    return {
      'jobTitles': jobTitles,
      'industries': industries,
      'functionalAreas': functionalAreas,
      'employmentType': employmentType,
      'workMode': workMode,
      'workModeCities': workModeCities,
      'shiftPreferred': shiftPreferred,
      'expectedSalary': expectedSalary,
      'joiningAvailability': joiningAvailability,
    };
  }
}
