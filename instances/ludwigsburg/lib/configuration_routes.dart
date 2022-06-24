import 'package:flutter/material.dart';
import 'package:ludwigsburg/pages/parking_information_page/parking_information_cubit/parking_information_cubit.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ludwigsburg/pages/parking_information_page/parking_information_page.dart';
import 'package:stadtnavi_core/consts.dart';

import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

final extraDrawerItems = [ParkingInformationPage.menuItemDrawer];

Map<String, RouteSettings Function(RouteData)> extraRoutes(
  WidgetBuilder Function(String) drawerBuilder,
) {
  return {
    ParkingInformationPage.route: (route) => NoAnimationPage(
          child: ParkingInformationPage(
            drawerBuilder: drawerBuilder(ParkingInformationPage.route),
          ),
        ),
  };
}

final List<BlocProvider> extraBlocs = [
  BlocProvider<ParkingInformationCubit>(
    create: (context) => ParkingInformationCubit(openTripPlannerUrl),
  ),
];
