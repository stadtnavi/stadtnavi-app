import 'alert.dart';
import 'enums/bikes_allowed.dart';
import 'enums/stop/wheelchair_boarding.dart';
import 'geometry.dart';
import 'pattern.dart';
import 'route.dart';
import 'stop.dart';
import 'stoptime.dart';

class Trip {
  final String id;
  final String gtfsId;
  final Route route;
  final String serviceId;
  final List<String> activeDates;
  final String tripShortName;
  final String tripHeadsign;
  final String routeShortName;
  final String directionId;
  final String blockId;
  final String shapeId;
  final WheelchairBoarding wheelchairAccessible;
  final BikesAllowed bikesAllowed;
  final Pattern pattern;
  final List<Stop> stops;
  final String semanticHash;
  final List<Stoptime> stoptimes;
  final Stoptime departureStoptime;
  final Stoptime arrivalStoptime;
  final List<Stoptime> stoptimesForDate;
  final List<double> geometry;
  final Geometry tripGeometry;
  final List<Alert> alerts;

  const Trip({
    this.id,
    this.gtfsId,
    this.route,
    this.serviceId,
    this.activeDates,
    this.tripShortName,
    this.tripHeadsign,
    this.routeShortName,
    this.directionId,
    this.blockId,
    this.shapeId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    this.pattern,
    this.stops,
    this.semanticHash,
    this.stoptimes,
    this.departureStoptime,
    this.arrivalStoptime,
    this.stoptimesForDate,
    this.geometry,
    this.tripGeometry,
    this.alerts,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'].toString(),
        gtfsId: json['gtfsId'].toString(),
        route: json['route'] != null
            ? Route.fromJson(json['route'] as Map<String, dynamic>)
            : null,
        serviceId: json['serviceId'].toString(),
        activeDates: json['activeDates'] != null
            ? (json['activeDates'] as List<String>)
            : null,
        tripShortName: json['tripShortName'].toString(),
        tripHeadsign: json['tripHeadsign'].toString(),
        routeShortName: json['routeShortName'].toString(),
        directionId: json['directionId'].toString(),
        blockId: json['blockId'].toString(),
        shapeId: json['shapeId'].toString(),
        wheelchairAccessible: getWheelchairBoardingByString(
            json['wheelchairAccessible'].toString()),
        bikesAllowed: getBikesAllowedByString(json['bikesAllowed'].toString()),
        pattern: json['pattern'] != null
            ? Pattern.fromJson(json['pattern'] as Map<String, dynamic>)
            : null,
        stops: json['stops'] != null
            ? List<Stop>.from((json["stops"] as List<dynamic>).map(
                (x) => Stop.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        semanticHash: json['semanticHash'].toString(),
        stoptimes: json['stoptimes'] != null
            ? List<Stoptime>.from((json["stoptimes"] as List<dynamic>).map(
                (x) => Stoptime.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        departureStoptime: json['departureStoptime'] != null
            ? Stoptime.fromJson(
                json['departureStoptime'] as Map<String, dynamic>)
            : null,
        arrivalStoptime: json['arrivalStoptime'] != null
            ? Stoptime.fromJson(json['arrivalStoptime'] as Map<String, dynamic>)
            : null,
        stoptimesForDate: json['stoptimesForDate'] != null
            ? List<Stoptime>.from(
                (json["stoptimesForDate"] as List<dynamic>).map(
                (x) => Stoptime.fromJson(x as Map<String, dynamic>),
              ))
            : null,
        geometry: json['geometry'] != null
            ? (json['geometry'] as List<double>)
            : null,
        tripGeometry: json['tripGeometry'] != null
            ? Geometry.fromJson(json['tripGeometry'] as Map<String, dynamic>)
            : null,
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gtfsId': gtfsId,
        'route': route?.toJson(),
        'serviceId': serviceId,
        'activeDates': activeDates,
        'tripShortName': tripShortName,
        'tripHeadsign': tripHeadsign,
        'routeShortName': routeShortName,
        'directionId': directionId,
        'blockId': blockId,
        'shapeId': shapeId,
        'wheelchairAccessible': wheelchairAccessible?.name,
        'bikesAllowed': bikesAllowed?.name,
        'pattern': pattern?.toJson(),
        'stops':
            List.generate(stops?.length ?? 0, (index) => stops[index].toJson()),
        'semanticHash': semanticHash,
        'stoptimes': List.generate(
            stoptimes?.length ?? 0, (index) => stoptimes[index].toJson()),
        'departureStoptime': departureStoptime?.toJson(),
        'arrivalStoptime': arrivalStoptime?.toJson(),
        'stoptimesForDate': List.generate(stoptimesForDate?.length ?? 0,
            (index) => stoptimesForDate[index].toJson()),
        'geometry': geometry,
        'tripGeometry': tripGeometry?.toJson(),
        'alerts': List.generate(
            alerts?.length ?? 0, (index) => alerts[index].toJson()),
      };
}
