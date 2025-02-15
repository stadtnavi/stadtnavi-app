import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/stop_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/icons_transport_modes.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/othermodel/alert.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/alert_severity_level_type.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/models/utils/alert_utils.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/offer_carpool/offer_carpool_screen.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/mode_transport_screen.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/custom_text_button.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/step_navigation_details.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/transit_leg.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/widgets/info_message.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/configuration/custom_async_executor.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class BicycleDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final PlanItineraryLeg? bicycleWalkLeg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final MoveInMap moveInMap;

  const BicycleDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.bicycleWalkLeg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final isTypeBikeRentalNetwork =
        leg.transportMode == TransportMode.bicycle &&
            leg.fromPlace?.bikeRentalStation != null;
    final distance = leg.distanceString(localizationBase);
    final duration = leg.durationLeg(localizationBase);
    final bikerentalNetwork =
        getBikeRentalNetwork(leg.fromPlace?.bikeRentalStation?.networks?[0]);
    final isScooter = isTypeBikeRentalNetwork
        ? bikerentalNetwork == BikeRentalNetwork.scooter
        : false;

    final isSimpleBicycle =
        (leg.mode != 'BICYCLE_WALK') && isTypeBikeRentalNetwork;
    final stopsDescription = localization.localeName == 'en'
        ? leg.mode == 'BICYCLE_WALK'
            ? (isScooter
                ? 'Walk your kick scooter $duration ($distance)'
                : 'Walk your bike $duration ($distance)')
            : (isScooter
                ? 'Ride your kick scooter $duration ($distance)'
                : 'Cycle $duration ($distance)')
        : leg.mode == 'BICYCLE_WALK'
            ? (isScooter
                ? 'Scooter $distance schieben ($duration)'
                : 'Fahrrad schieben: $duration ($distance)')
            : (isScooter
                ? 'Scooter $distance fahren ($duration)'
                : 'Radfahren: $duration ($distance)');
    final isAvailibleBikes =
        leg.fromPlace?.bikeRentalStation?.bikesAvailable ?? 0;
    return Column(
      children: [
        if (showBeforeLine)
          DashLinePlace(
            date: leg.startTimeString,
            location: bikerentalNetwork.getTranslateTitle(localizationBase),
            color: BikeRentalNetwork.cargoBike.color,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: BikeRentalNetwork.cargoBike.color,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        SeparatorPlace(
          color: isSimpleBicycle
              ? BikeRentalNetwork.cargoBike.color
              : Colors.grey[400],
          separator: null,
          child: GestureDetector(
            onTap: () {
              if (leg.fromPlace != null) {
                moveInMap(LatLng(
                  leg.fromPlace!.lat,
                  leg.fromPlace!.lon,
                ));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 0),
                if (isSimpleBicycle)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment: leg.fromPlace?.name != null &&
                              leg.fromPlace!.name.isNotEmpty
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: isTypeBikeRentalNetwork
                                  ? bikerentalNetwork.image
                                  : null,
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: isAvailibleBikes == 0
                                      ? const Color(0xffDC0451)
                                      : (isAvailibleBikes > 3
                                          ? const Color(0xff3B7F00)
                                          : const Color(0xffFCBC19)),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FittedBox(
                                      child: Text(
                                        isAvailibleBikes.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 5),
                            child: isTypeBikeRentalNetwork
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        leg.fromPlace?.name != null &&
                                                leg.fromPlace!.name.isNotEmpty
                                            ? leg.fromPlace!.name
                                            : bikerentalNetwork
                                                .getTranslate(localizationBase),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (leg.fromPlace?.name != null &&
                                          leg.fromPlace!.name.isNotEmpty)
                                        Text(
                                          localization.bikeRentalBikeStation,
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                        ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isTypeBikeRentalNetwork &&
                    (itinerary.arrivedAtDestinationWithRentedBicycle))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InfoMessage(
                        message: localization.bikeRentalNetworkFreeFloating),
                  ),
                BicycleWalkLegDash(
                  bicycleWalkLeg: bicycleWalkLeg,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if ((leg.steps != null && leg.steps!.isNotEmpty))
                        ExpansionTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(
                            stopsDescription,
                            style: const TextStyle(fontSize: 14),
                          ),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          textColor: theme.colorScheme.onSurface,
                          collapsedTextColor: theme.colorScheme.onSurface,
                          iconColor: theme.primaryColor,
                          collapsedIconColor: theme.primaryColor,
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          children: leg.steps!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final step = entry.value;

                            return InkWell(
                              onTap: () {
                                if (step.lat != null && step.lon != null) {
                                  moveInMap(LatLng(step.lat!, step.lon!),
                                      zoom: 18);
                                }
                              },
                              child: StepNavigationDetails(
                                step: step,
                                isFirst: index == 0,
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            stopsDescription,
                          ),
                        ),
                      Positioned(
                        left: -24,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              height: 20,
                              width: 20,
                              child: bikeSvg(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BicycleWalkLegDash extends StatelessWidget {
  const BicycleWalkLegDash({
    super.key,
    required this.bicycleWalkLeg,
    required this.child,
  });
  final PlanItineraryLeg? bicycleWalkLeg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localizationST = StadtnaviBaseLocalization.of(context);
    final showAfterBicycleWalkLeg = bicycleWalkLeg?.toPlace?.stopEntity == null;

    final walkDash = Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            showAfterBicycleWalkLeg
                ? localizationST.bicycleWalkFromTransitNoDuration(
                    bicycleWalkLeg?.fromPlace?.stopEntity?.vehicleMode
                            ?.getSecondaryTranslate(localizationST) ??
                        "",
                  )
                : localizationST.bicycleWalkToTransitNoDuration(
                    bicycleWalkLeg?.toPlace?.stopEntity?.vehicleMode
                            ?.getSecondaryTranslate(localizationST) ??
                        "",
                  ),
          ),
          Positioned(
            left: -24,
            top: -5,
            child: Container(
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                height: 20,
                width: 20,
                child: bicycleWalkSvg(),
              ),
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bicycleWalkLeg != null && showAfterBicycleWalkLeg) walkDash,
        child,
        if (bicycleWalkLeg != null && !showAfterBicycleWalkLeg) walkDash,
      ],
    );
  }
}

extension TransportModeExtension on TransportMode {
  static String? _secondaryTranslate(
      TransportMode mode, StadtnaviBaseLocalization localization) {
    return {
      TransportMode.airplane: null,
      TransportMode.bicycle: null,
      TransportMode.bus: null,
      TransportMode.cableCar: null,
      TransportMode.car: null,
      TransportMode.carPool: null,
      TransportMode.ferry: localization.instructionVehicleMetro,
      TransportMode.flexible: null,
      TransportMode.funicular: null,
      TransportMode.gondola: null,
      TransportMode.legSwitch: null,
      TransportMode.rail: localization.instructionVehicleLightRail,
      TransportMode.subway: localization.instructionVehicleMetro,
      TransportMode.tram: null,
      TransportMode.transit: null,
      TransportMode.walk: null,
      // route icons for specific types of transportation
      TransportMode.trufi: null,
      TransportMode.micro: null,
      TransportMode.miniBus: null,
      TransportMode.lightRail: localization.instructionVehicleLightRail,
    }[mode];
  }

  String getSecondaryTranslate(StadtnaviBaseLocalization localization) =>
      _secondaryTranslate(this, localization) ?? 'No translate';
}

class CarDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final MoveInMap moveInMap;

  const CarDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final textCarInstruction =
        '${localization.carInstructionDrive} ${leg.durationLeg(localizationBase)} (${leg.distanceString(localizationBase)})';
    return Column(
      children: [
        if (showBeforeLine)
          DashLinePlace(
            date: leg.startTimeString,
            location: leg.fromPlace?.name ?? '',
            color: leg.primaryColor,
          ),
        SeparatorPlace(
          color: leg.primaryColor,
          child: GestureDetector(
            onTap: () {
              if (leg.fromPlace != null) {
                moveInMap(LatLng(
                  leg.fromPlace!.lat,
                  leg.fromPlace!.lon,
                ));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 0),
                if (leg.steps != null && leg.steps!.isNotEmpty)
                  ExpansionTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      textCarInstruction,
                      style: const TextStyle(fontSize: 14),
                    ),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    textColor: theme.colorScheme.onSurface,
                    collapsedTextColor: theme.colorScheme.onSurface,
                    iconColor: theme.primaryColor,
                    collapsedIconColor: theme.primaryColor,
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                    children: leg.steps!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;

                      return InkWell(
                        onTap: () {
                          if (step.lat != null && step.lon != null) {
                            moveInMap(LatLng(step.lat!, step.lon!), zoom: 18);
                          }
                        },
                        child: StepNavigationDetails(
                          step: step,
                          isFirst: index == 0,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      textCarInstruction,
                    ),
                  ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BaseTrufiPage(
                              child: OfferCarpoolScreen(planItineraryLeg: leg)),
                        ),
                      );
                    },
                    child: Text(
                      localization.localeName == "en"
                          ? "Offer carpool"
                          : "Fahrgemeinschaft anbieten",
                      style: TextStyle(color: theme.colorScheme.surface),
                    ),
                  ),
                ),
                if ((leg.toPlace?.vehicleParkingWithEntrance?.vehicleParking
                            ?.tags !=
                        null) &&
                    (leg.toPlace!.vehicleParkingWithEntrance!.vehicleParking!
                        .tags!
                        .contains('state:few')))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      InfoMessage(
                          message: localization.carParkCloseCapacityMessage),
                      CustomTextButton(
                        text: localization.carParkExcludeFull,
                        onPressed: () async {
                          final mapRouteState =
                              context.read<MapRouteCubit>().state;
                          final mapModesCubit = context.read<MapModesCubit>();
                          final settingFetchState =
                              context.read<SettingFetchCubit>().state;
                          customAsyncExecutor.run<MapModesState>(
                            context: context,
                            onExecute: () async =>
                                await mapModesCubit.fetchPlanModeRidePark(
                              from: mapRouteState.fromPlace!,
                              to: mapRouteState.toPlace!,
                              advancedOptions: settingFetchState,
                              localeName:
                                  Localizations.localeOf(context).languageCode,
                            ),
                            onFinish: (mapModesState) {
                              final modesTransport =
                                  mapModesState.modesTransport;
                              if (modesTransport?.parkRidePlan != null) {
                                mapModesCubit.setValuesMap(
                                  plan: modesTransport!.parkRidePlan!,
                                );
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ModeTransportScreen(
                                    title: localization
                                        .settingPanelMyModesTransportParkRide,
                                    typeTransport:
                                        ModesTransportType.parkRidePlan,
                                  ),
                                ));
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                const Divider(height: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TransportDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final bool showAfterText;
  final MoveInMap moveInMap;

  const TransportDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
    this.showAfterText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panelCubit = context.read<PanelCubit>();
    return Column(
      children: [
        if (showBeforeLine)
          DashLinePlace(
            date: leg.startTimeString,
            location: leg.fromPlace?.name ?? '',
            color: leg.primaryColor,
            alertSeverityIcon: AlertActionIcon.getActiveAlertSeverityLevel(
              alerts: leg.fromPlace?.stopEntity?.alerts,
              referenceUnixTime: leg.startTime.millisecondsSinceEpoch / 1000,
              ontap: () {
                panelCubit.setPanel(
                  CustomMarkerPanel(
                    panel: (
                      context,
                      _, {
                      isOnlyDestination,
                    }) =>
                        StopMarkerModal(
                      initialIndex: 2,
                      stopFeature: StopFeature(
                        code: leg.fromPlace?.stopEntity?.code,
                        gtfsId: leg.fromPlace?.stopEntity?.gtfsId,
                        name: leg.fromPlace?.stopEntity?.name,
                        parentStation: null,
                        patterns: null,
                        platform: null,
                        type: StopsLayerIdsIdsToString.fromTransportMode(
                            leg.transportMode),
                        position:
                            LatLng(leg.fromPlace!.lat, leg.fromPlace!.lon),
                      ),
                    ),
                    positon: LatLng(leg.fromPlace!.lat, leg.fromPlace!.lon),
                    minSize: 130,
                  ),
                );
              },
            ),
          ),
        SeparatorPlace(
          color: leg.primaryColor,
          child: GestureDetector(
            onTap: () {
              if (leg.fromPlace != null) {
                moveInMap(LatLng(
                  leg.fromPlace!.lat,
                  leg.fromPlace!.lon,
                ));
              }
            },
            child: TransitLeg(
              itinerary: itinerary,
              leg: leg,
              moveInMap: moveInMap,
            ),
          ),
        ),
        if (showAfterLine)
          DashLinePlace(
            date: leg.endTimeString.toString(),
            location: showAfterText ? (leg.toPlace?.name ?? '') : '',
            color: leg.primaryColor,
            alertSeverityIcon: AlertActionIcon.getActiveAlertSeverityLevel(
              alerts: leg.toPlace?.stopEntity?.alerts,
              referenceUnixTime: leg.startTime.millisecondsSinceEpoch / 1000,
              ontap: () {
                panelCubit.setPanel(
                  CustomMarkerPanel(
                    panel: (
                      context,
                      _, {
                      isOnlyDestination,
                    }) =>
                        StopMarkerModal(
                      initialIndex: 2,
                      stopFeature: StopFeature(
                        code: leg.toPlace?.stopEntity?.code,
                        gtfsId: leg.toPlace?.stopEntity?.gtfsId,
                        name: leg.toPlace?.stopEntity?.name,
                        parentStation: null,
                        patterns: null,
                        platform: null,
                        type: StopsLayerIdsIdsToString.fromTransportMode(
                            leg.transportMode),
                        position: LatLng(leg.toPlace!.lat, leg.toPlace!.lon),
                      ),
                    ),
                    positon: LatLng(leg.toPlace!.lat, leg.toPlace!.lon),
                    minSize: 130,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class AlertActionIcon extends StatelessWidget {
  static Widget? getActiveAlertSeverityLevel({
    required List<Alert>? alerts,
    required double? referenceUnixTime,
    required VoidCallback ontap,
  }) {
    final activeAlertSeverityLevel = AlertUtils.getActiveAlertSeverityLevel(
      alerts,
      referenceUnixTime,
    );
    return activeAlertSeverityLevel != null
        ? AlertActionIcon(
            alertSeverityLevelType: activeAlertSeverityLevel,
            ontap: ontap,
          )
        : null;
  }

  const AlertActionIcon({
    super.key,
    required this.alertSeverityLevelType,
    required this.ontap,
  });
  final AlertSeverityLevelType alertSeverityLevelType;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: alertSeverityLevelType.getServiceAlertIcon(size: 16),
    );
  }
}

class BikeParkDash extends StatelessWidget {
  final PlanItineraryLeg leg;
  final BikeParkEntity? bikePark;
  const BikeParkDash({
    Key? key,
    required this.leg,
    this.bikePark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final bikerentalNetwork =
        getBikeRentalNetwork(leg.fromPlace?.bikeRentalStation?.networks?[0]);
    return Column(
      children: [
        DashLinePlace(
          date: leg.endTimeString.toString(),
          location: bikePark != null
              ? localization.bikePark
              : bikerentalNetwork.getTranslateTitle(localizationBase),
          subtitle: bikePark?.name ?? leg.toPlace?.name ?? '',
          color: leg.primaryColor,
          child: Column(
            children: [
              SizedBox(
                height: 18,
                width: 24,
                child: bikeParkingSvg,
              ),
              Container(
                width: 5,
                color: Colors.red,
              )
            ],
          ),
        ),
        SeparatorPlace(
          color: leg.primaryColor,
          height: 10,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 19,
            width: 19,
            child: walkSvg,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              '${localizationBase.commonWalk} ${leg.durationLeg(localizationBase)} (${leg.distanceString(localizationBase)})',
            ),
          ),
        ),
      ],
    );
  }
}

class WalkDash extends StatelessWidget {
  final PlanItineraryLeg leg;
  final MoveInMap moveInMap;
  const WalkDash({
    Key? key,
    required this.leg,
    required this.moveInMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    return Column(
      children: [
        SeparatorPlace(
          color: leg.primaryColor,
          height: 10,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            height: 19,
            width: 19,
            child: walkSvg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leg.steps != null && leg.steps!.isNotEmpty)
                ExpansionTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  title: Text(
                    '${localization.commonWalk} ${leg.durationLeg(localization)} (${leg.distanceString(localization)})',
                    style: const TextStyle(fontSize: 14),
                  ),
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  textColor: theme.colorScheme.onSurface,
                  collapsedTextColor: theme.colorScheme.onSurface,
                  iconColor: theme.primaryColor,
                  collapsedIconColor: theme.primaryColor,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                  children: leg.steps!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;

                    return InkWell(
                      onTap: () {
                        if (step.lat != null && step.lon != null) {
                          moveInMap(LatLng(step.lat!, step.lon!), zoom: 18);
                        }
                      },
                      child: StepNavigationDetails(
                        step: step,
                        isFirst: index == 0,
                      ),
                    );
                  }).toList(),
                )
              else
                Text(
                  '${localization.commonWalk} ${leg.durationLeg(localization)} (${leg.distanceString(localization)})',
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class WaitDash extends StatelessWidget {
  final PlanItineraryLeg legBefore;
  final PlanItineraryLeg legAfter;
  const WaitDash({
    Key? key,
    required this.legBefore,
    required this.legAfter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = TrufiBaseLocalization.of(context);
    return Column(
      children: [
        if (legBefore.endTime.millisecondsSinceEpoch -
                legAfter.startTime.millisecondsSinceEpoch !=
            0)
          DashLinePlace(
            date: legBefore.endTimeString.toString(),
            location: legBefore.toPlace?.name ?? '',
            color: Colors.grey,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        SeparatorPlace(
          color: Colors.grey,
          separator: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            height: 19,
            width: 19,
            child: waitSvg,
          ),
          height: 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
                "${localization.commonWait} (${localization.instructionDurationMinutes(legAfter.startTime.difference(legBefore.endTime).inMinutes)})"),
          ),
        ),
      ],
    );
  }
}

class SeparatorPlace extends StatelessWidget {
  final Widget child;
  final Widget? separator;
  final double? height;
  final Color? color;

  const SeparatorPlace({
    Key? key,
    required this.child,
    this.separator,
    this.color,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: (45 * textScaleFactor) + 2),
          if (separator != null)
            SizedBox(
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      width: 4,
                      color: color ?? Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    child: separator,
                  ),
                  Expanded(
                    child: Container(
                      width: 4,
                      color: color ?? Colors.black,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7.5),
              width: 5,
              color: color ?? Colors.black,
            ),
          const SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class DashLinePlace extends StatelessWidget {
  final String date;
  final String location;
  final String? subtitle;
  final Widget? child;
  final Color? color;
  final Widget? alertSeverityIcon;

  const DashLinePlace({
    Key? key,
    required this.date,
    required this.location,
    this.subtitle,
    this.child,
    this.color,
    this.alertSeverityIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 45 * textScaleFactor,
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          if (child == null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                Icons.circle,
                size: 18,
                color: color,
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                child!,
                Expanded(
                  child: Container(
                    width: 4,
                    color: color ?? Colors.black,
                  ),
                ),
              ],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (alertSeverityIcon != null)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: alertSeverityIcon,
                      ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
