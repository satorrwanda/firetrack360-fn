import 'package:firetrack360/graphql/mutations/auth_mutations.dart';
import 'package:firetrack360/graphql/queries/users_query.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/models/users.dart';
import 'package:firetrack360/configs/graphql_client.dart';

class UsersProvider extends ChangeNotifier {
  final GraphQLClient _client;
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  UsersProvider() : _client = GraphQLConfiguration.initializeClient().value;

  List<User> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _client.query(
        QueryOptions(
          document: gql(getAllUsersQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        final profiles = result.data!['getAllProfiles'] as List<dynamic>;

        _users = profiles.map((profileData) {
          if (profileData == null) {
            throw const FormatException(
                'Received null profile in GraphQL response');
          }

          final profileMap = Map<String, dynamic>.from(profileData as Map);
          _validateProfileData(profileMap);
          return User.fromJson(profileMap);
        }).toList();
      } else {
        _users = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = _formatError(e);
      _isLoading = false;
      _users = [];
      notifyListeners();
      rethrow;
    }
  }

  void _validateProfileData(Map<String, dynamic> profile) {
    final requiredFields = [
      'id',
      'firstName',
      'lastName',
      'isActive',
      'createdAt',
      'updatedAt',
      'user'
    ];

    for (final field in requiredFields) {
      if (!profile.containsKey(field) || profile[field] == null) {
        throw FormatException('Missing required profile field: $field');
      }
    }

    final userMap = profile['user'] as Map<String, dynamic>;
    final requiredUserFields = ['email', 'role', 'verified'];

    for (final field in requiredUserFields) {
      if (!userMap.containsKey(field) || userMap[field] == null) {
        throw FormatException('Missing required user field: $field');
      }
    }
  }

  String _handleGraphQLError(OperationException? exception) {
    if (exception == null) return 'Unknown error occurred';

    if (exception.linkException != null) {
      final linkException = exception.linkException!;
      if (linkException is NetworkException) {
        return 'Network error occurred. Please check your connection.';
      } else if (linkException is ServerException) {
        return 'Server error occurred. Please try again later.';
      }
      return 'Connection error occurred: ${linkException.toString()}';
    }

    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.map((e) => e.message).join(', ');
    }

    return 'An error occurred while processing your request';
  }

  String _formatError(dynamic error) {
    if (error is FormatException) {
      return 'Data format error: ${error.message}';
    } else if (error is GraphQLError) {
      return 'GraphQL error: ${error.message}';
    } else if (error is String) {
      return error;
    } else {
      return 'Error: ${error.toString()}';
    }
  }

  Future<void> refreshUsers() async {
    try {
      await loadUsers();
    } catch (e) {
      debugPrint('Error refreshing users: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;

    final lowercaseQuery = query.toLowerCase();
    return _users.where((user) {
      return user.email.toLowerCase().contains(lowercaseQuery) ||
          (user.phone?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          user.role.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getVerifiedUsers() async {
    return _users.where((user) => user.verified).toList();
  }

  Future<List<User>> getUsersByRole(String role) async {
    return _users.where((user) => user.role == role).toList();
  }

  Future<Map<String, dynamic>> createTechnician(
      Map<String, dynamic> input) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _client.mutate(
        MutationOptions(
          document: gql(createTechnicianMutation),
          variables: {'technicianInput': input},
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        final response =
            result.data!['createTechnician'] as Map<String, dynamic>;
        _isLoading = false;
        notifyListeners();
        return response;
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('No data returned from mutation');
      }
    } catch (e) {
      _error = _formatError(e);
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }



  @override
  void dispose() {
    _users = [];
    super.dispose();
  }

  List<User> getTechnicians() {
    return _users.where((user) {
      return user.role.toLowerCase() == 'technician' ||
          user.role.toLowerCase() ==
              'tech';
    }).toList();
  }
}
