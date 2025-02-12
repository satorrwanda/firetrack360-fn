import 'package:flutter/material.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? profilePictureUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String email;
  final String? phone;
  final String role;
  final bool verified;

  String get fullName => '$firstName $lastName';

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.profilePictureUrl,
    this.bio,
    this.dateOfBirth,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    this.phone,
    required this.role,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        address: json['address'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        zipCode: json['zipCode'] as String?,
        profilePictureUrl: json['profilePictureUrl'] as String?,
        bio: json['bio'] as String?,
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'] as String)
            : null,
        isActive: json['isActive'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        email: (json['user'] as Map<String, dynamic>)['email'] as String,
        phone: (json['user'] as Map<String, dynamic>)['phone'] as String?,
        role: (json['user'] as Map<String, dynamic>)['role'] as String,
        verified: (json['user'] as Map<String, dynamic>)['verified'] as bool,
      );
    } catch (e, stackTrace) {
      debugPrint('Error creating User from JSON: $e\nStackTrace: $stackTrace');
      debugPrint('JSON: $json');
      rethrow;
    }
  }
}
