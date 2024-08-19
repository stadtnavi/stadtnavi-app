import 'dart:convert';
import 'dart:developer';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:herrenberg/firebase_options.dart';
import 'package:herrenberg/lifecycle_reactor_handler_notifications.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/certificates_letsencrypt_android.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';

import 'package:stadtnavi_core/consts.dart';
import 'package:stadtnavi_core/stadtnavi_core.dart';
import 'package:stadtnavi_core/stadtnavi_hive_init.dart';

import 'branding_herrenberg.dart';
import 'static_layer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CertificatedLetsencryptAndroid.workAroundCertificated();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  log("getToken");
  // final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  // if (apnsToken != null) {
  //   log("apnsToken: $apnsToken");
  // }
  FirebaseMessaging.instance.getToken().then((value) {
    log("getToken: $value");
  }).catchError((error) {
    log("catchError");
    print("$error");
  });
  FirebaseInstallations.instance.getId().then((e) => log(e.toString()));
  // IOS
  // apnsToken: 66616B652D61706E732D746F6B656E2D666F722D73696D756C61746F72
  // getToken: eUy0rR1RVU9CpPJTc68vgf:APA91bGBUSe54uy0MyFAvBhf-1x-rWjxQ5XT6FfPbf5a2KTfIPJ-huTiuzSNPdVjh4c-8oUut_SkeDIiDoV18uW3CLL6Iif6EF7Jlj9CE-xDJvS3EnJYNuokPlqoTEYg6RekPI9GhXxE

  // ANDROID
  // getToken: e3PjGzmqTeqxrPLGwAK8_R:APA91bGr3W__eqE31jE9wTsO1tpkRP-_U_38ilalXgWvyFrIPVrMoT48DZiDbub_Dwp4GAoluNX2MXbOHhGgi7hlZbg0IB50TtSeUspUuQOirZIwTFvwH6Pu84XaUPXWYSQ4L3RgrZM3

  await messaging
      .requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )
      .catchError((error) => {print("$error")});

  await initHiveForFlutter();
  await _migrationOldData();
  // TODO we need to improve TransportMode Configuration
  TransportModeConfiguration.configure(transportColors: {
    TransportMode.bicycle: const Color(0xffFECC01),
    TransportMode.walk: const Color(0xffFECC01),
  });
  runApp(
    StadtnaviApp(
      appLifecycleReactorHandler: AppLifecycleReactorHandlerNotifications(),
      appName: 'stadtnavi',
      appNameTitle: 'stadtnavi|Herrenberg',
      cityName: 'Herrenberg',
      center: LatLng(48.5950, 8.8672),
      otpGraphqlEndpoint: ApiConfig().openTripPlannerUrl,
      urlFeedback: 'https://stadtnavi.de/feedback/',
      urlShareApp: 'https://herrenberg.stadtnavi.de/',
      urlRepository: 'https://github.com/trufi-association/trufi-app',
      urlImpressum: 'https://www.herrenberg.de/impressum',
      reportDefectsUri:
          Uri.parse('https://www.herrenberg.de/tools/mvs').replace(
        fragment: "mvPagePictures",
      ),
      layersContainer: customLayersHerrenberg,
      urlSocialMedia: const UrlSocialMedia(
        urlFacebook: 'https://www.facebook.com/stadtnavi/',
        urlInstagram: 'https://www.instagram.com/stadtnavi/',
        urlTwitter: 'https://twitter.com/stadtnavi',
        urlYoutube: 'https://www.youtube.com/channel/UCL_K2RPU0pxV5VYw0Aj_PUA',
      ),
      trufiBaseTheme: TrufiBaseTheme(
        themeMode: ThemeMode.light,
        brightness: Brightness.light,
        theme: brandingStadtnaviHerrenberg,
        darkTheme: brandingStadtnaviHerrenberg,
      ),
    ),
  );
}

Future<void> _migrationOldData() async {
  List<List<String>> data = [
    ['myPlacesStorage', 'SearchLocationsCubitMyPlaces'],
    ['myDefaultPlacesStorage', 'SearchLocationsCubitMyDefaultPlaces'],
    ['historyPlacesStorage', 'SearchLocationsCubitHistoryPlaces'],
    ['favoritePlacesStorage', 'SearchLocationsCubitFavoritePlaces'],
  ];
  final prefs = await SharedPreferences.getInstance();
  final _box = Hive.box('SearchLocationsCubit');
  for (List<String> element in data) {
    await _migration(
      oldRef: element[0],
      newRef: element[1],
      prefsOld: prefs,
      prefsNew: _box,
    );
  }
  await prefs.clear();
}

Future<void> _migration({
  required String oldRef,
  required String newRef,
  required SharedPreferences prefsOld,
  required Box prefsNew,
}) async {
  try {
    if (kIsWeb) return;
    // Migration datavor version menores a la 1.5.0
    final String? action = prefsOld.getString(oldRef);
    if (!prefsNew.containsKey(newRef) && action != null) {
      final data = (jsonDecode(action) as List<dynamic>)
          .map<TrufiLocation>(
            (dynamic json) =>
                TrufiLocation.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      await prefsNew.put(newRef, jsonEncode(data));
    }
  } catch (e) {
    e;
  }
}
