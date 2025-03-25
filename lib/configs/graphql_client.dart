import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        return token != null && token.isNotEmpty ? 'Bearer $token' : null;
      },
    );
  }

  static Link _createLink() {
    try {
      final httpLink = _createHttpLink();
      final authLink = _createAuthLink();

      final errorLink =
          Link.function((Request request, [NextLink? forward]) async* {
        try {
          final stream = await forward!(request);

          await for (final response in stream) {
            if (response.errors != null && response.errors!.isNotEmpty) {
              if (GraphQLErrorHandler.isAuthenticationError(
                  response.errors!.first)) {
                await AuthService.logout();
              }
            }
            yield response;
          }
        } catch (error) {
          if (error is LinkException &&
              GraphQLErrorHandler.isAuthenticationError(error)) {
            await AuthService.logout();
          }
          rethrow;
        }
      });

      return errorLink.concat(authLink).concat(httpLink);
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

      return ValueNotifier(client);
    } catch (e, stackTrace) {
      debugPrint('Error initializing GraphQL client: $e');
      debugPrint('Stack trace: $stackTrace');
      return ValueNotifier(
        GraphQLClient(
          link: _createHttpLink(),
          cache: GraphQLCache(store: InMemoryStore()),
        ),
      );
    }
  }
}

class GraphQLErrorHandler {
  static bool isAuthenticationError(dynamic error) {
    if (error.toString().contains('ResponseFormatException') ||
        error.toString().contains('Unexpected end of input')) {
      return true;
    }

    if (error.toString().contains('401') || error.toString().contains('403')) {
      return true;
    }

    if (error is GraphQLError) {
      final message = error.message.toLowerCase();
      return message.contains('unauthorized') ||
          message.contains('unauthenticated') ||
          message.contains('invalid token') ||
          message.contains('token expired');
    }

    if (error is LinkException) {
      final message = error.toString().toLowerCase();
      return message.contains('unauthorized') ||
          message.contains('unauthenticated') ||
          message.contains('invalid token') ||
          message.contains('token expired');
    }

    return false;
  }
}
