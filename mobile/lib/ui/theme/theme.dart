import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF18604A);
  static const Color greyColor = Color(0xFF626262);
  static const Color sendRequestColor = Color(0xFFE6D6C6);
  static const Color hintTextColor = Color(0xFF969696);
  static const Color secondaryColor = Color(0xFFD9E9E6);
  static const Color hintTextColor2 = Colors.black45;
  static const Color whiteBackgroundColor = Color(0xFFF2F3F2);
  static const Color lowCrowdLevelColor = Color(0xff008b05);
  static const Color mediumCrowdLevelColor = Color(0xFFFFCC4D);
  static const Color highCrowdLevelColor = Color(0xffff5e5e);
  static const Color sentTextColor = Color(0xFFE6D6C6);

  // Margins
  static const double marginOnSides = 12;
  static const double marginOnSides2 = 22;

  // Font Sizes
  static const double textFontSize = 12;
  static const double subHeading3Size = 15;
  static const double subHeading2Size = 18;
  static const double subHeading1Size = 21;

  static const double titleFontSize = 30;

  // Font Weight
  static const FontWeight subHeadingWeight = FontWeight.w800;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static const TextStyle busArrivalTimeTextStyle =
      TextStyle(color: Colors.black87, fontSize: 10);
}
