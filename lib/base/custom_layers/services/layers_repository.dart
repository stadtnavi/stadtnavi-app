import 'dart:async';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_core/base/models/othermodel/route.dart';
import 'package:stadtnavi_core/configuration/graphql_client.dart';
import 'package:trufi_core/base/utils/graphql_client/graphql_utils.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_data_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/bike_rental_station.dart';
// import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
// import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_data_fetch.dart';
import 'package:stadtnavi_core/base/models/othermodel/vehicle_parking.dart';
import 'package:stadtnavi_core/consts.dart';

import 'graphql_operation/fragment/pattern_fragments.dart' as pattern_fragments;
import 'graphql_operation/fragment/stop_fragments.dart' as stops_fragments;
import 'graphql_operation/queries/park_queries.dart' as park_queries;
import 'graphql_operation/queries/pattern_queries.dart' as pattern_queries;
import 'graphql_operation/queries/stops_queries.dart' as stops_queries;
import 'graphql_operation/queries/alerts_queries.dart' as stops_alerts_queries;
import 'graphql_operation/fragment/alerts_fragments.dart'
    as stops_alerts_fragments;
import 'models_otp/pattern.dart';
import 'models_otp/stop.dart';

class RouteAlertData {
  final RouteOtp route;
  final PatternOtp pattern;

  const RouteAlertData({
    required this.route,
    required this.pattern,
  });
}

class LayersRepository {
  static GraphQLClient client = getClient(ApiConfig().openTripPlannerUrl);

  LayersRepository();

  static Future<Stop> fetchStopCached(String idStop) async {
    return _fetchStopByTIme(idStop, 0);
  }

  static Future<Stop> fetchStop(String idStop) async {
    return _fetchStopByTIme(
        idStop, DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  static Future<Stop> stopAlerts({
    required String idStop,
  }) async {
    final WatchQueryOptions patternQuery = WatchQueryOptions(
      document: addFragments(
        parseString(stops_alerts_queries.stopAlertsQuery),
        [stops_alerts_fragments.stopAlertsContainer],
      ),
      variables: <String, dynamic>{
        "stopId": idStop,
      },
    );
    // "Validation error (UndefinedVariable@[stop]) : Undefined variable 'stopId'"
    final dataStopsTimes = await client.query(patternQuery);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final stopData =
        Stop.fromJson(dataStopsTimes.data!['stop'] as Map<String, dynamic>);

    return stopData;
  }

  static Future<RouteAlertData> routeAlerts({
    required String routeId,
    required String patternId,
  }) async {
    final WatchQueryOptions patternQuery = WatchQueryOptions(
      document: addFragments(
        parseString(stops_alerts_queries.routeAlertsQuery),
        [
          stops_alerts_fragments.routeAlertsContainer,
          stops_alerts_fragments.routePatternAlertsContainer,
        ],
      ),
      variables: <String, dynamic>{
        "routeId": routeId,
        "patternId": patternId,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final dataStopsTimes = await client.query(patternQuery);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final routeOtp = RouteOtp.fromJson(
        dataStopsTimes.data!['route'] as Map<String, dynamic>);

    final patternOtp = PatternOtp.fromJson(
        dataStopsTimes.data!['pattern'] as Map<String, dynamic>);

    return RouteAlertData(route: routeOtp, pattern: patternOtp);
  }

  static Future<Stop> fetchTimeTable(String idStop, {DateTime? date}) async {
    final WatchQueryOptions listStopTimes = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.timeTableQuery),
          [stops_fragments.timetableContainerStop]),
      variables: <String, dynamic>{
        'stopId': idStop,
        "date": DateFormat('yyyyMMdd').format(date ?? DateTime.now()),
      },
      fetchResults: true,
    );
    final dataStopsTimes = await client.query(listStopTimes);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final stopData =
        Stop.fromJson(dataStopsTimes.data!['stop'] as Map<String, dynamic>);

    return stopData;
  }

  static Future<Stop> _fetchStopByTIme(String idStop, int startTime) async {
    final WatchQueryOptions listStopTimes = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.stopDataQuery), [
        stops_fragments.fragmentStopCardHeaderContainerstop,
        stops_fragments.stopPageTabContainerStop,
        stops_fragments.departureListContainerStoptimes,
      ]),
      variables: <String, dynamic>{
        'stopId': idStop,
        "numberOfDepartures": 100,
        "startTime": startTime,
        "timeRange": 864000
      },
      fetchResults: true,
    );
    final dataStopsTimes = await client.query(listStopTimes);
    if (dataStopsTimes.hasException && dataStopsTimes.data == null) {
      throw Exception("Bad request");
    }
    final stopData =
        Stop.fromJson(dataStopsTimes.data!['stop'] as Map<String, dynamic>);

    return stopData;
  }

  static Future<PatternOtp> fetchStopsRoute(String patternId) async {
    final WatchQueryOptions patternQuery = WatchQueryOptions(
      document:
          addFragments(parseString(pattern_queries.routeStopListContainer), [
        pattern_fragments.timetableContainerStop,
        addFragments(pattern_fragments.routePageMapPattern, [
          addFragments(pattern_fragments.routeLinePattern,
              [pattern_fragments.stopCardHeaderContainerStop]),
          pattern_fragments.stopCardHeaderContainerStop,
        ])
      ]),
      variables: <String, dynamic>{
        "currentTime": DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "patternId": patternId
      },
      fetchResults: true,
    );
    final patternResult = await client.query(patternQuery);
    if (patternResult.hasException && patternResult.data == null) {
      throw Exception("Bad request");
    }
    final patternOtp = PatternOtp.fromJson(
        patternResult.data!['pattern'] as Map<String, dynamic>);

    return patternOtp;
  }

  static Future<CityBikeDataFetch> fetchCityBikesData(String cityBikeId) async {
    final WatchQueryOptions cityBikeQuery = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.citybikeQuery),
          [stops_fragments.bikeRentalStationFragment]),
      variables: <String, dynamic>{
        "id": cityBikeId,
      },
      fetchPolicy: FetchPolicy.noCache,
      fetchResults: true,
    );
    final bikeRentalStation = await client.query(cityBikeQuery);
    if (bikeRentalStation.hasException && bikeRentalStation.data == null) {
      throw Exception("Bad request");
    }
    final bikeRentalStationData = BikeRentalStation.fromJson(
        bikeRentalStation.data!['bikeRentalStation'] as Map<String, dynamic>);

    return CityBikeDataFetch.fromBikeRentalStation(bikeRentalStationData);
  }

  static Future<VehicleParkingDataFetch> fetchPark(String parkId) async {
    final WatchQueryOptions parkingQuery = WatchQueryOptions(
      document: parseString(park_queries.parking),
      variables: <String, dynamic>{
        "parkId": parkId,
      },
      fetchResults: true,
      fetchPolicy: FetchPolicy.noCache,
    );
    final parkingResult = await client.query(parkingQuery);
    if (parkingResult.hasException && parkingResult.data == null) {
      throw Exception("Bad request");
    }
    final parkingData = VehicleParking.fromMap(
        parkingResult.data!['vehicleParking'] as Map<String, dynamic>);

    return VehicleParkingDataFetch.fromVehicleParking(parkingData);
  }
}
