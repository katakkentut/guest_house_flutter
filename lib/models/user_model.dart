class UserModel {
  String userId;
  String fullName;
  String email;
  String password;
  String phoneNumber;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
    );
  }

  


}