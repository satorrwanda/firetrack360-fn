import 'package:flutter/material.dart';

class User {
  final String id;
  final String? firstName;
  final String? lastName;
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

  String get fullName {
    final names = [firstName, lastName].where((n) => n != null && n.isNotEmpty);
    return names.isNotEmpty ? names.join(' ') : 'Unknown User';
  }

  String get initials {
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return (first + last).isEmpty ? '?' : (first + last).toUpperCase();
  }

  User({
    required this.id,
    this.firstName,
    this.lastName,
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
      final userData = json['user'] as Map<String, dynamic>? ?? json;

      return User(
        id: _parseString(json['id']) ??
            (throw ArgumentError('id cannot be null')),
        firstName: _parseString(json['firstName']),
        lastName: _parseString(json['lastName']),
        address: _parseString(json['address']),
        city: _parseString(json['city']),
        state: _parseString(json['state']),
        zipCode: _parseString(json['zipCode']),
        profilePictureUrl: _parseString(json['profilePictureUrl']),
        bio: _parseString(json['bio']),
        dateOfBirth: _parseDateTime(json['dateOfBirth']),
        isActive: json['isActive'] as bool? ?? false,
        createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
        updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
        email: _parseString(userData['email']) ?? 'no-email@example.com',
        phone: _parseString(userData['phone']),
        role: _parseString(userData['role']) ?? 'user',
        verified: userData['verified'] as bool? ?? false,
      );
    } catch (e, stackTrace) {
      debugPrint('Error creating User from JSON: $e\nStackTrace: $stackTrace');
      debugPrint('JSON: $json');
      rethrow;
    }
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    return value.toString();
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'email': email,
      'phone': phone,
      'role': role,
      'verified': verified,
    };
  }
}
