import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trufi_core/base/utils/util_icons/custom_icons.dart';

String caution({
  String color = 'FFFFFF',
  String backColor = 'DC0451',
}) =>
    '''
<svg id="icon-icon_caution" viewBox="0 0 286.46 286.46">
  <path d="M278.569 215.773c3.425 4.894 4.894 10.766 4.894 16.638 0 16.638-13.703 30.83-30.83 30.83H30.461c-10.767 0-21.042-5.872-26.427-15.66-5.382-9.298-5.382-21.042 0-30.34L115.121 24.432c5.382-9.298 15.659-15.171 26.424-15.171 11.256 0 21.042 5.872 26.915 15.171l110.109 191.341z" fill='$color'/>
  <path d="M158.671 76.793c.49-5.872-3.425-10.276-8.808-10.276h-16.638c-5.383 0-8.809 4.404-8.318 10.276l8.318 95.916c.49 4.893 3.916 8.319 8.318 8.319 4.894 0 8.32-3.426 8.809-8.319l8.319-95.916zm-.488 137.512c0-9.298-6.852-16.149-16.64-16.149-9.296 0-16.637 6.852-16.637 16.149v2.447c0 9.298 7.341 16.149 16.637 16.149 9.787 0 16.64-6.852 16.64-16.149v-2.447z" fill='$backColor'/>
</svg>
''';
Widget cautionSvg({Color? color, Color? backColor}) {
  return SvgPicture.string(caution(
    color: decodeFillColor(color),
    backColor: decodeFillColor(backColor),
  ));
}
