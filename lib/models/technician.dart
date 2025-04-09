class Technician {
  final String? id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? role;

  Technician({
    this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.role,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] as String?,
      firstName: json['firstName'] as String? ?? 'No first name',
      lastName: json['lastName'] as String? ?? 'No last name',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
    );
  }

  String get fullName => '$firstName $lastName';
}
