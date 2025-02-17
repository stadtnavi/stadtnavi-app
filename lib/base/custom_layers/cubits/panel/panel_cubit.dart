import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
part 'panel_state.dart';

class PanelCubit extends Cubit<PanelState> {
  PanelCubit() : super(const PanelState());
  void setPanel(CustomMarkerPanel panel) {
    // emit(const PanelState());
    Future.delayed(
      const Duration(milliseconds: 0),
      () => emit(
        state.isTransportPanel
            ? state.copyWith(modeTransportPanel: panel)
            : state.copyWith(panel: panel),
      ),
    );
  }

  void cleanPanel() {
    emit(
      state.isTransportPanel
          ? PanelState(
              panel: state.panel,
              isTransportPanel: state.isTransportPanel,
            )
          : PanelState(
              modeTransportPanel: state.modeTransportPanel,
              isTransportPanel: state.isTransportPanel,
            ),
    );
  }

  void changeTransportPanel(bool isTransportPanel) {
    emit(state.copyWith(isTransportPanel: isTransportPanel));
  }
}
