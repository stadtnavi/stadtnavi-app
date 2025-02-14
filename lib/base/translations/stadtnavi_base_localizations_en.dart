import 'stadtnavi_base_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StadtnaviBaseLocalizationEn extends StadtnaviBaseLocalization {
  StadtnaviBaseLocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get itineraryTicketsTitle => 'Required tickets';

  @override
  String get itineraryTicketTitle => 'Required ticket';

  @override
  String get itineraryBuyTicket => 'Buy tickets';

  @override
  String get itineraryMissingPrice => 'No price information';

  @override
  String get itineraryPriceOnlyPublicTransport => 'Price only valid for public transport part of the journey.';

  @override
  String get copyrightsPriceProvider => 'Fare information provided by Nahverkehrsgesellschaft Baden-Württemberg mbH (NVBW). No liability for the correctness of the information.';

  @override
  String get fareTicketName => 'Adult';

  @override
  String get settingPanelWalkingSpeed => 'Walking speed';

  @override
  String get settingPanelAvoidWalking => 'Avoid walking';

  @override
  String get settingPanelTransportModes => 'Transport modes';

  @override
  String get instructionVehicleSharing => 'Sharing';

  @override
  String get commonCitybikes => 'Rental bikes and scooters';

  @override
  String get instructionVehicleSharingRegioRad => 'RegioRad';

  @override
  String get instructionVehicleSharingTaxi => 'Taxi';

  @override
  String get instructionVehicleSharingCarSharing => 'Car sharing';

  @override
  String get settingPanelAvoidTransfers => 'Avoid transfers';

  @override
  String get settingPanelMyModesTransport => 'My modes of transport';

  @override
  String get settingPanelBikingSpeed => 'Biking speed';

  @override
  String get settingPanelMyModesTransportParkRide => 'Park & Ride';

  @override
  String get settingPanelAccessibility => 'Accessibility';

  @override
  String get settingPanelAccessibilityDetails => 'Due to a lack of data on accessibility, we are unfortunately unable to provide any barrier-free routes at the moment.';

  @override
  String get settingPanelWheelchair => 'Wheelchair';

  @override
  String get settingPanelMyModesTransportBike => 'Bike';

  @override
  String get typeSpeedAverage => 'Normal';

  @override
  String get typeSpeedFast => 'Fast';

  @override
  String get typeSpeedSlow => 'Slow';

  @override
  String get commonLeavingNow => 'Leaving now';

  @override
  String get commonArrival => 'Arrival';

  @override
  String get commonDeparture => 'Departure';

  @override
  String get infoMessageDestinationOutsideService => 'No route suggestions were found because the destination is outside the service area.';

  @override
  String get infoMessageNoRouteMsg => 'Unfortunately, no route suggestions were found.';

  @override
  String get infoMessageNoRouteMsgWithChanges => 'Unfortunately, no route suggestions were found. Please check your search settings or try changing the origin or destination.';

  @override
  String get infoMessageNoRouteOriginNearDestination => 'No route suggestions were found because the origin and destination are the same.';

  @override
  String get infoMessageNoRouteOriginSameAsDestination => 'No route suggestions were found because the origin and destination are very close to each other.';

  @override
  String get infoMessageNoRouteShowingAlternativeOptions => 'No route suggestions were found with your settings. However, we found the following route options:';

  @override
  String get infoMessageOnlyCyclingRoutes => 'Your search returned only cycling routes.';

  @override
  String get infoMessageOnlyWalkingCyclingRoutes => 'Your search returned only walking and cycling routes.';

  @override
  String get infoMessageOnlyWalkingRoutes => 'Your search returned only walking routes.';

  @override
  String get infoMessageOriginOutsideService => 'No route suggestions were found because the origin is outside the service area.';

  @override
  String get infoMessageUseNationalServicePrefix => 'We recommend you try the national journey planner,';

  @override
  String get bikeRentalBikeStation => 'Bike station';

  @override
  String get commonDetails => 'Details';

  @override
  String get commonMoreInformartion => 'More informartion';

  @override
  String get commonCall => 'Call';

  @override
  String get commonOnDemandTaxi => 'Book a trip';

  @override
  String get carParkCloseCapacityMessage => 'This car park is close to capacity. Please allow additional time for you journey.';

  @override
  String get carParkExcludeFull => 'Exclude full car parks';

  @override
  String get bikeRentalNetworkFreeFloating => 'Destination is not a designated drop-off area. Rental cannot be completed here. Please check terms & conditions for additional fees.';

  @override
  String get fetchMoreItinerariesLaterDeparturesTitle => 'Later departures';

  @override
  String get fetchMoreItinerariesEarlierDepartures => 'Earlier departures';

  @override
  String get settingPanelMyModesTransportBikeRide => 'Bike & Ride';

  @override
  String get instructionVehicleTaxi => 'Taxi';

  @override
  String get mapLegendBicycleParking => 'bicycle parking';

  @override
  String get mapLegendCoveredBicycleParking => 'covered bicycle parking';

  @override
  String get mapLegendLockableBicycleParking => 'lockable bicycle parking';

  @override
  String get mapLegendBicycleRepairFacility => 'bicycle repair facility';

  @override
  String get mapLegendBikeLane => 'bike lane';

  @override
  String get mapLegendMajorCyclingRoute => 'major cycling route';

  @override
  String get mapLegendLocalCyclingRoute => 'local cycling route';

  @override
  String get notShowAgain => 'Do not show again';

  @override
  String get mapTypeLabel => 'Map Type';

  @override
  String get commonMapSettings => 'Map Settings';

  @override
  String get commonShowMap => 'Show on map';

  @override
  String get bikePark => 'Park & Ride for bikes';

  @override
  String get itinerarySummaryBikeParkTitle => 'Leave your bike at a Park & Ride';

  @override
  String get itinerarySummaryBikeAndPublicRailSubwayTitle => 'Take your bike with you on the train or to metro';

  @override
  String departureBikeStation(Object departureStop, Object departureTime) {
    return 'Departure at $departureTime from $departureStop bike station';
  }

  @override
  String get commonTotalDistance => 'Total distance';

  @override
  String get commonSettings => 'Settings';

  @override
  String get mapLegend => 'map legend';

  @override
  String selectStop(Object sizeStops) {
    return 'Select option ($sizeStops)';
  }

  @override
  String get bicycleParking => 'Bicycle parking';

  @override
  String get instructionVehicleRackRailway => 'funicular/ rack railway';

  @override
  String get commonTrack => 'Track';

  @override
  String get commonPlatform => 'Platform';

  @override
  String get weekdayMO => 'Monday';

  @override
  String get weekdayTU => 'Tuesday';

  @override
  String get weekdayWE => 'Wednesday';

  @override
  String get weekdayTH => 'Thursday';

  @override
  String get weekdayFR => 'Friday';

  @override
  String get weekdaySA => 'Saturday';

  @override
  String get weekdaySU => 'Sunday';

  @override
  String get weekdayPH => 'Public holiday';

  @override
  String legStepsStartInstructions(Object absoluteDirection, Object streetName) {
    return 'Start on $streetName towards $absoluteDirection';
  }

  @override
  String relativeDirectionDepart(Object streetName) {
    return 'Start on $streetName';
  }

  @override
  String relativeDirectionHardLeft(Object streetName) {
    return 'Turn sharp left onto $streetName';
  }

  @override
  String relativeDirectionLeft(Object streetName) {
    return 'Turn left onto $streetName';
  }

  @override
  String relativeDirectionSlightlyLeft(Object streetName) {
    return 'Keep slightly left onto $streetName';
  }

  @override
  String relativeDirectionContinue(Object streetName) {
    return 'Continue straight on $streetName';
  }

  @override
  String relativeDirectionSlightlyRight(Object streetName) {
    return 'Keep slightly right onto $streetName';
  }

  @override
  String relativeDirectionRight(Object streetName) {
    return 'Turn right onto $streetName';
  }

  @override
  String relativeDirectionHardRight(Object streetName) {
    return 'Turn sharp right onto $streetName';
  }

  @override
  String relativeDirectionCircleClockwise(Object exitNumber, Object streetName) {
    return 'Enter the roundabout to the left and take the $exitNumber exit clockwise onto $streetName';
  }

  @override
  String relativeDirectionCircleCounterclockwise(Object exitNumber, Object streetName) {
    return 'Enter the roundabout and take the $exitNumber exit onto $streetName';
  }

  @override
  String relativeDirectionElevator(Object streetName) {
    return 'Take the elevator to $streetName';
  }

  @override
  String relativeDirectionUturnLeft(Object streetName) {
    return 'Make a U-turn to the left onto $streetName';
  }

  @override
  String relativeDirectionUturnRight(Object streetName) {
    return 'Make a U-turn to the right onto $streetName';
  }

  @override
  String relativeDirectionEnterStation(Object streetName) {
    return 'Enter the station at $streetName';
  }

  @override
  String relativeDirectionExitStation(Object streetName) {
    return 'Exit the station towards $streetName';
  }

  @override
  String relativeDirectionFollowSigns(Object streetName) {
    return 'Follow the signs to $streetName';
  }

  @override
  String get absoluteDirectionNorth => 'North';

  @override
  String get absoluteDirectionNortheast => 'Northeast';

  @override
  String get absoluteDirectionEast => 'East';

  @override
  String get absoluteDirectionSoutheast => 'Southeast';

  @override
  String get absoluteDirectionSouth => 'South';

  @override
  String get absoluteDirectionSouthwest => 'Southwest';

  @override
  String get absoluteDirectionWest => 'West';

  @override
  String get absoluteDirectionNorthwest => 'Northwest';

  @override
  String get commonNow => 'Now';

  @override
  String get commonClosed => 'Closed';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonOpenAlways => 'Open 24/7';

  @override
  String get commonShowMore => 'Show more';

  @override
  String get commonShowLess => 'Show less';

  @override
  String get commonMoreInfo => 'More info';

  @override
  String get journeyCo2Emissions => 'CO₂ emissions of the journey';

  @override
  String get journeyCo2EmissionsSr => 'Carbondioxide emissions of the journey';

  @override
  String get itineraryCo2Link => 'This is how we compare emissions ›';

  @override
  String get commonRealTime => 'Real-time';

  @override
  String get commonStart => 'Start';

  @override
  String get navigationTurnByTurnNavigation => 'Turn by turn navigation';

  @override
  String get navigationTurnByTurnNavigationWarning => 'You have strayed too far from the route. Please return to the path.';

  @override
  String get carInstructionDrive => 'Drive';

  @override
  String get departureListUpdateSrInstructions => 'The list of upcoming departures and departure times will update in real time.';

  @override
  String departurePageSr(Object destination, Object shortName, Object time) {
    return 'Trip $shortName $destination $time information';
  }

  @override
  String departureTimeSr(Object realTime, Object time, Object when) {
    return '$when clock $time. $realTime';
  }

  @override
  String get disruptionsTabSrDisruptions => 'One or more known disruptions';

  @override
  String get disruptionsTabSrNoDisruptions => 'No known disruptions';

  @override
  String itineraryCo2Description(Object carCo2Value, Object co2value) {
    return '$co2value g of CO₂ emissions will be generated on this journey. A car would generate $carCo2Value g of CO₂ on the same journey.';
  }

  @override
  String itineraryCo2DescriptionSr(Object carCo2Value, Object co2value) {
    return '$co2value g of carbondioxide emissions will be generated on this journey. A car would generate $carCo2Value g of carbondioxide on the same journey.';
  }

  @override
  String itineraryCo2DescriptionSimple(Object co2value) {
    return '$co2value g of CO₂ emissions will be generated on this journey.';
  }

  @override
  String itineraryCo2DescriptionSimpleSr(Object co2value) {
    return '$co2value g of carbondioxide emissions will be generated on this journey.';
  }

  @override
  String get itineraryCo2TitleSr => 'Carbondioxide emissions of the journey';

  @override
  String get searchFieldsSrInstructions => 'Route search will take place automatically when you enter origin and destination. Changing search parameters will trigger a new search.';

  @override
  String get stopListUpdateSrInstructions => 'Departure times for each stop will update in real time.';

  @override
  String swipeSrNewTabOpened(Object number) {
    return 'Tab $number opened.';
  }

  @override
  String get tripCo2EmissionsSr => 'Carbondioxide emissions of the journey';

  @override
  String departureTimeInMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String get poiTagWheelchair => 'Wheelchair accessible';

  @override
  String get poiTagOutdoor => 'Outdoor seating';

  @override
  String get poiTagDogs => 'Dogs allowed';

  @override
  String get poiTagWifi => 'WiFi';

  @override
  String poiTagOperator(Object operator) {
    return 'Operator: $operator';
  }

  @override
  String poiTagBrand(Object brand) {
    return 'Brand: $brand';
  }

  @override
  String bicycleWalkFromTransitNoDuration(Object transportMode) {
    return 'Walk your bike off the $transportMode';
  }

  @override
  String bicycleWalkToTransitNoDuration(Object transportMode) {
    return 'Walk your bike to the $transportMode';
  }

  @override
  String get instructionVehicleLightRail => 'Rail';

  @override
  String get instructionVehicleMetro => 'Metro';

  @override
  String get chooseOnMap => 'Choose on map';
}
