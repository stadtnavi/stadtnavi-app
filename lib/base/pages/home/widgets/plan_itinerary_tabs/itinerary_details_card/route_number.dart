import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/icons_transport_modes.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/alert_severity_level_type.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

class RouteNumber extends StatelessWidget {
  final TransportMode? transportMode;
  final Color? backgroundColor;
  final String text;
  final String? tripHeadSing;
  final String? distance;
  final String? duration;
  final Widget? icon;
  final Widget? textContainer;
  final String? mode;
  final AlertSeverityLevelType? alertSeverityLevel;

  const RouteNumber({
    Key? key,
    this.transportMode,
    this.backgroundColor,
    required this.text,
    this.tripHeadSing,
    this.distance,
    this.duration,
    this.icon,
    this.textContainer,
    this.mode,
    this.alertSeverityLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    if (icon != null)
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: icon,
                      )
                    else
                      Container(
                        child: transportMode?.getImage(
                          color: transportMode == TransportMode.bicycle
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    if (transportMode != TransportMode.walk &&
                        transportMode != TransportMode.bicycle &&
                        transportMode != TransportMode.carPool)
                      Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (alertSeverityLevel != null)
                Positioned(
                  bottom: -5,
                  left: -4,
                  child: alertSeverityLevel!.getWithBigCautionIcon(size: 17),
                ),
            ],
          ),
          if (transportMode == TransportMode.carPool)
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: carpoolFgSvg,
                  ),
                  const SizedBox(width: 2),
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: carpoolAdacSvg,
                  )
                ],
              ),
            ),
          if (transportMode != TransportMode.bicycle &&
              transportMode != TransportMode.car &&
              textContainer == null)
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(2),
                child: Text(
                  tripHeadSing ?? '',
                  style: theme.primaryTextTheme.bodyLarge,
                  overflow: TextOverflow.visible,
                ),
              ),
            )
          else if (textContainer == null)
            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  duration ?? '',
                  style: theme.primaryTextTheme.bodyLarge,
                ),
                const SizedBox(width: 10),
                Text(
                  distance ?? '',
                  style: theme.primaryTextTheme.bodyLarge,
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.only(top: 0, left: 5),
              child: textContainer,
            ),
        ],
      ),
    );
  }
}
