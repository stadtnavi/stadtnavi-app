import 'package:flutter/material.dart';

import 'package:trufi_core/base/const/styles.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/itinerary_summary_advanced.dart';

final leafIcon =
    '<svg fill="#4C7C2A" width="800px" height="800px" viewBox="0 0 14 14" role="img" focusable="false" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"><path d="m 9.2375,10.433335 c -0.9041667,0.45 -1.9145833,0.71666 -2.9333333,0.71666 -1.7125,0 -3.1479167,-0.83541 -3.1479167,-0.83541 -0.3354167,0 -0.7375,1.35208 -1.31875,1.35208 -0.5625,0 -0.8375,-0.5 -0.8375,-0.80208 0,-0.68959 1.325,-1.22709 1.325,-1.61042 0,0 -0.2604167,-0.44167 -0.2604167,-1.23333 0,-2.10834 1.69375,-3.6125 3.5958334,-4.23542 1.3729166,-0.45 4.2916666,0.0729 5.2229163,-0.80208 0.36875,-0.3375 0.55,-0.65 1.1125,-0.65 0.75625,0 1.004167,1.94166 1.004167,2.50625 0,2.31041 -1.135417,4.30208 -3.7625,5.59375 z m -5.2979167,-1.575 c 1.3229167,-1.87292 3.0104167,-2.68334 5.36875,-2.5 0.1833334,0.0146 0.34375,-0.12292 0.3583334,-0.30625 0.014583,-0.18334 -0.1229167,-0.34375 -0.30625,-0.35834 -2.5833334,-0.2 -4.4979167,0.70625 -5.9645834,2.78125 -0.10625,0.15 -0.070833,0.35834 0.079167,0.46459 0.15,0.10625 0.3583333,0.0708 0.4645833,-0.0813 z"/></svg>';

class ItineraryCard extends StatelessWidget {
  final PlanItinerary itinerary;
  final PlanItinerary selectedItinerary;
  final GestureTapCallback onTap;
  final ModesTransportType? typeTransport;
  final Function(
    PlanItinerary selectItinerary, {
    bool? showAllItineraries,
  }) selectItinerary;

  const ItineraryCard({
    Key? key,
    required this.itinerary,
    required this.selectedItinerary,
    required this.onTap,
    required this.selectItinerary,
    this.typeTransport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    return GestureDetector(
      onTap: () async {
        await selectItinerary(itinerary);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: Insets.sm,
                bottom: Insets.xs,
                right: Insets.xl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${itinerary.startDateText(localizationBase)} ${itinerary.startTimeHHmm} - ${itinerary.endTimeHHmm}",
                    style: theme.primaryTextTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (itinerary.emissionsPerPerson != null)
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEBF6E4),
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          margin: EdgeInsets.only(right: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (itinerary.isMinorEmissionsPerPerson &&
                                  typeTransport !=
                                      ModesTransportType.carAndCarPark) ...[
                                SvgPicture.string(leafIcon),
                                Container(
                                  width: 5,
                                ),
                              ],
                              Text(
                                "${itinerary.emissionsPerPerson!.toStringAsFixed(0)} g",
                                style: TextStyle(
                                  color: const Color(0xFF4C7C2A),
                                ),
                              )
                            ],
                          ),
                        ),
                      Text(
                        itinerary.durationFormat(localizationBase),
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 50 * MediaQuery.of(context).textScaleFactor,
                  color: itinerary == selectedItinerary
                      ? theme.colorScheme.primary
                      : Colors.grey[400],
                  margin: const EdgeInsets.only(
                    right: 5,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (builderContext, constrains) {
                    return ItinerarySummaryAdvanced(
                      maxWidth: constrains.maxWidth,
                      itinerary: itinerary,
                    );
                  }),
                ),
                GestureDetector(
                  onTap: () async {
                    onTap();
                    await selectItinerary(
                      itinerary,
                      showAllItineraries: false,
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: 30,
                    height: 50,
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
