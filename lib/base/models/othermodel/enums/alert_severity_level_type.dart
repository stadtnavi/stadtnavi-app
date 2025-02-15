import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_icon.dart';
import 'package:stadtnavi_core/base/pages/home/services/global_alerts/models/icons.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

enum AlertSeverityLevelType { unknownseverity, info, warning, severe }

AlertSeverityLevelType getAlertSeverityLevelTypeByString(
    String alertSeverityLevelType) {
  return AlertSeverityLevelTypeExtension.names.keys.firstWhere(
    (key) => key.name == alertSeverityLevelType,
    orElse: () => AlertSeverityLevelType.unknownseverity,
  );
}

extension AlertSeverityLevelTypeExtension on AlertSeverityLevelType {
  static const names = <AlertSeverityLevelType, String>{
    AlertSeverityLevelType.unknownseverity: 'UNKNOWN_SEVERITY',
    AlertSeverityLevelType.info: 'INFO',
    AlertSeverityLevelType.warning: 'WARNING',
    AlertSeverityLevelType.severe: 'SEVERE'
  };

  String get name => names[this] ?? 'UNKNOWN_SEVERITY';

  String translateValue(
    StadtnaviBaseLocalization localization,
  ) {
    switch (this) {
      case AlertSeverityLevelType.unknownseverity:
        return localization.itineraryDetailsRouteHasInfoAlert;
      case AlertSeverityLevelType.info:
        return localization.itineraryDetailsRouteHasSevereAlert;
      case AlertSeverityLevelType.warning:
        return localization.itineraryDetailsRouteHasUnknownAlert;
      case AlertSeverityLevelType.severe:
        return localization.itineraryDetailsRouteHasWarningAlert;
      default:
        return 'typeError';
    }
  }

  static Widget? _images(AlertSeverityLevelType transportMode, Color? color) {
    switch (transportMode) {
      case AlertSeverityLevelType.unknownseverity:
        return null;
      case AlertSeverityLevelType.info:
        return infoSvg();
      case AlertSeverityLevelType.warning:
        return null;
      case AlertSeverityLevelType.severe:
        return cautionSvg(
          color: Colors.white,
          backColor: const Color(0xFFDC0451),
        );
      default:
        return null;
    }
  }

  Widget getServiceAlertIcon({Color? color, double size = 24}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      child: FittedBox(
        child: _images(
            this == AlertSeverityLevelType.info
                ? AlertSeverityLevelType.info
                : AlertSeverityLevelType.severe,
            color),
      ),
    );
  }

  Widget getWithBigCautionIcon({Color? color, double size = 24}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      child: FittedBox(
        child: this == AlertSeverityLevelType.info
            ? infoSvg()
            : cautionNoExclIcon(
                color: const Color(0xFFDC0451),
              ),
      ),
    );
  }
}
