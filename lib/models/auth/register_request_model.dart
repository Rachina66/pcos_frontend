class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String? role;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (role != null) 'role': role,
    };
  }
}
