import 'dart:async';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';

import 'graphl_client/graphql_client.dart';
import 'graphl_client/graphql_utils.dart';
import 'graphql_operation/fragment/pattern_fragments.dart' as pattern_fragments;
import 'graphql_operation/fragment/stop_fragments.dart' as stops_fragments;
import 'graphql_operation/queries/pattern_queries.dart' as pattern_queries;
import 'graphql_operation/queries/stops_queries.dart' as stops_queries;
import 'models_otp/bike_rental_station.dart';
import 'models_otp/pattern.dart';
import 'models_otp/stop.dart';

class LayersRepository {
  static final GraphQLClient client = getClient();

  LayersRepository();

  static Future<Stop> fetchStopCached(String idStop) async {
    return _fetchStopByTIme(idStop, 0);
  }

  static Future<Stop> fetchStop(String idStop) async {
    return _fetchStopByTIme(
        idStop, DateTime.now().millisecondsSinceEpoch ~/ 1000);
  }

  static Future<Stop> fetchTimeTable(String idStop, {DateTime date}) async {
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
        Stop.fromJson(dataStopsTimes.data['stop'] as Map<String, dynamic>);

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
        Stop.fromJson(dataStopsTimes.data['stop'] as Map<String, dynamic>);

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
        patternResult.data['pattern'] as Map<String, dynamic>);

    return patternOtp;
  }

  static Future<CityBikeDataFetch> fetchCityBikesData(String cityBikeId) async {
    final WatchQueryOptions cityBikeQuery = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.citybikeQuery),
          [stops_fragments.bikeRentalStationFragment]),
      variables: <String, dynamic>{
        "id": cityBikeId,
      },
      fetchResults: true,
    );
    final bikeRentalStation = await client.query(cityBikeQuery);
    if (bikeRentalStation.hasException && bikeRentalStation.data == null) {
      throw Exception("Bad request");
    }
    final bikeRentalStationData = BikeRentalStation.fromJson(
        bikeRentalStation.data['bikeRentalStation'] as Map<String, dynamic>);

    return CityBikeDataFetch.fromBikeRentalStation(bikeRentalStationData);
  }
}
