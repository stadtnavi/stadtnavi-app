import 'dart:async';
import 'package:async_executor/async_executor.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/banner_alerts.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/global_alerts_cubit/global_alerts_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';

import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/home_app_bar.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/custom_itinerary.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';

typedef MapRouteBuilder = Widget Function(
  BuildContext,
  TrufiMapController,
);

class HomePage extends StatefulWidget {
  static const String route = "/Home";
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final WidgetBuilder drawerBuilder;
  final MapRouteBuilder mapBuilder;
  final AsyncExecutor asyncExecutor;
  const HomePage({
    Key? key,
    required this.drawerBuilder,
    required this.mapBuilder,
    required this.asyncExecutor,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        TraceableClientMixin {
  final TrufiMapController trufiMapController = TrufiMapController();
  StreamSubscription<LatLng?>? locationStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final mapRouteCubit = context.read<MapRouteCubit>();
      final mapRouteState = mapRouteCubit.state;
      repaintMap(mapRouteCubit, mapRouteState);
      moveMyLocation(mapRouteState);
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (duration) => processUniLink(),
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (duration) => context
          .read<GlobalAlertsCubit>()
          .load(Localizations.localeOf(context).languageCode),
    );
  }

  @override
  String get actionName => 'HomePage-(Mobile-App)';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final mapRouteState = context.read<MapRouteCubit>().state;
      moveMyLocation(mapRouteState);
    }
    if (state == AppLifecycleState.inactive) {
      locationStreamSubscription?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> processUniLink() async {
    final queryParameters = RouteData.of(context).queryParameters;
    if (queryParameters['FetchRoute'] != null &&
        queryParameters['FetchRoute'] == "true") {
      await _callFetchPlan(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapRouteCubit = context.watch<MapRouteCubit>();
    final mapModesCubit = context.watch<MapModesCubit>();
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final panelCubit = context.watch<PanelCubit>();
    final theme = Theme.of(context);
    trufiMapController.onReady.then((value) {
      if (panelCubit.state.panel != null) {
        trufiMapController.move(
          center: panelCubit.state.panel!.positon,
          zoom: 16,
          tickerProvider: this,
        );
      }
    });
    return Scaffold(
      key: HomePage.scaffoldKey,
      drawer: widget.drawerBuilder(context),
      appBar: AppBar(
        backgroundColor: ThemeCubit.isDarkMode(theme)
            ? theme.appBarTheme.backgroundColor
            : theme.colorScheme.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: const BannerAlerts()),
            ],
          ),
          HomeAppBar(
            onSaveFrom: (TrufiLocation fromPlace) =>
                mapRouteCubit.setFromPlace(fromPlace).then(
              (value) {
                trufiMapController.move(
                  center: fromPlace.latLng,
                  zoom: mapConfiguratiom.chooseLocationZoom,
                  tickerProvider: this,
                );
                _callFetchPlan(context);
              },
            ),
            onClearFrom: () async {
              mapRouteCubit.resetFromPlaceKeepingToPlace();
              if (mapRouteCubit.state.plan != null) {
                panelCubit.cleanPanel();
                await mapModesCubit.reset();
              }
            },
            onSaveTo: (TrufiLocation toPlace) =>
                mapRouteCubit.setToPlace(toPlace).then(
              (value) {
                trufiMapController.move(
                  center: toPlace.latLng,
                  zoom: mapConfiguratiom.chooseLocationZoom,
                  tickerProvider: this,
                );
                _callFetchPlan(context);
              },
            ),
            onClearTo: () async {
              mapRouteCubit.resetToPlaceKeepingFromPlace();
              if (mapRouteCubit.state.plan != null) {
                panelCubit.cleanPanel();
                await mapModesCubit.reset();
              }
            },
            onBackButton: () {
              HomePage.scaffoldKey.currentState?.openDrawer();
            },
            onFetchPlan: () => _callFetchPlan(context),
            onReset: () async {
              panelCubit.cleanPanel();
              await mapModesCubit.reset();
              await mapRouteCubit.reset();
            },
            onSwap: () => mapRouteCubit
                .swapLocations()
                .then((value) => _callFetchPlan(context)),
          ),
          Expanded(
            child: Stack(
              children: [
                BlocListener<MapRouteCubit, MapRouteState>(
                  listener: (buildContext, state) {
                    trufiMapController.onReady.then((_) {
                      repaintMap(mapRouteCubit, state);
                    });
                  },
                  child: CustomScrollableContainer(
                    openedPosition: 200,
                    body: widget.mapBuilder(
                      context,
                      trufiMapController,
                    ),
                    panel: panelCubit.state.panel == null
                        ? mapRouteCubit.state.plan == null
                            ? null
                            : CustomItinerary(
                                trufiMapController: trufiMapController,
                              )
                        : panelCubit.state.panel?.panel(context, () {
                            panelCubit.cleanPanel();
                            _callFetchPlan(context);
                          }),
                    bottomPadding: panelCubit.state.panel?.minSize ?? 0,
                    onClose: panelCubit.state.panel == null
                        ? null
                        : panelCubit.cleanPanel,
                  ),
                ),
                Positioned(
                  top: -3.5,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xaa000000),
                          offset: Offset(0, 1.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void repaintMap(MapRouteCubit mapRouteCubit, MapRouteState mapRouteState) {
    if (mapRouteState.plan != null && mapRouteState.selectedItinerary != null) {
      trufiMapController.selectedItinerary(
          plan: mapRouteState.plan!,
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          selectedItinerary: mapRouteState.selectedItinerary!,
          tickerProvider: this,
          showAllItineraries: mapRouteState.showAllItineraries,
          onTap: (p1) {
            mapRouteCubit.selectItinerary(p1);
          });
    } else {
      trufiMapController.cleanMap();
    }
  }

  void moveMyLocation(MapRouteState mapRouteState) async {
    if (mapRouteState.plan == null) {
      final mapConfiguration = context.read<MapConfigurationCubit>().state;
      locationStreamSubscription = GPSLocationProvider().streamLocation.listen(
        (currentLocation) {
          if (currentLocation != null) {
            trufiMapController.moveToYourLocation(
              location: currentLocation,
              context: context,
              zoom: mapConfiguration.chooseLocationZoom,
              tickerProvider: this,
            );
            locationStreamSubscription?.cancel();
          }
        },
      );
    }
  }

  Future<void> _callFetchPlan(BuildContext context) async {
    final mapRouteCubit = context.read<MapRouteCubit>();
    final mapModesCubit = context.read<MapModesCubit>();
    final settingFetchState = context.read<SettingFetchCubit>().state;
    final mapRouteState = mapRouteCubit.state;
    if (mapRouteState.toPlace == null || mapRouteState.fromPlace == null) {
      return;
    }
    final languageCode = Localizations.localeOf(context).languageCode;
    widget.asyncExecutor.run(
      context: context,
      onExecute: () async {
        await mapModesCubit.reset();
        await mapRouteCubit.fetchPlan(
          advancedOptions: settingFetchState,
          localeName: languageCode,
        );
      },
      onFinish: (_) {
        mapModesCubit.fetchModesPlans(
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          advancedOptions: settingFetchState,
          localeName: languageCode,
        );
      },
    );
  }
}
