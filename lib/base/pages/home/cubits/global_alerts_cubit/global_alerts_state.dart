part of 'global_alerts_cubit.dart';

@immutable
class GlobalAlertsState extends Equatable {
  static const String _alerts = "alerts";
  static const String _removedAlertIds = "removedAlertIds";
  const GlobalAlertsState({
    required this.alerts,
    required this.removedAlertIds,
  });

  final List<GlobalAlertEntity> alerts;
  final List<String> removedAlertIds;

  GlobalAlertsState copyWith({
    List<GlobalAlertEntity>? alerts,
    List<String>? removedAlertIds,
  }) {
    return GlobalAlertsState(
      alerts: alerts ?? this.alerts,
      removedAlertIds: removedAlertIds ?? this.removedAlertIds,
    );
  }

  factory GlobalAlertsState.fromJson(Map<String, dynamic> json) {
    return GlobalAlertsState(
      alerts: json[_alerts] != null
          ? (json[_alerts] as List)
              .map(
                (e) => GlobalAlertEntity.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList()
          : [],
      removedAlertIds: json[_removedAlertIds] != null
          ? List<String>.from(json[_removedAlertIds])
          : [],
    );
  }

  List<GlobalAlertEntity> get getFilteredAlerts =>
      alerts.where((e) => !removedAlertIds.contains(e.getServiceAlertId)).toList();

  Map<String, dynamic> toJson() {
    return {
      _alerts: alerts.map((e) => e.toJson()).toList(),
      _removedAlertIds: removedAlertIds,
    };
  }

  @override
  List<Object?> get props => [
        alerts,
        removedAlertIds,
      ];
}
