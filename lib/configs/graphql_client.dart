import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class GraphQLConfiguration {
  static HttpLink _createHttpLink() {
    final String? endpointUrl = dotenv.env['GRAPHQL_ENDPOINT_URL'];
    debugPrint('GraphQL_ENDPOINT_URL: $endpointUrl'); 
    
    if (endpointUrl == null || endpointUrl.isEmpty) {
      throw Exception('GRAPHQL_ENDPOINT_URL is not set in .env file');
    }
    
    return HttpLink(
      endpointUrl,
      httpClient: http.Client(),
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  static AuthLink _createAuthLink() {
  return AuthLink(
    getToken: () async {
      final token = await AuthService.getAccessToken(); 
      debugPrint('Auth Token Present: ${token != null && token.isNotEmpty}');
      return token != null && token.isNotEmpty 
        ? 'Bearer $token' 
        : null;
    },
  );
}

  static Link _createLink() {
    try {
      final httpLink = _createHttpLink();
      final authLink = _createAuthLink();
      return authLink.concat(httpLink);
    } catch (e, stackTrace) {
      debugPrint('Error creating GraphQL link: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static ValueNotifier<GraphQLClient> initializeClient() {
    try {
      final Link link = _createLink();
      
      final client = GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
        defaultPolicies: DefaultPolicies(
          watchQuery: Policies(
            fetch: FetchPolicy.networkOnly,
            error: ErrorPolicy.all,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
          query: Policies(
            fetch: FetchPolicy.networkOnly,
            error: ErrorPolicy.all,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
          mutate: Policies(
            fetch: FetchPolicy.networkOnly,
            error: ErrorPolicy.all,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
        ),
      );

      // Test connection
      _testConnection(client);
      
      return ValueNotifier(client);
    } catch (e, stackTrace) {
      debugPrint('Error initializing GraphQL client: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Fallback client with basic configuration
      return ValueNotifier(
        GraphQLClient(
          link: _createHttpLink(),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );
    }
  }

  static Future<void> _testConnection(GraphQLClient client) async {
    try {
      const testQuery = '''
        query {
          __typename
        }
      ''';
      
      final result = await client.query(
        QueryOptions(
          document: gql(testQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        handleGraphQLError(result.exception);
      } else {
        debugPrint('GraphQL connection test successful');
      }
    } catch (e) {
      debugPrint('GraphQL connection test failed: $e');
    }
  }

  static void handleGraphQLError(OperationException? exception) {
    if (exception == null) return;

    debugPrint('GraphQL Error Details:');
    
    if (exception.linkException != null) {
      debugPrint('Link Exception: ${exception.linkException.toString()}');
      
      if (exception.linkException is NetworkException) {
        final networkException = exception.linkException as NetworkException;
        debugPrint('Network Error Details:');
        debugPrint('- Message: ${networkException.message}');
        debugPrint('- URI: ${networkException.uri}');
        debugPrint('- Original Exception: ${networkException.originalException}');
      }
    }

    if (exception.graphqlErrors.isNotEmpty) {
      debugPrint('GraphQL Errors:');
      for (var error in exception.graphqlErrors) {
        debugPrint('- Message: ${error.message}');
        debugPrint('- Location: ${error.locations}');
        debugPrint('- Path: ${error.path}');
        debugPrint('- Extensions: ${error.extensions}');
      }
    }
  }
}