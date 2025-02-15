import 'dart:async';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:stadtnavi_core/base/pages/home/services/global_alerts/models/global_alert_entity.dart';
import 'package:stadtnavi_core/configuration/graphql_client.dart';

class OtpGlobalAlertsRepository {
  final GraphQLClient client;

  OtpGlobalAlertsRepository(String endpoint)
      : client = getClient(endpoint,
            partialDataPolicy: PartialDataCachePolicy.reject);

  Future<List<GlobalAlertEntity>> fetchAlerts({
    required List<String> feedIds,
    required String locale,
  }) async {
    final QueryOptions planAdvancedQuery = QueryOptions(
      document: parseString(r'''
    query MessageBarQuery($feedids: [String!]) {
      alerts: alerts(severityLevel: [SEVERE], feeds: $feedids) {
        feed
        id
        alertDescriptionText
        alertHash
        alertHeaderText
        alertSeverityLevel
        alertUrl
        effectiveEndDate
        effectiveStartDate
      }
    }
'''),
      variables: <String, dynamic>{
        'feedids': feedIds,
      },
      fetchPolicy: FetchPolicy.noCache,
      cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
    );
    final planAdvancedData = await client.query(planAdvancedQuery);
    if (planAdvancedData.hasException && planAdvancedData.data == null) {
      throw planAdvancedData.exception!.graphqlErrors.isNotEmpty
          ? Exception("Bad request")
          : Exception(planAdvancedData.exception!.graphqlErrors);
    }
    List<GlobalAlertEntity> planData =
        (planAdvancedData.data!['alerts'] as List)
            .map(
              (e) => GlobalAlertEntity.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
    DateTime currentTime = DateTime.now();
    planData = planData.where((alert) {
      return (alert.effectiveStartDate != null &&
              alert.effectiveStartDate != null)
          ? (alert.effectiveStartDate!.isBefore(currentTime) &&
              alert.effectiveEndDate!.isAfter(currentTime))
          : false;
    }).toList();
    final planDatas = uniqBy(planData, (alert) => alert.alertHash);

    return planDatas;
  }

  List<T> uniqBy<T, V>(List<T> list, V Function(T) key) {
    var seenKeys = <V>{};
    return list.where((element) => seenKeys.add(key(element))).toList();
  }
}
