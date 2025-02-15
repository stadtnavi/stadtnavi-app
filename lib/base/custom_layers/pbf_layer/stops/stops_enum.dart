import 'package:trufi_core/base/models/enums/transport_mode.dart';

enum StopsLayerIds {
  bus,
  carpool,
  rail,
  subway,
  funicular,
}

extension StopsLayerIdsIdsToString on StopsLayerIds {
  static Map<TransportMode, StopsLayerIds> transportModeStops = {
    TransportMode.bus: StopsLayerIds.bus,
    TransportMode.carPool: StopsLayerIds.carpool,
    TransportMode.rail: StopsLayerIds.rail,
    TransportMode.subway: StopsLayerIds.subway,
  };
  String enumToString() {
    final Map<StopsLayerIds, String> enumStrings = {
      StopsLayerIds.bus: "Bus stops",
      StopsLayerIds.rail: "Train stations",
      StopsLayerIds.carpool: "Carpool stops",
      StopsLayerIds.subway: "Metro Station",
      StopsLayerIds.funicular: "Seil- und Zahnradbahnen",
    };
    return enumStrings[this] ?? "Bus stops";
  }

  static StopsLayerIds? fromTransportMode(TransportMode transportMode) {
    return transportModeStops[transportMode];
  }
}

StopsLayerIds? stopsLayerIdsstringToEnum(String id) {
  final Map<String, StopsLayerIds> enumStrings = {
    "BUS": StopsLayerIds.bus,
    "CARPOOL": StopsLayerIds.carpool,
    "RAIL": StopsLayerIds.rail,
    "SUBWAY": StopsLayerIds.subway,
    "FUNICULAR": StopsLayerIds.funicular,
  };
  return enumStrings[id];
}

String stopsLayerIdsEnumToString(StopsLayerIds id) {
  final Map<StopsLayerIds, String> enumStrings = {
    StopsLayerIds.bus: "BUS",
    StopsLayerIds.carpool: "CARPOOL",
    StopsLayerIds.rail: "RAIL",
    StopsLayerIds.subway: "SUBWAY",
    StopsLayerIds.funicular: "FUNICULAR",
  };
  return enumStrings[id] ?? "BUS";
}
