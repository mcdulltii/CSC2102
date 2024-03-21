import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color.fromARGB(255, 20, 121, 121);
  static const Color appBarColor = Color.fromARGB(255, 242, 242, 242);
  static const Color greyColor = Color(0xFF626262);
  static const Color blackColor = Color.fromARGB(255, 0, 0, 0);
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

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        lightColorScheme.primary, // Slightly darker shade for the button
      ),
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.white), // text color
      elevation: MaterialStateProperty.all<double>(5.0), // shadow
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Adjust as needed
        ),
      ),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
);
