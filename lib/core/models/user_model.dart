class UserModel {
  final int userId;
  final String email;

  UserModel({required this.userId, required this.email});

  // Convert from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userId: json['UserId'], email: json['Email']);
  }

  // Convert to Map for SharedPreferences
  Map<String, dynamic> toJson() {
    return {'UserId': userId, 'Email': email};
  }
}
