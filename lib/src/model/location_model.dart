class LocationData {
  final int? id;
  final String? formateData;

  LocationData({this.id, this.formateData});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    String formatLocality(String locality) {
      // Split the string by comma
      List<String> parts = locality.split(',');

      if (parts.length >= 2) {
        // Trim any leading or trailing spaces/tabs from both parts
        String part1 = parts[0].trim();
        String part2 = parts[1].trim();

        // Combine the parts with a single space after the comma
        return '$part1, $part2';
      }

      // If there's no comma, return the original string
      return locality;
    }

    return LocationData(
      id: json['id'],
      formateData: formatLocality(json['value']),
    );
  }
}

class TeamModel {
  final int? userId;
  final String? fullName;
  final int? reportTo;
  final int? userRole;

  TeamModel({this.userId, this.fullName, this.reportTo, this.userRole});

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      userId: json['employeeId'],
      fullName: json['fullName'],
      reportTo: json['reportTo'],
      userRole: json['userRole'],
    );
  }
}

class ExtraTeamModel {
  final int? userId;
  final String? fullName;

  ExtraTeamModel({this.userId, this.fullName});

  factory ExtraTeamModel.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      final key = json.keys.first; // Extract the first key
      return ExtraTeamModel(
        userId: int.tryParse(key), // Convert key (String) to int
        fullName: json[key], // Get value from key
      );
    }
    return ExtraTeamModel();
  }
}

class CertificateModel {
  final int? id;
  final String? value;

  CertificateModel({this.id, this.value});

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(id: json['id'], value: json['value']);
  }
}
