import '../user/user_model.dart';

class AuthDataModel {
  final UserModel user;
  final String token;

  const AuthDataModel({required this.user, required this.token});

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
