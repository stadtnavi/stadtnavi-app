import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/simple_opening_hours.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/widgets/opening_time_table.dart';
import "package:url_launcher/url_launcher.dart";
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'poi_feature_model.dart';

class PoiMarkerModal extends StatelessWidget {
  final PoiFeature element;
  final void Function() onFetchPlan;

  const PoiMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final localizationST = StadtnaviBaseLocalization.of(context);

    final subCategoryData = HBLayerData.subCategoriesList[element.category3];
    SimpleOpeningHours? openingHours;
    if (element.openingHours != null) {
      openingHours = SimpleOpeningHours(element.openingHours!);
    }

    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: subCategoryData != null
                              ? PoisLayer.fromStringToColor(
                                  subCategoryData.backgroundColor)
                              : null,
                          borderRadius: BorderRadius.circular(50)),
                      child: subCategoryData != null &&
                              subCategoryData.icon.isNotEmpty
                          ? SvgPicture.string(
                              subCategoryData.icon,
                              color: PoisLayer.fromStringToColor(
                                  subCategoryData.color),
                            )
                          : const Icon(Icons.error),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      subCategoryData?.en ?? subCategoryData?.en ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 11),
                  ),
                  Expanded(
                    child: Text(
                      element.name ?? "",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (element.address != null ||
            element.phone != null ||
            element.website != null)
          const Divider(),
        if (element.address != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                const Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  element.address!,
                ),
              ],
            ),
          ),
        if (element.phone != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: iconPhoneSvg,
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                  text: TextSpan(
                    style: theme.primaryTextTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: theme.colorScheme.primary,
                    ),
                    text: element.phone,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri =
                            Uri(scheme: 'tel', path: element.phone!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                          );
                        }
                      },
                  ),
                ),
                Text(
                  element.phone!,
                ),
              ],
            ),
          ),
        if (element.website != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: iconWebsiteSvg,
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                  text: TextSpan(
                    style: theme.primaryTextTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: theme.colorScheme.primary,
                    ),
                    text: element.website,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri = Uri.parse(element.website!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                          );
                        }
                      },
                  ),
                ),
              ],
            ),
          ),
        if (openingHours != null) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 10),
            child: OpeningTimeTable(
              openingHours: openingHours,
              isOpenParking: openingHours.isOpenNow(),
              currentOpeningTime:
                  OpeningTimeTable.getCurrentOpeningTime(openingHours),
            ),
          ),
        ],
        if (element.wheelchair == 'yes')
          LabelPOIsDetails(label: localizationST.poiTagWheelchair),
        if (element.outdoorSeating == 'yes')
          LabelPOIsDetails(label: localizationST.poiTagOutdoor),
        if (element.dog == 'yes')
          LabelPOIsDetails(label: localizationST.poiTagDogs),
        if (element.internetAccess == 'wlan')
          LabelPOIsDetails(label: localizationST.poiTagWifi),
        if (element.operatorName != null)
          LabelPOIsDetails(
              label: localizationST.poiTagOperator(element.operatorName!)),
        if (element.brand != null)
          LabelPOIsDetails(label: localizationST.poiTagBrand(element.brand!)),
        CustomLocationSelector(
          onFetchPlan: onFetchPlan,
          locationData: LocationDetail(
            element.name ?? "",
            "",
            element.position,
          ),
        ),
      ],
    );
  }
}

class LabelPOIsDetails extends StatelessWidget {
  const LabelPOIsDetails({
    super.key,
    required this.label,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Text(label),
    );
  }
}
