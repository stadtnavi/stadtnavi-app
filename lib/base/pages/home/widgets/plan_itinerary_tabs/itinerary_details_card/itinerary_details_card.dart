import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/mode_tracker_screen.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/itinerary_card.dart';
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/pages/saved_places/translations/saved_places_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/ticket_information.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

import 'bar_itinerary_details.dart';
import 'line_dash_components.dart';

class ItineraryDetailsCard extends StatelessWidget {
  final PlanItinerary itinerary;
  final void Function() onBackPressed;
  final MoveInMap moveInMap;

  const ItineraryDetailsCard({
    Key? key,
    required this.itinerary,
    required this.onBackPressed,
    required this.moveInMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localizationSB = StadtnaviBaseLocalization.of(context);
    final localization = SavedPlacesLocalization.of(context);
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final mapRouteCubit = context.read<MapRouteCubit>();
    final mapRouteState = mapRouteCubit.state;
    final compresedLegs = itinerary.compressLegs;
    final sizeLegs = compresedLegs.length;
    final mapModesCubit = context.watch<MapModesCubit>();
    final mapModesState = mapModesCubit.state;
    final bikeParked = compresedLegs.any((leg) =>
        leg.toPlace?.bikeParkEntity != null ||
        leg.fromPlace?.bikeParkEntity != null);
    return Scrollbar(
      child: SingleChildScrollView(
        controller: ScrollController(),
        primary: false,
        child: Column(
          children: [
            Row(
              children: [
                BackButton(
                  onPressed: onBackPressed,
                ),
                Expanded(
                  child: BarItineraryDetails(
                    itinerary: itinerary,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all()),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localizationSB.commonStart,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.navigation_rounded,
                            color: Color(0xFF9BBF28),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      final locationProvider = GPSLocationProvider();
                      await locationProvider.startLocation(context);

                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ModeTrackerScreen(
                          title: localizationSB.navigationTurnByTurnNavigation,
                          warning: localizationSB
                              .navigationTurnByTurnNavigationWarning,
                          itinerary: itinerary,
                        ),
                      ));
                    },
                  ),
                ),
              ],
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
              child: TicketInformation(
                itinerary: itinerary,
                legs: compresedLegs,
              ),
            ),
            if (itinerary.emissionsPerPerson != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SvgPicture.string(leafIcon),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      localizationSB.journeyCo2Emissions,
                    )),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFEBF6E4),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${itinerary.emissionsPerPerson!.toStringAsFixed(0)} g",
                            style: TextStyle(
                              color: const Color(0xFF4C7C2A),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: sizeLegs,
              controller: ScrollController(),
              primary: false,
              itemBuilder: (context, index) {
                final itineraryLeg = compresedLegs[index];

                PlanItineraryLeg? previousLeg;
                PlanItineraryLeg? nextLeg;
                if (index + 1 < compresedLegs.length) {
                  nextLeg = compresedLegs[index + 1];
                }
                if (index > 0) {
                  previousLeg = compresedLegs[index - 1];
                }
                final bikePark = previousLeg?.toPlace?.bikeParkEntity;
                final fromBikePark = itineraryLeg.toPlace?.bikeParkEntity;
                final showBicycleWalkLeg = nextLeg?.mode == 'RAIL' ||
                    nextLeg?.mode == 'SUBWAY' ||
                    previousLeg?.mode == 'RAIL' ||
                    previousLeg?.mode == 'SUBWAY';

                PlanItineraryLeg? bicycleWalkLeg;
                if (nextLeg?.mode == 'BICYCLE_WALK' && !bikeParked) {
                  bicycleWalkLeg = nextLeg;
                }
                if (previousLeg?.mode == 'BICYCLE_WALK' && !bikeParked) {
                  bicycleWalkLeg = previousLeg;
                }
                if (showBicycleWalkLeg && !bikeParked) {
                  PlaceEntity? fromPlace = itineraryLeg.fromPlace;
                  if ((previousLeg?.mode == 'RAIL' ||
                          previousLeg?.mode == 'SUBWAY') &&
                      itineraryLeg.fromPlace?.stopEntity == null) {
                    fromPlace = previousLeg?.toPlace;
                  }
                  bicycleWalkLeg = PlanItineraryLeg(
                    points: '',
                    routeLongName: '',
                    transitLeg: false,
                    duration: const Duration(),
                    startTime: DateTime(0),
                    endTime: DateTime(0),
                    distance: 0,
                    rentedBike: itineraryLeg.rentedBike,
                    toPlace: itineraryLeg.toPlace,
                    fromPlace: fromPlace,
                    mode: 'BICYCLE_WALK',
                  );
                }
                return Column(
                  children: [
                    // fromDashLine
                    if (index == 0)
                      DashLinePlace(
                        date: itinerary.startTimeHHmm.toString(),
                        location: mapRouteState.fromPlace
                                ?.displayName(localization) ??
                            '',
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const SizedBox(height: 18, width: 24),
                            Positioned(
                              top: -5,
                              right: -1,
                              left: -1,
                              child: SizedBox(
                                height: 28,
                                width: 28,
                                child: FittedBox(
                                  child: mapConfiguratiom
                                      .markersConfiguration.fromMarker,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (bikePark != null)
                      BikeParkDash(leg: itineraryLeg, bikePark: bikePark)
                    else if (itineraryLeg.mode == 'WALK')
                      Column(
                        children: [
                          if (fromBikePark != null)
                            BikeParkDash(
                                leg: itineraryLeg, bikePark: fromBikePark)
                          else
                            WalkDash(
                              leg: itineraryLeg,
                              moveInMap: moveInMap,
                            ),
                        ],
                      )
                    else if ((itineraryLeg.rentedBike ?? false) ||
                        itineraryLeg.mode == 'BICYCLE')
                      BicycleDash(
                        itinerary: itinerary,
                        leg: itineraryLeg,
                        bicycleWalkLeg: bicycleWalkLeg,
                        moveInMap: moveInMap,
                        showBeforeLine: index != 0 &&
                            (index > 0 && !compresedLegs[index - 1].transitLeg),
                      )
                    else if (itineraryLeg.mode == 'CAR')
                      CarDash(
                        itinerary: itinerary,
                        leg: itineraryLeg,
                        moveInMap: moveInMap,
                        showBeforeLine: index != 0,
                      )
                    else if (itineraryLeg.transportMode != TransportMode.walk)
                      TransportDash(
                        itinerary: itinerary,
                        leg: itineraryLeg,
                        moveInMap: moveInMap,
                        showBeforeLine: index != 0,
                        showAfterLine: index != sizeLegs - 1 &&
                            !compresedLegs[index + 1].transitLeg,
                        showAfterText: index != sizeLegs - 1 &&
                            compresedLegs[index + 1].mode == 'BICYCLE',
                      )
                    else
                      WalkDash(
                        leg: itineraryLeg,
                        moveInMap: moveInMap,
                      ),

                    if (index < sizeLegs - 1 &&
                        compresedLegs[index + 1]
                                .startTime
                                .difference(itineraryLeg.endTime)
                                .inMinutes >
                            0)
                      WaitDash(
                        legBefore: itineraryLeg,
                        legAfter: compresedLegs[index + 1],
                      ),

                    // toDashLine
                    if (index == sizeLegs - 1) ...[
                      DashLinePlace(
                        date: itinerary.endTimeHHmm.toString(),
                        location:
                            mapRouteState.toPlace?.displayName(localization) ??
                                '',
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const SizedBox(height: 24, width: 24),
                            Positioned(
                              top: -3,
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: FittedBox(
                                  child: mapConfiguratiom
                                      .markersConfiguration.toMarker,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          softWrap: false,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${localizationSB.commonTotalDistance}: ',
                                style: theme.textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: itinerary
                                    .getDistanceString(localizationBase),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (itinerary.emissionsPerPerson != null &&
                          mapConfiguratiom.co2EmmissionUrl != null) ...[
                        const Divider(
                          thickness: 1,
                        ),
                        Emissions(itinerary: itinerary),
                        const Divider(
                          thickness: 1,
                        ),
                      ],
                    ]
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Emissions extends StatelessWidget {
  const Emissions({
    super.key,
    required this.itinerary,
  });
  final PlanItinerary itinerary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationSB = StadtnaviBaseLocalization.of(context);
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final carItinerary = context
        .watch<MapModesCubit>()
        .state
        .modesTransport
        ?.carPlan
        ?.itineraries
        ?.firstOrNull;
    final co2value = itinerary.emissionsPerPerson ?? 0;
    final itineraryIsCar = itinerary.legs.every(
      (leg) => leg.mode == 'CAR' || leg.mode == 'WALK',
    );

    final carCo2Value = !itineraryIsCar && carItinerary != null
        ? carItinerary.emissionsPerPerson?.round()
        : null;

    final useCo2SimpleDesc = carCo2Value == null || itineraryIsCar;

    final co2DescriptionId = useCo2SimpleDesc
        ? localizationSB.itineraryCo2DescriptionSimple(
            co2value.toStringAsFixed(0),
          )
        : localizationSB.itineraryCo2Description(
            carCo2Value,
            co2value.toStringAsFixed(0),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              top: 5,
              right: 16,
            ),
            child: SvgPicture.string(
              leafIcon,
              width: 24,
              height: 24,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  co2DescriptionId,
                ),
                if (mapConfiguratiom.co2EmmissionUrl != null) ...[
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: localizationSB.itineraryCo2Link,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final co2EmmissionUri = Uri.parse(
                            mapConfiguratiom.co2EmmissionUrl!,
                          );
                          if (await canLaunchUrl(co2EmmissionUri)) {
                            await launchUrl(co2EmmissionUri);
                          }
                        },
                    ),
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
