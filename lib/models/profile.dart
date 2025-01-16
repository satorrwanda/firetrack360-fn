class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String? profilePictureUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserData user;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    this.profilePictureUrl,
    this.bio,
    this.dateOfBirth,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  String get fullName => '$firstName $lastName';
  String get fullAddress => '$address, $city, $state $zipCode';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      dateOfBirth: json['dateOfBirth'] != null 
        ? DateTime.parse(json['dateOfBirth']) 
        : null,
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String phone;
  final String role;
  final bool verified;

  UserData({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.verified,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      verified: json['verified'],
    );
  }
}