import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink('https://your-graphql-api.com/graphql');

final GraphQLClient graphqlClient = GraphQLClient(
  link: httpLink,
  cache: GraphQLCache(store: InMemoryStore()),
);

GraphQLClient getClient() => graphqlClient;