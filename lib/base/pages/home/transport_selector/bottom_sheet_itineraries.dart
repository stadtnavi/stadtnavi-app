import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/models/utils/modes_transport_utils.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/itinerary_card.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinerary_details_card/itinerary_details_card.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

class BottomSheetItineraries extends StatefulWidget {
  final TrufiMapController trufiMapController;
  final ModesTransportType typeTransport;

  const BottomSheetItineraries({
    Key? key,
    required this.trufiMapController,
    required this.typeTransport,
  }) : super(key: key);

  @override
  _BottomSheetItinerariesState createState() => _BottomSheetItinerariesState();
}

class _BottomSheetItinerariesState extends State<BottomSheetItineraries>
    with TickerProviderStateMixin {
  bool showDetail = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor, context: context);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (showDetail) {
      setState(() {
        showDetail = false;
      });
    } else if (!stopDefaultButtonEvent) {
      Navigator.pop(context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final mapModesCubit = context.watch<MapModesCubit>();
    final mapModesState = mapModesCubit.state;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: mapModesState.plan!.itineraries?.length ?? 0,
                itemBuilder: (buildContext, index) {
                  final itinerary = mapModesState.plan!.itineraries![index];

                  int? lengthBikePark;
                  if (mapModesState.plan!.type == 'bikeAndPublicPlan') {
                    lengthBikePark = filterOnlyBikeAndWalk(mapModesState
                                .modesTransport?.bikeParkPlan?.itineraries ??
                            [])
                        .length;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (index == 0 &&
                          lengthBikePark != null &&
                          lengthBikePark > 0)
                        Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Text(
                              localization.itinerarySummaryBikeParkTitle,
                              style: theme.primaryTextTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if (lengthBikePark != null &&
                          lengthBikePark == index &&
                          lengthBikePark <
                              mapModesState.plan!.itineraries!.length)
                        Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Text(
                              localization
                                  .itinerarySummaryBikeAndPublicRailSubwayTitle,
                              style: theme.primaryTextTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ItineraryCard(
                        itinerary: itinerary,
                        typeTransport: widget.typeTransport,
                        onTap: () {
                          setState(() {
                            showDetail = true;
                          });
                        },
                        selectedItinerary: mapModesState.selectedItinerary!,
                        selectItinerary: (selectedItinerary,
                            {showAllItineraries}) {
                          mapModesCubit.selectItinerary(
                            selectedItinerary,
                            showAllItineraries: showAllItineraries ?? true,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        if (showDetail && mapModesState.selectedItinerary != null)
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: ItineraryDetailsCard(
              itinerary: mapModesState.selectedItinerary!,
              onBackPressed: () {
                setState(() {
                  showDetail = false;
                });
                mapModesCubit.showAllItineraries();
              },
              moveInMap: (latLng, {zoom}) => widget.trufiMapController.move(
                center: latLng,
                zoom: zoom ?? 15.0,
                tickerProvider: this,
              ),
            ),
          ),
      ],
    );
  }
}
