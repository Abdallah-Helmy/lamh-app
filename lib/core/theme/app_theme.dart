import 'package:flutter/material.dart';
import 'package:lamh/core/theme/app_colors.dart';
import 'package:lamh/core/theme/app_fonts.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light);
  static ThemeData get dark => _build(AppColors.dark);

  static ThemeData _build(AppColorScheme colors) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      fontFamily: AppFonts.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: colors.brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.onGlass,
        error: colors.error,
      ),
      extensions: [colors],
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      cardColor: colors.surface,
      dividerColor: colors.glassStrokeSoft,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: colors.systemOverlayStyle,
        foregroundColor: colors.onGlass,
        centerTitle: true,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: AppFonts.primary,
        bodyColor: colors.onGlass,
        displayColor: colors.onGlass,
        decoration: TextDecoration.none,
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        fontFamily: AppFonts.primary,
        bodyColor: colors.onGlass,
        displayColor: colors.onGlass,
        decoration: TextDecoration.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.glassStrokeSoft;
        }),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
