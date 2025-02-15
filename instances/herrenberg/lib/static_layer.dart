import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/poi_feature_model.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/custom_marker_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/custom_poi_icons.dart';

final List<CustomLayerContainer> customLayersHerrenberg = [
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Public Transit"
        : "Öffentlicher Nahverkehr",
    icon: (context) => const Icon(
      Icons.train,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.stopsLayers[StopsLayerIds.funicular]!,
      StaticTileLayers.stopsLayers[StopsLayerIds.bus]!,
      StaticTileLayers.stopsLayers[StopsLayerIds.subway]!,
      StaticTileLayers.stopsLayers[StopsLayerIds.rail]!,
      StaticTileLayers.liveBusLayer,
      // ...PoiCategoryEnum.values
      //     .map((value) => StaticTileLayers.poisLayers[value]!)
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Bike & Car"
        : "Fahrrad & Auto",
    icon: (context) => const Icon(
      Icons.directions_bike,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.bikeParkLayer,
      Layer(
        LayerIds.bicycleInfrastructure,
        '3',
        url: 'https://data.mfdz.de/hbg/dt-layers/bicycleinfrastructure.geojson',
        isOnline: true,
      ),
      StaticTileLayers.poisLayers[PoiCategoryEnum.cycleNetwork]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.bikeShops]!,
      // StaticTileLayers.poisLayers[PoiCategoryEnum.bikeRental]!,
      // StaticTileLayers.poisLayers[PoiCategoryEnum.weatherStations]!,
      StaticTileLayers.weatherLayer,
      // StaticTileLayers.poisLayers[PoiCategoryEnum.roadworks]!,

      StaticTileLayers.cifsLayer,
      StaticTileLayers.poisLayers[PoiCategoryEnum.parkAndRide]!,

      // StaticTileLayers.poisLayers[PoiCategoryEnum.chargingStations]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.gasStations]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.workshopsMv]!,
      StaticTileLayers.chargingLayer,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Sharing"
        : "Sharing-Angebote",
    icon: (context) => const Icon(
      Icons.bike_scooter,
      color: Colors.grey,
    ),
    layers: [
      StaticTileLayers.poisLayers[PoiCategoryEnum.scooter]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.cargoBicycle]!,
      // StaticTileLayers.poisLayers[PoiCategoryEnum.bicycle]!,
      StaticTileLayers.citybikeLayer,
      StaticTileLayers.poisLayers[PoiCategoryEnum.car]!,
      StaticTileLayers.stopsLayers[StopsLayerIds.carpool]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.scooter]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.cargoBicycle]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.bicycle]!,
      // StaticTileLayers.citybikeLayer,
      StaticTileLayers.poisLayers[PoiCategoryEnum.car]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.taxi]!,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Leisure & Tourisms"
        : "Freizeit & Tourismus",
    icon: (context) => SvgPicture.string(CustomPoiIcons.iconLeisureTourism,color: Colors.grey,),
    layers: [
      StaticTileLayers.poisLayers[PoiCategoryEnum.sights]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.restaurants]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.cafes]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.barsAndPubs]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.entertainmentArtsAndCulture]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.benchesAndViewpoints]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.accommodation]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.sportsParksPlaygrounds]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.benchesAndViewpoints]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.drinkingWaterAndFountains]!,

      StaticTileLayers.poisLayers[PoiCategoryEnum.toilets]!,
      Layer(
        LayerIds.publicToilets,
        '3',
        url: 'https://data.mfdz.de/hbg/dt-layers/toilet.geojson',
        isOnline: true,
      ),
      StaticTileLayers.poisLayers[PoiCategoryEnum.loarawanGateways]!,
      // Layer(
      //   LayerIds.lorawanGateways,
      //   '3',
      //   url: 'https://data.mfdz.de/hbg/dt-layers/lorawan-gateways.geojson',
      //   isOnline: true,
      // ),
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Shopping & Services"
        : "Besorgungen",
    icon: (context) => SvgPicture.string(CustomPoiIcons.iconShoppingServices,color: Colors.grey,),
    layers: [
      StaticTileLayers.poisLayers[PoiCategoryEnum.groceriesAndBeverages]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.shops]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.secondHandAndSharing]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.finance]!,
      StaticTileLayers
          .poisLayers[PoiCategoryEnum.postMailboxesAndDeliveryPoints]!,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Public Facilities"
        : "Öffentliche Einrichtungen",
    icon: (context) => SvgPicture.string(CustomPoiIcons.iconPublicFacilities,color: Colors.grey,),
    layers: [
      StaticTileLayers.poisLayers[PoiCategoryEnum.administrativeFacilities]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.policeFireDepartment]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.cemeteries]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.trashBinsAndRecycling]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.dogWasteBagStations]!,
    ],
  ),
  CustomLayerContainer(
    name: (context) => TrufiBaseLocalization.of(context).localeName == "en"
        ? "Health & Social Services"
        : "Gesundheit & Soziales",
    icon: (context) => SvgPicture.string(CustomPoiIcons.iconHealthSocialServices,color: Colors.grey,),
    layers: [
      StaticTileLayers.poisLayers[PoiCategoryEnum.education]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.schoolRouteMap]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.medicalServices]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.socialFacilities]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.childrenAndYouth]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.religiousSites]!,
      StaticTileLayers.poisLayers[PoiCategoryEnum.animalFacilities]!,
    ],
  ),
];
