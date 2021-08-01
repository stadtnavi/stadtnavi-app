import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

import 'custom_marker_model.dart';

Future<List<CustomMarker>> markersFromAssets(String path) async {
  final List<CustomMarker> markers = [];
  final Map<String, String> icons = {};
  final body = await rootBundle.loadString(path).then(
        (jsonStr) => jsonDecode(jsonStr),
      );
  final List features = body["features"] as List;
  for (final feature in features) {
    final properties = feature["properties"];
    final icon = properties["icon"];
    final iconId = icon["id"] as String;
    final iconSvg = icon["svg"];
    if (iconSvg != null) {
      icons[iconId] = iconSvg as String;
    }
    final coordinate = feature["geometry"]["coordinates"];
    final position = LatLng(
      coordinate[1] as double,
      coordinate[0] as double,
    );
    markers.add(CustomMarker(
      id: properties["id"] as String,
      position: position,
      image: icons[iconId],
      name: properties["name"] as String,
      nameEn: properties["name_en"] as String,
      nameDe: properties["name_de"] as String,
      popupContent: properties["popupContent"] as String,
      popupContentEn: properties["popupContent_en"] as String,
      popupContentDe: properties["popupContent_de"] as String,
    ));
  }
  return markers;
}
