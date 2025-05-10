// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";

/// A Theme class for the app
///
/// This class contains methods that return a [ThemeData] depending on the brightness and or contrast desired.
class GalaksiTheme {
  const GalaksiTheme(this.textTheme);

  final TextTheme textTheme;
  static const seed = Color.fromARGB(255, 103, 80, 164);

  // Light and Dark Themes

  ThemeData light() {
    return theme(
      ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    );
  }

  ThemeData dark() {
    return theme(
      ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData.from(
    useMaterial3: true,
    colorScheme: colorScheme,
  ).copyWith(
    brightness: colorScheme.brightness,
    progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false),
    sliderTheme: const SliderThemeData(year2023: false),
    textTheme: textTheme,
  );

  /// Mikado Yellow
  static const mikadoYellow = ExtendedColor(
    seed: Color(0xffffc800),
    value: Color(0xffffc800),
    light: ColorFamily(
      color: Color(0xff745b0b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdf92),
      onColorContainer: Color(0xff241a00),
    ),
    dark: ColorFamily(
      color: Color(0xffe5c36c),
      onColor: Color(0xff3e2e00),
      colorContainer: Color(0xff594400),
      onColorContainer: Color(0xffffdf92),
    ),
  );

  /// Chestnut
  static const chestnut = ExtendedColor(
    seed: Color(0xffa44a3f),
    value: Color(0xffa44a3f),
    light: ColorFamily(
      color: Color(0xff904a41),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdad5),
      onColorContainer: Color(0xff3b0906),
    ),
    dark: ColorFamily(
      color: Color(0xffffb4a9),
      onColor: Color(0xff561e18),
      colorContainer: Color(0xff73342c),
      onColorContainer: Color(0xffffdad5),
    ),
  );

  /// Black Olive
  static const blackOlive = ExtendedColor(
    seed: Color(0xff36382e),
    value: Color(0xff36382e),
    light: ColorFamily(
      color: Color(0xff546524),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd7eb9b),
      onColorContainer: Color(0xff161f00),
    ),
    dark: ColorFamily(
      color: Color(0xffbbcf82),
      onColor: Color(0xff283500),
      colorContainer: Color(0xff3d4c0d),
      onColorContainer: Color(0xffd7eb9b),
    ),
  );

  /// Ghost White
  static const ghostWhite = ExtendedColor(
    seed: Color(0xffe8ebf7),
    value: Color(0xffe8ebf7),
    light: ColorFamily(
      color: Color(0xff405f90),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffd6e3ff),
      onColorContainer: Color(0xff001b3e),
    ),
    dark: ColorFamily(
      color: Color(0xffaac7ff),
      onColor: Color(0xff09305f),
      colorContainer: Color(0xff274777),
      onColorContainer: Color(0xffd6e3ff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
    mikadoYellow,
    chestnut,
    blackOlive,
    ghostWhite,
  ];
}

class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
  });

  final Color seed, value;
  final ColorFamily light;
  final ColorFamily dark;
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
