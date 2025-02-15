part of 'plan_entity.dart';

class StopEntity extends Equatable {
  final String? gtfsId;
  final double? lat;
  final double? lon;
  final String? name;
  final String? code;
  final TransportMode? vehicleMode;
  final String? platformCode;
  final String? zoneId;
  final String? id;
  final List<Alert>? alerts;

  const StopEntity({
    this.gtfsId,
    this.lat,
    this.lon,
    this.name,
    this.code,
    this.vehicleMode,
    this.platformCode,
    this.zoneId,
    this.id,
    this.alerts,
  });

  Map<String, dynamic> toMap() {
    return {
      'gtfsId': gtfsId,
      'lat': lat,
      'lon': lon,
      'name': name,
      'code': code,
      'vehicleMode': vehicleMode?.name,
      'platformCode': platformCode,
      'zoneId': zoneId,
      'id': id,
      'alerts': alerts != null
          ? List<dynamic>.from(alerts!.map((x) => x.toJson()))
          : null,
    };
  }

  factory StopEntity.fromMap(Map<String, dynamic> map) {
    return StopEntity(
      id: map['id'] as String?,
      gtfsId: map['gtfsId'] as String?,
      name: map['name'] as String?,
      lat: double.tryParse(map['lat'].toString()) ?? 0,
      lon: double.tryParse(map['lon'].toString()) ?? 0,
      code: map['code'] as String?,
      zoneId: map['zoneId'] as String?,
      platformCode: map['platformCode'] as String?,
      vehicleMode: getTransportMode(mode: map['vehicleMode'].toString()),
      alerts: map['alerts'] != null
          ? List<Alert>.from((map["alerts"] as List<dynamic>).map(
              (x) => Alert.fromJson(x as Map<String, dynamic>),
            ))
          : null,
    );
  }

  @override
  List<Object?> get props => [
        gtfsId,
        lat,
        lon,
        name,
        code,
        vehicleMode,
        platformCode,
        zoneId,
        id,
        alerts,
      ];
}
