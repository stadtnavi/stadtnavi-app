import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/poi_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';

class PoisFeatureTile extends StatelessWidget {
  final PoiFeature element;

  const PoisFeatureTile({
    super.key,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    final isLanguageEn = Localizations.localeOf(context).languageCode == 'en';
    final subCategoryData = HBLayerData.subCategoriesList[element.category3];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (subCategoryData != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: PoisLayer.fromStringToColor(
                      subCategoryData.backgroundColor),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SvgPicture.string(
                  subCategoryData.icon,
                ),
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                element.name ??
                    (isLanguageEn
                        ? (subCategoryData?.en ?? "")
                        : (subCategoryData?.de ?? "")),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
