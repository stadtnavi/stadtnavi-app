import 'package:graphql/client.dart';

GraphQLClient getClient(
  String endpoint, {
  PartialDataCachePolicy partialDataPolicy = PartialDataCachePolicy.accept,
}) {
  final HttpLink _httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      'accept-language': 'en',
    },
  );
  return GraphQLClient(
    cache: GraphQLCache(
      store: HiveStore(),
      partialDataPolicy: partialDataPolicy,
    ),
    link: _httpLink,
  );
}

GraphQLClient updateClient({
  required GraphQLClient graphQLClient,
  required String endpoint,
  String? langugeEncode,
}) {
  final httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      'accept-language': langugeEncode ?? 'en',
    },
  );
  return graphQLClient.copyWith(link: httpLink);
}
