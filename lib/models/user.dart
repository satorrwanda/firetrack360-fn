class User {
  final String email;
  final String? phone;
  final String role;
  final bool verified;

  User({
    required this.email,
    this.phone,
    required this.role,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      verified: json['verified'] ?? false,
    );
  }
}
