import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/graphql/mutations/profile_mutations.dart';
import 'package:firetrack360/graphql/mutations/profile_query.dart';
import 'package:firetrack360/services/auth_service.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic> _profile = {};
  bool _isLoading = false;
  String _error = '';

  Map<String, dynamic> get profile => _profile;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchProfile(GraphQLClient client) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = await AuthService.getUserId();
      if (userId == null) {
        _error = 'User not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final result = await client.query(
        QueryOptions(
          document: gql(getProfileQuery),
          variables: {'userId': userId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        _error = result.exception.toString();
      } else {
        _profile = result.data?['getProfileByUserId'];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load profile: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(GraphQLClient client, Map<String, dynamic> profileInput) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(updateProfileMutation),
          variables: {
            'id': _profile['id'],
            'profileInput': profileInput,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      _profile = {..._profile, ...profileInput};
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update profile: $e';
      notifyListeners();
    }
  }
}
