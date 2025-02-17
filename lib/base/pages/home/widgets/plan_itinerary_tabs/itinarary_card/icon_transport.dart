import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/othermodel/enums/alert_severity_level_type.dart';

class IconTransport extends StatelessWidget {
  final Color color;
  final Color bacgroundColor;
  final Color? borderColor;
  final String text;
  final Widget icon;
  final Widget? secondaryIcon;
  final AlertSeverityLevelType? alertSeverityLevel;

  const IconTransport({
    Key? key,
    required this.color,
    required this.bacgroundColor,
    this.borderColor,
    required this.text,
    required this.icon,
    this.secondaryIcon,
    this.alertSeverityLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: bacgroundColor,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 30,
            width: 22,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  icon,
                  if (alertSeverityLevel != null)
                    Positioned(
                      bottom: -8,
                      left: -5,
                      child: alertSeverityLevel!.getWithBigCautionIcon(size: 17),
                    ),
                ],
              ),
            ),
          ),
          if (secondaryIcon != null)
            SizedBox(
              height: 22,
              width: 22,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                child: secondaryIcon,
              ),
            ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
