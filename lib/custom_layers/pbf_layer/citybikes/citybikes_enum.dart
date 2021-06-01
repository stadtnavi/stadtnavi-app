import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'citybikes_icon.dart';

enum CityBikeLayerIds {
  carSharing,
  regiorad,
  taxi,
}

CityBikeLayerIds cityBikeLayerIdStringToEnum(String id) {
  return CityBikeLayerIdsExtension.names.keys.firstWhere(
    (keyE) => keyE.name == id,
    orElse: () => CityBikeLayerIds.carSharing,
  );
}

extension CityBikeLayerIdsExtension on CityBikeLayerIds {
  static const names = <CityBikeLayerIds, String>{
    CityBikeLayerIds.taxi: 'taxi',
    CityBikeLayerIds.carSharing: 'car-sharing',
    CityBikeLayerIds.regiorad: 'regiorad',
  };

  static final images = <CityBikeLayerIds, SvgPicture>{
    CityBikeLayerIds.taxi: SvgPicture.string(taxiSvg),
    CityBikeLayerIds.carSharing: SvgPicture.string(carSharingSvg),
    CityBikeLayerIds.regiorad: SvgPicture.string(regioradSvg),
  };

  static final imagesStop = <CityBikeLayerIds, SvgPicture>{
    CityBikeLayerIds.taxi: SvgPicture.string(taxiStopSvg),
    CityBikeLayerIds.carSharing: SvgPicture.string(carSharingStopSvg),
    CityBikeLayerIds.regiorad: SvgPicture.string(regioradStopSvg),
  };

  static final translateEn = <CityBikeLayerIds, String>{
    CityBikeLayerIds.taxi: "Taxi rank",
    CityBikeLayerIds.carSharing: "Car sharing station",
    CityBikeLayerIds.regiorad: "Bike rental station",
  };

  static final translateDE = <CityBikeLayerIds, String>{
    CityBikeLayerIds.taxi: 'Taxistand',
    CityBikeLayerIds.carSharing: 'Carsharing-Station',
    CityBikeLayerIds.regiorad: 'Fahrradverleih',
  };

  static const networkBookDataEn = <CityBikeLayerIds, NetworkBookData>{
    CityBikeLayerIds.taxi: null,
    CityBikeLayerIds.carSharing: NetworkBookData(
      'Book a shared car',
      'https://stuttgart.stadtmobil.de/privatkunden/',
      languageCode: "en",
    ),
    CityBikeLayerIds.regiorad: NetworkBookData(
      'Book a rental bike',
      'https://www.regioradstuttgart.de/',
      languageCode: "en",
    ),
  };

  static const networkBookDataDe = <CityBikeLayerIds, NetworkBookData>{
    CityBikeLayerIds.taxi: null,
    CityBikeLayerIds.carSharing: NetworkBookData(
      'Buchen Sie ein Car-Sharing-Auto',
      'https://stuttgart.stadtmobil.de/privatkunden/',
      languageCode: "de",
    ),
    CityBikeLayerIds.regiorad: NetworkBookData(
      'Buchen Sie ein Leihrad',
      'https://www.regioradstuttgart.de/de',
      languageCode: "de",
    ),
  };

  String get name => names[this];

  Widget get image =>
      images[this] ??
      const Icon(
        Icons.error,
        color: Colors.red,
      );

  Widget get imageStop =>
      imagesStop[this] ??
      const Icon(
        Icons.error,
        color: Colors.red,
      );

  String getTranslate(String languageCode) =>
      languageCode == 'en' ? translateEn[this] : translateDE[this];

  NetworkBookData getNetworkBookData(String languageCode) =>
      languageCode == 'en' ? networkBookDataEn[this] : networkBookDataDe[this];

  bool hasBook(String languageCode) => languageCode == 'en'
      ? networkBookDataEn[this] != null
      : networkBookDataDe[this] != null;
}

class NetworkBookData {
  final String title;
  final String url;
  final String languageCode;
  final IconData icon;

  const NetworkBookData(
    this.title,
    this.url, {
    this.languageCode,
    this.icon = Icons.launch,
  });

  String get bookText => languageCode == 'en' ? 'Book' : 'Buchen';
}
