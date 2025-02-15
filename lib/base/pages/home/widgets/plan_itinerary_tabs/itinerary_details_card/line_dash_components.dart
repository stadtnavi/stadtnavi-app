import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/icons_transport_modes.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/offer_carpool/offer_carpool_screen.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/mode_transport_screen.dart';
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
  final bool showBeforeLine;
  final bool showAfterLine;
  final void Function(LatLng latlng) moveInMap;

  const BicycleDash({
    Key? key,
    required this.itinerary,
    required this.leg,
    required this.moveInMap,
    this.showBeforeLine = true,
    this.showAfterLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          separator: isSimpleBicycle
              ? null
              : Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  height: 19,
                  width: 19,
                  child: bikeSvg(),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    stopsDescription,
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

class CarDash extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItineraryLeg leg;
  final bool showBeforeLine;
  final bool showAfterLine;
  final void Function(LatLng latlng) moveInMap;

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text(
                    '${localizationBase.localeName == 'en' ? 'Fahren' : 'Drive'} ${leg.durationLeg(localizationBase)} (${leg.distanceString(localizationBase)})',
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary),
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
  final void Function(LatLng latlng) moveInMap;

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
            location: showAfterText ? '' : leg.toPlace?.name ?? '',
            color: leg.primaryColor,
          ),
      ],
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
  final void Function(LatLng latlng) moveInMap;
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
              // if (leg.steps != null && leg.steps!.isNotEmpty)
              //   ExpansionTile(
              //     visualDensity: const VisualDensity(vertical: -4),
              //     title: Text(
              //       '${localization.commonWalk} ${leg.durationLeg(localization)} (${leg.distanceString(localization)})',
              //     ),
              //     tilePadding: const EdgeInsets.symmetric(
              //       horizontal: 0,
              //       vertical: 0,
              //     ),
              //     textColor: theme.colorScheme.onSurface,
              //     collapsedTextColor: theme.colorScheme.onSurface,
              //     iconColor: theme.primaryColor,
              //     collapsedIconColor: theme.primaryColor,
              //     childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              //     children: leg.steps!
              //         .map((e) => InkWell(
              //               onTap: () {
              //                 if (e.lat != null && e.lon != null) {
              //                   moveInMap(LatLng(
              //                     e.lat!,
              //                     e.lon!,
              //                   ));
              //                 }
              //               },
              //               child: StepNavigationDetails(
              //                 step: e,
              //               ),
              //             ))
              //         .toList(),
              //   )
              // else
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

  const DashLinePlace({
    Key? key,
    required this.date,
    required this.location,
    this.subtitle,
    this.child,
    this.color,
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
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
