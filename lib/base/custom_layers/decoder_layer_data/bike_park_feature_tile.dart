import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_park_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_park_icons.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

class BikeParkFeatureTile extends StatelessWidget {
  final BikeParkFeature element;

  const BikeParkFeatureTile({
    super.key,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    final localizationST = StadtnaviBaseLocalization.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.string(
              bikeParkMarkerIcons[element.type] ?? "",
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                localizationST.bicycleParking,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
