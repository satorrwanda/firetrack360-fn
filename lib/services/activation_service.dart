import 'package:firetrack360/graphql/auth_mutations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ActivationService {

  static Future<Map<String, dynamic>> verifyAccount({
    required GraphQLClient client,
    required String email,
    required String otp,
  }) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(verifyAccountMutation),
          variables: {
            'email': email,
            'otp': otp,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(
          result.exception?.graphqlErrors.first.message ?? 'Verification failed',
        );
      }

      return result.data?['verifyAccount'] ?? {};
    } catch (e) {
      rethrow;
    }
  }
}
