import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/models/utils/alert_utils.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/itinarary_card/icon_transport.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/utils/util_icons/custom_icons.dart';

class ModeLeg extends StatelessWidget {
  final double maxWidth;
  final PlanItineraryLeg leg;
  final double legLength;

  const ModeLeg({
    Key? key,
    required this.leg,
    required this.legLength,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final perc = legLength.abs() / 10;
    final duration = leg.durationIntLeg ~/ 60;
    final isAvailibleBikes =
        leg.fromPlace?.bikeRentalStation?.bikesAvailable ?? 0;
    return SizedBox(
      width: (maxWidth * perc) >= 24 ? (maxWidth * perc) : 24,
      height: 30,
      child: IconTransport(
        bacgroundColor: leg.transportMode == TransportMode.bicycle &&
                leg.fromPlace?.bikeRentalStation != null
            ? BikeRentalNetwork.cargoBike.color
            : leg.backgroundColor,
        color: Colors.black,
        text: (maxWidth * perc - 24) >= (duration.toString().length * 8.5)
            ? duration < 1
                ? '1'
                : duration.toString()
            : '',
        icon: leg.transportMode == TransportMode.bicycle &&
                leg.fromPlace?.bikeRentalStation != null
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: getBikeRentalNetwork(
                              leg.fromPlace?.bikeRentalStation?.networks?[0])
                          .color,
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(5)),
                    ),
                    child: getBikeRentalNetwork(
                            leg.fromPlace?.bikeRentalStation?.networks?[0])
                        .image,
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: isAvailibleBikes == 0
                            ? const Color(0xffDC0451)
                            : (isAvailibleBikes > 3
                                ? const Color(0xff3B7F00)
                                : const Color(0xffFCBC19)),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FittedBox(
                            child: Text(
                              isAvailibleBikes.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                width: 18,
                height: 20,
                child: leg.transportMode.getImage(),
              ),
      ),
    );
  }
}

class WaitLeg extends StatelessWidget {
  final double maxWidth;
  final double legLength;
  final int duration;

  const WaitLeg({
    Key? key,
    required this.legLength,
    required this.duration,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final perc = legLength.abs() / 10;
    return SizedBox(
      width: (maxWidth * perc) >= 24 ? (maxWidth * perc) : 24,
      height: 30,
      child: IconTransport(
        bacgroundColor: Colors.white,
        borderColor: TransportMode.walk.backgroundColor,
        color: Colors.black,
        text: (maxWidth * perc - 24) >= (duration.toString().length * 8.5)
            ? duration.toString()
            : '',
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          width: 20,
          height: 20,
          child: waitIcon(),
        ),
      ),
    );
  }
}

class RouteLeg extends StatelessWidget {
  final double maxWidth;
  final PlanItineraryLeg leg;
  final PlanItineraryLeg? beforeLeg;
  final double legLength;

  const RouteLeg({
    Key? key,
    required this.leg,
    this.beforeLeg,
    required this.legLength,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final perc = legLength.abs() / 10;
    final isRedenderBike = beforeLeg?.transportMode == TransportMode.bicycle &&
        beforeLeg?.toPlace?.bikeParkEntity == null;
    return SizedBox(
      width: (maxWidth * perc) >= 24 ? (maxWidth * perc) : 24,
      height: 30,
      child: IconTransport(
        bacgroundColor: leg.primaryColor,
        color: Colors.white,
        icon: leg.transportMode.getImage(color: Colors.white),
        secondaryIcon: (maxWidth * perc) >= 46 && isRedenderBike
            ? bikeSvg(color: 'FFFFFF')
            : null,
        text: (maxWidth * perc - 24) >= ((leg.nameTransport.length) * 8.5)
            ? leg.nameTransport
            : '',
        alertSeverityLevel: AlertUtils.getActiveLegAlertSeverityLevel(leg),
      ),
    );
  }
}
