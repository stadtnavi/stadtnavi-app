import 'package:stadtnavi_core/base/models/othermodel/alert.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/alert_severity_level_type.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/leg/realtime_state.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';

class AlertEntityType {
  static const String agency = 'Agency';
  static const String route = 'Route';
  static const String pattern = 'Pattern';
  static const String stop = 'Stop';
  static const String trip = 'Trip';
  static const String stopOnRoute = 'StopOnRoute';
  static const String stopOnTrip = 'StopOnTrip';
  static const String routeType = 'RouteType';
  static const String unknown = 'Unknown';
}

abstract class AlertUtils {
  static const int defaultValidity = 5 * 60;

  static bool isAlertValid(
    Alert? alert,
    double? referenceUnixTime, {
    int defaultValidity = defaultValidity,
    bool isFutureValid = false,
  }) {
    if (alert == null) {
      return false;
    }

    final effectiveStartDate = alert.effectiveStartDate;
    final effectiveEndDate = alert.effectiveEndDate;

    if (effectiveStartDate == null || referenceUnixTime == null) {
      return true;
    }

    if (isFutureValid && referenceUnixTime < effectiveStartDate) {
      return true;
    }

    return effectiveStartDate <= referenceUnixTime &&
        referenceUnixTime <=
            (effectiveEndDate ?? (effectiveStartDate + defaultValidity));
  }

  static bool cancelationHasExpired(
    double referenceUnixTime, {
    double? scheduledArrival,
    double? scheduledDeparture,
    double? serviceDay,
  }) {
    return isAlertValid(
      Alert(
        effectiveStartDate: (serviceDay ?? 0) + (scheduledArrival ?? 0),
        effectiveEndDate: (serviceDay ?? 0) + (scheduledDeparture ?? 0),
      ),
      referenceUnixTime,
      isFutureValid: true,
    );
  }

  static AlertSeverityLevelType? getMaximumAlertSeverityLevel(
      List<Alert>? alerts) {
    if (alerts == null || alerts.isEmpty) {
      return null;
    }

    final levels = <AlertSeverityLevelType, bool>{};

    for (var alert in alerts) {
      if (alert.alertSeverityLevel != null) {
        levels[alert.alertSeverityLevel!] = true;
      }
    }

    return levels.containsKey(AlertSeverityLevelType.severe)
        ? AlertSeverityLevelType.severe
        : levels.containsKey(AlertSeverityLevelType.warning)
            ? AlertSeverityLevelType.warning
            : levels.containsKey(AlertSeverityLevelType.info)
                ? AlertSeverityLevelType.info
                : levels.containsKey(AlertSeverityLevelType.unknownseverity)
                    ? AlertSeverityLevelType.unknownseverity
                    : null;
  }

  static AlertSeverityLevelType? getActiveAlertSeverityLevel(
      List<Alert>? alerts, double? referenceUnixTime) {
    if (alerts == null || alerts.isEmpty) {
      return null;
    }

    final filteredAlerts = alerts
        .where((alert) => isAlertValid(alert, referenceUnixTime))
        .toList();

    return getMaximumAlertSeverityLevel(filteredAlerts);
  }

  static AlertSeverityLevelType? getActiveLegAlertSeverityLevel(
      PlanItineraryLeg? leg) {
    if (leg == null) {
      return null;
    }

    if (legHasCancelation(leg)) {
      return AlertSeverityLevelType.warning;
    }

    final List<Alert> serviceAlerts = [
      ...(leg.route?.alerts ?? []),
      ...(leg.fromPlace?.stopEntity?.alerts ?? []),
      ...(leg.toPlace?.stopEntity?.alerts ?? []),
    ];

    return getActiveAlertSeverityLevel(
        serviceAlerts, (leg.startTime.millisecondsSinceEpoch / 1000));
  }

  static bool legHasCancelation(PlanItineraryLeg? leg) {
    if (leg == null) {
      return false;
    }
    return leg.realtimeState == RealtimeState.canceled;
  }

  static List<Alert> getActiveLegAlerts(
    PlanItineraryLeg? leg,
    double legStartTime,
  ) {
    if (leg == null) {
      return [];
    }
    final routeAlerts = leg.route?.alerts?.map(
      (e) => e.copyWith(sourceAlert: 'route-alert'),
    );
    final fromStopAlerts = leg.fromPlace?.stopEntity?.alerts?.map(
      (e) => e.copyWith(sourceAlert: 'from-stop-alert'),
    );
    final toStopAlerts = leg.toPlace?.stopEntity?.alerts?.map(
      (e) => e.copyWith(sourceAlert: 'to-stop-alert'),
    );

    final List<Alert> serviceAlerts = [
      ...routeAlerts ?? [],
      ...fromStopAlerts ?? [],
      ...toStopAlerts ?? [],
    ];

    return serviceAlerts
        .where((alert) => isAlertValid(alert, legStartTime))
        .toList();
  }

  static int alertSeverityCompare(Alert a, Alert b) {
    final List<AlertSeverityLevelType?> severityLevels = [
      AlertSeverityLevelType.info,
      AlertSeverityLevelType.unknownseverity,
      AlertSeverityLevelType.warning,
      AlertSeverityLevelType.severe,
    ];

    int severityLevelDifference = severityLevels.indexOf(b.alertSeverityLevel) -
        severityLevels.indexOf(a.alertSeverityLevel);

    return severityLevelDifference;
  }
}
