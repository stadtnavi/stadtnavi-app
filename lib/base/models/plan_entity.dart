import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/leg_mode.dart';
import 'package:stadtnavi_core/base/models/enums/plan_info_box.dart';
import 'package:stadtnavi_core/base/models/othermodel/alert.dart';
import 'package:stadtnavi_core/base/models/othermodel/booking_info.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/leg/realtime_state.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/place/vertex_type.dart';
import 'package:stadtnavi_core/base/models/othermodel/pickup_booking_info.dart';
import 'package:stadtnavi_core/base/models/othermodel/trip.dart';
import 'package:stadtnavi_core/base/models/othermodel/vehicle_parking_with_entrance.dart';
import 'package:stadtnavi_core/base/models/step_entity.dart';
import 'package:stadtnavi_core/base/models/utils/geo_utils.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/journey_plan/utils/duration_utils.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/utils/map_utils/trufi_map_utils.dart';

import 'utils/modes_transport_utils.dart';
import 'utils/plan_itinerary_leg_utils.dart';

part 'bike_park_entity.dart';
part 'stop_entity.dart';
part 'bike_rental_station_entity.dart';
part 'modes_transport_entity.dart';
part 'place_entity.dart';
part 'car_park_entity.dart';
part 'route_entity.dart';
part 'agency_entity.dart';
part 'plan_itinerary.dart';
part 'plan_itinerary_leg.dart';
part 'plan_location.dart';

class PlanEntity extends Equatable {
  const PlanEntity({
    this.type,
    this.from,
    this.to,
    this.itineraries,
    this.planInfoBox = PlanInfoBox.undefined,
  });

  static const _itineraries = "itineraries";
  static const _from = "from";
  static const _plan = "plan";
  static const _to = "to";
  static const _type = "type";
  static const _planInfoBox = "planInfoBox";

  final PlanLocation? from;
  final PlanLocation? to;
  final String? type;
  final List<PlanItinerary>? itineraries;
  final PlanInfoBox? planInfoBox;

  factory PlanEntity.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> planJson = json[_plan] as Map<String, dynamic>;
    final itineraries = removePlanItineraryDuplicates(
      planJson[_itineraries]
          .map<PlanItinerary>(
            (dynamic itineraryJson) =>
                PlanItinerary.fromJson(itineraryJson as Map<String, dynamic>),
          )
          .toList() as List<PlanItinerary>,
    );
    findMinEmissionsPerPerson(itineraries);
    return PlanEntity(
      from: PlanLocation.fromJson(planJson[_from] as Map<String, dynamic>),
      to: PlanLocation.fromJson(planJson[_to] as Map<String, dynamic>),
      itineraries: itineraries,
      type: planJson[_type] as String,
      planInfoBox: getPlanInfoBoxByKey(planJson[_planInfoBox] as String),
    );
  }

  PlanEntity copyWith({
    PlanLocation? from,
    PlanLocation? to,
    List<PlanItinerary>? itineraries,
    String? type,
    PlanInfoBox? planInfoBox,
  }) {
    return PlanEntity(
      from: from ?? this.from,
      to: to ?? this.to,
      itineraries: itineraries != null
          ? removePlanItineraryDuplicates(itineraries)
          : this.itineraries,
      type: type ?? this.type,
      planInfoBox: planInfoBox ?? this.planInfoBox,
    );
  }

  static List<PlanItinerary> removePlanItineraryDuplicates(
    List<PlanItinerary> itineraries,
  ) {
    Set<PlanItinerary> set = Set<PlanItinerary>.from(itineraries);
    return set.toList();
  }

  static void findMinEmissionsPerPerson(
    List<PlanItinerary> itineraries,
  ) {
    // Determine the itinerary with the smallest non-null emissionsPerPerson
    double? minEmissionsPerPerson;
    for (var i = 0; i < itineraries.length; i++) {
      final itinerary = itineraries[i];
      if (itinerary.emissionsPerPerson != null) {
        if (minEmissionsPerPerson == null ||
            (itinerary.emissionsPerPerson! < minEmissionsPerPerson)) {
          minEmissionsPerPerson = itinerary.emissionsPerPerson;
        }
      }
      itineraries[i] = itinerary.copyWith(isMinorEmissionsPerPerson: false);
    }

    for (var i = 0; i < itineraries.length; i++) {
      final itinerary = itineraries[i];
      if (itinerary.emissionsPerPerson == minEmissionsPerPerson) {
        itineraries[i] = itinerary.copyWith(
            isMinorEmissionsPerPerson:
                itinerary.emissionsPerPerson == minEmissionsPerPerson);
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      _plan: {
        _from: from?.toJson(),
        _to: to?.toJson(),
        _itineraries:
            itineraries?.map((itinerary) => itinerary.toJson()).toList(),
        _type: type,
        _planInfoBox: planInfoBox?.name
      }
    };
  }

  bool get isOnlyWalk =>
      (itineraries?.isEmpty ?? true) ||
      itineraries!.length == 1 &&
          itineraries![0].legs.length == 1 &&
          itineraries![0].legs[0].transportMode == TransportMode.walk;

  Widget get iconSecondaryPublic {
    if ((itineraries ?? []).isNotEmpty) {
      final publicModes = itineraries![0]
          .legs
          .where(
            (element) =>
                element.transportMode != TransportMode.walk &&
                element.transportMode != TransportMode.bicycle &&
                element.transportMode != TransportMode.car,
          )
          .toList();
      if (publicModes.isNotEmpty) {
        return Container(
            decoration: BoxDecoration(
                color: publicModes[0].route?.color != null
                    ? Color(
                        int.tryParse("0xFF${publicModes[0].route!.color!}") ??
                            0,
                      )
                    : publicModes[0].transportMode.color),
            child: publicModes[0].transportMode.getImage(color: Colors.white));
      }
    }
    return Container();
  }

  bool get isOutSideLocation {
    return planInfoBox == PlanInfoBox.originOutsideService ||
        planInfoBox == PlanInfoBox.destinationOutsideService;
  }

  bool get isTypeMessageInformation {
    return [
      PlanInfoBox.noRouteOriginSameAsDestination,
      PlanInfoBox.noRouteOriginNearDestination,
      PlanInfoBox.onlyWalkingRoutes,
      PlanInfoBox.onlyCyclingRoutes,
      PlanInfoBox.onlyWalkingCyclingRoutes,
    ].contains(planInfoBox);
  }

  @override
  List<Object?> get props => [
        from,
        to,
        type,
        itineraries,
        planInfoBox,
      ];
}
