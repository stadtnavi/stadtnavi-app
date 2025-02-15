import 'package:flutter/material.dart';
import 'package:trufi_core/base/utils/util_icons/custom_icons.dart';

enum Mode {
  airplane,
  bicycle,
  bus,
  cableCar,
  car,
  carPool,
  ferry,
  flexible,
  funicular,
  gondola,
  legSwitch,
  rail,
  subway,
  tram,
  transit,
  walk
}

Mode getModeByString(String mode) {
  return ModeExtension.names.keys.firstWhere(
    (key) => key.name == mode,
    orElse: () => Mode.walk,
  );
}

extension ModeExtension on Mode {
  static const names = <Mode, String>{
    Mode.airplane: 'AIRPLANE',
    Mode.bicycle: 'BICYCLE',
    Mode.bus: 'BUS',
    Mode.cableCar: 'CABLE_CAR',
    Mode.car: 'CAR',
    Mode.carPool: 'CARPOOL',
    Mode.ferry: 'FERRY',
    Mode.flexible: 'FLEXIBLE',
    Mode.funicular: 'FUNICULAR',
    Mode.gondola: 'GONDOLA',
    Mode.legSwitch: 'LEG_SWITCH',
    Mode.rail: 'RAIL',
    Mode.subway: 'SUBWAY',
    Mode.tram: 'TRAM',
    Mode.transit: 'TRANSIT',
    Mode.walk: 'WALK',
  };

  // static const icons = <Mode, IconData>{
  //   Mode.airplane: Icons.airplanemode_active,
  //   Mode.bicycle: Icons.pedal_bike,
  //   Mode.bus: Icons.directions_bus,
  //   Mode.cableCar: CustomIcons.gondola,
  //   Mode.car: Icons.drive_eta,
  //   Mode.carPool: Icons.drive_eta,
  //   Mode.ferry: Icons.directions_ferry,
  //   Mode.flexible: Icons.warning,
  //   Mode.funicular: CustomIcons.gondola,
  //   Mode.gondola: CustomIcons.gondola,
  //   Mode.legSwitch: Icons.warning,
  //   Mode.rail: Icons.train,
  //   Mode.subway: Icons.directions_subway,
  //   Mode.tram: Icons.warning,
  //   Mode.transit: Icons.directions_transit,
  //   Mode.walk: Icons.directions_walk,
  // };

  static final colors = <Mode, Color?>{
    Mode.airplane: null,
    Mode.bicycle: Colors.blue,
    Mode.bus: const Color(0xffff260c),
    Mode.cableCar: null,
    Mode.car: null,
    Mode.carPool: const Color(0xff9fc726),
    Mode.ferry: null,
    Mode.flexible: null,
    Mode.funicular: null,
    Mode.gondola: null,
    Mode.legSwitch: null,
    Mode.rail: const Color(0xff83b23b),
    Mode.subway: Colors.blueAccent[700],
    Mode.tram: null,
    Mode.transit: null,
    Mode.walk: Colors.grey[850],
  };

  static Widget? _images(Mode transportMode, Color? color) {
    switch (transportMode) {
      case Mode.airplane:
        return null;
      case Mode.bicycle:
        return bikeIcon(color: color ?? const Color(0xff666666));
      case Mode.bus:
        return busIcon(color: color ?? const Color(0xffff260c));
      case Mode.cableCar:
        return gondolaIcon(color: color ?? const Color(0xff000000));
      case Mode.car:
        return carIcon(color: color ?? const Color(0xff000000));
      case Mode.carPool:
        return carpoolIcon(color: color ?? const Color(0xff9fc727));
      case Mode.ferry:
        return null;
      case Mode.flexible:
        return null;
      case Mode.funicular:
        return funicularIcon(color: color ?? const Color(0xffFFCC00));
      case Mode.gondola:
        return gondolaIcon(color: color ?? const Color(0xff000000));
      case Mode.legSwitch:
        return null;
      case Mode.rail:
        return railIcon(color: color ?? const Color(0xff018000));
      case Mode.subway:
        return subwayIcon(color: color ?? Colors.blueAccent[700]);
      case Mode.tram:
        return null;
      case Mode.transit:
        return null;
      case Mode.walk:
        return walkIcon(color: color ?? const Color(0xff000000));
      default:
        return null;
    }
  }

  static const _icons = <Mode, IconData?>{
    Mode.airplane: Icons.airplanemode_active,
    Mode.bicycle: Icons.directions_bike,
    Mode.bus: Icons.directions_bus,
    Mode.cableCar: null,
    Mode.car: Icons.drive_eta,
    Mode.carPool: Icons.drive_eta,
    Mode.ferry: Icons.directions_ferry,
    Mode.flexible: Icons.warning,
    Mode.funicular: null,
    Mode.gondola: null,
    Mode.legSwitch: Icons.warning,
    Mode.rail: Icons.train,
    Mode.subway: Icons.directions_subway,
    Mode.tram: Icons.warning,
    Mode.transit: Icons.directions_transit,
    Mode.walk: Icons.directions_walk,
  };

  String get name => names[this] ?? 'WALK';

  // IconData get icon => icons[this] ?? (Icons.directions_walk);

  Widget get image => _images(this, null) ?? (Icon(Icons.error, color: color));

  Widget getImage({Color? color, double size = 24}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      child: FittedBox(
        child: _images(this, color) ??
            (_icons[this] != null
                ? Icon(
                    _icons[this],
                    color: color ?? color,
                  )
                : const Icon(
                    Icons.error,
                    color: Colors.red,
                  )),
      ),
    );
  }

  Color get color => colors[this] ?? Colors.grey;
}
