class UserModel {
  final int userId;
  final String email;
  final String userName;

  UserModel({
    required this.userId,
    required this.email,
    required this.userName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['UserId'],
      email: json['Email'],
      userName: json['UserName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'UserId': userId, 'Email': email, 'UserName': userName};
  }
}
