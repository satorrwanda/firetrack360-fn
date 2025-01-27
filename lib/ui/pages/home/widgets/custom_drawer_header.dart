import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/graphql/queries/profile_query.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({super.key});

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  Object _getImage(String url) => url.startsWith(RegExp(r'https?://'))
      ? NetworkImage(url)
      : FileImage(File(url.replaceAll('file://', '')));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }
        final userId = snapshot.data;
        if (userId == null) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.of(context).pushReplacementNamed('/login'));
          return const SizedBox.shrink();
        }
        return Query(
          options: QueryOptions(
            document: gql(getProfileQuery),
            variables: {'userId': userId},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
          builder: (result, {refetch, fetchMore}) {
            if (result.isLoading) return _buildLoading();
            if (result.hasException)
              return _buildError(result.exception.toString());
            final profile = result.data?['getProfileByUserId'];
            if (profile == null) return _buildError('Profile not found');
            return _buildProfile(profile);
          },
        );
      },
    );
  }

  Widget _buildProfile(Map<String, dynamic> profile) {
    final fullName =
        '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'.trim();
    final email = profile['user']?['email'] ?? 'Email not available';
    final profilePicture = profile['profilePictureUrl'];
    final role = profile['user']?['role'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 40,
            backgroundImage: profilePicture != null
                ? _getImage(profilePicture) as ImageProvider
                : null,
            child: profilePicture == null
                ? const Icon(Icons.person_outline,
                    size: 40, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            fullName.isNotEmpty ? fullName : '___ ___',
            style: _textStyle(fontSize: 18, isBold: true),
          ),

          // Email
          Text(email, style: _textStyle()),

          // Role Badge
          if (role != null) _buildRoleBadge(role),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(role.toUpperCase(), style: _textStyle(fontSize: 12)),
      );

  TextStyle _textStyle({double fontSize = 14, bool isBold = false}) =>
      TextStyle(
        color: Colors.white,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
      );

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );

  Widget _buildError(String message) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.white),
            const SizedBox(height: 16),
            Text('Error loading profile',
                style: _textStyle(fontSize: 16, isBold: true)),
            Text(message, style: _textStyle(fontSize: 12)),
          ],
        ),
      );
}
