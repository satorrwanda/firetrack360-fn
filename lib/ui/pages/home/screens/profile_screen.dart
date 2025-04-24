import 'dart:io';
import 'package:firetrack360/graphql/mutations/profile_mutations.dart';
import 'package:firetrack360/graphql/queries/profile_query.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/home/widgets/ImagePickerModal.dart';
import 'package:firetrack360/ui/pages/profile/UpdateProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:firetrack360/ui/pages/home/widgets/custom_bottom_nav.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final userId = snapshot.data;
        if (userId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const SizedBox.shrink();
        }

        return Query<Object?>(
          options: QueryOptions(
            document: gql(getProfileQuery),
            variables: {'userId': userId},
            fetchPolicy: FetchPolicy.networkOnly,
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return _ErrorScreen(
                error: result.exception.toString(),
                onRetry: () async {
                  try {
                    await refetch?.call();
                  } catch (e) {
                    debugPrint('Refetch error: $e');
                  }
                },
              );
            }

            if (result.isLoading) {
              return const _LoadingScreen();
            }

            final profileData = result.data?['getProfileByUserId'];
            if (profileData == null) {
              return const _ErrorScreen(
                error: 'Profile data not found',
              );
            }

            return _ProfileContent(
              profile: profileData,
              onRefresh: () async {
                try {
                  await refetch?.call();
                } catch (e) {
                  debugPrint('Refetch error: $e');
                }
              },
            );
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading profile...',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const _ErrorScreen({
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Error Loading Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Retry',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final Map<String, dynamic> profile;
  final Future<void> Function()? onRefresh;

  const _ProfileContent({
    required this.profile,
    this.onRefresh,
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  Widget buildProfileImage(String? imageUrl) {
    // If no image URL is provided, show the avatar
    if (imageUrl == null) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
        child: Icon(Icons.person, size: 50, color: Colors.deepPurple),
      );
    }

    // Check if the image path is a local file path
    if (imageUrl.startsWith('/data/') || imageUrl.startsWith('file://')) {
      final file = File(imageUrl.replaceFirst('file://', ''));
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(file),
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, size: 50, color: Colors.deepPurple);
              },
            ),
          ),
        ),
      );
    }

    // Handle network images (from Cloudinary or other sources)
    return CircleAvatar(
      radius: 50,
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 50, color: Colors.deepPurple);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    bool verified = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.deepPurple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (verified)
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.green[700],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Divider(color: Colors.deepPurple),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateProfileScreen(currentProfile: profile),
                ),
              );
              if (result == true) {
                onRefresh?.call();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: RefreshIndicator(
          color: Colors.deepPurple,
          onRefresh: () async {
            await onRefresh?.call();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 24),
                _buildPersonalInfo(context),
                const SizedBox(height: 24),
                _buildAddressInfo(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        userRole: profile['user']?['role'],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                buildProfileImage(profile['profilePictureUrl']),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ProfileImagePickerModal(
                          hasExistingImage:
                              profile['profilePictureUrl'] != null,
                          onImageSelected: (cloudinaryUrl) async {
                            final client = GraphQLProvider.of(context).value;

                            try {
                              final result = await client.mutate(
                                MutationOptions(
                                  document: gql(updateProfileMutation),
                                  variables: {
                                    'id': profile['id'],
                                    'profileInput': {
                                      'profilePictureUrl': cloudinaryUrl,
                                    },
                                  },
                                ),
                              );
                              if (result.hasException) {
                                throw Exception(result.exception.toString());
                              }

                              onRefresh?.call();
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.error_outline,
                                            color: Colors.white),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Text(
                                                'Failed to update profile image: $e')),
                                      ],
                                    ),
                                    backgroundColor: Colors.red.shade600,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          onRemoveImage: profile['profilePictureUrl'] != null
                              ? () async {
                                  final client =
                                      GraphQLProvider.of(context).value;

                                  try {
                                    final result = await client.mutate(
                                      MutationOptions(
                                        document: gql(updateProfileMutation),
                                        variables: {
                                          'id': profile['id'],
                                          'profileInput': const {
                                            'profilePictureUrl': null,
                                          },
                                        },
                                      ),
                                    );

                                    if (result.hasException) {
                                      throw Exception(
                                          result.exception.toString());
                                    }

                                    onRefresh?.call();
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.error_outline,
                                                  color: Colors.white),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                  child: Text(
                                                      'Failed to remove profile image: $e')),
                                            ],
                                          ),
                                          backgroundColor: Colors.red.shade600,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              profile['firstName'] != null || profile['lastName'] != null
                  ? '${profile['firstName'] ?? ''} ${profile['lastName'] ?? ''}'
                      .trim()
                  : '____   _____',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (profile['bio'] != null) ...[
              const SizedBox(height: 8),
              Text(
                profile['bio'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (profile['user']?['verified'] == true)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Verified Account',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return _buildSection(
      context,
      title: 'Personal Information',
      children: [
        _buildInfoTile(
          icon: Icons.email,
          title: 'Email',
          value: profile['user']?['email'] ?? 'Not provided',
          verified: profile['user']?['verified'] ?? false,
        ),
        if (profile['user']?['phone'] != null)
          _buildInfoTile(
            icon: Icons.phone,
            title: 'Phone',
            value: profile['user']?['phone'],
          ),
        _buildInfoTile(
          icon: Icons.badge,
          title: 'Role',
          value: (profile['user']?['role'] ?? '').toString().toUpperCase(),
        ),
        if (profile['dateOfBirth'] != null)
          _buildInfoTile(
            icon: Icons.cake,
            title: 'Date of Birth',
            value: _formatDate(
                DateTime.tryParse(profile['dateOfBirth']) ?? DateTime.now()),
          ),
      ],
    );
  }

  Widget _buildAddressInfo(BuildContext context) {
    final hasAddress = profile['address'] != null ||
        profile['city'] != null ||
        profile['state'] != null ||
        profile['zipCode'] != null;

    if (!hasAddress) return const SizedBox.shrink();

    return _buildSection(
      context,
      title: 'Address',
      children: [
        if (profile['address'] != null)
          _buildInfoTile(
            icon: Icons.location_on,
            title: 'Street',
            value: profile['address'],
          ),
        if (profile['city'] != null || profile['state'] != null)
          _buildInfoTile(
            icon: Icons.location_city,
            title: 'City/State',
            value: '${profile['city'] ?? ''} ${profile['state'] ?? ''}'.trim(),
          ),
        if (profile['zipCode'] != null)
          _buildInfoTile(
            icon: Icons.maps_home_work,
            title: 'ZIP Code',
            value: profile['zipCode'],
          ),
      ],
    );
  }
}
