import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stadtnavi_core/base/pages/home/services/global_alerts/models/global_alert_entity.dart';
import 'package:stadtnavi_core/base/pages/home/services/global_alerts/otp_global_alerts_repository.dart';

part 'global_alerts_state.dart';

class GlobalAlertsCubit extends Cubit<GlobalAlertsState> {
  static const String path = "GlobalAlertsCubit";
  late Box _box;

  final OtpGlobalAlertsRepository _requestManager;
  final List<String> feedIds;
  String languageCode = "en";

  GlobalAlertsCubit({
    required String otpEndpoint,
    required this.feedIds,
  })  : _requestManager = OtpGlobalAlertsRepository(otpEndpoint),
        super(const GlobalAlertsState(alerts: [], removedAlertIds: []));

  Future<void> load(newLanguageCode) async {
    languageCode = newLanguageCode;
    _box = Hive.box(path);
    final jsonString = _box.get(path);
    if (jsonString != null && jsonString.isNotEmpty) {
      emit(
        GlobalAlertsState.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        ),
      );
    }
    await loadOnlineData();
    updateGlobalAlertsState(state);
  }

  Future<void> loadOnlineData() async {
    final alerts = await _requestManager.fetchAlerts(
      feedIds: feedIds,
      locale: languageCode,
    );
    emit(state.copyWith(alerts: alerts));
  }

  Future<void> reset() async {
    await updateGlobalAlertsState(const GlobalAlertsState(
      alerts: [],
      removedAlertIds: [],
    ));
  }

  Future<void> deleteAlert(GlobalAlertEntity alert) async {
    final tempAlerts = [...state.alerts];
    tempAlerts.remove(alert);
    final newState = state.copyWith(
      alerts: tempAlerts,
      removedAlertIds: [...state.removedAlertIds, alert.getServiceAlertId],
    );
    await updateGlobalAlertsState(newState);
  }

  Future<void> updateGlobalAlertsState(GlobalAlertsState newState) async {
    await _box.put(path, jsonEncode(newState.toJson()));
    emit(newState);
  }
}
