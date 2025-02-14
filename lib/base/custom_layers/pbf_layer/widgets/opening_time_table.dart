import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/simple_opening_hours.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

class OpeningTimeTable extends StatefulWidget {
  final SimpleOpeningHours openingHours;
  final bool isOpenParking;
  final String? currentOpeningTime;
  const OpeningTimeTable({
    super.key,
    required this.openingHours,
    required this.isOpenParking,
    this.currentOpeningTime,
  });
  static String getCurrentOpeningTime(SimpleOpeningHours sOpeningHours) {
    final weekday = DateTime.now().weekday;
    return sOpeningHours.openingHours.values.toList()[weekday - 1].join(",");
  }

  @override
  State<OpeningTimeTable> createState() => _OpeningTimeTableState();
}

class _OpeningTimeTableState extends State<OpeningTimeTable> {
  @override
  Widget build(BuildContext context) {
    final localizationST = StadtnaviBaseLocalization.of(context);
    final theme = Theme.of(context);
    final isAlwaysOpen = widget.openingHours.inp == '24/7';
    final weekday = DateTime.now().weekday;
    const iconColor = Color(0xFF747474);
    return Column(
      children: [
        ExpansionTile(
          textColor: Colors.black,
          collapsedIconColor: Colors.black,
          iconColor: Colors.red,
          tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          title: Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${localizationST.commonNow} ",
                style: theme.textTheme.bodyMedium?.copyWith(color: iconColor),
              ),
              widget.isOpenParking
                  ? Text(
                      "${localizationST.commonOpen} : ${widget.currentOpeningTime}",
                      style: theme.textTheme.bodyMedium,
                    )
                  : Text(
                      localizationST.commonClosed,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
            ],
          ),
          children: [
            isAlwaysOpen
                ? Text(
                    localizationST.commonOpenAlways,
                  )
                : Column(
                    children: widget.openingHours.openingHours.entries.map(
                      (day) {
                        bool isBold = widget.openingHours.openingHours.keys
                                .toList()[weekday - 1] ==
                            day.key;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                SimpleOpeningHours.getDayName(
                                    day.key, localizationST),
                                style: TextStyle(
                                  fontWeight: isBold ? FontWeight.bold : null,
                                ),
                              ),
                              Column(
                                children: day.value.isNotEmpty
                                    ? day.value
                                        .map((e) => Text(
                                              e,
                                              style: TextStyle(
                                                fontWeight: isBold
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                            ))
                                        .toList()
                                    : [Text(localizationST.commonClosed)],
                              )
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
          ],
        ),
      ],
    );
  }
}
