import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/route_stops_screen/route_stops_screen.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/stoptime.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class CustomStopTile extends StatelessWidget {
  final StoptimeOtp stopTime;
  final bool isLastStop;

  const CustomStopTile({
    Key? key,
    required this.stopTime,
    this.isLastStop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final stLocalization = StadtnaviBaseLocalization.of(context);
    final timeDiffInMinutes = stopTime.departureDelay != null
        ? ((stopTime.departureDelay! - DateTime.now().millisecondsSinceEpoch) /
                60)
            .floor()
        : 0;

    String shownTime = "";
    if (timeDiffInMinutes <= 0) {
      shownTime = stLocalization.commonNow;
    } else {
      shownTime = stLocalization.departureTimeInMinutes(timeDiffInMinutes);
    }

    return Semantics(
      label: stLocalization.departurePageSr(
        stopTime.getHeadsing(
          isLastStop: isLastStop,
          languageCode: languageCode,
        ),
        stopTime.trip?.route?.shortName ?? '',
        shownTime,
      ),
      button: true,
      excludeSemantics: true,
      child: Column(
        children: [
          ListTile(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BaseTrufiPage(
                      child: RoutesStopScreen(
                        routeShortName: stopTime.trip?.route?.shortName ?? '',
                        routeGtfsId: stopTime.trip?.route?.gtfsId ?? '',
                        patternCode: stopTime.trip?.pattern?.code ?? '',
                        transportMode: stopTime.trip?.route?.mode,
                      ),
                    ),
                  ),
                );
              },
              leading: Container(
                decoration: BoxDecoration(
                  color: stopTime.trip?.route?.color != null
                      ? Color(
                          int.tryParse("0xFF${stopTime.trip?.route?.color}")!)
                      : stopTime.trip?.route?.mode?.color ?? Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: 50,
                child: stopTime.trip?.route?.useIcon ?? false
                    ? stopTime.trip!.route!.mode?.getImage()
                    : Text(
                        stopTime.trip?.route?.shortName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              title: Text(
                stopTime.getHeadsing(
                    isLastStop: isLastStop, languageCode: languageCode),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: stopTime.isArrival && !isLastStop
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            color: const Color(0xffe5f2fa),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: theme.colorScheme.primary,
                                  size: 17,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  languageCode == 'en'
                                      ? "Drop-off only"
                                      : "Nur Abgabe",
                                  style: theme.textTheme.bodyLarge
                                      ?.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
              trailing: Semantics(
                label: stLocalization.departureTimeSr(
                  ((stopTime.realtime ?? false) ? "Realtime" : ""),
                  stopTime.stopTimeAsString,
                  shownTime,
                ),
                button: true,
                excludeSemantics: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${stopTime.timeDiffInMinutes} ',
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      '${stopTime.stopTimeAsString} ',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              )),
          const Divider(
            height: 0,
            color: Colors.black87,
            indent: 16,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
