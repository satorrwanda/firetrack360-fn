import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class GraphQLConfiguration {

  static HttpLink _createHttpLink() {
    final String? endpointUrl = dotenv.env['GRAPHQL_ENDPOINT_URL'];
    
    if (endpointUrl == null || endpointUrl.isEmpty) {
      throw Exception('GRAPHQL_ENDPOINT_URL is not set in .env file');
    }
    
    return HttpLink(
      endpointUrl,
      httpClient: http.Client(),
    );
  }

  static AuthLink _createAuthLink() {
    return AuthLink(
      getToken: () async {
        final String? token = dotenv.env['GRAPHQL_TOKEN'];
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
    } catch (e) {
      debugPrint('Error creating GraphQL link: $e');
      rethrow;
    }
  }

  static ValueNotifier<GraphQLClient> initializeClient() {
    try {
      final Link link = _createLink();
      
      return ValueNotifier(
        GraphQLClient(
          link: link,
          cache: GraphQLCache(store: InMemoryStore()),
          defaultPolicies: DefaultPolicies(
            watchQuery: Policies(
              fetch: FetchPolicy.networkOnly,
              error: ErrorPolicy.all,
            ),
            query: Policies(
              fetch: FetchPolicy.networkOnly,
              error: ErrorPolicy.all,
            ),
            mutate: Policies(
              fetch: FetchPolicy.networkOnly,
              error: ErrorPolicy.all,
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error initializing GraphQL client: $e');
      return ValueNotifier(
        GraphQLClient(
          link: _createHttpLink(),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );
    }
  }
static void handleGraphQLError(OperationException? exception) {
  if (exception == null) return;

  if (exception.linkException is NetworkException) {
    final networkException = exception.linkException as NetworkException;
    
    if (networkException.originalException is TimeoutException) {
      debugPrint('GraphQL Request Timed Out');
    } else {
      debugPrint('Network Error: ${networkException.message}');
    }
  }

  if (exception.graphqlErrors.isNotEmpty) {
    for (var error in exception.graphqlErrors) {
      debugPrint('GraphQL Error: ${error.message}');
    }
  }
}
}