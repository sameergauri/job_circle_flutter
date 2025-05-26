import 'package:job_circle/models/career_preference/career_preference_model.dart';


class CareerPreferenceApiService {
  // Mock API call to save career preference data
  Future<bool> saveCareerPreference(
      CareerPreferenceModel careerPreference) async {
    try {
      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock response: Assume the API accepts the data in JSON format
      print('Saving Career Preference: ${careerPreference.toJson()}');

      // Simulate a successful save
      return true;
    } catch (e) {
      print('Error saving career preference: $e');
      return false;
    }
  }

  // Existing methods (fetch suggestions)
  Future<List<String>> fetchJobRoleSuggestions(String query) async {
    // Mock implementation
    List<String> allRoles = [
      "Software Engineer",
      "Product Manager",
      "Data Scientist",
      "UX Designer",
      "DevOps Engineer",
    ];
    return allRoles
        .where((role) => role.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<String>> fetchIndustrySuggestions(String query) async {
    // Mock implementation
    List<String> allIndustries = [
      "Technology",
      "Finance",
      "Healthcare",
      "Education",
      "Retail",
    ];
    return allIndustries
        .where(
            (industry) => industry.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<String>> fetchFunctionalAreaSuggestions(String query) async {
    // Mock implementation
    List<String> allAreas = [
      "Engineering",
      "Marketing",
      "Sales",
      "Operations",
      "Human Resources",
    ];
    return allAreas
        .where((area) => area.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
