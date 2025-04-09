import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  Profile? _profile;
  bool _isLoading = false;
  String? _error;
  List<Profile> _availableTechnicians = [];

  final GraphQLClient _client;

  ProfileProvider(this._client);

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Profile> get availableTechnicians => _availableTechnicians;
  String? get fullName {
    if (_profile?.firstName == null && _profile?.lastName == null) return null;
    return '${_profile?.firstName ?? ''} ${_profile?.lastName ?? ''}'.trim();
  }

  // GraphQL Queries and Mutations
  static const String _getProfileQuery = '''
    query GetProfile {
      profile {
        id
        firstName
        lastName
        profilePictureUrl
        bio
        address
        city
        state
        zipCode
        dateOfBirth
        user {
          id
          email
          role
        }
      }
    }
  ''';


  static const String _updateProfileMutation = '''
    mutation UpdateProfile(
      \$firstName: String
      \$lastName: String
      \$bio: String
      \$address: String
      \$city: String
      \$state: String
      \$zipCode: String
      \$dateOfBirth: DateTime
    ) {
      updateProfile(input: {
        firstName: \$firstName
        lastName: \$lastName
        bio: \$bio
        address: \$address
        city: \$city
        state: \$state
        zipCode: \$zipCode
        dateOfBirth: \$dateOfBirth
      }) {
        id
        firstName
        lastName
        profilePictureUrl
        bio
        address
        city
        state
        zipCode
        dateOfBirth
        user {
          id
          email
          role
        }
      }
    }
  ''';

  static const String _updateProfilePictureMutation = '''
    mutation UpdateProfilePicture(\$url: String!) {
      updateProfilePicture(url: \$url) {
        id
        profilePictureUrl
      }
    }
  ''';

  Future<void> loadProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _client.query(
        QueryOptions(
          document: gql(_getProfileQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        _profile = Profile.fromJson(result.data!['profile']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    DateTime? dateOfBirth,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _client.mutate(
        MutationOptions(
          document: gql(_updateProfileMutation),
          variables: {
            if (firstName != null) 'firstName': firstName,
            if (lastName != null) 'lastName': lastName,
            if (bio != null) 'bio': bio,
            if (address != null) 'address': address,
            if (city != null) 'city': city,
            if (state != null) 'state': state,
            if (zipCode != null) 'zipCode': zipCode,
            if (dateOfBirth != null)
              'dateOfBirth': dateOfBirth.toIso8601String(),
          },
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        _profile = Profile.fromJson(result.data!['updateProfile']);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String url) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _client.mutate(
        MutationOptions(
          document: gql(_updateProfilePictureMutation),
          variables: {
            'url': url,
          },
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null && _profile != null) {
        _profile = _profile!.copyWith(
          profilePictureUrl: result.data!['updateProfilePicture']
              ['profilePictureUrl'],
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleGraphQLError(OperationException? exception) {
    if (exception == null) return 'Unknown error occurred';

    if (exception.linkException != null) {
      if (exception.linkException is NetworkException) {
        return 'Network error occurred. Please check your connection.';
      }
      return exception.linkException.toString();
    }

    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.map((e) => e.message).join(', ');
    }

    return 'An error occurred while processing your request';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _profile = null;
    _isLoading = false;
    _error = null;
    _availableTechnicians = [];
    notifyListeners();
  }
}
