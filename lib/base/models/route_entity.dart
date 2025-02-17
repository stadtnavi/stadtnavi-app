part of 'plan_entity.dart';

class RouteEntity extends Equatable {
  final String? id;
  final String? gtfsId;
  final AgencyEntity? agency;
  final String? shortName;
  final String? longName;
  final TransportMode? mode;
  final int? type;
  final String? desc;
  final String? url;
  final String? color;
  final String? textColor;
  final List<Alert>? alerts;

  const RouteEntity({
    this.id,
    this.gtfsId,
    this.agency,
    this.shortName,
    this.longName,
    this.mode,
    this.type,
    this.desc,
    this.url,
    this.color,
    this.textColor,
    this.alerts,
  });

  factory RouteEntity.fromJson(Map<String, dynamic> json) => RouteEntity(
        id: json['id'] as String?,
        gtfsId: json['gtfsId'] as String?,
        agency: json['agency'] != null
            ? AgencyEntity.fromMap(json['agency'] as Map<String, dynamic>)
            : null,
        shortName: json['shortName'] as String?,
        longName: json['longName'] as String?,
        mode: getTransportMode(mode: json['mode'].toString()),
        type: int.tryParse(json['type'].toString()) ?? 0,
        desc: json['desc'] as String?,
        url: json['url'] as String?,
        color: json['color'] as String?,
        textColor: json['textColor'] as String?,
        alerts: json['alerts'] != null
            ? List<Alert>.from((json["alerts"] as List<dynamic>).map(
                (x) => Alert.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gtfsId': gtfsId,
        'agency': agency?.toMap(),
        'shortName': shortName,
        'longName': longName,
        'mode': mode?.name,
        'type': type,
        'desc': desc,
        'url': url,
        'color': color,
        'textColor': textColor,
        'alerts': alerts != null
            ? List<dynamic>.from(alerts!.map((x) => x.toJson()))
            : null,
      };

  String get headsignFromRouteLongName {
    return longName ?? (longName ?? "");
  }

  bool get useIcon {
    return shortName == null || shortName!.length > 6;
  }

  Color get primaryColor {
    return color != null
        ? Color(int.tryParse('0xFF$color')!)
        : mode?.color ?? Colors.black;
  }

  Color get backgroundColor {
    return color != null
        ? Color(int.tryParse('0xFF$color')!)
        : mode?.backgroundColor ?? Colors.black;
  }

  @override
  List<Object?> get props => [
        id,
        gtfsId,
        agency,
        shortName,
        longName,
        mode,
        type,
        desc,
        url,
        color,
        textColor,
        alerts,
      ];
}
