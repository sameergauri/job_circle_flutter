class UserActivity {
  int userId;
  bool active;
  DateTime lastActive;

  UserActivity({
    required this.userId,
    required this.active,
    required this.lastActive,
  });

  // Convert UserActivity object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'active': active,
      'lastActive': lastActive.toUtc().toIso8601String(),
    };
  }
}
