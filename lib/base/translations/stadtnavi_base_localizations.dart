import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'stadtnavi_base_localizations_de.dart';
import 'stadtnavi_base_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StadtnaviBaseLocalization
/// returned by `StadtnaviBaseLocalization.of(context)`.
///
/// Applications need to include `StadtnaviBaseLocalization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/stadtnavi_base_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StadtnaviBaseLocalization.localizationsDelegates,
///   supportedLocales: StadtnaviBaseLocalization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the StadtnaviBaseLocalization.supportedLocales
/// property.
abstract class StadtnaviBaseLocalization {
  StadtnaviBaseLocalization(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StadtnaviBaseLocalization of(BuildContext context) {
    return Localizations.of<StadtnaviBaseLocalization>(
        context, StadtnaviBaseLocalization)!;
  }

  static const LocalizationsDelegate<StadtnaviBaseLocalization> delegate = _StadtnaviBaseLocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// Itinerary Ticket Title label
  ///
  /// In en, this message translates to:
  /// **'Required tickets'**
  String get itineraryTicketsTitle;

  /// Itinerary Ticket Title label
  ///
  /// In en, this message translates to:
  /// **'Required ticket'**
  String get itineraryTicketTitle;

  /// Itinerary Buy tickets label
  ///
  /// In en, this message translates to:
  /// **'Buy tickets'**
  String get itineraryBuyTicket;

  /// Itinerary No price information label
  ///
  /// In en, this message translates to:
  /// **'No price information'**
  String get itineraryMissingPrice;

  /// Itinerary Price Only PublicTransport label
  ///
  /// In en, this message translates to:
  /// **'Price only valid for public transport part of the journey.'**
  String get itineraryPriceOnlyPublicTransport;

  /// copyrights Price Provider for cost
  ///
  /// In en, this message translates to:
  /// **'Fare information provided by Nahverkehrsgesellschaft Baden-Württemberg mbH (NVBW). No liability for the correctness of the information.'**
  String get copyrightsPriceProvider;

  /// The type ticket.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get fareTicketName;

  /// Walking Speed configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Walking speed'**
  String get settingPanelWalkingSpeed;

  /// Avoid Walking configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Avoid walking'**
  String get settingPanelAvoidWalking;

  /// Transport Modes configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Transport modes'**
  String get settingPanelTransportModes;

  /// Vehicle name (Sharing)
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get instructionVehicleSharing;

  /// General Rental bikes and scooters label
  ///
  /// In en, this message translates to:
  /// **'Rental bikes and scooters'**
  String get commonCitybikes;

  /// Vehicle name (RegioRad)
  ///
  /// In en, this message translates to:
  /// **'RegioRad'**
  String get instructionVehicleSharingRegioRad;

  /// Vehicle name (Taxi)
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get instructionVehicleSharingTaxi;

  /// Vehicle name (Car sharing)
  ///
  /// In en, this message translates to:
  /// **'Car sharing'**
  String get instructionVehicleSharingCarSharing;

  /// Avoid Transfers configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Avoid transfers'**
  String get settingPanelAvoidTransfers;

  /// My modes of transport configuration panel label
  ///
  /// In en, this message translates to:
  /// **'My modes of transport'**
  String get settingPanelMyModesTransport;

  /// Travel Speed configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Biking speed'**
  String get settingPanelBikingSpeed;

  /// Park and Ride configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Park & Ride'**
  String get settingPanelMyModesTransportParkRide;

  /// Accessibility configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingPanelAccessibility;

  /// Accessibility details configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Due to a lack of data on accessibility, we are unfortunately unable to provide any barrier-free routes at the moment.'**
  String get settingPanelAccessibilityDetails;

  /// Wheelchair configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Wheelchair'**
  String get settingPanelWheelchair;

  /// Bike configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get settingPanelMyModesTransportBike;

  /// Average speed type
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get typeSpeedAverage;

  /// Fast speed type
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get typeSpeedFast;

  /// Slow speed type
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get typeSpeedSlow;

  /// General Leaving now label
  ///
  /// In en, this message translates to:
  /// **'Leaving now'**
  String get commonLeavingNow;

  /// General Arrival label
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get commonArrival;

  /// General Departure label
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get commonDeparture;

  /// Text info message Destination outside for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the destination is outside the service area.'**
  String get infoMessageDestinationOutsideService;

  /// Text info message No Route Msg for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no route suggestions were found.'**
  String get infoMessageNoRouteMsg;

  /// Text info message No Route Msg With Changes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no route suggestions were found. Please check your search settings or try changing the origin or destination.'**
  String get infoMessageNoRouteMsgWithChanges;

  /// Text info message no route origin same as a destination for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the origin and destination are the same.'**
  String get infoMessageNoRouteOriginNearDestination;

  /// Text info message No Route Origin Same As Destination for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the origin and destination are very close to each other.'**
  String get infoMessageNoRouteOriginSameAsDestination;

  /// Text info message No Route Showing Alternative Options for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found with your settings. However, we found the following route options:'**
  String get infoMessageNoRouteShowingAlternativeOptions;

  /// Text info message Only walking and cycling Routes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Your search returned only cycling routes.'**
  String get infoMessageOnlyCyclingRoutes;

  /// Text info message Only cycling Routes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Your search returned only walking and cycling routes.'**
  String get infoMessageOnlyWalkingCyclingRoutes;

  /// Text info message Only Walking Routes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Your search returned only walking routes.'**
  String get infoMessageOnlyWalkingRoutes;

  /// Text info message origin outside for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the origin is outside the service area.'**
  String get infoMessageOriginOutsideService;

  /// Text info message Use National Service Prefix for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'We recommend you try the national journey planner,'**
  String get infoMessageUseNationalServicePrefix;

  /// Common Text Bike station
  ///
  /// In en, this message translates to:
  /// **'Bike station'**
  String get bikeRentalBikeStation;

  /// General details label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get commonDetails;

  /// General More informartion label
  ///
  /// In en, this message translates to:
  /// **'More informartion'**
  String get commonMoreInformartion;

  /// General Call label
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// General book a trip label
  ///
  /// In en, this message translates to:
  /// **'Book a trip'**
  String get commonOnDemandTaxi;

  /// This car park is close to capacity
  ///
  /// In en, this message translates to:
  /// **'This car park is close to capacity. Please allow additional time for you journey.'**
  String get carParkCloseCapacityMessage;

  /// Car Park Exclude Full parks label
  ///
  /// In en, this message translates to:
  /// **'Exclude full car parks'**
  String get carParkExcludeFull;

  /// Text Bike Rental Network message FreeFloating
  ///
  /// In en, this message translates to:
  /// **'Destination is not a designated drop-off area. Rental cannot be completed here. Please check terms & conditions for additional fees.'**
  String get bikeRentalNetworkFreeFloating;

  /// Text about extra fetch itineraries for later departure title
  ///
  /// In en, this message translates to:
  /// **'Later departures'**
  String get fetchMoreItinerariesLaterDeparturesTitle;

  /// Text about extra fetch itineraries for Earlier departure title
  ///
  /// In en, this message translates to:
  /// **'Earlier departures'**
  String get fetchMoreItinerariesEarlierDepartures;

  /// Bike and Ride configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Bike & Ride'**
  String get settingPanelMyModesTransportBikeRide;

  /// Vehicle name (onCar)
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get instructionVehicleTaxi;

  /// No description provided for @mapLegendBicycleParking.
  ///
  /// In en, this message translates to:
  /// **'bicycle parking'**
  String get mapLegendBicycleParking;

  /// No description provided for @mapLegendCoveredBicycleParking.
  ///
  /// In en, this message translates to:
  /// **'covered bicycle parking'**
  String get mapLegendCoveredBicycleParking;

  /// No description provided for @mapLegendLockableBicycleParking.
  ///
  /// In en, this message translates to:
  /// **'lockable bicycle parking'**
  String get mapLegendLockableBicycleParking;

  /// No description provided for @mapLegendBicycleRepairFacility.
  ///
  /// In en, this message translates to:
  /// **'bicycle repair facility'**
  String get mapLegendBicycleRepairFacility;

  /// No description provided for @mapLegendBikeLane.
  ///
  /// In en, this message translates to:
  /// **'bike lane'**
  String get mapLegendBikeLane;

  /// No description provided for @mapLegendMajorCyclingRoute.
  ///
  /// In en, this message translates to:
  /// **'major cycling route'**
  String get mapLegendMajorCyclingRoute;

  /// No description provided for @mapLegendLocalCyclingRoute.
  ///
  /// In en, this message translates to:
  /// **'local cycling route'**
  String get mapLegendLocalCyclingRoute;

  /// No description provided for @notShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Do not show again'**
  String get notShowAgain;

  /// Label for the Map types
  ///
  /// In en, this message translates to:
  /// **'Map Type'**
  String get mapTypeLabel;

  /// General Map Settings label
  ///
  /// In en, this message translates to:
  /// **'Map Settings'**
  String get commonMapSettings;

  /// General Show on map tilers label
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get commonShowMap;

  ///
  ///
  /// In en, this message translates to:
  /// **'Park & Ride for bikes'**
  String get bikePark;

  /// Text title itinerary Summary Bike Park Title
  ///
  /// In en, this message translates to:
  /// **'Leave your bike at a Park & Ride'**
  String get itinerarySummaryBikeParkTitle;

  /// Text title itinerary Summary Bike And Public Rail Subway
  ///
  /// In en, this message translates to:
  /// **'Take your bike with you on the train or to metro'**
  String get itinerarySummaryBikeAndPublicRailSubwayTitle;

  /// Departure Bike Station detail Time and Stop
  ///
  /// In en, this message translates to:
  /// **'Departure at {departureTime} from {departureStop} bike station'**
  String departureBikeStation(Object departureStop, Object departureTime);

  /// No description provided for @commonTotalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total distance'**
  String get commonTotalDistance;

  /// General Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @mapLegend.
  ///
  /// In en, this message translates to:
  /// **'map legend'**
  String get mapLegend;

  /// No description provided for @selectStop.
  ///
  /// In en, this message translates to:
  /// **'Select option ({sizeStops})'**
  String selectStop(Object sizeStops);

  /// No description provided for @bicycleParking.
  ///
  /// In en, this message translates to:
  /// **'Bicycle parking'**
  String get bicycleParking;

  /// No description provided for @instructionVehicleRackRailway.
  ///
  /// In en, this message translates to:
  /// **'funicular/ rack railway'**
  String get instructionVehicleRackRailway;

  /// General Track  label
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get commonTrack;

  /// General Platform  label
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get commonPlatform;

  /// No description provided for @weekdayMO.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMO;

  /// No description provided for @weekdayTU.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTU;

  /// No description provided for @weekdayWE.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWE;

  /// No description provided for @weekdayTH.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayTH;

  /// No description provided for @weekdayFR.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFR;

  /// No description provided for @weekdaySA.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySA;

  /// No description provided for @weekdaySU.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySU;

  /// No description provided for @weekdayPH.
  ///
  /// In en, this message translates to:
  /// **'Public holiday'**
  String get weekdayPH;

  /// No description provided for @legStepsStartInstructions.
  ///
  /// In en, this message translates to:
  /// **'Start on {streetName} towards {absoluteDirection}'**
  String legStepsStartInstructions(Object absoluteDirection, Object streetName);

  /// No description provided for @relativeDirectionDepart.
  ///
  /// In en, this message translates to:
  /// **'Start on {streetName}'**
  String relativeDirectionDepart(Object streetName);

  /// No description provided for @relativeDirectionHardLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn sharp left onto {streetName}'**
  String relativeDirectionHardLeft(Object streetName);

  /// No description provided for @relativeDirectionLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn left onto {streetName}'**
  String relativeDirectionLeft(Object streetName);

  /// No description provided for @relativeDirectionSlightlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Keep slightly left onto {streetName}'**
  String relativeDirectionSlightlyLeft(Object streetName);

  /// No description provided for @relativeDirectionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue straight on {streetName}'**
  String relativeDirectionContinue(Object streetName);

  /// No description provided for @relativeDirectionSlightlyRight.
  ///
  /// In en, this message translates to:
  /// **'Keep slightly right onto {streetName}'**
  String relativeDirectionSlightlyRight(Object streetName);

  /// No description provided for @relativeDirectionRight.
  ///
  /// In en, this message translates to:
  /// **'Turn right onto {streetName}'**
  String relativeDirectionRight(Object streetName);

  /// No description provided for @relativeDirectionHardRight.
  ///
  /// In en, this message translates to:
  /// **'Turn sharp right onto {streetName}'**
  String relativeDirectionHardRight(Object streetName);

  /// No description provided for @relativeDirectionCircleClockwise.
  ///
  /// In en, this message translates to:
  /// **'Enter the roundabout to the left and take the {exitNumber} exit clockwise onto {streetName}'**
  String relativeDirectionCircleClockwise(Object exitNumber, Object streetName);

  /// No description provided for @relativeDirectionCircleCounterclockwise.
  ///
  /// In en, this message translates to:
  /// **'Enter the roundabout and take the {exitNumber} exit onto {streetName}'**
  String relativeDirectionCircleCounterclockwise(Object exitNumber, Object streetName);

  /// No description provided for @relativeDirectionElevator.
  ///
  /// In en, this message translates to:
  /// **'Take the elevator to {streetName}'**
  String relativeDirectionElevator(Object streetName);

  /// No description provided for @relativeDirectionUturnLeft.
  ///
  /// In en, this message translates to:
  /// **'Make a U-turn to the left onto {streetName}'**
  String relativeDirectionUturnLeft(Object streetName);

  /// No description provided for @relativeDirectionUturnRight.
  ///
  /// In en, this message translates to:
  /// **'Make a U-turn to the right onto {streetName}'**
  String relativeDirectionUturnRight(Object streetName);

  /// No description provided for @relativeDirectionEnterStation.
  ///
  /// In en, this message translates to:
  /// **'Enter the station at {streetName}'**
  String relativeDirectionEnterStation(Object streetName);

  /// No description provided for @relativeDirectionExitStation.
  ///
  /// In en, this message translates to:
  /// **'Exit the station towards {streetName}'**
  String relativeDirectionExitStation(Object streetName);

  /// No description provided for @relativeDirectionFollowSigns.
  ///
  /// In en, this message translates to:
  /// **'Follow the signs to {streetName}'**
  String relativeDirectionFollowSigns(Object streetName);

  /// No description provided for @absoluteDirectionNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get absoluteDirectionNorth;

  /// No description provided for @absoluteDirectionNortheast.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get absoluteDirectionNortheast;

  /// No description provided for @absoluteDirectionEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get absoluteDirectionEast;

  /// No description provided for @absoluteDirectionSoutheast.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get absoluteDirectionSoutheast;

  /// No description provided for @absoluteDirectionSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get absoluteDirectionSouth;

  /// No description provided for @absoluteDirectionSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get absoluteDirectionSouthwest;

  /// No description provided for @absoluteDirectionWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get absoluteDirectionWest;

  /// No description provided for @absoluteDirectionNorthwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get absoluteDirectionNorthwest;

  /// No description provided for @commonNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get commonNow;

  /// No description provided for @commonClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get commonClosed;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @commonOpenAlways.
  ///
  /// In en, this message translates to:
  /// **'Open 24/7'**
  String get commonOpenAlways;

  /// No description provided for @commonShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get commonShowMore;

  /// No description provided for @commonShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get commonShowLess;

  /// No description provided for @commonMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'More info'**
  String get commonMoreInfo;

  /// No description provided for @journeyCo2Emissions.
  ///
  /// In en, this message translates to:
  /// **'CO₂ emissions of the journey'**
  String get journeyCo2Emissions;

  /// No description provided for @journeyCo2EmissionsSr.
  ///
  /// In en, this message translates to:
  /// **'Carbondioxide emissions of the journey'**
  String get journeyCo2EmissionsSr;

  /// No description provided for @itineraryCo2Link.
  ///
  /// In en, this message translates to:
  /// **'This is how we compare emissions ›'**
  String get itineraryCo2Link;

  /// No description provided for @commonRealTime.
  ///
  /// In en, this message translates to:
  /// **'Real-time'**
  String get commonRealTime;

  /// No description provided for @commonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get commonStart;

  /// No description provided for @navigationTurnByTurnNavigation.
  ///
  /// In en, this message translates to:
  /// **'Turn by turn navigation'**
  String get navigationTurnByTurnNavigation;

  /// No description provided for @navigationTurnByTurnNavigationWarning.
  ///
  /// In en, this message translates to:
  /// **'You have strayed too far from the route. Please return to the path.'**
  String get navigationTurnByTurnNavigationWarning;

  /// No description provided for @carInstructionDrive.
  ///
  /// In en, this message translates to:
  /// **'Drive'**
  String get carInstructionDrive;

  /// No description provided for @departureListUpdateSrInstructions.
  ///
  /// In en, this message translates to:
  /// **'The list of upcoming departures and departure times will update in real time.'**
  String get departureListUpdateSrInstructions;

  /// No description provided for @departurePageSr.
  ///
  /// In en, this message translates to:
  /// **'Trip {shortName} {destination} {time} information'**
  String departurePageSr(Object destination, Object shortName, Object time);

  /// No description provided for @departureTimeSr.
  ///
  /// In en, this message translates to:
  /// **'{when} clock {time}. {realTime}'**
  String departureTimeSr(Object realTime, Object time, Object when);

  /// No description provided for @disruptionsTabSrDisruptions.
  ///
  /// In en, this message translates to:
  /// **'One or more known disruptions'**
  String get disruptionsTabSrDisruptions;

  /// No description provided for @disruptionsTabSrNoDisruptions.
  ///
  /// In en, this message translates to:
  /// **'No known disruptions'**
  String get disruptionsTabSrNoDisruptions;

  /// No description provided for @itineraryCo2Description.
  ///
  /// In en, this message translates to:
  /// **'{co2value} g of CO₂ emissions will be generated on this journey. A car would generate {carCo2Value} g of CO₂ on the same journey.'**
  String itineraryCo2Description(Object carCo2Value, Object co2value);

  /// No description provided for @itineraryCo2DescriptionSr.
  ///
  /// In en, this message translates to:
  /// **'{co2value} g of carbondioxide emissions will be generated on this journey. A car would generate {carCo2Value} g of carbondioxide on the same journey.'**
  String itineraryCo2DescriptionSr(Object carCo2Value, Object co2value);

  /// No description provided for @itineraryCo2DescriptionSimple.
  ///
  /// In en, this message translates to:
  /// **'{co2value} g of CO₂ emissions will be generated on this journey.'**
  String itineraryCo2DescriptionSimple(Object co2value);

  /// No description provided for @itineraryCo2DescriptionSimpleSr.
  ///
  /// In en, this message translates to:
  /// **'{co2value} g of carbondioxide emissions will be generated on this journey.'**
  String itineraryCo2DescriptionSimpleSr(Object co2value);

  /// No description provided for @itineraryCo2TitleSr.
  ///
  /// In en, this message translates to:
  /// **'Carbondioxide emissions of the journey'**
  String get itineraryCo2TitleSr;

  /// No description provided for @searchFieldsSrInstructions.
  ///
  /// In en, this message translates to:
  /// **'Route search will take place automatically when you enter origin and destination. Changing search parameters will trigger a new search.'**
  String get searchFieldsSrInstructions;

  /// No description provided for @stopListUpdateSrInstructions.
  ///
  /// In en, this message translates to:
  /// **'Departure times for each stop will update in real time.'**
  String get stopListUpdateSrInstructions;

  /// No description provided for @swipeSrNewTabOpened.
  ///
  /// In en, this message translates to:
  /// **'Tab {number} opened.'**
  String swipeSrNewTabOpened(Object number);

  /// No description provided for @tripCo2EmissionsSr.
  ///
  /// In en, this message translates to:
  /// **'Carbondioxide emissions of the journey'**
  String get tripCo2EmissionsSr;

  /// No description provided for @departureTimeInMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String departureTimeInMinutes(Object minutes);

  /// No description provided for @poiTagWheelchair.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair accessible'**
  String get poiTagWheelchair;

  /// No description provided for @poiTagOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor seating'**
  String get poiTagOutdoor;

  /// No description provided for @poiTagDogs.
  ///
  /// In en, this message translates to:
  /// **'Dogs allowed'**
  String get poiTagDogs;

  /// No description provided for @poiTagWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get poiTagWifi;

  /// No description provided for @poiTagOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator: {operator}'**
  String poiTagOperator(Object operator);

  /// No description provided for @poiTagBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand: {brand}'**
  String poiTagBrand(Object brand);

  /// No description provided for @bicycleWalkFromTransitNoDuration.
  ///
  /// In en, this message translates to:
  /// **'Walk your bike off the {transportMode}'**
  String bicycleWalkFromTransitNoDuration(Object transportMode);

  /// No description provided for @bicycleWalkToTransitNoDuration.
  ///
  /// In en, this message translates to:
  /// **'Walk your bike to the {transportMode}'**
  String bicycleWalkToTransitNoDuration(Object transportMode);

  /// No description provided for @instructionVehicleLightRail.
  ///
  /// In en, this message translates to:
  /// **'Rail'**
  String get instructionVehicleLightRail;

  /// No description provided for @instructionVehicleMetro.
  ///
  /// In en, this message translates to:
  /// **'Metro'**
  String get instructionVehicleMetro;

  /// No description provided for @chooseOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get chooseOnMap;
}

class _StadtnaviBaseLocalizationDelegate extends LocalizationsDelegate<StadtnaviBaseLocalization> {
  const _StadtnaviBaseLocalizationDelegate();

  @override
  Future<StadtnaviBaseLocalization> load(Locale locale) {
    return SynchronousFuture<StadtnaviBaseLocalization>(lookupStadtnaviBaseLocalization(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_StadtnaviBaseLocalizationDelegate old) => false;
}

StadtnaviBaseLocalization lookupStadtnaviBaseLocalization(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return StadtnaviBaseLocalizationDe();
    case 'en': return StadtnaviBaseLocalizationEn();
  }

  throw FlutterError(
    'StadtnaviBaseLocalization.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
