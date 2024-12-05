import 'package:graphql_flutter/graphql_flutter.dart';
import 'client.dart';

Future<QueryResult> executeQuery(String query,
    {Map<String, dynamic>? variables}) async {
  final client = getClient();
  return client
      .query(QueryOptions(document: gql(query), variables: variables ?? {}));
}
