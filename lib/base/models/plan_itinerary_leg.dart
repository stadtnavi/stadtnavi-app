part of 'plan_entity.dart';

// ignore: must_be_immutable
class PlanItineraryLeg extends Equatable {
  PlanItineraryLeg({
    required this.points,
    required this.mode,
    this.route,
    this.shortName,
    required this.routeLongName,
    required this.distance,
    required this.duration,
    this.agency,
    this.realtimeState,
    this.toPlace,
    this.fromPlace,
    required this.startTime,
    required this.endTime,
    this.steps,
    this.intermediatePlaces,
    this.intermediatePlace,
    required this.transitLeg,
    this.rentedBike,
    this.pickupBookingInfo,
    this.dropOffBookingInfo,
    this.interlineWithPreviousLeg,
    this.accumulatedPoints = const [],
    this.trip,
  }) {
    transportMode =
        getTransportMode(mode: mode, specificTransport: routeLongName);
  }

  static const _distance = "distance";
  static const _duration = "duration";
  static const _legGeometry = "legGeometry";
  static const _points = "points";
  static const _mode = "mode";
  static const _route = "route";
  static const _routeLongName = "routeLongName";
  static const _agency = "agency";
  static const _realtimeState = "realtimeState";
  static const _toPlace = "to";
  static const _fromPlace = "from";
  static const _startTime = "startTime";
  static const _endTime = "endTime";
  static const _steps = "steps";
  static const _intermediatePlaces = "intermediatePlaces";
  static const _intermediatePlace = "intermediatePlace";
  static const _transitLeg = "transitLeg";
  static const _rentedBike = "rentedBike";
  static const _interlineWithPreviousLeg = "interlineWithPreviousLeg";
  static const _pickupBookingInfo = "pickupBookingInfo";
  static const _dropOffBookingInfo = "dropOffBookingInfo";
  static const _trip = "trip";

  final String points;
  final String mode;
  final RouteEntity? route;
  final String? shortName;
  final String routeLongName;
  final double distance;
  final Duration duration;
  final AgencyEntity? agency;
  final RealtimeState? realtimeState;
  final PlaceEntity? toPlace;
  final PlaceEntity? fromPlace;
  final DateTime startTime;
  final DateTime endTime;
  final bool transitLeg;
  final bool? intermediatePlace;
  final bool? rentedBike;
  final bool? interlineWithPreviousLeg;
  final PickupBookingInfo? pickupBookingInfo;
  final BookingInfo? dropOffBookingInfo;
  final List<StepEntity>? steps;
  final List<PlaceEntity>? intermediatePlaces;
  final Trip? trip;

  late TransportMode transportMode;
  final List<LatLng> accumulatedPoints;

  factory PlanItineraryLeg.fromJson(Map<String, dynamic> json) {
    return PlanItineraryLeg(
      points: json[_legGeometry][_points] as String,
      mode: json[_mode] as String,
      route: json[_route] != null
          ? ((json[_route] is Map<String, dynamic>)
              ? RouteEntity.fromJson(json[_route] as Map<String, dynamic>)
              : null)
          : null,
      shortName: json[_route] != null
          ? ((json[_route] is String) && json[_route] != ''
              ? json[_route] as String
              : null)
          : null,
      routeLongName: json[_routeLongName] as String,
      distance: json[_distance] as double,
      duration: Duration(
          seconds: (double.tryParse(json[_duration].toString()) ?? 0).toInt()),
      agency: json[_agency] != null
          ? AgencyEntity.fromMap(json[_agency] as Map<String, dynamic>)
          : null,
      realtimeState: getRealtimeStateByString(json[_realtimeState].toString()),
      toPlace: json[_toPlace] != null
          ? PlaceEntity.fromMap(json[_toPlace] as Map<String, dynamic>)
          : null,
      fromPlace: json[_fromPlace] != null
          ? PlaceEntity.fromMap(json[_fromPlace] as Map<String, dynamic>)
          : null,
      startTime: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json[_startTime].toString()) ?? 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json[_endTime].toString()) ?? 0),
      steps: json[_steps] != null
          ? List<StepEntity>.from((json[_steps] as List<dynamic>).map(
              (x) => StepEntity.fromJson(x as Map<String, dynamic>),
            ))
          : null,
      intermediatePlaces: json[_intermediatePlaces] != null
          ? List<PlaceEntity>.from(
              (json[_intermediatePlaces] as List<dynamic>).map(
                (x) => PlaceEntity.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      pickupBookingInfo: json[_pickupBookingInfo] != null
          ? PickupBookingInfo.fromMap(
              json[_pickupBookingInfo] as Map<String, dynamic>)
          : null,
      dropOffBookingInfo: json[_dropOffBookingInfo] != null
          ? BookingInfo.fromMap(
              json[_dropOffBookingInfo] as Map<String, dynamic>)
          : null,
      transitLeg: json[_transitLeg] as bool,
      intermediatePlace: json[_intermediatePlace] as bool?,
      rentedBike: json[_rentedBike] as bool?,
      interlineWithPreviousLeg: json[_interlineWithPreviousLeg] as bool?,
      accumulatedPoints: decodePolyline(json[_legGeometry][_points] as String?),
      trip: json[_trip] != null
          ? Trip.fromJson(json[_trip] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _legGeometry: {_points: points},
      _mode: mode,
      _route: route?.toJson() ?? shortName,
      _routeLongName: routeLongName,
      _distance: distance,
      _duration: duration.inSeconds,
      _agency: agency?.toMap(),
      _realtimeState: realtimeState?.name,
      _toPlace: toPlace?.toMap(),
      _fromPlace: fromPlace?.toMap(),
      _startTime: startTime.millisecondsSinceEpoch,
      _endTime: endTime.millisecondsSinceEpoch,
      _steps: steps != null
          ? List<dynamic>.from(steps!.map((x) => x.toMap()))
          : null,
      _intermediatePlaces: intermediatePlaces != null
          ? List<dynamic>.from(intermediatePlaces!.map((x) => x.toMap()))
          : null,
      _pickupBookingInfo: pickupBookingInfo?.toMap(),
      _dropOffBookingInfo: dropOffBookingInfo?.toMap(),
      _intermediatePlace: intermediatePlace,
      _transitLeg: transitLeg,
      _rentedBike: rentedBike,
      _interlineWithPreviousLeg: interlineWithPreviousLeg,
      _trip: trip?.toJson(),
    };
  }

  PlanItineraryLeg copyWith({
    String? points,
    String? mode,
    RouteEntity? route,
    String? shortName,
    String? routeLongName,
    double? distance,
    Duration? duration,
    RealtimeState? realtimeState,
    PlaceEntity? toPlace,
    PlaceEntity? fromPlace,
    DateTime? startTime,
    DateTime? endTime,
    bool? rentedBike,
    bool? intermediatePlace,
    bool? transitLeg,
    bool? interlineWithPreviousLeg,
    List<StepEntity>? steps,
    List<PlaceEntity>? intermediatePlaces,
    PickupBookingInfo? pickupBookingInfo,
    BookingInfo? dropOffBookingInfo,
    List<LatLng>? accumulatedPoints,
    Trip? trip,
  }) {
    return PlanItineraryLeg(
      points: points ?? this.points,
      mode: mode ?? this.mode,
      route: route ?? this.route,
      shortName: shortName ?? this.shortName,
      routeLongName: routeLongName ?? this.routeLongName,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      realtimeState: realtimeState ?? this.realtimeState,
      toPlace: toPlace ?? this.toPlace,
      fromPlace: fromPlace ?? this.fromPlace,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      rentedBike: rentedBike ?? this.rentedBike,
      intermediatePlace: intermediatePlace ?? this.intermediatePlace,
      transitLeg: transitLeg ?? this.transitLeg,
      interlineWithPreviousLeg:
          interlineWithPreviousLeg ?? this.interlineWithPreviousLeg,
      steps: steps ?? this.steps,
      intermediatePlaces: intermediatePlaces ?? this.intermediatePlaces,
      pickupBookingInfo: pickupBookingInfo ?? this.pickupBookingInfo,
      dropOffBookingInfo: dropOffBookingInfo ?? this.dropOffBookingInfo,
      accumulatedPoints: accumulatedPoints ?? this.accumulatedPoints,
      trip: trip ?? this.trip,
    );
  }

  String distanceString(TrufiBaseLocalization localization) =>
      displayDistanceWithLocale(
        localization,
        distance,
      );

  String get startTimeString => durationToHHmm(startTime);

  String get endTimeString => durationToHHmm(endTime);

  String get headSign {
    return transportMode == TransportMode.carPool
        ? toPlace?.name ?? ''
        : stopStart;
  }

  String get nameTransport {
    return route?.shortName ?? (route?.longName ?? (shortName ?? ''));
  }

  String get stopStart {
    return trip?.tripHeadsign ?? route?.longName ?? '';
  }

  Color get primaryColor {
    return transportMode == TransportMode.bicycle &&
            fromPlace?.bikeRentalStation != null
        ? getBikeRentalNetwork(fromPlace!.bikeRentalStation!.networks?[0]).color
        : route?.color != null
            ? Color(int.tryParse('0xFF${route?.color}')!)
            : transportMode.color;
  }

  Color get backgroundColor {
    return route?.color != null
        ? Color(int.tryParse('0xFF${route?.color}')!)
        : transportMode.backgroundColor;
  }

  String durationLeg(TrufiBaseLocalization localization) =>
      durationFormatString(localization, duration);

  int get durationIntLeg {
    return endTime.difference(startTime).inSeconds;
  }

  Widget get iconData => transportMode.getImage();

  bool get isLegOnFoot =>
      transportMode == TransportMode.walk || mode == 'BICYCLE_WALK';

  String get transportName {
    return route?.shortName ?? (route?.longName ?? (shortName ?? ''));
  }

  @override
  List<Object?> get props => [
        points.length,
        mode,
        route,
        shortName,
        routeLongName,
        distance,
        duration,
        agency,
        toPlace,
        fromPlace,
        startTime,
        endTime,
        transitLeg,
        intermediatePlace,
        rentedBike,
        interlineWithPreviousLeg,
        pickupBookingInfo,
        dropOffBookingInfo,
        steps,
        intermediatePlaces,
        // trip,
        realtimeState,
      ];
}
