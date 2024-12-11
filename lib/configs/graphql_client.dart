import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphQLConfiguration {
  static HttpLink _createHttpLink() {
    final String? endpointUrl = dotenv.env['GRAPHQL_ENDPOINT_URL'];
    
    if (endpointUrl == null || endpointUrl.isEmpty) {
      throw Exception('GRAPHQL_ENDPOINT_URL is not set in .env file');
    }
    
    return HttpLink(endpointUrl);
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
}