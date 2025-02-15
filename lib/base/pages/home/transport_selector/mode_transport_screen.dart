import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/bottom_sheet_itineraries.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/trufi_map_mode.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class ModeTransportScreen extends StatefulWidget {
  final String title;
  final ModesTransportType typeTransport;
  const ModeTransportScreen({
    Key? key,
    required this.title,
    required this.typeTransport,
  }) : super(key: key);

  @override
  _ModeTransportScreen createState() => _ModeTransportScreen();
}

class _ModeTransportScreen extends State<ModeTransportScreen>
    with TickerProviderStateMixin {
  final TrufiMapController trufiMapController = TrufiMapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final mapRouteState = context.read<MapRouteCubit>().state;
      final mapModesCubit = context.read<MapModesCubit>();
      context.read<PanelCubit>().changeTransportPanel(true);
      context.read<PanelCubit>().cleanPanel();
      final mapModesState = mapModesCubit.state;
      repaintMap(mapRouteState, mapModesCubit, mapModesState);
    });
  }

  @override
  void deactivate() {
    context.read<PanelCubit>().cleanPanel();
    context.read<PanelCubit>().changeTransportPanel(false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final mapRouteState = context.read<MapRouteCubit>().state;
    final mapModesCubit = context.watch<MapModesCubit>();
    final panelCubit = context.watch<PanelCubit>();
    return BaseTrufiPage(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Stack(
          children: [
            BlocListener<MapModesCubit, MapModesState>(
              listener: (buildContext, state) {
                trufiMapController.onReady.then((_) {
                  repaintMap(mapRouteState, mapModesCubit, state);
                });
              },
              child: CustomScrollableContainer(
                openedPosition: 200,
                body: TrufiMapMode(
                  trufiMapController: trufiMapController,
                ),
                panel: panelCubit.state.modeTransportPanel == null
                    ? mapModesCubit.state.plan != null
                        ? BottomSheetItineraries(
                            trufiMapController: trufiMapController,
                            typeTransport: widget.typeTransport,
                          )
                        : null
                    : panelCubit.state.modeTransportPanel?.panel(context, () {
                        panelCubit.cleanPanel();
                      }),
                onClose: panelCubit.state.modeTransportPanel == null
                    ? null
                    : panelCubit.cleanPanel,
                // panel: mapModesCubit.state.plan != null
                //     ? BottomSheetItineraries(
                //         trufiMapController: trufiMapController,
                //         typeTransport: widget.typeTransport,
                //       )
                //     : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void repaintMap(MapRouteState mapRouteState, MapModesCubit mapModesCubit,
      MapModesState mapModesState) {
    if (mapModesState.plan != null && mapModesState.selectedItinerary != null) {
      trufiMapController.selectedItinerary(
          plan: mapModesState.plan!,
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          selectedItinerary: mapModesState.selectedItinerary!,
          tickerProvider: this,
          showAllItineraries: mapModesState.showAllItineraries,
          onTap: (p1) {
            mapModesCubit.selectItinerary(p1);
          });
    } else {
      trufiMapController.cleanMap();
    }
  }
}
