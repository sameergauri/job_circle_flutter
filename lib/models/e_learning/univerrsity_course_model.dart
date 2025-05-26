class UniversityCourse {
  final String universityName;
  final String courseName;
  final String duration;
  final String fees;
  final String imageUrl;
  final String logoUrl;
  final String detail_url;
  final List<String> ranking;

  UniversityCourse({
    required this.universityName,
    required this.courseName,
    required this.duration,
    required this.fees,
    required this.imageUrl,
    required this.logoUrl,
    required this.detail_url,
    required this.ranking,
  });

  factory UniversityCourse.fromJson(Map<String, dynamic> json) {
    return UniversityCourse(
      universityName: json['universityName'] ?? 'Unknown University',
      courseName: json['courseName'] ?? 'Unknown Course',
      duration: json['duration'] ?? 'Unknown Duration',
      fees: json['fees'] ?? 'Unknown Fees',
      imageUrl: json['imageUrl'] ?? 'https://picsum.photos/300/150',
      logoUrl: json['logoUrl'] ??
          'https://cdn-websites.talentedge.com/DYPATIL/www/wwwroot/dypatiledu.com/assets/img/staticpage/dyp-online-logo.png',
      detail_url: json['detail_url'],
      ranking: json['ranking'],
    );
  }
}
