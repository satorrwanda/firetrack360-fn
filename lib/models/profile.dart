import 'package:firetrack360/models/user.dart';

class Profile {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? profilePictureUrl;
  final String? bio;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final DateTime? dateOfBirth;
  final User user;

  Profile({
    required this.id,
    this.firstName,
    this.lastName,
    this.profilePictureUrl,
    this.bio,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.dateOfBirth,
    required this.user,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      user: User.fromJson(json['user']),
    );
  }

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? profilePictureUrl,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    DateTime? dateOfBirth,
  }) {
    return Profile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      user: user,
    );
  }
}
